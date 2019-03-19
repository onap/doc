.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0

.. contents::
   :depth: 2

.. index:: Release Notes

Beijing Release Notes
^^^^^^^^^^^^^^^^^^^^^
This page is the ONAP Beijing Release Notes. The first release was
Amsterdam and subsequent major release will be named using city names.

* Release Name: Beijing
* Release Version: 2.0.0
* Release Date: June 7, 2018


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
**Portal** - a single, consistent user experience for both design timer
and run time environments, based on the user’s role.

**Design Time Framework** - a comprehensive development environment with
tools, techniques, and repositories for defining/describing resources,
services, and products:

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

 - ONAP Operation Manager (OOM) use kubernetes and Helm to manage ONAP
   components.
 - Microservices Bus (MSB) provides service registration/discovery,
   external API gateway, internal API gateway, client software development kit
   (SDK), and Swagger SDK.

Project Specific Release Notes
==============================
ONAP releases are specified by a list of project artifact
versions in a :ref:`manifest<doc-release-manifest>`.

Each project provides detailed :ref:`release notes<doc-releaserepos>`
and prepends to these if/when any updated versions the project team believes
are compatible with a major release are made available.

.. index:: Download

Installation
============
There are 3 approaches to install ONAP:

* :ref:`Installation using Kubernetes (aka OOM) <installing-onap-k8s>`. Recommended method.
* :ref:`Installation using Heat template <installing-onap-heat>`.
* :ref:`Advanced installation to install individual components <installing-onap-individual>`.

Documentation
=============
ONAP Beijing Release provides multiple documents including the following:

 * A high level :ref:`architecture view<doc-architecture>` of how components
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
ONAP has adopted the `CII Best Practice Badge Program <https://bestpractices.coreinfrastructure.org/en>`_. The goal of the Beijing release is for all ONAP projects to be close to achieving a CII Passing badge.

- `Badging Requirements <https://github.com/coreinfrastructure/best-practices-badge#core-infrastructure-initiative-best-practices-badge>`_
- `Badging Status for all ONAP projects <https://bestpractices.coreinfrastructure.org/en/projects?q=onap>`_

Project specific details are in the :ref:`release notes<doc-releaserepos>`
for each project.

**Please note that this version is no longer supported in terms of security bug fixes.
It means that community is not going to backport any security improvements introduced in master nor fix any reported vulnerabilities.
Please upgrade to newer release.**

Licenses
========
ONAP Source Code is licensed under the `Apache Version 2 License
<http://www.apache.org/licenses/LICENSE-2.0>`_.
ONAP Documentation is licensed under the `Creative Commons Attribution 4.0
International License <http://creativecommons.org/licenses/by/4.0>`_.

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
   question into the
   `Ask question <https://wiki.onap.org/display/DW/questions/all>`_.
   You will need a Linux Foundation ID to login and post your question.
   Get a Linux Foundation Identity using this
   `quick procedure <https://wiki.onap.org/display/DW/Joining+the+ONAP+Technical+Community#JoiningtheONAPTechnicalCommunity-WhereDoIStart?>`_.

To properly report a bug in Jira, you may want to consider these `recommendations <https://wiki.onap.org/display/DW/Tracking+Issues+with+JIRA#TrackingIssueswithJIRA-RecommendationsforwrittingProperJIRAIssue>`_ to elaborate the issue you are facing.


.. Include files referenced by link in the toctree as hidden

.. toctree::
   :hidden:

   release-manifest.rst
   releaserepos.rst
   repolist.rst
