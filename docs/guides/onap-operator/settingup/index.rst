.. This work is licensed under
.. a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017-2018 AT&T Intellectual Property. All rights reserved.
.. Modifications Copyright 2018 Orange
.. Modifications Copyright 2018 Amdocs
.. Modifications Copyright 2018 Huawei
.. Modifications Copyright 2019 Orange
.. Modifications Copyright 2021 Nokia

Setting Up ONAP
===============

.. _installing-onap:

ONAP is deployed using the ONAP Operations Manager (OOM).

The recommended ONAP deployment can be deployed on a private set of physical
hosts or VMs (or even a combination of the two) and is based on Kubernetes,
Docker containers and Helm installer.

Requirements
------------

ONAP deployment via OOM requires the following software components.

* Kubernetes cluster
* Helm
* kubectl
* Docker

The Software versions needed for the specific ONAP release
as well as the minimum Hardware configuration can be found in the
:ref:`OOM Infrastructure Setup Guide<onap-oom:oom_infra_setup_guide>`

Installation
------------

On the target Kubernetes cluster ONAP requires the setup of a Base Platform:

:ref:`OOM Base Platform <onap-oom:oom_base_setup_guide>`

Additional optional setups (e.g. Prometheus) and instructions can be found in:

:ref:`OOM Ingress controller setup (optional)<onap-oom:oom_base_optional_addons>`
:ref:`OOM Ingress controller setup (optional)<onap-oom:oom_setup_ingress_controller>`

ONAP configuration and installation instructions are described here:

:ref:`OOM Deployment Guide<onap-oom:oom_deploy_guide>`
