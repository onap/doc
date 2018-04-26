.. This work is licensed under a Creative Commons Attribution 4.0 International License.


Setting Up
==========

Some initial set up is required to connect a project with
the master document structure and enable automated publishing of
changes as summarized in the following diagram and description below
below.

.. seqdiag::
   :height: 700
   :width: 1000

   seqdiag {
     RD [label = "Read The Docs",                color =lightgreen ];
     DA [label = "Doc Project\nAuthor/Committer",   color=lightblue];
     DR [label = "Doc Gerrit Repo" ,                     color=pink];
     PR [label = "Other Project\nGerrit Repo",          color=pink ];
     PA [label = "Other Project\nAuthor/Committer", color=lightblue];

     === One time setup doc project only ===
     RD  ->   DA [label = "Acquire Account" ];
     DA  ->   DR [label = "Create initial\n doc repository content"];
     DA  <<-- DR [label = "Merge" ];
     RD  <--  DA [label = "Connect gerrit.onap.org" ];
     === For each project repository containing document source ===
     PA  ->   DR [label = "Add project repo as\ngit submodule" ];
     DR  ->   DA [label = "Review & Plan to\nIntegrate Content with\nTocTree Structure" ];
     DR  <--  DA [label = "Vote +2/Merge" ];
     PA  <--  DR [label = "Merge Notification" ];
     PA  ->   PR [label = "Create in project repo\ntop level directory and index.rst" ];
     PR  ->   DA [label = "Add as Reviewer" ];
     PR  <--  DA [label = "Approve and Integrate" ];
     PA  <--  PR [label = "Merge" ];
     }



Setup doc project
-----------------
These steps are performed only once for the doc project and include:

(1) creating in the doc repository an initial:

  - sphinx master document index

  - a directory structure aligned with the document structure

  - tests performed in jenkins verify jobs

  - sphinx configuration

(2) establishing an account at readthedocs connected with the doc
doc project repo in gerrit.onap.org.


Setup project repositories(s)
-----------------------------
These steps are performed for each project repository that provides documentation.

First let's set two variables that will be used in the subsequent steps.
Set reponame to the project repository you are setting up just as it appears in the
**Project Name** column of the Gerrit projects page.
Set lfid to your Linux Foundation identity that you use to login to gerrit or for git
clone requests over ssh.

.. code-block:: bash

   reponame=
   lfid=

The next step is to add a directory in the doc project where your project will be included as a
submodule and at least one reference from the doc project to the documentation index in your repository.
The following sequence will do this over ssh.

.. caution::

   If your access network restricts ssh, you will need to use equivalent git commands and
   HTTP Passwords as described `here <http://wiki.onap.org/x/X4AP>`_.

.. code-block:: bash

   git clone ssh://$lfid@gerrit.onap.org:29418/doc
   cd doc
   mkdir -p `dirname docs/submodules/$reponame`
   git submodule add ../$reponame docs/submodules/$reponame.git
   git submodule init docs/submodules/$reponame.git
   git submodule update docs/submodules/$reponame.git

   echo "   $reponame <../submodules/$reponame.git/docs/index>" >> docs/release/repolist.rst

   git add .
   git commit -s
   git review

.. caution::
   Wait for the above change to be merged before any merge to the
   project repository that you have just added as a submodule.
   If the project repository added as submodule changes before the doc project merge, git may not
   automatically update the submodule reference on changes and/or the verify job will
   fail in the step below.


The last step is to create a docs directory in your repository with an index.rst file.
The following sequence will complete the minimum required over ssh.  As you have time
to convert or add new content you can update the index and add files under the docs folder.

.. hint::
   If you have additional content, you can include it by editing the
   index.rst file and/or adding other files before the git commit.
   See `Templates and Examples`_ below and :ref:`converting-to-rst` for more information.


.. code-block:: bash

   git clone ssh://$lfid@gerrit.onap.org:29418/$reponame
   cd $reponame
   mkdir docs
   echo ".. This work is licensed under a Creative Commons Attribution 4.0 International License.

   TODO Add files to toctree and delete this header
   ------------------------------------------------
   .. toctree::
      :maxdepth: 1

   " >  docs/index.rst

   git add .
   git commit -s
   git review


The diagram below illustrates what is accomplished in the setup steps
above from the perspective of a file structure created for a local test,
a jenkins verify job, and/or published release documentation including:

- ONAP gerrit project repositories,
- doc project repository master document index.rst, templates, configuration, and other documents
- submodules directory where other project repositories and directories/files are referenced
- file structure: directories (ellipses), files(boxes)
- references: directory/files (solid edges), git submodule (dotted edges), sphinx toctree (dashed edges)


.. graphviz::


   digraph docstructure {
   size="8,12";
   node [fontname = "helvetica"];
   // Align gerrit repos and docs directories
   {rank=same doc aaf aai reponame repoelipse vnfsdk vvp}
   {rank=same confpy release templates masterindex submodules otherdocdocumentelipse}
   {rank=same releasedocumentindex releaserepolist}

   //Illustrate Gerrit Repos and provide URL/Link for complete repo list
   gerrit [label="gerrit.onap.org/r", href="https://gerrit.onap.org/r/#/admin/projects/" ];
   doc [href="https://gerrit.onap.org/r/gitweb?p=doc.git;a=tree"];
   gerrit -> doc;
   gerrit -> aaf;
   gerrit -> aai;
   gerrit -> reponame;
   gerrit -> repoelipse;
             repoelipse [label=". . . ."];
   gerrit -> vnfsdk;
   gerrit -> vvp;

   //Show example of local reponame instance of component info
   reponame -> reponamedocsdir;
   reponamesm -> reponamedocsdir;
                    reponamedocsdir [label="docs"];
   reponamedocsdir -> repnamedocsdirindex;
                         repnamedocsdirindex [label="index.rst", shape=box];

   //Show detail structure of a portion of doc/docs
   doc  -> docs;
   docs -> confpy;
           confpy [label="conf.py",shape=box];
   docs -> masterindex;
           masterindex [label="Master\nindex.rst", shape=box];
   docs -> release;
   docs -> templates;
   docs -> otherdocdocumentelipse;
           otherdocdocumentelipse [label="...other\ndocuments"];
   docs -> submodules

   masterindex -> releasedocumentindex [style=dashed, label="sphinx\ntoctree\nreference"];

   //Show submodule linkage to docs directory
   submodules -> reponamesm [style=dotted,label="git\nsubmodule\nreference"];
                 reponamesm [label="reponame.git"];

   //Example Release document index that references component info provided in other project repo
   release -> releasedocumentindex;
              releasedocumentindex [label="index.rst", shape=box];
   releasedocumentindex -> releaserepolist [style=dashed, label="sphinx\ntoctree\nreference"];
        releaserepolist  [label="repolist.rst", shape=box];
   release -> releaserepolist;
   releaserepolist -> repnamedocsdirindex [style=dashed, label="sphinx\ntoctree\nreference"];

   }

About GIT branches
------------------

GIT is a powerful tool allowing many actions, but without respecting some rules
the GIT structure can be quickly ugly and unmaintainble.

Here are some conventions about GIT branches:
  - ALWAYS create a local branch to edit or create any file. This local branch
    will be considered as a topic in Gerrit and allow contributors to work at the
    same time on the same project.
  - 1 feature = 1 branch. In the case of documentation, a new chapter or page about
    a new code feature can be considered as a 'doc feature'
  - 1 bug = 1 branch. In the case of documentation, a correction on an existing
    sentence can be considered as a 'doc bug'
  - the master branch is considered as "unstable", containing new features that
    will converge to a stable situation for the release date.

The day of the release, the repository owner will create a new branch to
fix the code and documentation. This will represent the 'stable' code of the
release. In this context:

  - NEVER push a new feature on a stable branch

  - Only bug correction are authorized on a stable branch using cherry pick method

.. image:: git_branches.png

Creating Restructured Text
==========================

Templates and Examples
----------------------
Templates are available that capture the kinds of information
useful for different types of projects and provide some examples of
restructured text.  We organize templates in the following way to: help authors
understand relationships between documents; keep the user audience context in mind when writing;
and tailor sections for different kinds of projects.

**Sections** Represent a certain type of content.   A section is **provided** in a repository, to
to describe something about the characteristics, use, capability, etc. of things in that repository.
A section may also be **referenced** from other sections and in other repositories.
The notes in the beginning of each section template provide
additional detail about what is typically covered and where there may be references to the section.

**Collections** Are a set of sections that are typically provided for a particular type
of project, repository, guide, reference manual, etc.

You can: browse the template *collections* and *sections* below; show source to look at the Restructured
Text and Sphinx directives used; copy the source either from a browser window
or by downloading the file in raw form from
the `gerrit doc repository <https://gerrit.onap.org/r/gitweb?p=doc.git;a=tree;f=docs/templates;/>`_ and
then add them to your repository docs folder and index.rst.


Sections
++++++++

.. toctree::
   :maxdepth: 1
   :glob:

   ../../../templates/sections/*


Collections
+++++++++++

.. toctree::
   :maxdepth: 1
   :glob:

   ../../../templates/collections/*



In addition to these simple templates and examples
there are many open source projects (e.g. Open Daylight, Open Stack)
that are using Sphinx and Readthedocs where you may find examples to start with.
Working with project teams we will continue to enhance templates here and
capture frequently asked questions on the developer wiki question
topic `documentation <https://wiki.onap.org/questions/topics/16384055/documentation>`_.

Each project should: decide what is relevant content; determine the
best way to create/maintain it in a CI/CD process; and work with the
documentation team to reference content from the master index and guides.
Consider options including filling in a template,
identifying existing content that can be used as is or
easily converted, and use of Sphinx directives/extensions to automatically
generate restructured text from other source you already have.

Links and References
--------------------
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

.. _building-all-documentation:

All Documentation
-----------------
To build the whole documentation under doc/, follow these steps:

Install virtual environment.

.. code-block:: bash

   sudo pip install virtualenv
   cd /local/repo/path/to/project

Download the DOC repository.

.. code-block:: bash

   git clone http://gerrit.onap.org/r/doc

Build documentation using tox local environment & then open using any browser.

.. code-block:: bash

   cd doc
   tox -elocal
   firefox docs/_build/html/index.html

.. note:: Make sure to run `tox -elocal` and not just `tox`.

There are additional tox enviornment options for checking External URLs and Spelling.
Use the tox environment options below and then look at the output with the Linux `more` or
similar command for scanning for output that applies to the files you
are validating.

.. code-block:: bash

   tox -elinkcheck
   more <  docs/_build/linkcheck/output.txt

   tox -espellcheck
   more <  docs/_build/spellcheck/output.txt

