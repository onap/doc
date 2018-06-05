.. This work is licensed undera Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2018 ONAP


.. contents::
   :depth: 2
..

.. index:: Setting Up Full ONAP using Containers


=========================================
**Setting Up Full ONAP using Containers**
=========================================

.. _installing-onap-heat:

**Context**
===========

The recommended installation is based on Kubernetes to deploy ONAP
components using containers.

You must use the following version for the various sofware components.

  ===========  =======
  Software     Version
  ===========  =======
  Kubernetes   1.8.10
  Helm         2.8.2
  kubectl      1.8.10
  Docker       17.03.x
  ===========  =======

Creation of Kubernetes cluster is available here:
   ../../../submodules/oom.git/docs/oom_cloud_setup_guide.rst


The ONAP full installation requires the following footprint:
 - 4 VM
 - 32 vCPU
 - 128 GB RAM
 - 160 GB Storage

ONAP installation is described here:
   ../../../submodules/oom.git/docs/oom_quickstart_guide.rst

.. note::
   It is also possible to deploy a subset of ONAP components on a single VM.
   The VM flavor to be used depends on the number of ONAP components to be
   deployed.
