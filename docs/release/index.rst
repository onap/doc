.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0


.. _release-notes:

Frankfurt Release Notes
^^^^^^^^^^^^^^^^^^^^^^^

This page provides the release notes for the ONAP Frankfurt release. This
includes details of software versions, known limitations, and outstanding
trouble reports.

Release notes are cumulative for the release, meaning this release note will
have an entry for each Major, Minor, and Maintenance release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each release by each component is
maintained in the component specific release notes.

Frankfurt Releases
==================

The following releases are available for Frankfurt:
  - `Frankfurt Major Release 6.0.0`_
  - `Frankfurt Maintenance Release 6.0.1`_

Frankfurt Maintenance Release 6.0.1
===================================

Release data
============

+--------------------------------------+--------------------------------------+
| **Project**                          | Open Network Automation Platform     |
|                                      | (ONAP)                               |
+--------------------------------------+--------------------------------------+
| **Release name**                     | Frankfurt                            |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release version**                  | 6.0.1                                |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | August 17th 2020                     |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

Frankfurt Maintenance Release 6.0.1 delivered a number of fixes and updates
across the following projects:

- AAF
- OOM
- CCSDK
- CLAMP
- DCAEGEN2
- Integration
- POLICY
- SDC
- SO
- TEST

Details on the specific Jira tickets addressed by each project can be found in
the component specific Release Notes. Link can be found below in section
`Project Specific Release Notes`_.

Frankfurt Major Release 6.0.0
=============================

Release data
============

+--------------------------------------+--------------------------------------+
| **Project**                          | Open Network Automation Platform     |
|                                      | (ONAP)                               |
+--------------------------------------+--------------------------------------+
| **Release name**                     | Frankfurt                            |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release version**                  | 6.0.0                                |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | June 11th 2020                       |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

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
ONAP Frankfurt Release provides a set selection of documents,
see `ONAP Documentation <https://docs.onap.org/en/frankfurt/index.html>`_.

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

Project specific details are in the :ref:`release notes<doc-releaserepos>` for
each project.

.. index:: maturity

ONAP Maturity Testing Notes
===========================
For the Frankfurt release, ONAP continues to improve in multiple areas of
Scalability, Security, Stability and Performance (S3P) metrics.

The Integration team ran the 72 hours stability testing (100% passing rate)
and full resilience testing (99.4% passing rate) at ONAP OpenLabs. More details
in :ref:`ONAP Maturity Testing Notes <integration-s3p>`

Known Issues and Limitations
============================
Known Issues and limitations are documented in each
:ref:`project Release Notes <doc-releaserepos>`.


.. Include files referenced by link in the toctree as hidden
