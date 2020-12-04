.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0


.. _onap-release-notes:

Guilin Release Notes
^^^^^^^^^^^^^^^^^^^^

This page provides the release notes for the ONAP Guilin release. This
includes details of software versions, known limitations, and outstanding
trouble reports.

Release notes are cumulative for the release, meaning this release note will
have an entry for each Major, Minor, and Maintenance release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each release by each component is
maintained in the component specific release notes.

Guilin Releases
===============

The following releases are available for Guilin:
  - `Guilin Major Release 7.0.0`_

Guilin Major Release 7.0.0
==========================

Release data
============

+--------------------------------------+--------------------------------------+
| **Project**                          | Open Network Automation Platform     |
|                                      | (ONAP)                               |
+--------------------------------------+--------------------------------------+
| **Release name**                     | Guilin                               |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release version**                  | 7.0.0                                |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | December 3rd 2020                    |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

Guilin Features
===============
ONAP Guilin focusses on:

* 5G network automation and services such as network slicing through RAN, core
  and transport
* deepening O-RAN Software Community integration along with other leading SDOs
* seamless orchestration of CNFs, VNFs and PNFs
* and bringing several new ONAP Blueprint and docs updates.

5G Network Slicing
------------------
In the industry evolution toward 5G networks, Guilin expands upon the
end-to-end network slicing introduced with Frankfurt with the addition of RAN,
core, and transport through Network Slice Subnet Management Function (NSSMF)
which completes functionality with the Communication Service Management
Function (CSMF) and Network Slice Management Function (NSMF) components. In
addition to the NSSMF included in Guilin, ONAP supports an external RAN NSSMF.
Next, the RAN domain also has initial support for a simple closed control loop
and machine learning (ML) for intelligent slicing.

ONAP/O-RAN Alignment
--------------------
The release also marks greater ONAP + O-RAN Software Community harmonization by
adding  support for the A1 interface (O-RAN A1-AP v1.1), adding to the existing
O1 support. ONAP can now manage multiple A1 targets with different versions and
includes a A1 Policy Management Service that interacts with the Near Real-Time
RICs policy instances and provides a transient cache for these policies.

CNF, VNF and PNF integration
----------------------------
Guilin contains a large number of new features classified into design time,
run time, and ONAP operations to optimize the self-serve control loop and
dashboard, make it easier to reuse existing models, make xNF pre-onboarding and
onboarding easier, speed up UI development, and more. For Documentation
(Usability), ONAP documentation made improvements such as setting up ONAP,
Platform Operations, Service Design and Deployment, and User Guides. Specific
to cloud native, The Service Design & Creation (SDC) project, the unified
design time tool, now supports Helm types to natively support Cloud Native
Network Functions (CNF).

Enhancements in ONAP Blueprints
-------------------------------
Other enhancements to the ONAP Blueprints includes a new Standard Defined VNF
Event Stream (VES) event for Fault Management (FM) / Performance Management
(PM) Data Collection, the first use of Machine Learning in Self-Organizing
Networks (SON), and greater support for 5G RAN Wireless Network Resource Model
(NRM) with Service Modeling and Definition and Intent Based Network supporting
intent-drive 5G slice creation. The Cross Domain and Cross Layer VPN (CC-VPN)
includes transport slicing and the MDONS (Multi-Domain Optical Network Service
) has been extended.

Functional Requirements
-----------------------
The following requirements have been introduced in the Guilin Release:

xNF Integration
...............

- ONAP CNF orchestration - Enhancements
- Extension of PNF Pre-onboarding/onboarding
- Enhancements for PNF Plug & Play'
- xNF License Management

Lifecycle Management
....................

- Policy Based Filtering
- CLAMP Deployment of Native policies
- Bulk PM / PM Data Control Extension
- Support xNF Software Upgrade in association to schema updates
- Configuration & Persistency Service

Security
........

- CMPv2 Enhancements

Standard alignment
..................

- ETSI-Alignment for Guilin
- ONAP/3GPP & O-RAN Alignment-Standards Defined Notifications over VES
- Extend ORAN A1 Adapter and add A1 Policy Management

NFV testing Automatic Platform
...............................

- Test Result Auto Analysis & Certification
- Test Task Auto Execution
- Test Environment Auto Deploy
- Test Topology Auto Design

Non-Functional Requirements
---------------------------
The following 'non-functional' requirements have been introduced in the Guilin
Release:

Best Practice
.............

- ONAP shall use STDOUT for logs collection
- IPv4/IPv6 dual stack support in ONAP (Guilin)
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

- ONAP must complete update of the Python language (from 2.7 -> 3.8)
- ONAP must complete update of the java language (from v8 -> v11)
- All containers must run as non-root user
- Continue hardcoded passwords removal
- Flow management must be activated for ONAP.
- Each project will update the vulnerable direct dependencies in their code
  base

Tests
.....

- More tests integrated in CI/CD but enhancements expected in Honolulu
- ONAP shall increase the number of Docker Benchmark tests

Others
......

- ONAP to support Multi - tenancy

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
ONAP Guilin Release provides a set selection of documents,
see `ONAP Documentation <https://docs.onap.org/en/guilin/index.html>`_.

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

In the Guilin release,

- 100% projects passed 90% of the CII badge
- 85% projects passed the CII badge
- 11% projects passed the CII Silver badge

Project specific details are in the :ref:`release notes<doc-releaserepos>` for
each project.

.. index:: maturity

ONAP Maturity Testing Notes
===========================
For the Guilin release, ONAP continues to improve in multiple areas of
Scalability, Security, Stability and Performance (S3P) metrics.

In Guilin the Integration team focussed in

- Automating ONAP Testing to improve the overall quality
- Adding security and E2E tests
- Integrated new ONAP Python SDK in E2E testing

More details in :ref:`ONAP Integration Project<onap-integration:master_index>`

Known Issues and Limitations
============================
Known Issues and limitations are documented in each
:ref:`project Release Notes <doc-releaserepos>`.


.. Include files referenced by link in the toctree as hidden
