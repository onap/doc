.. This work is licensed under a Creative Commons Attribution 4.0 International License.


Introduction
============
This guide describes how to create documentation for the Open Network
Automation Platform (ONAP).  ONAP projects create a variety of 
content depending on the nature of the project.  For example projects delivering
a platform component may have different types of content than
a project that creates libraries for a software development kit.
The content from each project may be used together as a reference for that project
and/or be used in documents are tailored to a specific user audience and
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

Why reStructuredText/Sphinx?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the past, standard documentation methods included ad-hoc Word documents, PDFs, 
poorly organized Wikis, and other, often closed, tools like Adobe FrameMaker.
The rise of DevOps, Agile, and Continuous Integration, however, created a paradigm
shift for those who care about documentation because:

1. Documentation must be tightly coupled with code/product releases. In many cases,
particularly with open-source products, many different versions of the same code
can be installed in various production environments. DevOps personnel must have
access to the correct version of documentation.

2. Resources are often tight, volunteers scarce. With a large software base
like ONAP, a small team of technical writers, even if they are also developers,
cannot keep up with a constantly changing, large code base. Therefore, those closest
to the code should document it as best they can, and let professional writers edit for
style, grammar, and consistency.

Plain-text formatting syntaxes, such as reStructuredText, Markdown, and Textile,
are a good choice for documentation because:

a. They are editor agnostic
b. The source is nearly as easy to read as the rendered text
c. Documentation can be treated exactly as source code is (e.g. versioned,
   diff'ed, associated with commit messages that can be included in rendered docs)
d. Shallow learning curve

The documentation team chose reStructuredText largely because of Sphinx, a Python-based
documentation build system, which uses reStructuredText natively. In a code base
as large as ONAP's, cross-referencing between component documentation was deemed
critical. Sphinx and reStructuredText have built-in functionality that makes
collating and cross-referencing component documentation easier.

Which docs should go where?
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequently, developers ask where documentation should be created. Should they always use
reStructuredText/Sphinx? Not necessarily. Is the wiki appropriate for anything at all? Yes.

It's really up to the development team. Here is a simple rule:

The more tightly coupled the documentation is to a particular version of the code,
the more likely it is that it should be stored with the code in reStructuredText.

Two examples on opposite ends of the spectrum:

Example 1: API documentation is often stored literally as code in the form of formatted
comment sections. This would be an ideal choice for reStructuredText stored in a doc repo.

Example 2: A high-level document that describes in general how a particular component interacts
with other ONAP components with charts. The wiki would be a better choice for this.

The doc team encourages component teams to store as much documentation as reStructuredText
as possible because:

1. The doc team can more easily edit component documentation for grammar, spelling, clarity, and consistency.
2. A consistent formatting syntax across components will allow the doc team more flexibility in producing different kinds of output.
3. The doc team can easily re-organize the documentation.
4. Wiki articles tend to grow stale over time as the people who write them change positions or projects.

Structure
---------
A top level master document structure is used to organize all 
documents for an ONAP release and this resides in the gerrit doc repository. 
Complete documents or guides may reside here and reference parts of 
source for documentation from other project repositories 
A starting structure is shown below and may change as content is
integrated for each release.   Other ONAP projects will provide
content that is referenced from this structure.

.. index:: master


::

        docs/
        ├── releases
        │   ├── major releases
        │   ├── projects
        │   ├── cryptographic signatures
        │   └── references
        ├── onap-developer
        │   ├── architecture
        │   ├── tutorials
        │   ├── setting up
        │   ├── developing
        │   └── documenting
        └── onap-users
            ├── vf provider
            ├── service designer
            ├── service administrator
            └── platform administrator



Source Files
------------
All documentation for a project should be structured and stored 
in or below `<your_project_repo>/docs/` directory as Restructured Text.
ONAP jenkins jobs that verify and merge documentation are triggered by
RST file changes in the top level docs directory and below.


.. index:: licensing

Licensing
---------
All contributions to the ONAP project are done in accordance with the
ONAP licensing requirements.   Documentation in ONAP is contributed
in accordance with the `Creative Commons 4.0 <https://creativecommons.org/licenses/by/4.0/>`_ license.
All documentation files need to be licensed using the text below. 
The license may be applied in the first lines of all contributed RST 
files:

.. code-block:: bash

 .. This work is licensed under a Creative Commons Attribution 4.0 International License.
 .. http://creativecommons.org/licenses/by/4.0
 .. Copyright YEAR ONAP or COMPANY or INDIVIDUAL

 These lines will not be rendered in the html and pdf files.

When there are subsequent, significant contributions to a source file from a different contributor,
a new copyright line may be appended after the last existing copyright line.

