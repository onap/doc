.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.

Introduction
============
This guide describes how to create documentation for the Open Network
Automation Platform (ONAP).  ONAP projects create a variety of
content depending on the nature of the project.  For example projects
delivering a platform component may have different types of content than
a project that creates libraries for a software development kit.
The content from each project may be used together as a reference for
that project and/or be used in documents that are tailored to a specific
user audience and tasks they are performing.

Much of the content in this document is derived from similar
documentation processes used in other Linux Foundation
Projects including OPNFV and Open Daylight.

When is documentation required?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
All ONAP project contributions should have corresponding documentation.
This includes all new features and changes to features that impact users.

How do I create ONAP documentation?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ONAP documentation is written in ReStructuredText_ (an easy-to-read,
what-you-see-is-what-you-get, plain text markup syntax).  The process for
creating ONAP documentation and what documents are required are
described in later sections of this Developer Documentation Guide.

.. _ReStructuredText: http://docutils.sourceforge.net/rst.html

Why reStructuredText/Sphinx?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the past, standard documentation methods included ad-hoc Word documents,
PDFs, poorly organized Wikis, and other, often closed, tools like
Adobe FrameMaker.  The rise of DevOps, Agile, and Continuous Integration,
however, created a paradigm shift for those who care about documentation
because:

1. Documentation must be tightly coupled with code/product releases.
   In many cases, particularly with open-source products, many different
   versions of the same code can be installed in various production
   environments. DevOps personnel must have access to the correct version
   of documentation.

2. Resources are often tight, volunteers scarce. With a large software base
   like ONAP, a small team of technical writers, even if they are also
   developers, cannot keep up with a constantly changing, large code base.
   Therefore, those closest to the code should document it as best they can,
   and let professional writers edit for style, grammar, and consistency.

Plain-text formatting syntaxes, such as reStructuredText, Markdown,
and Textile, are a good choice for documentation because:

a. They are editor agnostic

b. The source is nearly as easy to read as the rendered text

c. Documentation can be treated exactly as source code is (e.g. versioned,
   diff'ed, associated with commit messages that can be included
   in rendered docs)

d. Shallow learning curve

The documentation team chose reStructuredText largely because of Sphinx,
a Python-based documentation build system, which uses reStructuredText
natively. In a code base as large as ONAP's, cross-referencing between
component documentation was deemed critical. Sphinx and reStructuredText
have built-in functionality that makes collating and cross-referencing
component documentation easier.

Which docs should go where?
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequently, developers ask where documentation should be created. Should
they always use reStructuredText/Sphinx? Not necessarily. Is the wiki
appropriate for anything at all? Yes.

It's really up to the development team. Here is a simple rule:

The more tightly coupled the documentation is to a particular version
of the code, the more likely it is that it should be stored with the
code in reStructuredText.

The doc team encourages component teams to store as much documentation
as reStructuredText as possible because:

1. It is easier to edit component documentation for grammar,
   spelling, clarity, and consistency.

2. A consistent formatting syntax across components will allow
   flexibility in producing different kinds of output.

3. It is easier to re-organize the documentation.

4. Wiki articles tend to grow in size and not maintained making it hard
   to find current information.

Structure
---------
A top level master document structure is used to organize all
documents created by ONAP projects and this resides in the gerrit doc
repository.  Complete documents or guides may reside here and
reference parts of source for documentation from other project
repositories.  Other ONAP projects will provide content that
is referenced from this structure.

::

    docs
    ├── guides
    │   ├── onap-developer
    │   │   ├── apiref
    │   │   ├── architecture
    │   │   ├── developing
    │   │   ├── how-to-use-docs
    │   │   ├── settingup
    │   │   ├── tutorials
    │   │   └── use-cases
    │   ├── onap-provider
    │   └── onap-user
    ├── release
    └── templates
        ├── collections
        └── sections

Source Files
------------
All documentation for project repositories should be structured and stored
in or below `<your_project_repo>/docs/` directory as Restructured Text.
ONAP jenkins jobs that verify and merge documentation are triggered by
RST file changes in the top level docs directory and below.

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

When there are subsequent, significant contributions to a source file
from a different contributor, a new copyright line may be appended
after the last existing copyright line.
