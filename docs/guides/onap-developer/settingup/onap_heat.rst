.. This work is licensed undera Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017-2018 ONAP


.. contents::
   :depth: 2
..

.. index:: Setting Up Full ONAP using Virtual Machines


===============================================
**Setting Up Full ONAP using Virtual Machines**
===============================================

.. _demo-installing-running-onap:

**Context**
===========
ONAP may be deployed in different contexts depending on your requirements.
The recommended installation for Beijng Release over virtual machines is based
on OpenStack HEAT Template.

The VNFs managed by ONAP may be deployed in different OpenStack tenants or
based on top of VMware based infrastructure. For details, refer
:ref:`to MultiCloud project<index-multicloud>`.

The current installation is based on the single tenant deployment (all the ONAP
components will be hosted in a unique tenant).

.. _demo-installing-running-onap-requirements:

**Requirements**
================

OpenStack
---------
ONAP installation is validated on
`OpenStack Ocata <https://releases.openstack.org/ocata/>`_ or latter release.

You can use various Cloud providers offering OpenStack based solutions.
A list of available Cloud providers on the
`OpenStack marketplace <https://www.openstack.org/marketplace/public-clouds/>`_.

You can use your private Cloud infrastructure.

The following OpenStack components must be deployed in the infrastructure:
 - *Cinder*
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
 - Notice the documentation version mentioned in the URL, e.g. ocata/, pike/,
   latest/ ...
 - The installation is pretty huge, some automated scripts have been created by
   the community:

  - `OpenStack installation with Ansible (All openstack services) <https://docs.openstack.org/openstack-ansible/latest/>`_
  - `OpenStack Ocata installation scripts for testing environment(DO NOT install Heat, Designate and Cinder Volume services) <https://github.com/reachsrirams/openstack-scripts>`_

The OpenStack infrastructure must enable internet access and you need to have
an "External network" already configured properly.
The External network ID will have to be provided in the Heat environment file.

ONAP components
---------------
The following table presents the mapping between the created VM and the ONAP
components, and provides VM information (flavor and image):

    ===================  =================   =======  ============
    VM name              ONAP project(s)     Flavor   Image
    ===================  =================   =======  ============
    onap-aai-inst1       AAI                 xlarge   Ubuntu 14.04
    onap-aai-inst2       AAI/UI              xlarge   Ubuntu 14.04
    onap-appc            APPC, CCSDK         large    Ubuntu 14.04
    onap-clamp           CLAMP               medium   Ubuntu 16.04
    onap-dns-server      *Internal DNS*      small    Ubuntu 14.04
    onap-message-router  DMAAP               large    Ubuntu 14.04
    onap-multi-service   MSB, VF-C, VNFSDK   xlarge   Ubuntu 16.04
    onap-policy          Policy              xlarge   Ubuntu 14.04
    onap-portal          Portal, CLI         large    Ubuntu 14.04
    onap-robot           Integration         medium   Ubuntu 16.04
    onap-sdc             SDC                 xlarge   Ubuntu 16.04
    onap-sdnc            SDNC, CCSDK         large    Ubuntu 14.04
    onap-so              SO                  large    Ubuntu 16.04
    onap-vid             VID                 medium   Ubuntu 14.04
    onap-dcae            DCAE, Holmes        xlarge   Ubuntu 16.04
    onap-music           Music               large    Ubuntu 14.04
    onap-oof             OOF                 large    Ubuntu 16.04
    onap-aaf             AAF                 medium   Ubuntu 16.04
    onap-sms             AAF                 medium   Ubuntu 16.04
    onap-nbi             External API        small    Ubuntu 16.04
    ===================  =================   =======  ============

Footprint
---------
The ONAP installation requires the following footprint:
 - 20 VM
 - 88 vCPU
 - 176 GB RAM
 - 1.76 TB Storage
 - 20 floating IP addresses

.. Note: You should also reserve some resources for the VNFs to be deployed.

Artifacts
---------
The following artifacts must be deployed on the OpenStack infrastructure:
 - a public SSH key to access the various VM
 - Ubuntu 14.04 image (https://cloud-images.ubuntu.com/releases/14.04/14.04/)
 - Ubuntu 16.04 image (https://cloud-images.ubuntu.com/releases/16.04/release/)
 - Set of flavors: small, medium, large, xlarge

.. Note: The floating IP may be private IP.

.. Note: Basic flavors can reuse the default flavors as defined by
   OpenStack
   <https://docs.openstack.org/horizon/latest/admin/manage-flavors.html>`_

Security
--------
The default installation assumes that the Default security group is configured
to enable full access between the ONAP components.
Depending on your environment, we may need to open some security groups
(eg when using the portal from your desktop).

The list of various services and ports used can be found on the
`ONAP wiki - ports <https://wiki.onap.org/display/DW/ONAP+Services+List#ONAPServicesList-ONAPServices>`_.

**Deployment**
==============

Source files
------------

Both following files must be downloaded and configured to match your
configuration:

- Template file:
  https://git.onap.org/demo/plain/heat/ONAP/onap_openstack.yaml
- Environment file:
  https://git.onap.org/demo/plain/heat/ONAP/onap_openstack.env

The environment file must be customized as described in the following sections.

.. Note Beijing release files

Description
-----------

The ONAP Heat template spins up all the components including the DCAE.
The template, onap_openstack.yaml, comes with an environment file,
onap_openstack.env, in which all the default values are defined.

The Heat template is composed of two sections: (i) parameters, and (ii)
resources.
The parameter section contains the declaration and
description of the parameters that will be used to spin up ONAP, such as
public network identifier, URLs of code and artifacts repositories, etc.
The default values of these parameters can be found in the environment
file.

The resource section contains the definition of:

- ONAP Private Management Network, which ONAP components use to communicate
  with each other and with VNFs
- ONAP Virtual Machines (VMs)
- Public key pair used to access ONAP VMs
- Virtual interfaces towards the ONAP Private Management Network
- Disk volumes

Each VM specification includes Operating System image name, VM size
(i.e. flavor), VM name, etc. Each VM has two virtual network interfaces:
one towards the public network and one towards the ONAP Private
Management network, as described above. Furthermore, each VM runs a
post-instantiation script that downloads and installs software
dependencies (e.g. Java JDK, gcc, make, Python, ...) and ONAP software
packages and Docker containers from remote repositories.

When the Heat template is executed, the OpenStack Heat engine creates
the resources defined in the Heat template, based on the parameters
values defined in the environment file.

Environment file
----------------

Before running Heat, it is necessary to customize the environment file.
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

 ubuntu_1404_image:  PUT THE UBUNTU 14.04 IMAGE NAME HERE
 ubuntu_1604_image:  PUT THE UBUNTU 16.04 IMAGE NAME HERE
 flavor_small:       PUT THE SMALL FLAVOR NAME HERE
 flavor_medium:      PUT THE MEDIUM FLAVOR NAME HERE
 flavor_large:       PUT THE LARGE FLAVOR NAME HERE
 flavor_xlarge:      PUT THE XLARGE FLAVOR NAME HERE

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

 dns_list: PUT THE ADDRESS OF THE EXTERNAL DNS HERE (e.g. a comma-separated list
 of IP addresses in your /etc/resolv.conf in UNIX-based Operating Systems)
 external_dns: PUT THE FIRST ADDRESS OF THE EXTERNAL DNS LIST HERE
 dns_forwarder: PUT THE IP OF DNS FORWARDER FOR ONAP DEPLOYMENT'S OWN DNS SERVER
 oam_network_cidr: 10.0.0.0/16

You can use the Google Public DNS 8.8.8.8 and 4.4.4.4 address or your internal
DNS servers.

ONAP installs a DNS server used to resolve IP addresses in the ONAP OAM private
network.

**DCAE Parameters**

For Beijing Release, all the DCAE components are deployed in a single
virtual machine.
You must specify R2 to run R2 DCAE components.
Is you are using R1 to get R1 ONAP, you must fill all the other
DCAE parameters.
Please refer to the Amsterdam documentation to fill these parameters.
::

  dcae_deployment_profile: PUT DCAE DEPLOYMENT PROFILE (R1, R2MVP, R2, or R2PLUS)

Instantiation
-------------

The ONAP platform can be instantiated via Horizon (OpenStack dashboard)
or Command Line.

**Instantiation via Horizon:**

- Login to Horizon URL with your personal credentials
- Click "Stacks" from the "Orchestration" menu
- Click "Launch Stack"
- Paste or manually upload the Heat template file (onap_openstack.yaml) in the
  "Template Source" form
- Paste or manually upload the Heat environment file (onap_openstack.env) in
  the "Environment Source" form
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

 # Old Heat client

::

 heat stack-create STACK_NAME -f PATH_TO_HEAT_TEMPLATE(YAML FILE)
 -e PATH_TO_ENV_FILE

 OR

::

 # New OpenStack client
 openstack stack create -t PATH_TO_HEAT_TEMPLATE(YAML FILE)
 -e PATH_TO_ENV_FILE STACK_NAME


.. Note The Heat template deployment may take time (up to one hour)
   depending on your hardware environment.

Test the installation
---------------------
Every ONAP component offers a HealthCheck REST API. The Robot Virtual Machine
(*onap-robot*) can be used to test that every components run smoothly.
Run the following command to perform the HealthCheck:

.. code-block:: bash

  docker exec -it openecompete_container /var/opt/OpenECOMP_ETE/runTags.sh
  -i health
  -d ./html
  -V /share/config/integration_robot_properties.py
  -V /share/config/integration_preload_parameters.py
  -V /share/config/vm_properties.py

This test suite will execute 40 tests towards the various ONAP components.

After the installation, it is possible to deploy the various use-cases
described in `ONAP wiki - demos <https://wiki.onap.org/display/DW/Running+the+ONAP+Demos>`_.

Detect problems
---------------
If all the tests are not OK, many causes are possible.
Here is a simple procedure to detect where the problem occurs:

* Check the OpenStack Virtual Machine logs
* Connect to the Virtual Machine and check that the various containers are
  running.

The list of containers are described on the `ONAP wiki - containers <https://wiki.onap.org/display/DW/ONAP+Services+List#ONAPServicesList-ONAPServices>`_.
In case some containers are missing, check the Docker logs using the following
command:

.. code-block:: bash

 sudo docker ps -a
 sudo docker logs <containerid>

**Portal configuration**
========================
The current ONAP installation is using the *onap.org* domain.
To use the portal on your desktop, you must configure the following information
in your *host* file (located in /etc/hosts for Linux or
/windows/system32/drivers/etc/hosts for Windows):

.. code-block:: bash

 <onap-policy_ip>      policy.api.simpledemo.onap.org
 <onap-portal_ip>      portal.api.simpledemo.onap.org
 <onap-sdc_ip>         sdc.api.simpledemo.onap.org
 <onap-vid_ip>         vid.api.simpledemo.onap.org
 <onap-aai-inst1_ip>   aai.api.simpledemo.onap.org
 <onap-aai-inst2_ip>   aai.ui.simpledemo.onap.org


You can use the Horizon dashboard to get the IP addresses associated with the
Virtual Machines or use the following command line:

.. code-block:: bash

 openstack server list

Launch the portal on the
http://portal.api.simpledemo.onap.org:8989/ONAPPORTAL/login.htm

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

Go to the `Portal component user guide
<http://onap.readthedocs.io/en/latest/submodules/portal.git/docs/index.html>`_

Other UI documentation:
 - `CLAMP  <http://onap.readthedocs.io/en/latest/submodules/clamp.git/docs/index.html>`_
 - `SDC <http://onap.readthedocs.io/en/latest/submodules/sdc.git/docs/index.html>`_
 - `UI Use-Case <http://onap.readthedocs.io/en/latest/submodules/usecase-ui.git/docs/index.html>`_


**Components**
==============

The list of various services and ports used can be found on the
`ONAP wiki - services <https://wiki.onap.org/display/DW/ONAP+Services+List#ONAPServicesList-ONAPServices>`_

.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
..  http://creativecommons.org/licenses/by/4.0
.. Copyright 2017-2018 ONAP


.. contents::
