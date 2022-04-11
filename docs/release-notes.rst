.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0
   Copyright 2017 AT&T Intellectual Property.  All rights reserved.
   Copyright 2018-2021 by ONAP and contributors.

.. _doc_release_notes:

:orphan:

Release Notes
=============

This document provides the release notes for the documentation project.

Istanbul Releases
=================

The following releases are available for Istanbul:
  - `Jakarta Major Release 10.0.0`_

Jakarta Major Release 10.0.0
============================

+--------------------------------------+--------------------------------------+
| **Project**                          | Documentation Project                |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release name**                     | Jakarta                              |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release version**                  | 10.0.0                               |
|                                      |                                      |
+--------------------------------------+--------------------------------------+


New features
------------

- Documentation cleaned up. Chapters which include unmaintained projects were
  removed to avoid misunderstandings at the readership.
- Projects (repositories) which do not create a stable release branch are no
  longer included in the release documentation. This should help to improve the
  release management process.
- Beginning with this release we are providing example configuration files for
  setting up a proper process of documentation creation. Please check the 'doc'
  repository.
- The Interactive Architecture Overview was updated. Learn about the ONAP
  architecture in an intuitive way.
- The guide to set up a development system for documentation was updated.

All JIRA tickets for the Istanbul release can be found
`ONAP Documentation Jira`_

.. _`ONAP Documentation Jira`: https://jira.onap.org/issues/?jql=project%20%3D%20DOC%20AND%20fixVersion%20%3D%20%22Jakarta%20Release%22%20%20ORDER%20BY%20priority%20DESC%2C%20updated%20DESC
