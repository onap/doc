..
  This work is licensed under a Creative Commons Attribution 4.0
  International License. http://creativecommons.org/licenses/by/4.0


.. _onap-release-notes:

'London' Release Notes
======================

This page provides the release notes for the ONAP 'London' release. This
includes details of software versions, known limitations, and outstanding
trouble reports.

Release notes are cumulative for the release, meaning this release note will
have an entry for each Major, Minor, and Maintenance release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each release by each component is
maintained in the component specific release notes.

'London' Major Release 12.0.0
-----------------------------

+-----------------------------------+-----------------------------------------+
| **Project**                       | Open Network Automation Platform (ONAP) |
+-----------------------------------+-----------------------------------------+
| **Release name**                  | London                                  |
+-----------------------------------+-----------------------------------------+
| **Release version**               | 12.0.0                                  |
+-----------------------------------+-----------------------------------------+
| **Release date**                  | 2023, July 6th                          |
+-----------------------------------+-----------------------------------------+

Features
--------
ONAP 'London' focusses on:

- ONAP takeaways to get feedback from consumers on what we need to prioritize
- ONAP evolution definition and mission statement refresh
- Modularity and module bundles for specific use cases (O-RAN SMO, Network
  slicing etc.)
- Managing unmaintained projects
- Formalizing ONAP as key player in open RAN @ O-RAN SC TOC Level
- Getting first project: CPS road for gold badge
- SBOMs delivery
- Streamlining Release Management tasks
- Implementing Service Mesh with ISTIO
- Improving software quality by fixing bugs and upgrading components packages
- First implementation of Java 17
- Functional Requirements

-----------------------

Richer Set of Cloud Native Functionality
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- to be done

E2E Network Slicing
^^^^^^^^^^^^^^^^^^^
Added support for 3GPP 28.532 based APIs in NSSMF for network slicing, with
focus on RAN slicing.

Control Loop Evolutions
^^^^^^^^^^^^^^^^^^^^^^^
- Improvements to CLAMP Automation Composition Management (ACM).
- Metadata driven API Generation.
- Improved Metrics and SLAs.
- Improved Testing.

Extended O-RAN Integration
^^^^^^^^^^^^^^^^^^^^^^^^^^
- Enhancements for Configuration Management notification from O-RAN network
  functions over O1 interface.

Controllers
^^^^^^^^^^^
- A1 policy and platform enhancements from CCSDK.

Service Design
^^^^^^^^^^^^^^
- Support for constraints.
- UI support for view/edit/import data types.
- Increased support for TOSCA functions.
- Removed need for USER_ID cookie and header.

Inventory
^^^^^^^^^
- Addition of Cell and Neighbour objects.

ONAP Operations Manager
^^^^^^^^^^^^^^^^^^^^^^^
- Introduction of "Production" ONAP setup.
- Removal of unsupported components (AAF, Portal, Contrib,...).
- Update of component helm charts to use common templates and practices.
- Introduction of Kubernetes Operators for Cassandra (k8ssandra-operator) - to
  support latest Cassandra version (optional for London) and Keycloak.

Non-Functional Requirements
---------------------------
The following 'non-functional' requirements are followed in the
'London' Release:

Best Practice
^^^^^^^^^^^^^
- to be done

Security
^^^^^^^^
- SBOMs generation.
- Packages upgrades to limit number of affecting vulnerabilities.

Documentation
^^^^^^^^^^^^^
- Interactive architecture diagram updated
- End-2-End guides removed because they have become outdated due to
  unmaintained projects.

Tests & Integration
^^^^^^^^^^^^^^^^^^^
- Minor bug fixes, package upgrades and python version fixes.
- Migration out of Orange infra and pipelines was started.

<additional section to be added?>
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
- to be done

.. important::
  Some non-functional requirements are not fully finalized. Please, check details
  on the :doc:`Integration <onap-integration:usecases/release_non_functional_requirements>`

Documentation Sources
---------------------

The formal ONAP 'London' Release Documentation is available
in :ref:`ReadTheDocs<master_index>`.

The `Developer Wiki <http://wiki.onap.org>`_ remains a good source of
information on meeting plans and notes from committees, project teams and
community events.

OpenSSF Best Practice
---------------------
ONAP has adopted the `OpenSSF Best Practice Badge Program <https://bestpractices.coreinfrastructure.org/en>`_.
- `Badging Requirements <https://github.com/coreinfrastructure/best-practices-badge>`_
- `Badging Status for all ONAP projects <https://bestpractices.coreinfrastructure.org/en/projects?q=onap>`_

In the London release,

- 100% projects passed 90% of the OpenSSF badge
- 86% passed the OpenSSF badge
- 11% projects passed the OpenSSF Silver badge

Project specific details are in the :ref:`release notes<component-release-notes>`
for each component.

.. index:: maturity

ONAP Maturity Testing Notes
---------------------------
For the 'London' release, ONAP continues to improve in multiple areas of
Scalability, Security, Stability and Performance (S3P) metrics.
More details in :ref:`ONAP Integration Project<onap-integration:master_index>`

Known Issues and Limitations
----------------------------
Known Issues and limitations are documented in each
:ref:`project Release Notes <component-release-notes>`.
