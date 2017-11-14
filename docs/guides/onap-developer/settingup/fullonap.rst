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
ONAP may be deployed in different contexts depending on your requirements. The recommended installation for Amsterdam Release is currently based on OpenStack.

Using the Amsterdam Release installer, ONAP components may be deployed in a single tenant or multiple tenants. One tenant for all the components except DCAE, and another tenant dedicated to the DCAE components.

The VNFs managed by ONAP may be deployed in different OpenStack tenants or based on top of VMware based infrastructure (cf MultiCloud project).

The current installation is based on the single tenant deployment (all the ONAP components will be hosted in a unique tenant) with DCAE componntes deployed in High Availability mode.

**Requirements**
================

OpenStack
---------
ONAP installation is validated on `OpenStack Ocata <https://releases.openstack.org/ocata/>`_ or latter release.

The following Open Stack components must be deployed in the infrastructure:
 - *Cinder*
 - *Designate*
 - *Glance*
 - *Heat*
 - *Horizon*
 - *Keystone*
 - *Neutron*
 - *Nova*

To deploy OpenStack, you can use various solutions:
 - `OpenStack installer <https://docs.openstack.org/install-guide/>`_
 - `OPNFV Cross Community Continuous Integration - XCI installer <http://docs.opnfv.org/en/latest/infrastructure/xci.html>`_

*Designate* component is usually not deployed using standard OpenStack installers.
Please find a guide to deploy and configure *Designate*.

The OpenStack infrastructure must enable internet access.

ONAP components
---------------
The following table presents the mapping between the created VM and the ONAP components, and provides informtaion about he VM (flavor and image):

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
 - 29 floating IP

.. Note: the default flavor size may be optimized. The ONAP community is working to provide adpted flavors for basic ONAP installation.

.. Note: you should also reserve some resourcse for the VNFs to be deployed.

Artifacts
---------
The following artifacts must be deployed on the OpenStack infrastructure.
 - a public SSH key to access the various VM
 - private SSH key and public key SSH key for the DCAE VM
 - Ubuntu 14.04 image
 - Ubuntu 16.04 image
 - CentOS 7 image
 - Set of flavors: small, medium, large, medium, large, xlarge, xxlarge

.. Note that floating IP may be private IP.

.. Note Basic flavors can reuse the default flavors as defined by `OpenStack <https://docs.openstack.org/horizon/latest/admin/manage-flavors.html>`_
   The xxlarge flavor should be confiured using the following values: 12 vCPU, 64 GB RAM and 120 GB storage.

Security
--------
The default installation assumes that the Default security group is configured to enable full access between the ONAP components.
Depending on your environment, we may need to open some security groups (eg when using the portal from your desktop).

The following tables presents the ports exposed by the various components:

TODO list the ports

**Deployment**
==============

Instantiation
-------------
- To deploy ONAP, use the Heat template and follow the described guidelines in `Integration project <http://onap.readthedocs.io/en/latest/submodules/integration.git/docs/index.html>`_

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
The current ONAP installation is using the *onap.org* domain.
To use the portal on your desktop, you must configure the following information in your *host* file (located in /etc/host for Linux or /windows/system32/drivers/etc/hosts for Windows):

.. code-block:: bash

 <onap-policy_ip>      policy.api.simpledemo.onap.org
 <onap-portal_ip>      portal.api.simpledemo.onap.org
 <onap-sdc_ip>         sdc.api.simpledemo.onap.org
 <onap-vid_ip>         vid.api.simpledemo.onap.org
 <onap-aai-inst1_ip>   aai.api.simpledemo.onap.org
 <onap-aai-inst2_ip>   aai.ui.simpledemo.onap.org


You can use the Horizon dashboard to get the IP adresses associated with the Virtual Machines or use the following command line:

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
 - `SDC http://onap.readthedocs.io/en/latest/submodules/sdc.git/docs/index.html>`_
 - `UI Use-Case <http://onap.readthedocs.io/en/latest/submodules/usecase-ui.git/docs/index.html>`_


**Components**
==============

The following table presents the list of containers for every Virtual Machine

  .. csv-table::
   :header: Virtual Machine, Container, Description
   :widths: 15, 20, 20

    onap-appc,sdnc_dgbuilder_container
    ,appc_controller_container
    ,sdnc_db_container

TODO: list all the containers

TODO: update the deployment figure available on the wiki ?

.. This work is licensed under a Creative Commons Attribution 4.0 International License.
   http://creativecommons.org/licenses/by/4.0
   Copyright 2017 ONAP


.. contents::
