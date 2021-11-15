.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0


.. _onap-release-notes:

Istanbul Release Notes
^^^^^^^^^^^^^^^^^^^^^^

This page provides the release notes for the ONAP Istanbul release. This
includes details of software versions, known limitations, and outstanding
trouble reports.

Release notes are cumulative for the release, meaning this release note will
have an entry for each Major, Minor, and Maintenance release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each release by each component is
maintained in the component specific release notes.

Istanbul Major Release 9.0.0
============================

+--------------------------------------+--------------------------------------+
| **Project**                          | Open Network Automation Platform     |
|                                      | (ONAP)                               |
+--------------------------------------+--------------------------------------+
| **Release name**                     | Istanbul                             |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release version**                  | 9.0.0                                |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | November 15th  2021                  |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

Istanbul Features
=================
ONAP Istanbul focusses on:

- Intent based networking (IBN) simplifies interaction and network
  configuration by Control-Loop and Smart AI.
- Alignment with O-RAN Strategy to enable new RAN use cases
- Continued Cloud Native evolution with a rich feature set for CNF
  orchestration capabilities
- Next level of functionality for 5G use cases including Network Slicing,
  Performance management, SON, and CCVPN
- A second generation of control loop automation architecture
- New Network Function lifecycle management features based on real-life use
  cases
- New functionality for complex network configuration management
- Flexibility in resource onboarding with choice of modeling including SDC AID,
  ETSI SOL001
- Software quality and security improvements based on deployment experience

Functional Requirements
-----------------------

Increased Cloud Native Functionality
....................................
Information about created CNF resources in k8s cluster are now available. This
information can be utilized later on i.e. in closed-loop context. CNF
Healthcheck Workflow in SO will let to monitor the status of CNF deployed into
k8s cluster and whether it is healthy or not. Further changes in k8splugin
related to Helm specification support allow for the better and more reliable
deployment of complex CNFs defined as a Helm package. ONAP now supports
Helm 3.5 package specification.

E2E Network Slicing
...................

- Support for NSMF (Network Slice Management Function) based TN
  (Transport Network) slices in which NSMF is responsible for TN-FH (FrontHaul)
  and TN-MH (MidHaul) allocation
- RAN NSSMF (Network Slice Subnet Management Function) integration with CPS
  (Configuration Persistence Service) and handled closed loop impacts
- POC on A1-interface for closed loop updates
- KPI Monitoring enhancements

Intent-based networking
.......................
The Intent Based Networking (IBN) use case includes the development of an
intent framework that contains intent modeling, intent translation, intent
execution and intent decision making. The intent UI is implemented in UUI
and the components of the intent framework interact with many components of
ONAP including SO, A&AI, Policy, DCAE, and CDS.

Control Loop evolutions
.......................

- CLAMP functionality is merged into Policy Framework project
- Control Loops can be defined and described in Metadata using TOSCA. Control
  loops can run on the fly on any component that implements  a *participant*
  API. Control Loops can be commissioned into Policy/CLAMP, they can be
  parameterized, initiated on arbitrary participants, activated and monitored
- Policy Handling Improvements: Support delta policies in PDPs
- CLAMP Client Policy and TOSCA Handling
- Policy Handling Improvements
- System Attribute Improvements

Fault management
................

- Updates in fault management reporting and fault handling to be in line with
  VES 7.2, 3GPP and smoother future alignment with O1 for OOF-SON
- Performance Management data collection control provides 5G network operators
  with a dynamic and more efficient way to configure performance measurement
  collection on a selected subset of PNFs/VNFs in the network and complements
  the existing PM data collection and processing capabilities in ONAP/DCAE
- Simplified deployment for DCAE services via Helm
- Reduction on ONAP/DCAE footprint under transformation initiative by
  deprecating Cloudify based platform components and Consul
- VES 7.2.1 integration for HV_VES enables ONAP, 3GPP, ORAN alignment
- Enhancements for Network Slicing, Bulk PM, OOF-SON usecases

Extended O-RAN Integration
..........................

- Improvements for managing A1 Policies and terminating the A1 interface for
  A1 Policies
- A1 Adapter and A1 Policy Managements Enhancements

Controllers
...........

- SDN-C is based on OpenDaylight major release upgrade (Silicon)
- Enhancements to CCVPN, Network Slicing, and ONAP A1 Interface

Service Design
..............

- SDC can be used for onboarding resources and designing services with models
  other than SDC AID

Inventory
.........

- Model updates as part of CCVPN Transport Slicing Feature
- Model updates as part of Smart Intent Guarantee based on IBN Feature
- Model updates as part of CNF Orchestration Feature

ONAP Operations Manager
.......................

- IPv4 / IPv6 dual stack support in ONAP: support for Kubernetes 1.20+
  DualStack networking properties in ONAP K8S Service spec properties.
  Upgraded EJBCA CMP v2 server to version 7.x
- CMPv2 enhancements: certificate update implemented using Key Update Request
  (KUR) and Certificate Request (CR) CMPv2 messages

Non-Functional Requirements
---------------------------

The following 'non-functional' requirements are followed in the
Istanbul Release:

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
- Flow management must be activated for ONAP
- Each project will update the vulnerable direct dependencies in their code
  base

Documentation
.............

- Interactive architecture map including short description and link to detailed
  documentation for every architecture building block
- Changes in the Sphinx configuration for all contributing projects
- Guide to set up a documentation development environment with preview function

Tests
.....

- New E2E tests: basic_cnf
- New tests: CPS healthcheck
- Stability tests: basic_vm and basic_onboard

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
ONAP Istanbul Release provides a set selection of documents,
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

In the Istanbul release,

- 100% projects passed 90% of the CII badge
- 85% projects passed the CII badge
- 11% projects passed the CII Silver badge

Project specific details are in the :ref:`release notes<doc-releaserepos>` for
each project.

.. index:: maturity

ONAP Maturity Testing Notes
===========================
For the Istanbul release, ONAP continues to improve in multiple areas of
Scalability, Security, Stability and Performance (S3P) metrics.

In Istanbul the Integration team focussed in

- Automating ONAP Testing to improve the overall quality
- Adding security and E2E tests

More details in :ref:`ONAP Integration Project<onap-integration:master_index>`

Known Issues and Limitations
============================
Known Issues and limitations are documented in each
:ref:`project Release Notes <doc-releaserepos>`.
