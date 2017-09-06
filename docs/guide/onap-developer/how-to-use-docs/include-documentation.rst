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

First let's set two variables that will be used in the following examples.
Set reponame to the project repository you are setting up just as it appears in the
**Project Name** column of the Gerrit projects page https://gerrit.onap.org/r/#/admin/projects/.
Set lfid to your Linux Foundation identity that you use to login to gerrit or for git
clone requests over ssh.

.. code-block:: bash

   reponame=
   lfid=

The next step is to add a directory in the doc project where your project will be included as a 
submodule and at least one reference from the doc project to the documentation index in your repository.
	
.. code-block:: bash

   git clone ssh://$lfid@gerrit.onap.org:29418/doc
   cd doc
   mkdir -p `dirname docs/submodules/$reponame`
   git submodule add https://gerrit.onap.org/r/$reponame docs/submodules/$reponame.git
   git submodule init docs/submodules/$reponame.git
   git submodule update docs/submodules/$reponame.git

   echo "   $reponame <../submodules/$reponame.git/docs/index>" >> docs/release/repolist.rst
   
   git add .
   git commit -s
   git review
   


The last step is to create a docs directory in your repository with an index.rst file.

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

  - all ONAP gerrit project repositories,
  - the doc project repository master document index.rst, templates, configuration
  - the submodules directory where other project repositories and directories/files may be referenced


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

Creating Restructured Text
==========================

TODO Add simple example and references here

Links and References
====================
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



