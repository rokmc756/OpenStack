================UNDERCLOUD==================
1. Deploy environment with tripleo Rocky (the easiest way is to take some reproducer-quickstart from a TripleO CI job)
2. Download and install -y tripleo-repos:
    sudo yum install -y https://trunk.rdoproject.org/centos7/consistent/python2-tripleo-repos-0.0.1-0.20191001113300.9dba973.el7.noarch.rpm
3. Set up stein repos:
    sudo -E tripleo-repos -b stein current
4. Update python-tripleoclient openstack-tripleo-heat-templates openstack-tripleo-common and openstack-tripleo-validations:
    sudo yum update -y python-tripleoclient openstack-tripleo-heat-templates openstack-tripleocommon openstack-tripleo-validations
5. Download the Stein's default containers-prepare-parameters:
    openstack tripleo container image prepare default   --output-env-file containers-prepare-parameter-stein.yaml
   5.1 Make sure that containers-prepare-parameter-stein.yaml file contains the following:
     ContainerImagePrepare:
     - push_destination: true   <<<<< Important, otherwise the containers won't be uploaded locally.
       set:
         namespace: docker.io/tripleostein
         neutron_driver: openvswitch
         rhel_containers: "false"
 
6. In Undercloud's home directory, there should exist an undercloud.conf file. Change the container_images_file field:
    container_images_file = /home/zuul/containers-prepare-parameter-stein.yaml
7. Run the undercloud upgrade command:
    openstack undercloud upgrade -y
    
 ==========OVERCLOUD===================
1. Use the same overcloud deploy parameters for the openstack upgrade prepare step (the easiest way is to copy overcloud-deploy.sh into overcloud-upgrade-prepare.sh and change the command name and extra parameters needed)
2. Create a environment file in which we'll pass the right parameters to enable the upgrade:
cat <<EOF > ~/overcloud-params.yaml
parameter_defaults:
  UpgradeLeappEnabled: False
  SELinuxMode: permissive
  UpgradeInitCommand: |
    yum install -y https://trunk.rdoproject.org/centos7/consistent/python2-tripleo-repos-0.0.1-0.20191001113300.9dba973.el7.noarch.rpm
    tripleo-repos -b stein current-tripleo
EOF
3. Append the created files into the overcloud-upgrade-prepare.sh script or the command directly:
   -e ~/overcloud-params.yaml
4. If your environment was deployed with ML2-OVS, you need to pass the environment variable neutron-ovs.yaml in the upgrade prepare step.
   In the case you are not sure if your environment is deployed with OVN or ML2-OVS, you can check it via:
   openstack stack output show overcloud EnabledServices | grep 'neutron_ovs_agent' 
   if it matches you will need to pass the enviroment file.
   -e <tht_directory>/environments/services/neutron-ovs.yaml
5. Check if the initial overcloud-deploy.sh or the command for deployment appended a containers-parameters-default.yaml file. If so, remove it
   from the overcloud-upgrade-prepare.sh and make sure to append at the end of the command the containers-prepare-parameter-stein.yaml file we
   used for the Undercloud upgrade:
     -e /home/zuul/containers-prepare-parameter-stein.yaml
6. Substitute the docker.yaml environment file for the podman.yaml one and remove docker-ha.yaml. Try to append the environments/podman.yaml 
   environment file at the very end, so it will override any ContainerCli value set in any other environment files. Remove
   /home/zuul/containers-default-parameters.yaml file also.
7. The command should look like this:
   openstack overcloud upgrade prepare --override-ansible-cfg /home/zuul/custom_ansible.cfg \
    --templates /usr/share/openstack-tripleo-heat-templates \
    --libvirt-type qemu  --timeout 157 --ntp-server 0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org 
    -e /home/zuul/cloud-names.yaml          
    -e /usr/share/openstack-tripleo-heat-templates/ci/environments/network/multiple-nics/network-isolation-absolute.yaml 
    -e /usr/share/openstack-tripleo-heat-templates/ci/environments/network/multiple-nics/network-environment.yaml 
    -e /home/zuul/overcloud_network_params.yaml  -e /home/zuul/overcloud_storage_params.yaml  
    -e /usr/share/openstack-tripleo-heat-templates/environments/low-memory-usage.yaml 
    -e /opt/stack/new/tripleo-ci/test-environments/worker-config.yaml 
    -e /usr/share/openstack-tripleo-heat-templates/environments/debug.yaml  -e /home/zuul/enable-tls.yaml 
    -e /usr/share/openstack-tripleo-heat-templates/environments/ssl/tls-endpoints-public-ip.yaml 
    -e /home/zuul/inject-trust-anchor.yaml   -e /usr/share/openstack-tripleo-heat-templates/environments/disable-telemetry.yaml 
    --validation-warnings-fatal    -e /home/zuul/overcloud-topology-config.yaml  -e /home/zuul/overcloud-selinux-config.yaml 
    -e /usr/share/openstack-tripleo-heat-templates/ci/environments/ovb-ha.yaml  
    -e /usr/share/openstack-tripleo-heat-templates/environments/services/neutron-ovs.yaml 
    -e /home/zuul/overcloud-params.yaml 
    -e /home/zuul/containers-prepare-parameter-stein.yaml
    -e /usr/share/openstack-tripleo-heat-templates/environments/podman.yaml
8. Execute the command or the script:
     ./overcloud-upgrade-prepare.sh
9. Run the containers preparation step:
     openstack overcloud external-upgrade run --tags container_image_prepare
10. Log in to any of the Controllers and check which is the bootstrap node for pacemaker:
     ssh heat-admin@<IP ctrlr> "sudo hiera -c /etc/puppet/hiera.yaml pacemaker_short_bootstrap_node_name"
   That will be the first controller you will have to start with. For this example, lets suppose it is overcloud-controller-0.
11. Run the system_upgrade step for overcloud-controller-0:
   openstack overcloud upgrade run --playbook upgrade_steps_playbook.yaml --tags system_upgrade --limit overcloud-controller-0
12. Execute the transfer data step for the bootstrap Controller node [This can be only run once]:
   openstack overcloud external-upgrade run --tags system_upgrade_transfer_data
13. Run the overcloud upgrade command for the bootstrap overcloud node:
   openstack overcloud upgrade run --limit overcloud-controller-0

# https://gist.github.com/jfrancoa/d1fa9e5bd81f380412dd95b534b6ebc0
