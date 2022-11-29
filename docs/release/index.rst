..
  This work is licensed under a Creative Commons Attribution 4.0
  International License. http://creativecommons.org/licenses/by/4.0


.. _onap-release-notes:

'Kohn' Release Notes
====================

This page provides the release notes for the ONAP 'Kohn' release. This
includes details of software versions, known limitations, and outstanding
trouble reports.

Release notes are cumulative for the release, meaning this release note will
have an entry for each Major, Minor, and Maintenance release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each release by each component is
maintained in the component specific release notes.

'Kohn' Major Release 11.0.0
---------------------------

+-----------------------------------+-----------------------------------------+
| **Project**                       | Open Network Automation Platform (ONAP) |
+-----------------------------------+-----------------------------------------+
| **Release name**                  | Kohn                                    |
+-----------------------------------+-----------------------------------------+
| **Release version**               | 11.0.0                                  |
+-----------------------------------+-----------------------------------------+
| **Release date**                  | 2022, December 1st                      |
+-----------------------------------+-----------------------------------------+

Features
--------

ONAP 'Kohn' focusses on:

- Further O-RAN integration with A1 and O1 policy control for SON use cases
- improved flows for Cloud-Native Network Functions (CNF) orchestration and
  upgrade
- Intent-driven Closed-loop Autonomous Networks with the CCVPN use case
- Robust KPI computation for use in Intent Based E2E Network Slicing
- Improved configuration query and change notifications in the Configuration
  Persistency Service (CPS)
- Improved slice analysis in the Control loop automation
- Continued modernization of the Policy framework including Service Mesh
  integration and native Kafka messaging
- Security enhancements that include removal of known vulnerabilities and
  adoption of key software supply chain artifacts

Functional Requirements
-----------------------

Richer set of Cloud Native Functionality
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- CDS support for Application Service Descriptor

  - Onboarding ASD CSARs
  - Transformation to ONAP SDC CSAR
  - Model updates to support ASD TOSCA types
  - Support in SDC TOSCA parser

- SO improved flows around the CNF orchestration, CNF Upgrade, and minor bug
  fixes around the slicing use case.

  - Create multiple PNF instances in the same request
  - Support for long-running CDS process
  - Recursive orchestration Support
  - CNF Upgrade Workflow with Da-2 supported

E2E Network Slicing
^^^^^^^^^^^^^^^^^^^

- Slice Analysis MS enhancement to support real-time intent listening using
  DCAE SDK dmaap-client lib
- KPI Computation MS enhancement to support new KPI reporting to UUI, KPIs
  spanning multiple resources and error handling for missing counter
- Enhancements for Intent-based Cloud Leased Line and Transport Slicing with
  DCAE SDK alignment for SliceAnalysis MS & enhancing AAI interface for
  supporting IBN CL

Control Loop evolutions
^^^^^^^^^^^^^^^^^^^^^^^

- 5G SON use case enhancements including Control Loop message for ANR modified
  to align with A1-based flow/support
- CCVPN enhancements for Intent-based Cloud Leased Line and Transport Slicing


Extended O-RAN Integration
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Continued maturing A1-Policy controller functions:

  - Support updated RESTCONF spec (RFC 8040) between A1 PMS & A1 Adapter
  - Numerous 3PP dependency updates
  - Support custom south-bound adapters for custom A1-AP protocol versions
  - Deprecate DMaaP NBI
  - Improved logging / Tracing / Metrics
  - Improved logging/debug-ability in CSIT tests
  - Support JWT access tokens - for use in service mesh environments.
  - Additional SONAR reporting for A1-PMS service

- Better alignment with O-RAN in the 5G SON use case with use of O1 and A1
  interfaces.

  - Introduction of specific control loop flows for O1-based and A1-based RAN
    actions. This includes changes in Policy, SDN-R, SON-Handler MS, and
    RAN-Sim.
  - Enhancement of RAN-Sim to support A1-based actions
  - Modification of Control Loop message formats and policies to direct O1 and
    A1 flows appropriately

Controllers
^^^^^^^^^^^

- Resource Resolution Enhancements

  - Enabled deleting resources by lastN occurrences
  - Template headers, path, and outputs mapping in the rest processor
  - The empty Output mapping means for JSON/MAP all keys and for other types
    extracting of primitive
  - The empty response is mapped to the value is output mapping is empty (but
    not null)
  - Open resolution processors for in-CBA customization
  - Improve resolution tests verification
  - Use RestProcessor for testing RestProcessor
  - Added component for deleting resources and templates
  - Fixed enrichment for multiple assignments
  - Fixed the transform-templating for referenced complex types
  - Creation of dynamic data-type using all workflow steps

- CDS now has an endpoint for template deletion


Service Design
^^^^^^^^^^^^^^

- Application Service Descriptor support with:

  - Onboarding ASD CSARs
  - Transformation to ONAP SDC CSAR
  - Model updates to support ASD TOSCA types
  - Support in SDC TOSCA parser

- Deletion of archived assets
- Improved support for TOSCA constructs
- Support for TOSCA value expressions using TOSCA functions
- Improved support for import of services
- Application metrics

Inventory
^^^^^^^^^

- Updates to schema and edge rules

  - Model updates for User Network Interfaces (uni), Route target, Network
    Route, BGP neighbor, VPN binding, Lag interface, Physical interface and
    Logical interface
  - Edge rule changes


ONAP Operations Manager
^^^^^^^^^^^^^^^^^^^^^^^

- Update of Infrastructure and tools versions to improve build and deployment
  time, as well as fixing vulnerabilities
- Initial Setup for "ONAP on ServiceMesh" deployment as basis for the London
  release
  - using Istio 1.14.1 as SM platform
  - including Istio Ingress Gateway for external access
  - modify 90% of ONAP component charts to support Sevice Mesh
  - Established daily deployment pipelines to test the SM setup

Non-Functional Requirements
---------------------------

The following 'non-functional' requirements are followed in the
Kohn Release:

Best Practice
^^^^^^^^^^^^^

- Standardized log fields
- Support dual stack IPv4/Ipv6 across all ONAP modules
- GUI test suites for all UI exposing modules

Security
^^^^^^^^

- Adoption of software bill of materials (SBOMs)
- Usage of basic images that provide the most updated and secure Java and
  Python versions
- Improve OpenSSF (formerly CII badging)


Documentation
^^^^^^^^^^^^^

- Development guide updated
- Structural changes in 'Guide' section

Tests & Integration
^^^^^^^^^^^^^^^^^^^

- deployment/noheat refactorization, fixes and updates:

  - Updated Ansible, Galaxy collections and Python libs to latest versions
  - Better Galaxy collections and Python libraries versions management
  - Added playbook to deploy Devstack
  - Added option to deploy Istio
  - Ability to set arbitrary overrides file
  - Added one playbook to deploy whole infrastructure (i.e. create OpenStack
    VMs in which Devstack, k8s and ONAP gets deployed)
  - Documentation updates


.. important::
   Some non-functional requirements are not fully finalized. Please, check details
   on the :doc:`Integration <onap-integration:usecases/release_non_functional_requirements>`

Documentation Sources
---------------------

The formal ONAP 'Kohn' Release Documentation is available
in :ref:`ReadTheDocs<master_index>`.

The `Developer Wiki <http://wiki.onap.org>`_ remains a good source of
information on meeting plans and notes from committees, project teams and
community events.

OpenSSF Best Practice
---------------------

ONAP has adopted the `OpenSSF Best Practice Badge Program <https://bestpractices.coreinfrastructure.org/en>`_.

- `Badging Requirements <https://github.com/coreinfrastructure/best-practices-badge>`_
- `Badging Status for all ONAP projects <https://bestpractices.coreinfrastructure.org/en/projects?q=onap>`_

In the Kohn release,

- 100% projects passed 90% of the OpenSSF badge
- 86% passed the OpenSSF badge
- 11% projects passed the OpenSSF Silver badge

Project specific details are in the :ref:`release notes<component-release-notes>`
for each component.

.. index:: maturity

ONAP Maturity Testing Notes
---------------------------
For the Kohn release, ONAP continues to improve in multiple areas of
Scalability, Security, Stability and Performance (S3P) metrics.


More details in :ref:`ONAP Integration Project<onap-integration:master_index>`

Known Issues and Limitations
----------------------------
Known Issues and limitations are documented in each
:ref:`project Release Notes <component-release-notes>`.
