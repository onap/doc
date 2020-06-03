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

The recommended ONAP deployment can be deployed on a private set of physical
hosts or VMs (or even a combination of the two) and is based on Kubernetes,
Docker containers and Helm installer.


Requirements
------------

OOM requires the following  Software components.

* Kubernetes
* Helm
* kubectl
* Docker

The Software versions needed for the specific ONAP release
as well as the minimum Hardware configuration can be found in the
:ref:`OOM Cloud Setup Guide<onap-oom:oom_cloud_setup_guide>`


Installation
------------

Creation of Kubernetes cluster is described here:

.. toctree::
   :maxdepth: 2
   :titlesonly:

:ref:`OOM Cloud Setup Guide<onap-oom:oom_cloud_setup_guide>`

:ref:`ONAP on HA Kubernetes Cluster<onap-oom:onap-on-kubernetes-with-rancher>`

ONAP installation is described here:

.. toctree::
   :maxdepth: 2
   :titlesonly:

:ref:`OOM Quickstart Guide<onap-oom:oom_quickstart_guide>`

:ref:`OOM User Guide<onap-oom:oom_user_guide>`

Alternative way of offline ONAP installation is described here:

.. toctree::
   :maxdepth: 2
   :titlesonly:

:ref:`OOM Offline-Installer<onap-oom-offline-installer:master_index>`

.. note::
   Prior to deployment of ONAP, there is no need to download manually any Docker
   container. The OOM deployment takes care to automatically download the Docker
   containers.

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
An alternative solution based on Ingress Controller, which initial support is
already in place. It is planned to become a default deployment option in the
Guilin release.

More information from official Kubernetes documentation about
`NodePort <https://kubernetes.io/docs/concepts/services-networking/service/#nodeport>`_.

The following table lists all the NodePorts used by ONAP.

.. csv-table:: NodePorts table
   :file: nodeports.csv
   :widths: 20,20,20,20,20
   :header-rows: 1

.. note::
   \*) POMBA, LOG and SNIRO are not part of the default Frankfurt ONAP
   deployment.

This table retrieves information from the ONAP deployment using the following
Kubernetes command:

.. code-block:: bash

  kubectl get svc -n onap -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{.}}{{"\n"}}{{end}}{{end}}{{end}}'
