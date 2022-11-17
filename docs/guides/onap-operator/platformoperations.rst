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

:doc:`RobotFramework<onap-integration:docs_robot>`


ONAP Backup and Restore
-----------------------

To backup and restore ONAP component specific databases you can follow the below link:

.. toctree::
  :maxdepth: 1

  onap_backup_restore.rst
