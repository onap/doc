.. This work is licensed under
.. a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017-2018 AT&T Intellectual Property. All rights reserved.
.. Modifications Copyright 2018 Orange
.. Modifications Copyright 2018 Amdocs
.. Modifications Copyright 2018 Huawei
.. Modifications Copyright 2019 Orange

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
  Kubernetes   1.13.5
  Helm         2.12.3
  kubectl      1.13.5
  Docker       18.09.5
  ===========  =========

The ONAP full installation is validated with the following footprint:

.. csv-table:: Validated installation footprint
   :widths: 3,5,10

   VM number, VM flavor, VM role
   12, 16 GB RAM - 8 vCPUs, Running the K8S worker role
   3, 8 GB RAM - 4 vCPUs, Running the K8S controller role
   1, 8 GB RAM - 4 vCPUs, Running the shared NFS server for /dockerdata-nfs/

Installation
------------

Creation of Kubernetes cluster is described here:

.. toctree::
   :maxdepth: 2
   :titlesonly:

:ref:`../../../oom.git/docs/oom_cloud_setup_guide.rst<oom:master_index>`

ONAP installation is described here:

.. toctree::
   :maxdepth: 2
   :titlesonly:

:ref:`../../../oom.git/docs/oom_quickstart_guide.rst<oom:master_index>`
:ref:`../../../oom.git/docs/oom_user_guide.rst<oom:master_index>`

Alternative way of offline ONAP installation is described here:

.. toctree::
   :maxdepth: 2
   :titlesonly:

:ref:`../../../oom/offline-installer.rst<oom-offline-installer:master_index>`

.. note::
   Prior to deployment of ONAP, there is no need to download manually any Docker container.
   The OOM deployment takes care to automatically download the Docker containers.

   It is also possible to deploy a subset of ONAP components on a single VM.
   The VM flavor to be used depends on the number of ONAP components to be
   deployed.

NodePorts
---------

NodePorts are used to allow client applications, that run outside of
Kubernetes, access to ONAP components deployed by OOM.
A NodePort maps an externally reachable port to an internal port of an ONAP
microservice.
It should be noted that the use of NodePorts is temporary.
An alternative solution is currently being scoped for the Dublin Release.

More information from official Kubernetes documentation about
`NodePort <https://kubernetes.io/docs/concepts/services-networking/service/#nodeport>`_.

The following table lists all the NodePorts used by ONAP.

.. csv-table:: NodePorts table
   :file: nodeports.csv
   :widths: 20,20,20,20,20
   :header-rows: 1

This table retrieves information from the ONAP deployment using the following
Kubernetes command:

.. code-block:: bash

  kubectl get svc -n onap -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{.}}{{"\n"}}{{end}}{{end}}{{end}}'
