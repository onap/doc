.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0

Addendum
========

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

Read The Docs URLs
------------------

When referencing versions of documentation a Read The Docs the following
URL conventions should be used

 +----------------------------------+----------------------------------------+
 | URL                              | To Refer to                            |
 +==================================+========================================+
 | docs.onap.org                    | Most recent approved named release     |
 +----------------------------------+----------------------------------------+
 | docs.onap.org/en/latest          | Latest master branch all projects      |
 +----------------------------------+----------------------------------------+
 | docs.onap.org/en/*named release* | An approved name release eg. amsterdam |
 +----------------------------------+----------------------------------------+
