.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.


Setting Up
==========

ONAP documentation is stored in git repositories, changes are managed
with gerrit reviews, and published documents generated when there is a
change in any source used to build the documentation.

Authors create source for documents in reStructured Text (RST) that is
rendered to HTML and published on Readthedocs.io.
The developer Wiki or other web sites can reference these rendered
documents directly allowing projects to easily maintain current release
documentation.

Some initial set up is required to connect a project with
the master document structure and enable automated publishing of
changes as summarized in the following diagram and description below
below.

.. seqdiag::
   :height: 700
   :width: 1000

   seqdiag {
     DA [label = "Doc Project\nAuthor/Committer",   color=lightblue];
     DR [label = "Doc Gerrit Repo" ,                     color=pink];
     PR [label = "Other Project\nGerrit Repo",          color=pink ];
     PA [label = "Other Project\nAuthor/Committer", color=lightblue];

     PA  ->   DR [label = "Add project repo as\ngit submodule" ];
     DR  ->   DA [label = "Review & Plan to\nIntegrate Content with\nTocTree Structure" ];
     DR  <--  DA [label = "Vote +2/Merge" ];
     PA  <--  DR [label = "Merge Notification" ];
     PA  ->   PR [label = "Create in project repo\ntop level directory and index.rst" ];
     PR  ->   DA [label = "Add as Reviewer" ];
     PR  <--  DA [label = "Approve and Integrate" ];
     PA  <--  PR [label = "Merge" ];
     }

Setup project repositories
--------------------------
These steps are performed for each project repository that
provides documentation.

1. Set two variables that will be used in the subsequent steps.
Set *reponame* to the project repository you are setting up
just as it appears in the **Project Name** column of
the Gerrit projects page.
Set *lfid* to your Linux Foundation identity that you use to
login to gerrit or for git clone requests over ssh.

.. code-block:: bash

   reponame=
   lfid=

2. Add a directory in the doc project where your
project will be included as a submodule and at least one reference
from the doc project to the documentation index in your repository.
The following sequence will do this over ssh. Please note that the
reference to your project in *repolist.rst* should be considered
temporary and removed when you reference it from more appropriate
place.

.. caution::

   If your access network restricts ssh, you will need to use equivalent
   git commands and HTTP Passwords as described `here <http://wiki.onap.org/x/X4AP>`_.

.. caution::

   Don't replace ../ in *git submodule add* with any relative path on
   your local file system. It refers to the location of your repository
   on the server.

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
   If the project repository added as submodule changes before the
   doc project merge, git may not automatically update the submodule
   reference on changes and/or the verify job will fail in the step below.


3. Create a docs directory in your repository with
an index.rst file.  The following sequence will complete the minimum
required over ssh.  As you have time to convert or add new content you
can update the index and add files under the docs folder.

.. hint::
   If you have additional content, you can include it by editing the
   index.rst file and/or adding other files before the git commit.
   See `Templates and Examples`_ below and :ref:`converting-to-rst`
   for more information.


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

- doc project repository master document index.rst, templates,
  configuration, and other documents

- submodules directory where other project repositories and
  directories/files are referenced

- file structure: directories (ellipses), files(boxes)

- references: directory/files (solid edges), git submodule
  (dotted edges), sphinx toctree (dashed edges)

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

Branches in the DOC Project
---------------------------

The DOC project 'master' branch aggregates the 'latest' content
from all ONAP project repositories contributing documentation into a
single tree file structure as described in the previous section.  This
branch is continuously integrated and deployed at Read The
Docs as the 'latest' ONAP Documentation by:

* Jenkins doc-verify-rtd and doc-merge-rtd jobs triggered whenever patches on
  contributing repositories contain rst files at or below a top level
  'docs' folder.

* Subscription in the DOC project to changes in submodule repositories.
  These changes appear in the DOC project as commits with title
  'Updated git submodules' when a change to a contributing project
  repository is merged.  No DOC project code review occurs, only a
  submodule repository commit hash is updated to track the head of each
  contributing master branch.

For each ONAP named release the DOC project creates a branch with the
release name.  The timing of the release branch is determined by
work needed in the DOC project to prepare the release branch and the
amount of change unrelated to the release in the master branch.
For example contributing projects that create named release branches
early to begin work on the next release and/or contributing projects
to the master that are not yet part of the named release would result
in an earlier named release branch to cleanly separate work to stabilize
a release from other changes in the master branch.

A named release branch is integrated and deployed at Read The Docs
as the 'named release' by aggregating content from contributing
project repositories.  A contributing project repository can
choose one of the following for the 'named release' branch:

* Remove the contributing project repository submodule and RST
  references when not part of the named release.

* Provide a commit hash or tag for the contributing project master
  branch to be used for the life of the release branch or until a
  request is submitted to change the commit hash or tag.

* Provide the commit hash for the head of a named release branch
  created in the contributing project repository.  This option
  may be appropriate if frequent changes are expected over the
  life of the named release and work the same way as the continuous
  integration and deployment described for the master branch.

The decision on option for each contributing project repository
can be made or changed before the final release is approved.  The
amount of change and expected differences between master and a
named release branch for each repository should drive the choice of
option and timing.

About GIT branches
------------------

GIT is a powerful tool allowing many actions, but without respecting some rules
the GIT structure can be quickly hard to maintain.

Here are some conventions about GIT branches:

  - ALWAYS create a local branch to edit or create any file. This local branch
    will be considered as a topic in Gerrit and allow contributors to
    work at the same time on the same project.

  - 1 feature = 1 branch. In the case of documentation, a new chapter
    or page about a new code feature can be considered as a 'doc feature'

  - 1 bug = 1 branch. In the case of documentation, a correction on an
    existing sentence can be considered as a 'doc bug'

  - the master branch is considered as "unstable", containing new features that
    will converge to a stable situation for the release date.

The day of the release, the repository owner will create a new branch to
fix the code and documentation. This will represent the 'stable' code of the
release. In this context:

  - NEVER push a new feature on a stable branch

  - Only bug correction are authorized on a stable branch using
    cherry pick method

.. image:: git_branches.png

Creating Restructured Text
==========================

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
