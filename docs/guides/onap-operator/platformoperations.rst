.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.


Platform Operations
===================

.. toctree::
   :maxdepth: 1
   :titlesonly:

ONAP Operations
---------------

Configuring, scaling and upgrading ONAP is supported by OOM and can
be found in:

.. toctree::
   :maxdepth: 2
   :titlesonly:

:ref:`oom_user_guide<onap-oom:oom_user_guide>`

ONAP Testing and Monitoring
---------------------------

Monitoring of ONAP depends on the deployment scenario.
Generally the infrastructure monitoring (Openstack, K8S) depends on the
platform ONAP is installed on.

Additionally ONAP supports the following additional tools to monitor ONAP
functions

**Basic Healthcheck of ONAP is supported by:**

.. toctree::
   :maxdepth: 2
   :titlesonly:

:ref:`RobotFramework<onap-integration:docs_robot>`

**Interface Health can be checked via Consul:**

   OOM provides two mechanisms to monitor the real-time health of an ONAP
   deployment

    * a Consul GUI for a human operator or downstream monitoring systems
      and Kubernetes liveness probes that enable automatic healing of
      failed containers, and
    * a set of liveness probes which feed into the Kubernetes manager

   Within ONAP, Consul is the monitoring system of choice and deployed
   by OOM in two parts:

    * a three-way, centralized Consul server cluster is deployed as a
      highly available monitor of all of the ONAP components, and a number
      of Consul agents.

   The Consul server provides a user interface that allows a user to
   graphically view the current health status of all of the ONAP components
   for which agents have been created

   The Consul GUI can be accessed via:

   http://<onap-kubernetes IP>:30270/ui/

**ONAP Log collection is provided by the Logging and Analytics Module:**

.. toctree::
   :maxdepth: 2
   :titlesonly:

:ref:`Logging & Analytics <onap-logging-analytics:master_index>`

ONAP Backup and Restore
-----------------------

To Backup ONAP a solution is described in Wiki (Migration to RTD->TBD):

`Backup and Restore Solution <onap-https://wiki.onap.org/display/DW/Backup+and+Restore+Solution%3A+ONAP-OOM>`_

ONAP Multisite Deployment
-------------------------

ONAP Multisite deployment, coordination and management is supported by
the MUSIC component:

.. toctree::
   :maxdepth: 2
   :titlesonly:

:ref:`Multi-Site State Coordination<onap-music:master_index>`

