.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _include-documentation:

============================
Including your Documentation
============================

.. contents::
   :depth: 3
   :local:

In your project repository
--------------------------

Add your documentation to your repository in the folder structure and
using templates as described above. The documentation templates 
are available in `doc/docs/templates/`, you should
copy the relevant templates to your <repo>/docs/ directory in your repository.
For instance if you want to document release-notes, then your steps shall be
as follows:

.. code-block:: bash

   git clone ssh://<your_id>@gerrit.onap.org:29418/doc
   cp -p doc/docs/templates/release-notes <your_repo>/docs/release-notes/


You should then add the relevant information to the template that will
explain the documentation. When you are done writing, you can commit
the documentation to the your project repository.

.. code-block:: bash

   git add .
   git commit --signoff --all
   git review

In the ONAP doc Repository
--------------------------

To import project documents from project repositories, we use git submodules.
Each ONAP project providing documentation, other than the doc project, is loaded under  `doc/docs/submodules/` 
when needed for validating or publishing documentation.   To describe the relationship between content files
we use the `Sphinx toctree directive`.

The following diagram illustrates:
  - all ONAP gerrit project repositories,
  - the doc project repository including a main index.rst,
  - other master document directories and/or RST files that may be created to organize sections and documents,
  - the submodules directory where other repositories and directories/files may be referenced,
  - the templates directory with one example, a release-notes template, and
  - another project repository `appc` that provides documentation source by copying and filling in an instance of the release-notes template.


.. graphviz::

   
   digraph docstructure {
   size="8,12";
   node [fontname = "helvetica"];
   // Align gerrit repos and docs directories
   {rank=same doc aaf aai appc repoelipse vnfsdk vvp}
   {rank=same releasenotestemplate localappcdocs }

   //Show submodule linkage to docs directory
   submodules -> localappcdocs [style=dotted];

   //Illustrate Gerrit Repos and provide URL/Link for complete repo list
   gerrit [label="gerrit.onap.org/r", href="https://gerrit.onap.org/r/#/admin/projects/" ];
   gerrit -> doc;
   gerrit -> aaf;
   gerrit -> aai;
   gerrit -> appc;
   gerrit -> repoelipse;                                   repoelipse [label=". . . ."];
   gerrit -> vnfsdk;
   gerrit -> vvp;

   //Show example of local appc instance release notes
   appc -> localappcdocs;                               localappcdocs [label="docs"];
   localappcdocs -> releasenotesinstance; releasenotesinstance        [label="release-notes"];
   releasenotesinstance -> relnoteindexinstance; relnoteindexinstance [label="index.rst", shape=box];
   releasenotesinstance -> relnoteotherinstance; relnoteotherinstance [label="... other sections", shape=box];

   //Show detail structure of a portion of doc/docs _images _static _templates multiple master documents omitted
   doc  -> docs;
   docs -> confpy;                                             confpy [label="conf.py",shape=box];
   docs -> toplevelindex;                               toplevelindex [label="index.rst", shape=box];
   docs -> release;
   docs -> rsttemplates;                                 rsttemplates [label="templates"];
   docs -> indexdirelipse;                             indexdirelipse [label="...other\ndocuments"];
   docs -> submodules

   //Example Release notes document
   release -> releasenotes;                              releasenotes [label="release-notes"];
   releasenotes -> lowerlevelindex;                   lowerlevelindex [label="index.rst", shape=box];

   //Example release-notes template
   rsttemplates -> releasenotestemplate;         releasenotestemplate [label="release-notes"];
   releasenotestemplate -> relnoteindex;                 relnoteindex [label="index.rst", shape=box];
   releasenotestemplate -> relnoteother;                 relnoteother [label="... other sections", shape=box];
   }

In the toctree
++++++++++++++

To include your project specific documentation in the composite documentation,
first identify where your project documentation should be included.
Say your project provides release-notes and should be referenced in the `doc/docs/release/release-notes/index.rst toctree`, then:

.. code-block:: bash

   git clone ssh://<your_id>@gerrit.onap.org:29418/doc
   vim doc/docs/release/release-notes/index.rst

This opens the text editor. Identify where you want to add your release notes.
If your release notes are to be added to the toctree, simply include the path to
it, example:


.. code-block:: bash

   .. toctree::
      :maxdepth: 1

      ../../submodules/<your_repo>/docs/release-notes/index

When finished, you can request a commit to the doc project repository.
Be sure to add the project leader of the docs project as a reviewr of the change you just pushed in gerrit.

.. code-block:: bash
   
   git add .
   git commit --signoff --all
   git review


As a Hyperlink
++++++++++++++

It's pretty common to want to reference another location in the
ONAP documentation and it's pretty easy to do with
reStructuredText. This is a quick primer, more information is in the
`Sphinx section on Cross-referencing arbitrary locations
<http://www.sphinx-doc.org/en/stable/markup/inline.html#ref-role>`_.

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


'doc8' Validation
-----------------
It is recommended that all rst content is validated by `doc8 <https://pypi.python.org/pypi/doc8>`_ standards.
To validate your rst files using doc8, install doc8.

.. code-block:: bash

   sudo pip install doc8

doc8 can now be used to check the rst files. Execute as,

.. code-block:: bash

   doc8 --ignore D000,D001 <file>


Testing: Build Documentation Locally
------------------------------------

Composite DOC documentation
+++++++++++++++++++++++++++++++++
To build the whole documentation under doc/, follow these steps:

Install virtual environment.

.. code-block:: bash

   sudo pip install virtualenv
   cd /local/repo/path/to/project

Download the DOC repository.

.. code-block:: bash

   git clone http://gerrit.onap.org/r/doc

Change directory to docs & install requirements.

.. code-block:: bash

   cd doc
   sudo pip install -r etc/requirements.txt

Update submodules, build documentation using tox & then open using any browser.

.. code-block:: bash

   cd doc
   git submodule update --init
   tox -edocs
   firefox docs/_build/html/index.html

.. note:: Make sure to run `tox -edocs` and not just `tox`.

Individual project documentation
++++++++++++++++++++++++++++++++
To test how the documentation renders in HTML, follow these steps:

Install virtual environment.

.. code-block:: bash

   sudo pip install virtualenv
   cd /local/repo/path/to/project

Download the doc repository.

.. code-block:: bash

   git clone http://gerrit.onap.org/r/doc

Change directory to doc & install requirements.

.. code-block:: bash

   cd doc
   sudo pip install -r etc/requirements.txt

Move the conf.py file to your project folder where RST files have been kept:

.. code-block:: bash

   mv doc/docs/conf.py <path-to-your-folder>/

Move the static files to your project folder:

.. code-block:: bash

   mv docs/_static/ <path-to-your-folder>/

Build the documentation from within your project folder:

.. code-block:: bash

   sphinx-build -b html <path-to-your-folder> <path-to-output-folder>

Your documentation shall be built as HTML inside the
specified output folder directory.

.. note:: Be sure to remove the `conf.py`, the static/ files and the output folder from the `<project>/docs/`. This is for testing only. Only commit the rst files and related content.


Adding your project repository as a submodule
---------------------------------------------

Clone the doc repository and add your submodule using the commands below and where $reponame is your repository name.

.. code-block:: bash

  cd docs/submodules/
  git submodule git https://gerrit.onap.org/r/$reponame
  git submodule init $reponame/
  git submodule update $reponame/
  git add .
  git review
