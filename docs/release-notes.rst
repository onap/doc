.. This work is licensed under a Creative Commons Attribution 4.0
   International License. http://creativecommons.org/licenses/by/4.0
   Copyright 2017 AT&T Intellectual Property.  All rights reserved.
   Copyright 2018-2021 by ONAP and contributors.

.. _doc_release_notes:

:orphan:

Release Notes
=============

This document provides the release notes for the documentation project.

Oslo Releases
=============

The following releases are available:

..  - `Oslo Major Release 15.0.0`_

Oslo Major Release 15.0.0
=========================

+--------------------------------------+--------------------------------------+
| **Project**                          | Documentation Project                |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release name**                     | Oslo                                 |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release version**                  | 15.0.0                               |
|                                      |                                      |
+--------------------------------------+--------------------------------------+


New features
------------

- Documentation cleaned up - unmaintained projects removed.
- Example configuration files updated. Please check the 'doc-best-practice'
  repository.
- Term 'platform' is no longer used. 'Platform' section renamed to 'Ecosystem'.
  Term replaced in text.
- Logo updated (term 'Open Network Automation Platform' removed). You can find
  the new logo in the "logo" directory in both documentation repos. We provide
  the vector format as well as bitmap formats in various sizes. You need to
  change conf.py and place the new logo in the _static directory.

All JIRA tickets for this release can be found here:
`ONAP Documentation Jira`_

.. _`ONAP Documentation Jira`: https://jira.onap.org/issues/?jql=project%20%3D%20DOC%20AND%20fixVersion%20%3D%20%22Oslo%20Release%22%20%20ORDER%20BY%20priority%20DESC%2C%20updated%20DESC
