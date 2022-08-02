.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.
.. Copyright 2022 ONAP

.. _creating-rst:

Creating ReStructuredText
=========================

ReStructuredText markup conventions
-----------------------------------
For detailed information on ReStructuredText and how to best use the format,
see:

- `ReStructured Text Primer <http://docutils.sourceforge.net/docs/user/rst/quickstart.html>`_
- `ReStructured Text Quick Reference <http://docutils.sourceforge.net/docs/user/rst/quickref.html>`_


Templates and Examples
----------------------
Templates are available that capture the kinds of information
useful for different types of projects and provide some examples of
restructured text.  We organize templates in the following way to:

 - help authors understand relationships between documents

 - keep the user audience context in mind when writing and

 - tailor sections for different kinds of projects.


**Sections** Represent a certain type of content. A section
is **provided** in an project repository, to describe something about
the characteristics, use, capability, etc. of things in that repository.
A section may also be **referenced** from other sections and in
other repositories.  For example, an API specification provided in a project
repository might be referenced to in a Platform API Reference Guide.
The notes in the beginning of each section template provide
additional detail about what is typically covered and where
there may be references to the section.

**Collections** Are a set of sections that are typically provided
for a particular type of project, repository, guide, reference manual, etc.
For example, a collection for a platform component, an SDK, etc.

You can: browse the template *collections* and *sections* below;
show source to look at the Restructured Text and Sphinx directives used.

Sections
++++++++

Section examples are available here: :ref:`Templates<templates>`

Collections
+++++++++++

In addition to these simple templates and examples
there are many open source projects (e.g. Open Daylight, Open Stack)
that are using Sphinx and Readthedocs where you may find examples
to start with.  Working with project teams we will continue to enhance
templates here and capture frequently asked questions on the developer
wiki question topic `documentation <https://wiki.onap.org/questions/topics/16384055/documentation>`_.

Each project should:

 - decide what is relevant content

 - determine the best way to create/maintain it in the CI/CD process and

 - work with the documentation team to reference content from the
   master index and guides.

Consider options including filling in a template, identifying existing
content that can be used as is or easily converted, and use of Sphinx
directives/extensions to automatically generate restructured text
from other source you already have.

Collection examples are available here: :ref:`Templates<templates>`

Links and References
--------------------
It's pretty common to want to reference another location in the
ONAP documentation and it's pretty easy to do with
reStructuredText. This is a quick primer, more information is in the
`Sphinx section on Cross-referencing arbitrary locations
<http://www.sphinx-doc.org/en/stable/markup/inline.html>`_.

Within a single document, you can reference another section simply by::

   This is a reference to `The title of a section`_

Assuming that somewhere else in the same file there a is a section
title something like::

   The title of a section
   ^^^^^^^^^^^^^^^^^^^^^^

It's typically better to use ``:ref:`` syntax and labels to provide
links as they work across files and are resilient to sections being
renamed. First, you need to create a label something like::

   .. _a-label:

   The title of a section
   ^^^^^^^^^^^^^^^^^^^^^^

.. note:: The underscore (_) before the label is required.

Then you can reference the section anywhere by simply doing::

    This is a reference to :ref:`a-label`

or::

    This is a reference to :ref:`a section I really liked <a-label>`

.. note:: When using ``:ref:``-style links, you don't need a trailing
          underscore (_).

Because the labels have to be unique, it usually makes sense to prefix
the labels with the project name to help share the label space, e.g.,
``sfc-user-guide`` instead of just ``user-guide``.

Index File
----------

The index file must relatively reference your other rst files in that directory.

Here is an example index.rst :

.. code-block:: bash

    *******************
    Documentation Title
    *******************

    .. toctree::
       :numbered:
       :maxdepth: 2

       documentation-example

Source Files
------------

Document source files have to be written in reStructuredText format (rst).
Each file would be built as an html page.

Here is an example source rst file :

.. code-block:: bash

    =============
    Chapter Title
    =============

    Section Title
    =============

    Subsection Title
    ----------------

    Hello!

Writing RST Markdown
--------------------

See http://sphinx-doc.org/rest.html .

**Hint:**
You can add html content that only appears in html output by using the
'only' directive with build type
('html' and 'singlehtml') for an ONAP document. But, this is not encouraged.

.. code-block:: bash

    .. only:: html
        This line will be shown only in html version.


Creating Indices
----------------

Building an index for your Sphinx project is relatively simple. First, tell Sphinx that
you want it to build an index by adding something like this after your TOC tree:

.. code-block:: rst

    Indices and Search
    ==================

    * :ref:`genindex`
    * :ref:`search`

**Hint:**
Note that search was included here. It works out of the box with any Sphinx project, so you
don't need to do anything except include a reference to it in your :code:`index.rst` file.

Now, to generate a index entry in your RST, do one of the following:

.. code-block:: rst

   Some content that requires an :index:`index`.

or

.. code-block:: rst

    .. index::
        single: myterm

    Some header containing myterm
    =============================

In the second case, Sphinx will create a link in the index to the paragraph that follows
the index entry declaration.

When your project is built, Sphinx will generate an index page populated with the entries
you created in the source RST.

These are simple cases with simple options. For more information about indexing with Sphinx,
please see the `official Sphinx documentation <http://www.sphinx-doc.org/en/stable/markup/misc.html>`_.


Jenkins Jobs
------------

Verify Job
++++++++++

The verify job name is **doc-{stream}-verify-rtd**

Proposed changes in files in any repository with top level docs folder
in the repository and RST files in below this folder
will be verified by this job as part of a gerrit code review.

.. Important::
   The contributing author and every reviewer on a gerrit code review
   should always review the Jenkins log before approving and merging a
   change.  The log review should include:

   * Using a browser or other editor to search for a pattern in the
     *console log* that matches files in the patch set.  This will quickly
     identify errors and warnings that are related to the patch set and
     repository being changed.

   * Using a browser to click on the *html* folder included in the log
     and preview how the proposed changes will look when published at
     Read The Docs. Small changes can be easily made in the patch set.

Merge Job
+++++++++

The merge job name is **doc-{stream}-merge-rtd**.

When a committer merges a patch that includes files matching the
path described above, the doc project merge job will trigger an
update at readthedocs.  There may be some delay after the merge job
completes until new version appears at Read The Docs.

Testing
=======

One RST File
------------
It is recommended that all rst content is validated by `doc8 <https://pypi.python.org/pypi/doc8>`_ standards.
To validate your rst files using doc8, install doc8.

.. code-block:: bash

   sudo pip install doc8

doc8 can now be used to check the rst files. Execute as,

.. code-block:: bash

   doc8 --ignore D000,D001 <file>



One Project
-----------
To test how the documentation renders in HTML, follow these steps:

Install `virtual environment <https://pypi.org/project/virtualenv>`_ & create one.

.. code-block:: bash

   sudo pip install virtualenv
   virtualenv onap_docs

Activate `onap_docs` virtual environment.

.. code-block:: bash

   source onap_docs/bin/activate

.. note:: Virtual environment activation has to be performed before attempting to build documentation.
          Otherwise, tools necessary for the process might not be available.

Download a project repository.

.. code-block:: bash

   git clone http://gerrit.onap.org/r/<project>

Download the doc repository.

.. code-block:: bash

   git clone http://gerrit.onap.org/r/doc

Change directory to doc & install requirements.

.. code-block:: bash

   cd doc
   pip install -r etc/requirements.txt

.. warning::

	Just follow the next step (copying conf.py from Doc project to your project)
	if that is your intention, otherwise skip it. Currently all projects should already have a conf.py file.
	Through the next step, this file and potential extensions in your project get overriden.

Copy the conf.py file to your project folder where RST files have been kept:

.. code-block:: bash

   cp docs/conf.py <path-to-project-folder>/<folder where are rst files>

Copy the static files to the project folder where RST files have been kept:

.. code-block:: bash

   cp -r docs/_static/ <path-to-project-folder>/<folder where are rst files>

Build the documentation from within your project folder:

.. code-block:: bash

   sphinx-build -b html <path-to-project-folder>/<folder where are rst files> <path-to-output-folder>

Your documentation shall be built as HTML inside the
specified output folder directory.

You can use your Web Browser to open
and check resulting html pages in the output folder.

.. note:: Be sure to remove the `conf.py`, the static/ files and the output folder from the `<project>/docs/`. This is for testing only. Only commit the rst files and related content.

.. _building-all-documentation:

All Documentation
-----------------
To build the all documentation under doc/, follow these steps:

Install `tox <https://pypi.org/project/tox>`_.

.. code-block:: bash

   sudo pip install tox

Download the DOC repository.

.. code-block:: bash

   git clone http://gerrit.onap.org/r/doc

Build documentation using tox local environment & then open using any browser.

.. code-block:: bash

   cd doc
   tox -elocal
   firefox docs/_build/html/index.html

.. note:: Make sure to run `tox -elocal` and not just `tox`.
   This updates all submodule repositories that are integrated
   by the doc project.

There are additional tox environment options for checking External
URLs and Spelling. Use the tox environment options below and then
look at the output with the Linux `more` or similar command
scan for output that applies to the files you are validating.

.. code-block:: bash

   tox -elinkcheck
   more <  docs/_build/linkcheck/output.txt

   tox -espellcheck
   more <  docs/_build/spellcheck/output.txt