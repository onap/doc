.. This work is licensed under
.. a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017-2018 AT&T Intellectual Property. All rights reserved.
.. Modifications Copyright 2018 Orange
.. Modifications Copyright 2018 Amdocs
.. Modifications Copyright 2018 Huawei

Setting Up ONAP
===============

.. _installing-onap:

ONAP is deployed using the ONAP Operations Manager (OOM).

The recommended ONAP deployment is based on Kubernetes, Docker containers
and Helm installer.


Requirements
------------

The following is the recommended component version.

  ===========  =========
  Software     Version
  ===========  =========
  Kubernetes   1.11.2
  Helm         2.9.1
  kubectl      1.11.2
  Docker       17.03.x
  ===========  =========

The ONAP full installation is validated with the following footprint:
 - 14 VM (1 Rancher, 13 K8s nodes)
   - 8 vCPU
   - 16 GB RAM
 - 160 GB Storage


Quick Start
-----------

A quick-start :ref:`ONAP OOM HEAT Template<onap-oom-heat>` is
available that fully automates the instructions in the installation
guides below and deploys ONAP using OOM on an HA-enabled Kubernetes
cluster.


Installation
------------

Creation of Kubernetes cluster is described here:

.. toctree::
   :maxdepth: 1
   :titlesonly:

   ../../../../submodules/oom.git/docs/oom_cloud_setup_guide.rst

ONAP installation is described here:

.. toctree::
   :maxdepth: 1
   :titlesonly:

   ../../../../submodules/oom.git/docs/oom_quickstart_guide.rst

NodePorts
---------

NodePorts are used to allow client applications, that run outside of
Kubernetes, access to ONAP components deployed by OOM.
A NodePort maps an externally reachable port to an internal port of an ONAP
microservice.
It should be noted that the use of NodePorts is temporary.
An alternative solution is currently being scoped for the Dublin Release.

* The list of node ports used by ONAP is documented
  in `ONAP Node Port List <https://wiki.onap.org/display/DW/OOM+NodePort+List>`_.

.. note::
   Prior to deployment of ONAP, there is no need to download manually any Docker container.
   The OOM deployment takes care to automatically download the Docker containers.

   It is also possible to deploy a subset of ONAP components on a single VM.
   The VM flavor to be used depends on the number of ONAP components to be
   deployed.

.. note::
   For test purposes, it is possible to use other installations:

.. toctree::
   :maxdepth: 1
   :titlesonly:

   onap_heat.rst
   onap_individual.rst
