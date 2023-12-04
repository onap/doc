..
  This work is licensed under a Creative Commons Attribution 4.0
  International License. http://creativecommons.org/licenses/by/4.0


.. _onap-release-notes:

'Montreal' Release Notes
========================

This page provides the release notes for the ONAP 'Montreal' release. This
includes details of software versions, known limitations, and outstanding
trouble reports.

Release notes are cumulative for the release, meaning this release note will
have an entry for each Major, Minor, and Maintenance release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each release by each component is
maintained in the component specific release notes.

'Montreal' Major Release 13.0.0
-------------------------------

+-----------------------------------+-----------------------------------------+
| **Project**                       | Open Network Automation Platform (ONAP) |
+-----------------------------------+-----------------------------------------+
| **Release name**                  | Montreal                                |
+-----------------------------------+-----------------------------------------+
| **Release version**               | 13.0.0                                  |
+-----------------------------------+-----------------------------------------+
| **Release date**                  | not released yet                        |
+-----------------------------------+-----------------------------------------+

Features
--------

ONAP 'Montreal' focusses on:

- to be done 

Functional Requirements
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

- to be done

Non-Functional Requirements
---------------------------

The following 'non-functional' requirements are followed in the 'Montreal'
Release:

Security
^^^^^^^^

- to be done

Documentation
^^^^^^^^^^^^^

- Minor corrections

Tests & Integration
^^^^^^^^^^^^^^^^^^^

- to be done

.. important::
   Some non-functional requirements are not fully finalized. Please, check
   details at :doc:`Integration <onap-integration:usecases/release_non_functional_requirements>`

Documentation Sources
---------------------

The formal ONAP 'Montreal' Release Documentation is available
in :ref:`ReadTheDocs<master_index>`.

The `Developer Wiki <http://wiki.onap.org>`_ remains a good source of
information on meeting plans and notes from committees, project teams and
community events.

OpenSSF Best Practice
---------------------

ONAP has adopted the `OpenSSF Best Practice Badge Program <https://bestpractices.coreinfrastructure.org/en>`_.

- `Badging Requirements <https://github.com/coreinfrastructure/best-practices-badge>`_
- `Badging Status for all ONAP projects <https://bestpractices.coreinfrastructure.org/en/projects?q=onap>`_

In the Montreal release,

- 100% projects passed 90% of the OpenSSF badge
- 86% passed the OpenSSF badge
- 11% projects passed the OpenSSF Silver badge

Project specific details are in the :ref:`release notes<component-release-notes>`
for each component.

.. index:: maturity

ONAP Maturity Testing Notes
---------------------------
For the 'Montreal' release, ONAP continues to improve in multiple areas of
Scalability, Security, Stability and Performance (S3P) metrics.

More details in :ref:`ONAP Integration Project<onap-integration:master_index>`

Known Issues and Limitations
----------------------------
Known Issues and limitations are documented in each
:ref:`project Release Notes <component-release-notes>`.
