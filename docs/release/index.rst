.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0


.. _release-notes:

El Alto Release Notes
^^^^^^^^^^^^^^^^^^^^^

This page provides the release notes for the ONAP El Alto release. This
includes details of software versions used, known limitations, and outstanding
trouble reports.

Release notes are cumulative for the release, meaning this release note for the
El Alto release will have an entry for each Major, Minor, and
Maintenance release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each releaese by each component is
maintained in the component specific release notes.

El Alto Releases
================

The following releases are available for El Alto:
  - `El Alto Maintenance Release 5.0.2`_
  - `El Alto Major Release 5.0.1`_

El Alto Maintenance Release 5.0.2
=================================

Release data
============

+--------------------------------------+--------------------------------------+
| **Project**                          | Open Network Automation Platform     |
|                                      | (ONAP)                               |
+--------------------------------------+--------------------------------------+
| **Release name**                     | El Alto                              |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release version**                  | 5.0.2                                |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | August 24th 2020                     |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

Besides renewal of certificates of various components,
El Alto Maintenance Release 5.0.2 delivered a number of fixes and updates
across the following projects:

- AAI
- AAF
- CCSDK
- DMaaP
- DCAEGEN2
- OOM
- Policy
- Portal
- SDC
- SO

Details on the specific Jira tickets addressed by each project can be found in the component specific Release Notes. Link can be found below in section `Project Specific Release Notes`_.


El Alto Major Release 5.0.1
===========================

Release data
============

+--------------------------------------+--------------------------------------+
| **Project**                          | Open Network Automation Platform     |
|                                      | (ONAP)                               |
+--------------------------------------+--------------------------------------+
| **Release name**                     | El Alto                              |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release version**                  | 5.0.1                                |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | October 24th 2019                    |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

El Alto features
================
El Alto release focused on tests, security and documentation, and introduces
some new features.

Existing Features Enhancement
-----------------------------
- CDS Enhancements
- Reduce Defects Backlog

Documentation
-------------
- Swagger integration
- User Guides (End to end, SDC, CLAMP...)

Tests
-----
- JS tests coverage
- Increase end to end test automation
- OOM Gating

Security/Vulnerability/Licenses
-------------------------------
- AAF Auto-Configuration and Certificate Generation
- Upgrade to latest oParent
- OpenDayLight Neson SR1
- Replace Angular by React (CLAMP)

IT Improvements
---------------
- Self-serve Release
- Kickoff DockerHub migration

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
ONAP El Alto Release provides a set selection of documents,
see :ref:`ONAP Home<master_index>`.

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

Project specific details are in the :ref:`release notes<doc-releaserepos>` for
each project.

.. index:: maturity

ONAP Maturity Testing Notes
===========================
For El Alto release, ONAP continues to improve in multiple areas of
Scalability, Security, Stability and Performance (S3P) metrics.

The Integration team ran the 72 hours stability testing (100% passing rate)
and full resilience testing (99.4% passing rate) at ONAP OpenLabs. More details
in :ref:`ONAP Maturity Testing Notes <integration-s3p>`

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
