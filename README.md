


[ References ]

* OVS-DPDK
  - https://docs.napatech.com/r/Getting-Started-with-Napatech-Link-VirtualizationTM-Software/Enabling-IOMMU

* RDO with Packstack
  - http://igoni.kr/books/7/page/01-openstack

* Kolla-ansibl3
  - https://parandol.tistory.com/79

* OVN Deployment by Openstack-ansibl
  - Openstack-Ansible Multi-Node OVN Deployment

* Openstack-Ansible
  - https://evrard.me/installing-an-openstack-ansible-multi-node-cloud-in-the-cloud/

* Script
  - https://github.com/electrocucaracha/openstack-multinode

* BareMetal
  - https://docs.openstack.org/ironic/rocky/install/index.html

* Openstack Packages for RHEL and CentOS
  - https://docs.openstack.org/install-guide/environment-packages-rdo.html

* Prepare CentOS Server for RDO
  - https://platform9.com/docs/openstack-docs/openstack/preparing-centos-preparing-centos-server-for-neutron

* Packstack with All In One
  - https://cloudee.tistory.com/7

* Manual Install and Configure Openstack in Oracle@Solaris
  - https://docs.oracle.com/cd/E65465_01/html/E57770/docinfo.html#scrolltoc

* Multinode Openstack Using Packstack
  - https://www.youtube.com/watch?v=DGf-ny25OAw
  - https://www.linuxtechi.com/multiple-node-openstack-liberty-installation-on-centos-7-x/
  - https://docs.napatech.com/r/Getting-Started-with-Napatech-Link-VirtualizationTM-Software/Installing-OpenStack-on-Multiple-Nodes-via-Packstack

* RHOSP 16 with Multiple Nodes
  - https://www.linkedin.com/pulse/how-deploy-openstack-16-train-platform-using-packstack-goran-jumi%C4%87/

[ Packstack Deploy Error ]
~~~
[root@rk9-node01 rdo-scripts]# dnf install openstack-neutron-common
Last metadata expiration check: 0:51:59 ago on Fri 22 Nov 2024 08:36:43 PM KST.
Error:
 Problem: package python3-neutron-1:25.0.0-2.el9s.noarch from openstack-dalmatian requires python3.9dist(ovsdbapp) >= 2.7.1, but none of the providers can be installed
  - package openstack-neutron-common-1:25.0.0-2.el9s.noarch from openstack-dalmatian requires python3-neutron = 1:25.0.0-2.el9s, but none of the providers can be installed
  - package python3-ovsdbapp-2.8.0-1.el9s.noarch from openstack-dalmatian requires python3-openvswitch, but none of the providers can be installed
  - conflicting requests
  - package python3-rdo-openvswitch-2:3.3-1.el9s.noarch from openstack-dalmatian is filtered out by exclude filtering
(try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)

[root@rk9-node01 rdo-scripts]# /usr/bin/dnf install openstack-neutron
Last metadata expiration check: 0:53:09 ago on Fri 22 Nov 2024 08:36:43 PM KST.
Error:
 Problem: package openstack-neutron-common-1:25.0.0-2.el9s.noarch from openstack-dalmatian requires python3-neutron = 1:25.0.0-2.el9s, but none of the providers can be installed
  - package python3-neutron-1:25.0.0-2.el9s.noarch from openstack-dalmatian requires python3.9dist(ovsdbapp) >= 2.7.1, but none of the providers can be installed
  - package openstack-neutron-1:25.0.0-2.el9s.noarch from openstack-dalmatian requires openstack-neutron-common = 1:25.0.0-2.el9s, but none of the providers can be installed
  - package python3-ovsdbapp-2.8.0-1.el9s.noarch from openstack-dalmatian requires python3-openvswitch, but none of the providers can be installed
  - conflicting requests
  - package python3-rdo-openvswitch-2:3.3-1.el9s.noarch from openstack-dalmatian is filtered out by exclude filtering
(try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
~~~

