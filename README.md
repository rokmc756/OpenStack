## What is this Ansible Playbook for OpenStack
It is Ansible Playbook to deploy OpenStack by Packstack and Devstack for Rocky/CentOS 9.x and Ubuntu 22.x.
The purpose of this is only for development environment not production.

## Openstack Architecutre
![alt text]()

## Supported Platform and OS
Virtual Machines\
Baremetal\
RHEL and CentOS 9 and Rocky Linux 9.x\
Ubuntu 22.x

## Prerequisite for ansible host
MacOS or Windows Linux Subsysetm or Many kind of Linux Distributions should have ansible as ansible host.\
Supported OS for ansible target host should be prepared with package repository configured such as yum, dnf and apt\

## Prepare Ansible Host to run this Ansible Playbook
* MacOS
```
$ xcode-select --install
$ brew install ansible
$ brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
```

* Fedora/CentOS/RHEL, Ubuntu, OpenSUSE
```
$ yum install ansible
$ apt install ansible
```

## How to Deploy and Destroy OpenStack by Packstack or DevStack
#### 1) Configure Variables and Inventory with Hostnames, IP Addresses, sudo Username and Password
##### Configure Inventory for Devstack
```
$ vi ansible-hosts-devstack
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"
ansible_python_interpreter=/usr/bin/python3

[controller]
ubt22-rdo01 ansible_ssh_host=192.168.1.171

[compute]
ubt22-rdo02 ansible_ssh_host=192.168.1.172
ubt22-rdo03 ansible_ssh_host=192.168.1.173
```

##### Configure Variables for Devstack
```
```

##### Configure Global Variables
```
```


#### 1) Deploy OpenStack by Devstack
```
$ vi setup-devstack.yml
---
- hosts: all
  become: yes
  vars:
    print_debug: true
  roles:


$ make prepare
$ make devstack r=install s=controller
$ make devstack r=install s=compute

$ make devstack r=uninstall s=compute
$ make devstack r=uninstall s=controller

```


#### 2) Deploy and Destroy OpenStack by Packstack
```
$ vi setup-packstack.yml
---
- hosts: all
  become: yes
  vars:
    print_debug: true
  roles:
    - packstack


$ make packstack r=prepare
$ make packstack r=install

$ make packstack r=uninstall
```



## Similar Playbook

## TODO

## Debugging

## References
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

