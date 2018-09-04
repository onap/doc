.. This work is licensed undera Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2018 ONAP

.. index:: Setting Up Full ONAP using Containers

====================================
**Setting Up ONAP using Kubernetes**
====================================

.. _installing-onap-k8s:

**Context**
===========

The recommended ONAP deployment is based on Kubernetes and Docker containers.
This method is also called deployment through OOM.

The following is the recommended component version.

  ===========  =========
  Software     Version
  ===========  =========
  Kubernetes   1.8.10
  Helm         2.8.2
  kubectl      1.8.10
  Docker       17.03.x
  ===========  =========

Creation of Kubernetes cluster is described here:

.. toctree::
   :maxdepth: 1
   :titlesonly:

   ../../../../submodules/oom.git/docs/oom_cloud_setup_guide.rst


The ONAP full installation requires the following footprint:
 - 4 VM
 - 32 vCPU
 - 128 GB RAM
 - 160 GB Storage

ONAP installation is described here:

.. toctree::
   :maxdepth: 1
   :titlesonly:

   ../../../../submodules/oom.git/docs/oom_quickstart_guide.rst

.. note::
   Prior to deployment of ONAP, there is no need to download manually any Docker container.
   The OOM deployment takes care to automatically download the Docker containers.

   It is also possible to deploy a subset of ONAP components on a single VM.
   The VM flavor to be used depends on the number of ONAP components to be
   deployed.
