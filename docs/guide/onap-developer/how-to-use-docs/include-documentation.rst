.. This work is licensed under a Creative Commons Attribution 4.0 International License.


Setting Up
==========
Some initial steps are required to connect a project with
the master document structure and enable automated publishing of
changes as summarized in the following diagram and described detail 
below.

.. seqdiag::

   seqdiag {
     RD [label = "Read The Docs",                color =lightgreen ];
     DA [label = "Doc Project\nAuthor/Committer",   color=lightblue];
     DR [label = "Doc Gerrit Repo" ,                     color=pink];
     PR [label = "Other Project\nGerrit Repo",          color=pink ];
     PA [label = "Other Project\nAuthor/Committer", color=lightblue];
     
     === One time setup doc project only ===
     RD  ->   DA [label = "Account Setup" ]; 
     DA  ->   DR [label = "Create initial\nrepository content"];
     DA  <<-- DR [label = "Merged" ];
     RD  <--  DA [label = "Connect gerrit.onap.org" ];
     === For each project & repository containing document source ===
     DA  ->   PR [label = "Other Project Contribution to Setup\ndocs directory, index, other initial content" ];
     PR  <--  PA [label = "Review/Merge Change" ];
     DA  <--  PR [label = "Change Merged" ];     
     DA  ->   DR [label = "Add Other Project Repo as\nGit submodule in doc project" ];
     DA  <--  DR [label = "Change Merged" ];
     }
     
     

Setup doc project
-----------------
These steps are performed only once for the doc project and include:

(1) creating in the doc repository an initial:
	- sphinx master document index
	- directory structure aligned with the document structure
	- set of test performed in jenkins verify jobs
	- configuration for sphinx plugins and redendering of content
  
(2) establishing an account at readthedocs connected with gerrit.onap.org


Setup other project(s)
----------------------
These steps are performed for each new project repo (referred to in the
next three code blocks as $newreponame) the master document
in doc repository references and include:

(1) clone, modify, and commit to the other project an initial: docs top
level directory; index.rst; any other intial content.   

.. code-block:: bash

   git clone ssh://<your_id>@gerrit.onap.org:29418/$newreponame
   cd $newreponame
   mkdir docs
   echo ".. This work is licensed under a Creative Commons Attribution 4.0 International License.

   $newreponame
   ============

   .. toctree::
      :maxdepth: 1
      
   " >  docs/index.rst
   
   git add .
   git commit -m "Add RST docs directory and index" -s
   git commit --amend
   # modify the commit message to comply with ONAP best practices
   git review
   
When the above commit is reviewed and merged complete step 2 before any
new changes are merged into $newreponame.
	
(2) clone, modify, and commit to the doc project: a directory under doc/docs/submodules with the same path/name as the other project and initialized as a git submodule.
	
.. code-block:: bash

   git clone ssh://<your_id>@gerrit.onap.org:29418/doc
   # For top level repositories use the following
   mkdir doc/docs/submodules/$reponame
   # For lower level repositories you may need to make a directory for each node in path
   
   echo "../submodules/$newreponame/index.rst" >> docs/release/index.rst
   cd doc/docs/submodules/$reponame
   
   git submodule git https://gerrit.onap.org/r/$reponame
   git submodule init $reponame/
   git submodule update $reponame/
   
   
   git add .
   git commit -m "Add $newreponame as asubmodule" -s
   git commit --amend
   # modify the commit message to comply with ONAP best practices
   git review
   


The diagram below illustrates what is accomplished in the setup steps
above from the perspective of a file structure created for local test,
jenkins verify job, and/or merge/publish documentation including:

  - all ONAP gerrit project repositories,
  - the doc project repository including a master document index.rst, templates, configuration
  - the submodules directory where other project repositories and directories/files may be referenced
  - newreponame project repository being added and integrated.


.. graphviz::

   
   digraph docstructure {
   size="8,12";
   node [fontname = "helvetica"];
   // Align gerrit repos and docs directories
   {rank=same doc aaf aai newreponame repoelipse vnfsdk vvp}
   {rank=same confpy release templates masterindex submodules otherdocdocumentelipse}


   //Illustrate Gerrit Repos and provide URL/Link for complete repo list
   gerrit [label="gerrit.onap.org/r", href="https://gerrit.onap.org/r/#/admin/projects/" ];
   gerrit -> doc;
   gerrit -> aaf;
   gerrit -> aai;
   gerrit -> newreponame; 
   gerrit -> repoelipse;
             repoelipse [label=". . . ."];
   gerrit -> vnfsdk;
   gerrit -> vvp;

   //Show example of local newreponame instance of component info
   newreponame -> newreponamedocsdir;
   newreponamesm -> newreponamedocsdir;  
                    newreponamedocsdir [label="docs"];
   newreponamedocsdir -> newrepodocsdirindex; 
                         newrepodocsdirindex [label="index.rst", shape=box];

   //Show detail structure of a portion of doc/docs 
   doc  -> docs;
   docs -> confpy;                   
           confpy [label="conf.py",shape=box];
   docs -> masterindex; 
           masterindex [label="Master index.rst", shape=box];
   docs -> release;
   docs -> templates;                                
   docs -> otherdocdocumentelipse;  
           otherdocdocumentelipse [label="...other\ndocuments"];
   docs -> submodules
   
   masterindex -> releasedocumentindex [style=dashed, label="sphinx\ntoctree\nreference"];
   
   //Show submodule linkage to docs directory
   submodules -> newreponamesm [style=dotted,label="git\nsubmodule\nreference"];  
                 newreponamesm [label="newreponame"];

   //Example Release document index that references component info provided in other project repo
   release -> releasedocumentindex;   
              releasedocumentindex [label="index.rst", shape=box];
   releasedocumentindex -> newrepodocsdirindex [style=dashed, label="sphinx\ntoctree\nreference"];
 
   }

THE FOLLOWING SECTION NEEDS TO BE CONSOLIDATED / UPDATED


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


