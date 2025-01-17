..
  This work is licensed under a Creative Commons Attribution 4.0
  International License. http://creativecommons.org/licenses/by/4.0


.. _onap-release-notes:

'Oslo' Release Notes
====================

This page provides the release notes for the ONAP 'Oslo' release. This
includes details of software versions, known limitations, and outstanding
trouble reports.

Release notes are cumulative for the release, meaning this release note will
have an entry for each Major, Minor, and Maintenance release, if applicable.

Each component within the ONAP solution maintains their own component level
release notes and links to those release notes are provided below.
Details on the specific items delivered in each release by each component is
maintained in the component specific release notes.

'Oslo' Major Release 15.0.0
---------------------------

+-----------------------------------+-----------------------------------------+
| **Project**                       | ONAP                                    |
+-----------------------------------+-----------------------------------------+
| **Release name**                  | Oslo                                    |
+-----------------------------------+-----------------------------------------+
| **Release version**               | 15.0.0                                  |
+-----------------------------------+-----------------------------------------+
| **Release date**                  | 2025, January 16th                      |
+-----------------------------------+-----------------------------------------+

=== TO BE UPDATED ===

ONAP is evolving. We took efforts in streamlining processes and roles and
NewDelhi release is the first one with agreed simplified software development
life cycle governance.

OpenSSF Gold Standard
---------------------

We are proud to announce that first ONAP project achieved OpenSSF Gold
standard. It will give ONAP consumers great confidence in the quality,
security, and reliability of CPS.

Java 17
-------

First ONAP projects (CCSDK, CPS, UUI and Policy) completed their upgrades to
Java 17. Spring boot (uplift to v3.1.2) and OpenApi 3 upgrades were also
performed. These upgrades allow benefits of patched vulnerabilities and
software efficiencies in the latest versions.

CPS
---

ONAP CPS project continued efforts in improvement of read/write, query
operations, and huge reduction of memory consumption allowing for improved
query performance and improve stability.

Modeling
--------

Modeling project added provision of YANG modules automation tools, which helps
improve the YANG development efficiency and check the version update of the
YANG model.

OOM
---

OOM project team added support for Gateway-API in Ingress template (13.0.1) as
well as support for mariadb-operator (13.0.2). All ONAP MariaDB instances will
now be created with the latest version by default using the mariaDB-operator.
Added Galera clients (e.g. SO, SDNC) will use access to "primary" pod to avoid
"Deadlocks". Additionally added default role creation to ServiceAccount for
better access management.

SDC
---

SDC implemented-services update capability directly in yaml was added, more
comprehensive support for defining behavior of interface operations and
adaptability to define CSAR structure and content to suit the requirements of
individual models.

CCSDK
-----

CCSDK continued maintaining alignment with OpenDaylight release schedule by
upgrading to OpenDaylight Argon version, Service Release 2. This allows latest
ONAP user to make use of latest OpenDaylight software when they use latest
release of ONAP.

Portal-NG
---------

We introduced new Portal-NG as a maintained alternative to the unmaintained
Portal project.  Allows ONAP user to make informed decisions on software use of
maintained and unmaintained projects.

Documentation Sources
---------------------

The formal ONAP 'NewDelhi' Release Documentation is available
in :ref:`ReadTheDocs<master_index>`.

The `Developer Wiki <http://wiki.onap.org>`_ remains a good source of
information on meeting plans and notes from committees, project teams and
community events.

OpenSSF Best Practice
---------------------

ONAP has adopted the `OpenSSF Best Practice Badge Program <https://bestpractices.coreinfrastructure.org/en>`_.

- `Badging Requirements <https://github.com/coreinfrastructure/best-practices-badge>`_
- `Badging Status for all ONAP projects <https://bestpractices.coreinfrastructure.org/en/projects?q=onap>`_


In the NewDelhi release,

- 100% projects passed 95% of the OpenSSF badge
- 94% passed the OpenSSF badge
- 24% projects passed the OpenSSF Silver badge
- 1 project passed the OpenSSF Gold badge

Project specific details are in the :ref:`release notes<component-release-notes>`
for each component.

.. index:: maturity

ONAP Maturity Testing Notes
---------------------------
For the 'NewDelhi' release, ONAP continues to improve in multiple areas of
Scalability, Security, Stability and Performance (S3P) metrics.

More details in :ref:`ONAP Integration Project<onap-integration:master_index>`

Known Issues and Limitations
----------------------------
Known Issues and limitations are documented in each
:ref:`project Release Notes <component-release-notes>`.
