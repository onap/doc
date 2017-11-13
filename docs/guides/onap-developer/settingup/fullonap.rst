.. This work is licensed under a Creative Commons Attribution 4.0 International License.
   http://creativecommons.org/licenses/by/4.0
   Copyright 2017 ONAP


.. contents::
   :depth: 2
..


========================
**Setting Up Full ONAP**
========================

.. _demo-installing-running-onap:

**Context**
===========
ONAP may be deployed in different contexts depending on your requirements. The recommended installation for Amsterdam Release is currently based on Open Stack.

Using the Amsterdam Release installer, ONAP components may be deployed in a single tenant or multiple tenants. One tenant for all the components except DCAE, and another tenant dedicated to the DCAE components. 

The VNFs managed by ONAP may be deployed in different Open Stack tenants or based on top of VMware based infrastructure (cf MultiCloud project).

Figure 1 

The current installation is based on the single tenant deployment (all the ONAP components will be hosted in a unique tenant)


**Requirements**
================

OpenStack
---------
ONAP installation is validated on `OpenStack Ocata <https://releases.openstack.org/ocata/>`_ or latter release.

The following Open Stack components must be deployed in the infrastructure: 
 - *Cinder*
 - *Designate*
 - *Glance*
 - *Horizon*
 - *Keystone*

To deploy Open Stack, you can use various solutions:
 - `OpenStack installer <https://docs.openstack.org/install-guide/>`_
 - `OPNFV Cross Community Continuous Integration - XCI installer <http://docs.opnfv.org/en/latest/infrastructure/xci.html>`_

*Designate* component is usually not deployed using standard OpenStack installers.
Please find a guide to deploy and configure *Designate* 

Footprint
---------
The ONAP installation requires the following footprint:
 - xx VM
 - xxx vCPU
 - xxx RAM
 - xxx Storage
 - xxx floating IP
 - a public SSH key
 - a private SSH key

Note that floating IP may be private IP.

Security
--------
The default installation assumes that the Default security group is configured to enable full access between the ONAP components.
Depending on your environment, we may need to open some security groups (eg when using the portal from your desktop) 

The following YAML file presents the ports exposed by the various components:

.. code-block:: yaml

 --- 
 aai: 
  - 8889 

TODO Generate the YAML file with installation

TODO Provide a command to create the security groups

**Deployment**
==============

Instantiation
-------------
- To deploy ONAP, use the Heat template and follow the described guidelines in integration project.

- The Heat template deployment may take time (up to one hour) depending on your hardware environment.

Test the installation
---------------------
Every ONAP component offers a HealthCheck REST API. The *Robot Virtual Machine* can be used to test that every components run smoothly.
Run the following command to perform the HealthCheck:

.. code-block:: bash

  docker exec -it openecompete_container /var/opt/OpenECOMP_ETE/runTags.sh -i health h -d ./html -V /share/config/integration_robot_properties.py -V /share/config/integration_preload_parameters.py -V /share/config/vm_properties.py

This testsuite will execute 31 tests towards the various ONAP components.

Detect problems
---------------
If all the tests are not OK, many causes are possible.
Here is a simple procedure to detect where the problem occurs:

* Check the OpenStack Virtual Machine logs 
* Connect to the Virtual Machine and check that the various containers are running.

The list of containers are described in the following section. In case some containers are missing, check the docker logs using the following command:

.. code-block:: bash

 sudo docker ps -a
 sudo docker logs <containerid>


**Portal configuration**
========================
The current ONAP installation is using the onap.org domain.
To use the portal on your desktop, you must configure the following information in your *host* file (located in /etc/host for Linux or /windows/system32/drivers/etc/hosts for Windows):

.. code-block:: bash

 104.239.249.17   policy.api.simpledemo.onap.org
 104.130.31.25    portal.api.simpledemo.onap.org
 104.239.249.15   sdc.api.simpledemo.onap.org
 104.130.170.142  vid.api.simpledemo.onap.org
 104.239.249.72   aai.api.simpledemo.onap.org 
 TODO ADD ui.aai

You can use the Horizon dashboard to get the IP adresses associated with the Virtual Machines or use the following command line:

.. code-block:: bash

 openstack server list

Launch the portal on the http://portal.api.simpledemo.onap.org:8989/ONAPPORTAL/login.htm

Go to the Portal component user guide.

Other UI documentation:
 - CLAMP
 - SDC Portal
 - UI Case


**Components**
==============

The following YAML file presents the list of containers for every Virtual Machine

.. code-block:: yaml

 aai:
   - traversal
   - be
   - fe
 appc
   - fe



