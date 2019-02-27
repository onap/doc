.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0

Casablanca Release Notes
^^^^^^^^^^^^^^^^^^^^^^^^
This page is the ONAP Casablanca Release Notes. The first release was labelled
Amsterdam, second release Beijing and subsequent major release will be named
using city names.

Release notes are cumulative for the release, meaning this release note for Casablanca will have an entry for each Major, Minor, and Maintenance release, if applicable. Information that is applicable regardless of release is included in the `Getting Started With ONAP`_ section of this document.

Each component within the ONAP solution maintains their own component level release notes and links to those release notes are provided below. Details on the specific items delivered in each releaese by each component is maintained in the component specific release notes.

Casablanca Releases
===================

The following releases are available for Casablanca:
  - `Casablanca Maintenance Release 3.0.1`_
  - `Casablanca Major Release 3.0.0`_

Casablanca Maintenance Release 3.0.1
====================================

* Release Name: Casablanca
* Release Version: 3.0.1
* Release Date: Jan 31, 2019

The Casablanca Maintenance Release delivered a number of fixes and updates across the following projects:
 - AAI
 - APPC
 - CCSDK
 - CLAMP
 - DCAEGEN2
 - DOC
 - EXTAPI
 - Integration
 - MultiCloud
 - OOM
 - OOF
 - Policy
 - Portal
 - SDC
 - SDNC
 - SO

Details on the specific Jira tickets addressed by each project can be found in the component specific Release Notes. Link can be found below in section `Project Specific Release Notes`_.

Casablanca Major Release 3.0.0
==============================

* Release Name: Casablanca
* Release Version: 3.0.0
* Release Date: Nov 30, 2018

The Casablanca 3.0.0 is the first of Casablanca.

.. _getting-started:

Getting Started With ONAP
=========================

Summary
-------
ONAP provides a comprehensive platform for real-time, policy-driven
service orchestration and automation including virtual network functions and
applications instantiation and configuration, but also physical network
functions configuration.
ONAP will enable software, network, IT and cloud providers and developers
to rapidly automate new services and support complete life cycle management.
By unifying member resources, ONAP will accelerate the development of a
vibrant ecosystem around a globally shared architecture and implementation
for network automation-with an open standards focus-faster than any one
product could on its own.

Functionality
-------------
**Portal** - a single, consistent user experience for both design time
and run time environments, based on the user’s role.

**Design Time Framework** - a comprehensive development environment with
tools, techniques, and repositories for defining/describing resources,
and services:

 - Service Design and Creation (SDC) provides tools, techniques, and
   repositories to define/simulate/certify system assets as well as their
   associated processes and policies.

 - A VNF Software Development Kit (VNFSDK) and VNF Validation Program (VVP)
   with tools for VNF supplier packaging and validation.

 - Policy Creation (POLICY) deals with conditions, requirements,
   constraints, attributes, or needs that must be provided, maintained,
   and/or enforced.

 - Closed Loop Automation Management Platform (CLAMP) provides a method
   for designing and managing control loops.

 - Optimization Framework (OOF) provides a policy-driven and model-driven
   framework for creating optimization applications.

**Runtime Framework** - The runtime execution framework executes the
rules and policies distributed by the design and creation environment
and Controllers that manage resources corresponding to their assigned
controlled domain:

 - Service Orchestrator (SO) executes the specified BPMN processes and
   automates sequences of activities, tasks, rules and policies needed for
   on-demand creation, modification or removal of network, application or
   infrastructure services and resources. SO is especially able to drive
   any OpenStack-based cloud platform.

 - Software Defined Network Controller (SDNC) executes network configuration
   for cloud computing resources and network.

 - Application Controller (APPC) executes Virtual Network Functions (VNF)
   configurations and lifecycle management operations.

 - Virtual Function Controller (VF-C) is responsible for lifecycle management
   of virtual network functions and network services based on VNF using
   VNF Manager.

 - Active and Available Inventory (A&AI) provides real-time views of a
   system’s resources, services, products and their relationships with each
   other.

**Closed-Loop Automation** -- Design -> Create -> Collect -> Analyze >
Detect -> Publish -> Respond:

 - Data Collection, Analytics and Events (DCAE) collects events, performance,
   usage and publishes information to policy that executes the rules to perform
   closed loop actions.

 - Holmes provides alarm correlation and analysis for Telecom cloud
   infrastructure and services, including servers, cloud infrastructure,
   VNFs and Network Services.

 - Common Services - operational services for all ONAP components including
   activity logging, reporting, common data layer, access control, resiliency,
   multisite state coordination, credential/secret management and
   software lifecycle management.

**Microservices Support**

 - ONAP Operation Manager (OOM) use Kubernetes and Helm to manage ONAP components.
 - Microservices Bus (MSB) provides service registration/discovery,
   external API gateway, internal API gateway, client software development kit
   (SDK), and Swagger SDK.

Project Specific Release Notes
==============================
ONAP releases are specified by a list of project artifact versions in a :ref:`manifest artifacts <doc-release-manifest-artifacts>` and :ref:`manifest dockers <doc-release-manifest-docker>`.

.. toctree::
   :hidden:

   release-manifest-docker.rst 
   release-manifest.rst

Each project provides detailed :ref:`release notes<doc-releaserepos>`
and prepends to these if/when any updated versions the project team believes
are compatible with a major release are made available.

.. index:: Download

Installation
============
ONAP is installed using :ref:`ONAP Operations Manager (OOM) over Kubernetes<installing-onap>`

Documentation
=============
ONAP Casablanca Release provides multiple documents including the following:

 * A high level :ref:`architecture view<doc-architecture>` of how component
   relate to each other.

 * A collection of documentation provided
   by :ref:`each project <doc_onap-developer_guide_projects>`.

 * Application Programming Interface
   Reference :ref:`available here <doc-apiref>`.

 * The `developer wiki <http://wiki.onap.org>`_ remains a good source of
   information on meeting plans and notes from committees, project teams and
   community events.

.. index:: Licensing

Security Notes
==============
ONAP has adopted the `CII Best Practice Badge Program <https://bestpractices.coreinfrastructure.org/en>`_.
The goal of the Casablanca release is for all ONAP projects to be close to achieving a CII Passing badge.

- `Badging Requirements <https://github.com/coreinfrastructure/best-practices-badge#core-infrastructure-initiative-best-practices-badge>`_
- `Badging Status for all ONAP projects <https://bestpractices.coreinfrastructure.org/en/projects?q=onap>`_

Project specific details are in the :ref:`release notes<doc-releaserepos>` for each project.

.. index:: maturity

ONAP Maturity Testing Notes
===========================
For the Casablanca release, ONAP continues to improve in multiple areas of Scalability, Security, Stability and Performance (S3P) metrics.

The Integration team ran the 72 hours stability testing (100% passing rate) and full resilience testing (96.9% passing rate) at ONAP OpenLabs. More details in :ref:`ONAP Maturity Testing Notes <integration-s3p>`

Licenses
========
ONAP Source Code is licensed under the `Apache Version 2 License <http://www.apache.org/licenses/LICENSE-2.0>`_.
ONAP Documentation is licensed under the `Creative Commons Attribution 4.0
International License <http://creativecommons.org/licenses/by/4.0>`_.

Known Issues and Limitations
============================
Known Issues and limitations are documented in each :ref:`project Release Notes <doc-releaserepos>`.

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

