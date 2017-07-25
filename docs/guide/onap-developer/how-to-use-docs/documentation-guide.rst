.. This work is licensed under a Creative Commons Attribution 4.0 International License.


Documentation Guide
===================

This page describes how documentation is created for the Open Network Automation Platform (ONAP).
ONAP projects create a variety of document types depending on the nature of the project.
Some projects will create detailed technical descriptions such as configuration parameters or how to
use or extend the functionality of platform component that may be used as a standalone reference for that project and/or
be used in larger end to end documents tailored to a specific user audience and task they are performing.

Acknowledgement
---------------

Much of the content in this document is derived from similar documentation processes used in other Linux Foundation Projects
including OPNFV and Open Daylight.

.. contents::
   :depth: 3
   :local:

Getting Started
---------------
ONAP documentation is stored in git repositories, changes are managed with gerrit reviews, and published documents
automatically generated when there is a change in any source used to build the documentation.

Authors create source for documents in reStructured Text (RST) that is automatically rendered to HTML and PDF
and published on Readthedocs.io.
The developer WiKi can reference these rendered documents directly allowing projects to
easily maintain current release documentation.
Read :ref:`this page <include-documentation>` which describes how documentation is created from
ONAP Documentation project (doc) documentation source and other ONAP projects providing source material.

Licencing Your Documentation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
All contributions to the ONAP project are done in accordance with the ONAP licensing requirements.
Documentation in ONAP is contributed
in accordance with the `Creative Commons 4.0 <https://creativecommons.org/licenses/by/4.0/>`_ license.
All documentation files need to be licensed using the text below. The license may be applied in the first lines of
all contributed RST files:

.. code-block:: bash

 .. This work is licensed under a Creative Commons Attribution 4.0 International License.
 .. (c) <optionally add copywriters name>

 These lines will not be rendered in the html and pdf files.

Storing Content Files in Your Repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
All documentation for your project should be structured and stored in `<your_project_repo>/docs/` directory.
The documentation toolchain will look in these directories and be triggered by events in repositories
containing these directories.
when generating documents.

.. index:: master, document

Document Structure and Contribution
-----------------------------------
A top level master_document structure is proposed for organizing and storing all documents.
Four areas as shown below with some additional detail under each area.
This structure may change some as we get the full requirements and gain experience with the first reelase of ONAP.
Where multiple sections with similar content are expected, templates can be created and stored 
under `doc/docs/templates/`. For example each component providing release notes uses the same release-note template.
A template is a directory name in `doc/docs/templates` and the directory contains at least an index.rst file with
content and as needed references to other sources in the template directory.

Project teams are encouraged to reuse and if needed propose new templates to ensure that there is
consistency across projects.

::

        docs/
        ├── release
        │   ├── overview
        │   ├── architecture
        │   ├── use-cases
        │   ├── tutorials
        │   └── release-notes
        ├── onap-developer
        │   ├── design
        │   ├── develop
        │   ├── document
        │   └── test
        ├── administrator
        │   ├── configure
        │   ├── deploy
        │   └── operate
        ├── service-designer
        │   ├── deploy
        │   ├── design
        │   └── portal
        └── vnf-provider
            ├── guidelines
            └── sdk


Release Documentation
^^^^^^^^^^^^^^^^^^^^^
Release documentation is the set of documents that are published for each ONAP release.
The documents have a master index.rst file in the <doc> repository and reference content as needed
from other project repository.
To provide content for these other projects place <content>.rst files in a directory in your repository that
matches the master document and add a reference to that file in the correct place in the
corresponding master index.rst. 

**Release Overview**: `doc/docs/release/overview`

- Content for this is prepared by the Marketing team together with the use case committee and doc project team.
- This document is not a project contribution driven document.

**Installation Instruction**: `doc/docs/release/install`

- Document providing an introduction, order, and aggregation of release notes from other component projects.
- This document is a contribution driven document.

**To Be Provided**: `<repo>/docs/xxxxxxxx`

- Additional descriptions for the above outline as it is finalized.


