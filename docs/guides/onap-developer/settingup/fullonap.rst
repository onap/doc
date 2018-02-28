.. This work is licensed under a Creative Commons Attribution 4.0 International License.
   http://creativecommons.org/licenses/by/4.0
   Copyright 2017 ONAP


.. contents::
   :depth: 2
..

.. index:: Setting Up Full ONAP


========================
**Setting Up Full ONAP**
========================

.. _demo-installing-running-onap:

**Context**
===========
ONAP may be deployed in different contexts depending on your requirements. The recommended installation for Amsterdam Release is currently based on OpenStack HEAT Template.

Using the Amsterdam HEAT Template installer, ONAP can be deployed in a single tenant or multiple tenants. One tenant for all the components except DCAE, and another tenant dedicated to the DCAE components.

The VNFs managed by ONAP may be deployed in different OpenStack tenants or based on top of VMware based infrastructure. For details, refer :ref:`to MultiCloud project<index-multicloud>`.

The current installation is based on the single tenant deployment (all the ONAP components will be hosted in a unique tenant) with DCAE components deployed in High Availability mode.

The installation requires some manual tasks to setup the DCAE components.

.. _demo-installing-running-onap-requirements:

**Requirements**
================

OpenStack
---------
ONAP installation is validated on `OpenStack Ocata <https://releases.openstack.org/ocata/>`_ or latter release.

You can use various Cloud providers offering OpenStack based solutions. A list of available Cloud providers on the `OpenStack marketplace <https://www.openstack.org/marketplace/public-clouds/>`_.

You can use your private Cloud infrastructure.

The following OpenStack components must be deployed in the infrastructure:
 - *Cinder*
 - *Designate*
 - *Glance*
 - *Heat*
 - *Horizon*
 - *Keystone*
 - *Neutron*
 - *Nova*

To deploy OpenStack, you can use various solutions:
 - `OpenStack installation guide <https://docs.openstack.org/install-guide/>`_
 - `OPNFV Cross Community Continuous Integration - XCI installer <http://docs.opnfv.org/en/latest/infrastructure/xci.html>`_
 - `OpenStack Ocata installation guide <https://docs.openstack.org/ocata/install/>`_

.. tip::
 - Notice the documentation version mentioned in the URL, e.g. ocata/, pike/, latest/ ...
 - The installation is pretty huge, some automated scripts have been created by the community:

  - `OpenStack installation with Ansible (All openstack services) <https://docs.openstack.org/openstack-ansible/latest/>`_
  - `OpenStack Ocata installation scripts for testing environment (DO NOT install Heat, Designate and Cinder Volume services) <https://github.com/reachsrirams/openstack-scripts>`_

Use the procedure below to deploy and configure *Designate* manually

.. toctree::
   :maxdepth:	 1

   install-designate.rst


The OpenStack infrastructure must enable internet access and you need to have an "External network" already configured properly.
The External network ID will have to be provided in the Heat environment file.

ONAP components
---------------
The following table presents the mapping between the created VM and the ONAP components, and provides VM information (flavor and image):

    ===================  =================   =======  ============
    VM name              ONAP project(s)     Flavor   Image
    ===================  =================   =======  ============
    onap-aai-inst1       AAI                 xlarge   Ubuntu 14.04
    onap-aai-inst2       AAI/UI              xlarge   Ubuntu 14.04
    onap-appc            APPC, CCSDK         large    Ubuntu 14.04
    onap-clamp           CLAMP               medium   Ubuntu 16.04
    onap-dns-server      *Internal DNS*      small    Ubuntu 14.04
    onap-message-router  DMAAP               large    Ubuntu 14.04
    onap-multi-service   MSB, VF-C, VNFSDK   xxlarge  Ubuntu 16.04
    onap-policy          Policy              xlarge   Ubuntu 14.04
    onap-portal          Portal, CLI         large    Ubuntu 14.04
    onap-robot           Integration         medium   Ubuntu 16.04
    onap-sdc             SDC                 xlarge   Ubuntu 16.04
    onap-sdnc            SDNC, CCSDK         large    Ubuntu 14.04
    onap-so              SO                  large    Ubuntu 16.04
    onap-vid             VID                 medium   Ubuntu 14.04
    onap-dcae-bootstrap  DCAE, Holmes        small    Ubuntu 14.04
    dcaeorcl00           DCAE/Orchestr.      medium   CentOS 7
    dcaecnsl00           DCAE/Consul         medium   Ubuntu 16.04
    dcaecnsl01           DCAE/Consul         medium   Ubuntu 16.04
    dcaecnsl02           DCAE/Consul         medium   Ubuntu 16.04
    dcaedokp00           DCAE/Policy Hand.   medium   Ubuntu 16.04
    dcaedoks00           DCAE/VES, Holmes    medium   Ubuntu 16.04
    dcaepgvm00           DCAE/Postrges       medium   Ubuntu 16.04
    dcaecdap00           DCAE/CDAP           large    Ubuntu 16.04
    dcaecdap01           DCAE/CDAP           large    Ubuntu 16.04
    dcaecdap02           DCAE/CDAP           large    Ubuntu 16.04
    dcaecdap03           DCAE/CDAP           large    Ubuntu 16.04
    dcaecdap04           DCAE/CDAP           large    Ubuntu 16.04
    dcaecdap05           DCAE/CDAP           large    Ubuntu 16.04
    dcaecdap06           DCAE/CDAP           large    Ubuntu 16.04
    ===================  =================   =======  ============

Footprint
---------
The ONAP installation requires the following footprint:
 - 29 VM
 - 148 vCPU
 - 336 GB RAM
 - 3 TB Storage
 - 29 floating IP addresses

.. Note: The default flavor size may be optimized. The ONAP community is working to update flavors of basic ONAP installation.

.. Note: You should also reserve some resources for the VNFs to be deployed.

Artifacts
---------
The following artifacts must be deployed on the OpenStack infrastructure:
 - a public SSH key to access the various VM
 - private SSH key and public key SSH key for the DCAE VM
 - Ubuntu 14.04 image (https://cloud-images.ubuntu.com/releases/14.04/14.04/)
 - Ubuntu 16.04 image (https://cloud-images.ubuntu.com/releases/16.04/release/)
 - CentOS 7 image (http://cloud.centos.org/centos/7/images/)
 - Set of flavors: small, medium, large, medium, large, xlarge, xxlarge

.. Note: The floating IP may be private IP.

.. Note: Basic flavors can reuse the default flavors as defined by `OpenStack <https://docs.openstack.org/horizon/latest/admin/manage-flavors.html>`_
   The xxlarge flavor should be configured using the following values: 12 vCPU, 64 GB RAM and 120 GB storage.

Security
--------
The default installation assumes that the Default security group is configured to enable full access between the ONAP components.
Depending on your environment, we may need to open some security groups (eg when using the portal from your desktop).

The list of various services and ports used can be found on the `ONAP wiki <https://wiki.onap.org/display/DW/ONAP+Services+List#ONAPServicesList-ONAPServices>`_.

**Deployment**
==============

Source files
------------

Both following files must be downloaded and configured to match your configuration:

- Template file: https://git.onap.org/demo/plain/heat/ONAP/onap_openstack.yaml?h=amsterdam
- Environment file: https://git.onap.org/demo/plain/heat/ONAP/onap_openstack.env?h=amsterdam

The environment file must be customized as described in the following sections.

.. Note Amsterdam release files

Description
-----------

The ONAP HEAT template spins up all the components expect the DCAE. The template,
onap_openstack.yaml, comes with an environment file,
onap_openstack.env, in which all the default values are defined.

The HEAT template is composed of two sections: (i) parameters, and (ii)
resources.
The parameter section contains the declaration and
description of the parameters that will be used to spin up ONAP, such as
public network identifier, URLs of code and artifacts repositories, etc.
The default values of these parameters can be found in the environment
file.

The resource section contains the definition of:

- ONAP Private Management Network, which ONAP components use to communicate with each other and with VNFs
- ONAP Virtual Machines (VMs)
- Public/private key pair used to access ONAP VMs
- Virtual interfaces towards the ONAP Private Management Network
- Disk volumes

Each VM specification includes Operating System image name, VM size
(i.e. flavor), VM name, etc. Each VM has two virtual network interfaces:
one towards the public network and one towards the ONAP Private
Management network, as described above. Furthermore, each VM runs a
post-instantiation script that downloads and installs software
dependencies (e.g. Java JDK, gcc, make, Python, ...) and ONAP software
packages and Docker containers from remote repositories.

When the HEAT template is executed, the OpenStack HEAT engine creates
the resources defined in the HEAT template, based on the parameters
values defined in the environment file.

Environment file
----------------

Before running HEAT, it is necessary to customize the environment file.
Indeed, some parameters, namely public_net_id, pub_key,
openstack_tenant_id, openstack_username, and openstack_api_key,
need to be set depending on the user's environment:

**Global parameters**

::

 public_net_id:       PUT YOUR NETWORK ID/NAME HERE
 pub_key:             PUT YOUR PUBLIC KEY HERE
 openstack_tenant_id: PUT YOUR OPENSTACK PROJECT ID HERE
 openstack_username:  PUT YOUR OPENSTACK USERNAME HERE
 openstack_api_key:   PUT YOUR OPENSTACK PASSWORD HERE
 horizon_url:         PUT THE HORIZON URL HERE
 keystone_url:        PUT THE KEYSTONE URL HERE (do not include version number)

openstack_region parameter is set to RegionOne (OpenStack default). If
your OpenStack is using another Region, please modify this parameter.

public_net_id is the unique identifier (UUID) or name of the public
network of the cloud provider. To get the public_net_id, use the
following OpenStack CLI command (ext is the name of the external
network, change it with the name of the external network of your
installation)

::

 openstack network list  | grep ext |  awk '{print $2}'

pub_key is string value of the public key that will be installed in
each ONAP VM. To create a public/private key pair in Linux, please
execute the following instruction:

::

 user@ubuntu:~$ ssh-keygen -t rsa

The following operations create the public/private key pair:

::

 Generating public/private rsa key pair.
 Enter file in which to save the key (/home/user/.ssh/id_rsa):
 Created directory '/home/user/.ssh'.
 Enter passphrase (empty for no passphrase):
 Enter same passphrase again:
 Your identification has been saved in /home/user/.ssh/id_rsa.
 Your public key has been saved in /home/user/.ssh/id_rsa.pub.

openstack_username, openstack_tenant_id (password), and
openstack_api_key are user's credentials to access the
OpenStack-based cloud.

**Images and flavors parameters**

::

 ubuntu_1404_image: PUT THE UBUNTU 14.04 IMAGE NAME HERE
 ubuntu_1604_image: PUT THE UBUNTU 16.04 IMAGE NAME HERE
 flavor_small:       PUT THE SMALL FLAVOR NAME HERE
 flavor_medium:      PUT THE MEDIUM FLAVOR NAME HERE
 flavor_large:       PUT THE LARGE FLAVOR NAME HERE
 flavor_xlarge:      PUT THE XLARGE FLAVOR NAME HERE
 flavor_xxlarge:     PUT THE XXLARGE FLAVOR NAME HERE

To get the images in your OpenStack environment, use the following
OpenStack CLI command:

::

        openstack image list | grep 'ubuntu'

To get the flavor names used in your OpenStack environment, use the
following OpenStack CLI command:

::

        openstack flavor list

**Network parameters**

::

 dns_list: PUT THE ADDRESS OFTHE EXTERNAL DNS HERE (e.g. a comma-separated list of IP addresses in your /etc/resolv.conf in UNIX-based Operating Systems). THIS LIST MUST INCLUDE THE DNS SERVER THAT OFFERS DNS AS AS SERVICE (see DCAE section below for more details)
 external_dns: PUT THE FIRST ADDRESS OF THE EXTERNAL DNS LIST HERE oam_network_cidr: 10.0.0.0/16
 dns_forwarder: PUT THE IP OF DNS FORWARDER FOR ONAP DEPLOYMENT'S OWN DNS SERVER
 oam_network_cidr: 10.0.0.0/16

You can use the Google Public DNS 8.8.8.8 and 4.4.4.4 address or your internal DNS servers.

ONAP installs a DNS server used to resolve IP addresses in the ONAP OAM private network.
ONAP Amsterdam Release also requires OpenStack Designate DNS support for the DCAE platform, so as to allow IP address discovery and communication among DCAE elements.
This is required because the ONAP HEAT template only installs the DCAE bootstrap container, which will in turn install the entire DCAE platform.
As such, at installation time, the IP addresses of the DCAE components are unknown.

The DNS server that ONAP installs needs to be connected to the Designate DNS to allow communication between the DCAE elements and the other ONAP components.
To this end, dns\_list, external\_dns, and dns\_forwarder should all have the IP address of the Designate DNS.
These three parameters are redundant, but still required for Amsterdam Release. Originally, dns\_list and external\_dns were both used to circumvent some limitations of older OpenStack versions.
In future releases, the DNS settings and parameters in HEAT will be consolidated.
The Designate DNS is configured to access the external DNS.
As such, the ONAP DNS will forward to the Designate DNS the queries from ONAP components to the external world.
The Designate DNS will then forward those queries to the external DNS.

**DCAE Parameters**

DCAE spins up ONAP's data collection and analytics system in two phases.

The first phase consists of launching a bootstrap VM that is specified in the ONAP HEAT template, as described above. This VM requires a number of deployment-specific configuration parameters being provided so that it can subsequently bring up the DCAE system.

There are two groups of parameters:

- The first group relates to the launching of DCAE VMs, including parameters such as the keystone URL and additional VM image IDs/names. Hence these parameters need to be provided to DCAE. Note that although DCAE VMs will be launched in the same tenant as the rest of ONAP, because DCAE may use MultiCloud node as the agent for interfacing with the underlying cloud, it needs a separate keystone URL (which points to MultiCloud node instead of the underlying cloud).


- The second group of configuration parameters relate to DNS As A Service support (DNSaaS). DCAE requires DNSaaS for registering its VMs into organization-wide DNS service. For OpenStack, DNSaaS is provided by Designate, as mentioned above. Designate support can be provided via an integrated service endpoint listed under the service catalog of the OpenStack installation; or proxyed by the ONAP MultiCloud service. For the latter case, a number of parameters are needed to configure MultiCloud to use the correct Designate service.

These parameters are described below:

::

 dcae_keystone_url: PUT THE MULTIVIM PROVIDED KEYSTONE API URL HERE
 dcae_centos_7_image: PUT THE CENTOS7 VM IMAGE NAME HERE FOR DCAE LAUNCHED CENTOS7 VM
 dcae_domain: PUT THE NAME OF DOMAIN THAT DCAE VMS REGISTER UNDER
 dcae_public_key: PUT THE PUBLIC KEY OF A KEYPAIR HERE TO BE USED BETWEEN DCAE LAUNCHED VMS
 dcae_private_key: PUT THE SECRET KEY OF A KEYPAIR HERE TO BE USED BETWEEN DCAE LAUNCHED VMS

 dnsaas_config_enabled: PUT WHETHER TO USE PROXYED DESIGNATE
 dnsaas_region: PUT THE DESIGNATE PROVIDING OPENSTACK'S REGION HERE
 dnsaas_keystone_url: PUT THE DESIGNATE PROVIDING OPENSTACK'S KEYSTONE URL HERE
 dnsaas_tenant_name: PUT THE TENANT NAME IN THE DESIGNATE PROVIDING OPENSTACK HERE (FOR R1 USE THE SAME AS openstack_tenant_name)
 dnsaas_username: PUT THE DESIGNATE PROVIDING OPENSTACK'S USERNAME HERE
 dnsaas_password: PUT THE DESIGNATE PROVIDING OPENSTACK'S PASSWORD HERE

Instantiation
-------------

The ONAP platform can be instantiated via Horizon (OpenStack dashboard)
or Command Line.

**Instantiation via Horizon:**

- Login to Horizon URL with your personal credentials
- Click "Stacks" from the "Orchestration" menu
- Click "Launch Stack"
- Paste or manually upload the HEAT template file (onap_openstack.yaml) in the "Template Source" form
- Paste or manually upload the HEAT environment file (onap_openstack.env) in the "Environment Source" form
- Click "Next" - Specify a name in the "Stack Name" form
- Provide the password in the "Password" form
- Click "Launch"

**Instantiation via Command Line:**

- You need to have the OpenStack Heat service installed:

- Create a file (named i.e. ~/openstack/openrc) that sets all the
  environmental variables required to access your OpenStack tenant:

::

 export OS_AUTH_URL=INSERT THE AUTH URL HERE
 export OS_USERNAME=INSERT YOUR USERNAME HERE
 export OS_TENANT_ID=INSERT YOUR TENANT ID HERE
 export OS_REGION_NAME=INSERT THE REGION HERE
 export OS_PASSWORD=INSERT YOUR PASSWORD HERE
 export OS_USER_DOMAIN_NAME=INSERT YOUR DOMAIN HERE
 export OS_PROJECT_NAME=INSERT YOUR PROJECT NAME HERE

-  Run the script from command line:

::

 source ~/openstack/openrc

-  In order to install the ONAP platform, type:

::

 # Old HEAT client
 heat stack-create STACK_NAME -f PATH_TO_HEAT_TEMPLATE(YAML FILE) -e PATH_TO_ENV_FILE

 OR

 # New OpenStack client
 openstack stack create -t PATH_TO_HEAT_TEMPLATE(YAML FILE) -e PATH_TO_ENV_FILE STACK_NAME


.. Note The HEAT template deployment may take time (up to one hour) depending on your hardware environment.

Deploy DCAE
-----------
The HEAT template deployed the onap-dcae-bootstrap virtual machine.

.. Note To provide the manual tasks to configure the local environment


Test the installation
---------------------
Every ONAP component offers a HealthCheck REST API. The Robot Virtual Machine (*onap-robot*) can be used to test that every components run smoothly.
Run the following command to perform the HealthCheck:

.. code-block:: bash

  docker exec -it openecompete_container /var/opt/OpenECOMP_ETE/runTags.sh -i health h -d ./html -V /share/config/integration_robot_properties.py -V /share/config/integration_preload_parameters.py -V /share/config/vm_properties.py

This test suite will execute 30 tests towards the various ONAP components.

After the installation, it is possible to deploy the various use-cases described in `ONAP wiki <https://wiki.onap.org/display/DW/Running+the+ONAP+Demos>`_.

Detect problems
---------------
If all the tests are not OK, many causes are possible.
Here is a simple procedure to detect where the problem occurs:

* Check the OpenStack Virtual Machine logs
* Connect to the Virtual Machine and check that the various containers are running.

The list of containers are described on the `ONAP wiki <https://wiki.onap.org/display/DW/ONAP+Services+List#ONAPServicesList-ONAPServices>`_
. In case some containers are missing, check the Docker logs using the following command:

.. code-block:: bash

 sudo docker ps -a
 sudo docker logs <containerid>

**Portal configuration**
========================
The current ONAP installation is using the *onap.org* domain.
To use the portal on your desktop, you must configure the following information in your *host* file (located in /etc/host for Linux or /windows/system32/drivers/etc/hosts for Windows):

.. code-block:: bash

 <onap-policy_ip>      policy.api.simpledemo.onap.org
 <onap-portal_ip>      portal.api.simpledemo.onap.org
 <onap-sdc_ip>         sdc.api.simpledemo.onap.org
 <onap-vid_ip>         vid.api.simpledemo.onap.org
 <onap-aai-inst1_ip>   aai.api.simpledemo.onap.org
 <onap-aai-inst2_ip>   aai.ui.simpledemo.onap.org


You can use the Horizon dashboard to get the IP addresses associated with the Virtual Machines or use the following command line:

.. code-block:: bash

 openstack server list

Launch the portal on the http://portal.api.simpledemo.onap.org:8989/ONAPPORTAL/login.htm

Various users are predefined as presented in the following table:

  .. csv-table::
   :header: Role, Login
   :widths: 20, 20

    Superuser,demo
    Designer,cs0008
    Tester,jm0007
    Governor,gv0001
    Ops,op0001

The password is *demo123456!*

Go to the `Portal component user guide <http://onap.readthedocs.io/en/latest/submodules/portal.git/docs/index.html>`_

Other UI documentation:
 - `CLAMP  <http://onap.readthedocs.io/en/latest/submodules/clamp.git/docs/index.html>`_
 - `SDC <http://onap.readthedocs.io/en/latest/submodules/sdc.git/docs/index.html>`_
 - `UI Use-Case <http://onap.readthedocs.io/en/latest/submodules/usecase-ui.git/docs/index.html>`_


**Components**
==============

The list of various services and ports used can be found on the `ONAP wiki <https://wiki.onap.org/display/DW/ONAP+Services+List#ONAPServicesList-ONAPServices>`_

.. This work is licensed under a Creative Commons Attribution 4.0 International License.
   http://creativecommons.org/licenses/by/4.0
   Copyright 2017 ONAP


.. contents::
