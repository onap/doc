.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0


.. _onap-release-notes:

Honolulu Release Notes
^^^^^^^^^^^^^^^^^^^^^^

This page provides the release notes for the ONAP Honolulu release. This
includes details of software versions, known limitations, and outstanding
trouble reports.

Release notes are cumulative for the release, meaning this release note will
have an entry for each Major, Minor, and Maintenance release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each release by each component is
maintained in the component specific release notes.

Honolulu Releases
=================

The following releases are available for Honolulu:
  - `Honolulu Maintenance Release 8.0.1`_
  - `Honolulu Major Release 8.0.0`_

Honolulu Maintenance Release 8.0.1
==================================

+--------------------------------------+--------------------------------------+
| **Project**                          | Open Network Automation Platform     |
|                                      | (ONAP)                               |
+--------------------------------------+--------------------------------------+
| **Release name**                     | Honolulu Maintenance Release         |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release version**                  | 8.0.1                                |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | September 30th 2021                  |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New Features
============

Honolulu Maintenance Release 8.0.1 delivered a number of fixes and updates
across the following projects:

 - SO          - bugfixes and support for transport slicing usecase
 - CDS         - fix BluePrint* classes renaming
 - MULTICLOUD  - update of k8s plugin to support Helm3
 - OOM         - fixes for common Helm chart templates and product charts
 - POLICY      - new versions of Policy Framework components
 - DCAE        - new version of the policy-handler and dashboard
 - OOF         - use new AAI schema version (v21)
 - CCSDK       - fix fault and pnf-registration event losses

Details on the specific Jira tickets addressed by each project can be found in
the component specific Release Notes: :ref:`release notes<doc-releaserepos>`


Honolulu Major Release 8.0.0
============================

+--------------------------------------+--------------------------------------+
| **Project**                          | Open Network Automation Platform     |
|                                      | (ONAP)                               |
+--------------------------------------+--------------------------------------+
| **Release name**                     | Honolulu                             |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release version**                  | 8.0.0                                |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | May 11th  2021                       |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

Honolulu Features
=================
ONAP Honolulu focusses on:

* Cloud Native Function (CNF) support with  with seamless configuration of Helm
  based CNFs and K8s resources
* End-to-end 5G network slicing with three network slicing components for RAN,
  core, and transport
* Introducing a new component: Configuration Persistence Service (CPS) to store
  persistent configuation data
* Modularity to pick and choose the components needed for specific use case
* Improving integration with many SDOs

Functional Requirements
-----------------------

Increased Cloud Native Functionality
....................................
The Honolulu release has important updates to support cloud native network
functions (CNF). The functionality includes configuration of Helm based CNFs
and seamless day 1, 2 operations. The Configuration API allows a user to
create, modify and delete Kubernetes (K8s) resource templates and their base
parameters and the Profile API allows for sophisticated day 0 configuration.
The Query API gathers filtered status of the CNF and the HealthCheck API
executes dedicated health check jobs to verify the status of a CNF. This new
functionality is implemented in the Controller Design Studio (CDS) component
using dedicated templates called Controller Blueprint Archives (CBA).
In addition, there is Swagger documentation for the API of the K8s plugin
component in the MultiCloud project.

Deeper 5G Support
.................
There is a significant set of new functionality around end-to-end 5G network
slicing in the Honolulu release. This release includes three internal Network
Slice Subnet Management Function (NSSMF) components for RAN, core, and
transport domains. External NSSMFs continue to be supported for RAN and core.
Next, slice optimization continues to be an area of ongoing effort with closed
loop automation and intelligent slicing testing. There are also enhancements in
NST, NSI, and NSSI selection in the OOF project and A&AI includes schema
changes to accommodate network and transport slicing.

In addition, the ExtAPI project now included Enhanced Service Ordering for
additional service types and the UUI graphical user interface has improved
slicing support. The VID graphical user has support for PNF plug-and-play
allowing operators to interact with PNFs via VID. In addition, there is better
compliance to standards such as 3GPP TS28.540/541 5G NRM driven xNF models in
ONAP. Finally the OOF SON functionality supports offline trained ML-models
providing additional inputs for Physical Cell Identity (PCI) optimization.
DCAE includes a new KPI microservice.

Configuration Persistence Service
.................................
Another key 5G related initiative is the new Configuration Persistence Service
(CPS) module that allows ONAP projects to store persistent state defined by
YANG models, deploy YANG models at runtime, and share access to configuration
management data.

Further O-RAN Integration
.........................
A key enhancement in the Honolulu release was increased support for the O-RAN
A1 standard that is implemented in the CCSDK and SDN-C projects. The O-RAN A1
interface provides a flexible way for RAN operators to manage wide area RAN
network optimization reducing capex investment needs. Both the enhanced A1
interface controller and A1 policy capabilities are now usable in ONAP with a
Near-Real-Time Radio Intelligent Controller (nRTRIC). This functionality is
also used downstream in O-RAN-Source Community (OSC) Non-RealTime RIC
(NONRTRIC) project, strengthening alignment between ONAP & OSC. In addition,
the DCAE project includes VES 7.2 integration that improves integration with
both O-RAN and 3GPP. Finally, there is a new CPS interface to query RAN
configuration data.

Expanded Modularity
...................
Modularity has been an important topic in ONAP to allow users to pick and
choose the components they need for their specific use case and Honolulu
continues to advance modularity. DCAE now simplifies microservice deployment
via Helm charts.

Service Design
..............

- Includes increased support for ETSI standards such as SOL001, SOL004, and
  SOL007 and allows users to choose unlicensed or externally licensed xNFs.
- Vendor License Model is now optional
- SDC distribution status report enhanced

Inventory
.........

- A&AI includes support for multi tenancy.
- Model updates for CCVPN Transport Slicing and Network Slicing
- GraphGraph POC enhanced for schema visualization and visual model generation
- Sparky UI updates including Browse, Specialized Search, BYOQ, and BYOQ
  Builder Views

ONAP Operations Manager
.......................

- Portal-Cassandra image updated to Bitnami, supporting IPv4/IPv6 Dual Stack
- CMPv2 external issuer implemented which extends Cert-Manager with ability to
  enroll X.509 certificates from CMPv2 servers
- New version for MariaDB Galera using Bitnami image, supporting IPv4/IPv6 Dual
  Stack
- Support of Helm v3.4 and Helm v3.5

Non-Functional Requirements
---------------------------
The following 'non-functional' requirements are followed in the
Honolulu Release:

Best Practice
.............

- ONAP shall use STDOUT for logs collection
- IPv4/IPv6 dual stack support in ONAP
- Containers must crash properly when a failure occurs
- Containers must have no more than one main process
- Application config should be fully prepared before starting the
  application container
- No root (superuser) access to database from application container

Code Quality
............

- Each ONAP project shall improve its CII Badging score by improving input
  validation and documenting it in their CII Badging site
- Each ONAP project shall define code coverage improvements and achieve at
  least 55% code coverage

Security
........

- Python language 3.8
- Java language v11
- All containers must run as non-root user
- Continue hardcoded passwords removal
- Flow management must be activated for ONAP.
- Each project will update the vulnerable direct dependencies in their code
  base

Tests
.....

- New E2E tests
- New IPv4/Ipv6 daily CI chain

.. important::
   Some non-functional requirements are not fully finalized. Please, check details
   on the :ref:`Integration<onap-integration:release_non_functional_requirements>`


Project Specific Release Notes
==============================
ONAP releases are specified by a list of project artifact versions in the
project repositories and docker container image versions listed in the OOM
Helm charts.

Each project provides detailed :ref:`release notes<doc-releaserepos>`
and prepends to these if/when any updated versions the project team believes
are compatible with a major release are made available.

Documentation
=============
ONAP Honolulu Release provides a set selection of documents,
see :ref:`ONAP Documentation<master_index>`.

The `developer wiki <http://wiki.onap.org>`_ remains a good source of
information on meeting plans and notes from committees, project teams and
community events.

Security Notes
==============
Details about discovered and mitigated vulnerabilities are in
:ref:`ONAP Security <onap-osa:onap-security>`

ONAP has adopted the `CII Best Practice Badge Program <https://bestpractices.coreinfrastructure.org/en>`_.

- `Badging Requirements <https://github.com/coreinfrastructure/best-practices-badge>`_
- `Badging Status for all ONAP projects <https://bestpractices.coreinfrastructure.org/en/projects?q=onap>`_

In the Honolulu release,

- 100% projects passed 90% of the CII badge
- 85% projects passed the CII badge
- 11% projects passed the CII Silver badge

Project specific details are in the :ref:`release notes<doc-releaserepos>` for
each project.

.. index:: maturity

ONAP Maturity Testing Notes
===========================
For the Honolulu release, ONAP continues to improve in multiple areas of
Scalability, Security, Stability and Performance (S3P) metrics.

In Honolulu the Integration team focussed in

- Automating ONAP Testing to improve the overall quality
- Adding security and E2E tests

More details in :ref:`ONAP Integration Project<onap-integration:master_index>`

Known Issues and Limitations
============================
Known Issues and limitations are documented in each
:ref:`project Release Notes <doc-releaserepos>`.


.. Include files referenced by link in the toctree as hidden
