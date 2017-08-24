.. This work is licensed under a Creative Commons Attribution 4.0 International License.


Introduction
============
This guide describes how to create documentation for the Open Network
Automation Platform (ONAP).  ONAP projects create a variety of document
types depending on the nature of the project. Some projects will create
detailed technical descriptions such as configuration parameters or how
to use or extend the functionality of platform component.
These descriptions may be used together as a reference for that project
and/or be used in documents tailored to a specific user audience and
task they are performing.

Much of the content in this document is derived from similar 
documentation processes used in other Linux Foundation 
Projects including OPNFV and Open Daylight.


End to End View
---------------
ONAP documentation is stored in git repositories, changes are managed
with gerrit reviews, and published documents generated when there is a
change in any source used to build the documentation.

Authors create source for documents in reStructured Text (RST) that is
rendered to HTML and PDF and published on Readthedocs.io.
The developer Wiki or other web sites can reference these rendered 
documents directly allowing projects to easily maintain current release
documentation.


Structure
---------
A top level master_document structure is used to organize all 
documents for an ONAP release that reside in the doc git repository. 
Complete documents or guides may reside here and reference parts of 
source for documentation from other project repositories 
A starting structure is shown below and may change as content is
intergrated for each release.   Others ONAP projects will provide
content that is referenced from this structure.

.. index:: master


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
        ├── adminstrator
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



Source Files
------------
All documentation for a project should be structured and stored 
in or below `<your_project_repo>/docs/` directory as Restructured Text.
ONAP jenkins jobs that verify and merge documentation are triggered by
file changes in the docs directory and below.


.. index:: licensing

Licencing
---------
All contributions to the ONAP project are done in accordance with the
ONAP licensing requirements.   Documentation in ONAP is contributed
in accordance with the `Creative Commons 4.0 <https://creativecommons.org/licenses/by/4.0/>`_ license.
All documentation files need to be licensed using the text below. 
The license may be applied in the first lines of all contributed RST 
files:

.. code-block:: bash

 .. This work is licensed under a Creative Commons Attribution 4.0 International License.
 .. (c) <optionally add copyrights company name>

 These lines will not be rendered in the html and pdf files.



Templates
---------
To encourage consistency of information across components, some
templates are available as a starting point under `doc/docs/templates/`
and listed below.  With the "show source" feature on html pages, you
may be able to use portions of an existing page as starting point for
creating new content.


.. toctree::
   :maxdepth: 1
   :glob:

   ../../../templates/**/index
   
