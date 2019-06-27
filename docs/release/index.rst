.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0


.. _dublinrelease-notes:

Dublin Release Notes
^^^^^^^^^^^^^^^^^^^^

This page provides the release notes for the ONAP Dublin release. This includes
details of software versions used, known limitations, and outstanding trouble
reports.

Release notes are cumulative for the release, meaning this release note for the
Dublin release will have an entry for each Major, Minor, and Maintenance
release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each releaese by each component is
maintained in the component specific release notes.

Dublin Major Release 4.0.0
==========================

* Release Name: Dublin
* Release Version: 4.0.0
* Release Date: , 2019

The Dublin 4.0.0 is the fourth major ONAP release.


Dublin features
===============
Dublin release introduces the following new features:

Interfaces
----------
- Locale/Internationalization language support for Portal and UseCase UI
- A&AI UI integration in Portal
- Management GUI for Customer and Service Type in UseCase UI
- VID: Centralized Representation and Consistent ID of Cloud Regions
- VID: Change Management - Flexible Designer & Orchestrator
- CLI commands for  end-to-end service creation

VNF Validation
--------------
- Extended PNF requirements
- VTP (VNF Test Platform) is enabled with scenario and test case execution
  management
- CSAR validation is enabled with PNF and VNF compliance check for SOL004,
  SOL001
- UI is available to execute VVP scripts.
- VVP is packaged as a Docker container including scripts covering all
  mandatory, testable HOT requirements from VNFRQTS

Design-Time
-----------
- PNF package  onboarding aligned with ETSI SOL001
- Updating the VNFD type based on SOL001 v2.5.1
- Controller Design Studio integration
- VSP compliance check feature (SDC)
- K8S based Cloud Region Support (vFW, EdgeXFoundry)
- Model Driven Control Loop Design based on TOSCA
- New A&AI data types and schema service

Run-Time
--------
- Hardening of HPA in SO and extension of HPA capabilities to existing
  use-cases
- Extended and enhance the SO generic building block to support pre and post
  instantiation.
- SO to be made independent of Cloud technologies
- PNF Plug an play updates & improvements
- PNF support in VFC
- MultiCloud plugin for Kubernetes based cloud regions which supports
  deployment via Helm Charts
- MultiCloud plugin for StarlingX
- MultiCloud plugin for ThinkCloud
- Additional LCM action for APPC : DistributeTrafficCheck
- Multiple standalone ansible servers support for APPC
- SDNC support for the PNF Use Case Network Assign for Plug and Play
  feature
- DCAE Collector : RESTConf collector
- DCAE Event Processors : VES Mapper, 3gpp PM-Mapper, BBS Event
  processor
- Analytics/RCA : SON-Handler, Heartbeat Micro Service
- Blueprint generator tool to simplify DCAE deployment artifact creation
- UI interface to manage Holmes rule management.
- Supports of Policy-model based Configuration Policy in CLAMP
- CLAMP supports new Policy Engine direct Rest API
- Support for Authenticated topics, Scaling support and  multi-site
  applications for DMAAP Message-Router
- Publication history for DMAAP  Data-Router
- A new TOSCA parser common library

SDO alignment
-------------
- ETSI: SO plugin to support SOL003 to connect to an external VNFM
- ETSI: SOL003 Alignment for GVNFM and Catalog in VFC
- TMF extension in External API with Service inventory notification and new
  service specificationInputSchemas operation

Operations
----------
- Default Storage Class Provisioner for improved Persistent Storage resiliency
- CNI reference integration for Multi-site support
- Platform Upgradability: Introduction of an Upgrade Framework supporting
  automated rolling upgrades for applications and Release-to-release upgrade
  for the following projects (A&AI, SDNC, SO)

Security
--------
- oParent Integration to fix vulnerabilities
- xNF communication security enhancements.
- Containers run as non-root
- More components integrated with AAF
- Some AAI services can be configured to leverage the ONAP Pluggable Security
  Sidecar proof of concept

Footprint Optimization
----------------------
- Optimized Docker images mainly using Alpine
- Shared MariaDB-Galera Cluster – used by : SO & SDNC
- Shared Cassandra Cluster – used by  A&AI & SDC
- Optional deployment of independent clusters

Verified use cases
------------------
Verified use cases are described in :ref:`verified Use Case <docs_usecases>`

- :ref:`vFirewall Use Case <docs_vfw>`
- :ref:`VF Module Scale Out Use Case (vLoadBalancer/vDNS) <docs_scaleout>`
- :ref:`vCPE Use Case <docs_vcpe>`
- :ref:`CCVPN (Cross Domain and Cross Layer VPN) Use Case <docs_ccvpn>`
- :ref:`vFirewall/vDNS with HPA Use Case <docs_vfw_hpa>`
- :ref:`vFirewall Traffic Distribution Use Case <docs_vfw_traffic>`
- :ref:`BBS (Broadband Service) Use Case <docs_bbs>`
- :ref:`vIPsec with HPA Use Case <docs_vipsec_hpa>`
- :ref:`vFirewall/edgex with K8S plugin <docs_vfw_edgex_multicloud_k8s>`

Project Specific Release Notes
==============================
ONAP releases are specified by a list of project artifact versions in the
project repositories and docker container image versions listed in the OOM Helm
charts.
Each project provides detailed :ref:`release notes<doc-releaserepos>`
and prepends to these if/when any updated versions the project team believes
are compatible with a major release are made available.

Documentation
=============
ONAP Dublin Release provides multiple documents, see
:ref:`ONAP Home<master_index>`.

The `developer wiki <http://wiki.onap.org>`_ remains a good source of
information on meeting plans and notes from committees, project teams and
community events.

Security Notes
==============
Details about discovered and mitigated vulnerabilities are in
:ref:`ONAP Security <onap-security>`

.. toctree::
   :hidden:

   ../submodules/osa.git/docs/index.rst

ONAP has adopted the `CII Best Practice Badge Program <https://bestpractices.coreinfrastructure.org/en>`_.

- `Badging Requirements <https://github.com/coreinfrastructure/best-practices-badge#core-infrastructure-initiative-best-practices-badge>`_
- `Badging Status for all ONAP projects <https://bestpractices.coreinfrastructure.org/en/projects?q=onap>`_

Project specific details are in the
:ref:`release notes<doc-releaserepos>` for each project.

.. index:: maturity

ONAP Maturity Testing Notes
===========================
For Dublin release, ONAP continues to improve in multiple areas of Scalability,
Security, Stability and Performance (S3P) metrics.

The Integration team ran the 72 hours stability testing (100% passing rate) and
full resilience testing (99.4% passing rate) at ONAP OpenLabs. More details in
:ref:`ONAP Maturity Testing Notes <integration-s3p>`

Known Issues and Limitations
============================
Known Issues and limitations are documented in each
:ref:`project Release Notes <doc-releaserepos>`.

.. index:: Reporting Bugs

How to Report a Bug
===================
There are 2 ways to report a bug in ONAP.

 * In case you are familiar within ONAP, you can directly report a bug by
   creating a Jira issue at `ONAP Jira <https://jira.onap.org>`_.

 * If you don't know you are facing a bug or have a question, post your
   question into the `Ask question <https://wiki.onap.org/display/DW/questions/all>`_.
   You will need a Linux Foundation ID to login and post your question.
   Get a Linux Foundation Identity using this `quick procedure <https://wiki.onap.org/display/DW/Joining+the+ONAP+Technical+Community#JoiningtheONAPTechnicalCommunity-WhereDoIStart?>`_.

To properly report a bug in Jira, you may want to consider these `recommendations <https://wiki.onap.org/display/DW/Tracking+Issues+with+JIRA#TrackingIssueswithJIRA-RecommendationsforwrittingProperJIRAIssue>`_ to elaborate the issue you are facing.


.. Include files referenced by link in the toctree as hidden

.. toctree::
   :hidden:

   releaserepos.rst
   repolist.rst
