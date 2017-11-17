.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0

.. index:: Release Notes

Releases
========
This page is the ONAP Amsterdam Release Notes. The first release is
Amsterdam and subsequent major release will be named using city names.

* Release Name: Amsterdam
* Release Version: 1.0.0
* Release Date: November 16, 2017


Amsterdam Release
-----------------

Summary
+++++++
ONAP provides a comprehensive platform for real-time, policy-driven
orchestration and automation of physical and virtual network functions
that will enable software, network, IT and cloud providers and developers
to rapidly automate new services and support complete life cycle management.
By unifying member resources, ONAP will accelerate the development of a
vibrant ecosystem around a globally shared architecture and implementation
for network automation–with an open standards focus–faster than any one
product could on its own.

Functionality
+++++++++++++
**Portal** - a single, consistent user experience for both design timer
and run time environments, based on the user’s role.

**Design Time Framework** - a comprehensive development environment with
tools, techniques, and repositories for defining/describing resources,
services, and products:

 - Service Design and Creation (SDC) provides tools, techniques, and
   repositories to define/simulate/certify system assets as well as their
   associated processes and policies.

 - A VNF Software Development Kit (VNFSDK) with tools for VNF supplier
   packaging and validation.

 - Policy Creation (POLICY) deals with conditions, requirements,
   constraints, attributes, or needs that must be provided, maintained,
   and/or enforced.

 - Closed Loop Automation Management Platform (CLAMP) provides a method
   for designing and managing control loops.

**Runtime Framework** - The runtime execution framework executes the
rules and policies distributed by the design and creation environment
and Controllers that manage resources corresponding to their assigned
controlled domain:

 - Service Orchestrator (SO) executes the specified processes and automates
   sequences of activities, tasks, rules and policies needed for on-demand
   creation, modification or removal of network, application or infrastructure
   services and resources.

 - Software Defined Network Controller (SDNC) network configuration of
   cloud computing resources.

 - Application Controller (APPC) Application resources.

 - Virtual Function Controller (VF-C) provides an ETSI NFV compliant NFV-O
   functions, and is responsible for life cycle management of virtual services
   and the associated physical COTS server infrastructure.

 - Active and Available Inventory (A&AI) provides real-time views of a
   system’s resources, services, products and their relationships with each
   other.

**Closed-Loop Automation** -- Design -> Create -> Collect -> Analyze >
Detect -> Publish -> Respond:

 - Data Collection, Analytics and Events (DCAE) collects performance,
   usage, and configuration data and publishes information to policy,
   orchestration, and the data lake.

 - “Holmes” provides alarm correlation and analysis for Telecom cloud
   infrastructure and services, including hosts, vims, VNFs and NSs

 - Common Services - operational services for all ONAP components including
   activity logging, reporting, common data layer, access control, resiliency,
   and software lifecycle management.

Project Specific Release Notes
++++++++++++++++++++++++++++++
ONAP releases are specified by a list of project artifact
versions in a :ref:`manifest<doc-release-manifest>`.
Each project provides detailed :ref:`release notes<doc-releaserepos>`
and prepends to these if/when any updated versions the project team believes
are compatible with a major release are made available.


Supported Platforms
+++++++++++++++++++
ONAP Amsterdam Release has been tested on Ubuntu 16.04 and thus is
the only OS supported.

Documentation
+++++++++++++
ONAP Amsterdam Release documentation is available :ref:`here <master_index>`.
For Amsterdam this includes:

 * A high level :ref:`architecture view<doc-architecture>` of how components
   relate to each other.

 * A collection of documentation provided
   by :ref:`each project <doc_onap-developer_guide_projects>`.

 * Application Programming Interface
   Reference :ref:`available here <doc-apiref>`.

 * The `developer wiki <http://wiki.onap.org>`_ remains a good source of
   information on meeting plans and notes from committees, project teams and
   community events.


Known Issues and Limitations
++++++++++++++++++++++++++++
Known Issues and limitations are documented in each project Release Notes.

Refer to :ref:`release notes <doc-releaserepos>` for each project.


.. index:: Licensing

Licenses
++++++++
ONAP Amsterdam Source Code is licensed under the `Apache Version 2 License <http://www.apache.org/licenses/LICENSE-2.0>`_.
ONAP Amsterdam Documentation is licensed under the `Creative Commons Attribution 4.0 International License <http://creativecommons.org/licenses/by/4.0>`_.

.. index:: Reporting Bugs

How to Report a Bug
+++++++++++++++++++
There are 2 ways to report a bug in ONAP.

 * In case you are familiar within ONAP, you can directly
   report a bug by creating a Jira issue
   at `ONAP Jira <https://jira.onap.org>`_.

 * If you don't know you are facing a bug or have a question, email
   the ONAP Discuss mailing list at onap-discuss@lists.onap.org .

You may consider these `recommendations <https://wiki.onap.org/display/DW/Tracking+Issues+with+JIRA#TrackingIssueswithJIRA-RecommendationsforwrittingProperJIRAIssue>`_ to elaborate the issue you are facing and this `guideline <https://wiki.onap.org/display/DW/Mailing+Lists>`_ to register into the ONAP Discuss mailing list.

.. index:: Download

Download
++++++++

* ONAP Source Code is available through Gerrit at https://gerrit.onap.org or Git at https://git.onap.org/ .

* ONAP is packaged within Docker and can be dowloaded from Docker Hub at https://hub.docker.com/r/onap .


.. index:: Installation


Install
+++++++
There are 2 approaches to install ONAP.

* From a complete demo solution perspective. This installs the whole ONAP,
  refer to :ref:`Setting Up ONAP <demo-installing-running-onap>`.

* From a developer perspective. ONAP is installed component per component.
  Each
  component :ref:`installation is listed in<doc_onap-developer_guide_projects>`.
  The list of ports used by default within ONAP is documented
  in `ONAP Service List <https://wiki.onap.org/display/DW/ONAP+Services+List>`_.

Usage
+++++
This section is intended to provide users on the usage of ONAP components.

Instructions on using the ONAP deployment including Robot, Portal, SDC and VID
in the context of running (Onboarding, service creation, service deployment,
VNF creation, VNF preload, VF Module creation and closed loop operations)
the vFirewall sanity use case is documented
in `Running the ONAP Demos <https://wiki.onap.org/display/DW/Running+the+ONAP+Demos>`_.


.. Include files referenced by link in the toctree as hidden

.. toctree::
   :hidden:

   release-manifest.rst
   releaserepos.rst
   repolist.rst
