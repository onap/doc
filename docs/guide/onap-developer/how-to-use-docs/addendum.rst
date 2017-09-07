.. This work is licensed under a Creative Commons Attribution 4.0 International License.

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
Each file would be build as an html page.

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

.. index:: single: indices

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
please see the `official Sphinx documentation <http://www.sphinx-doc.org/en/stable/markup/misc.html#directive-index>`_.

Jenkins Jobs
------------

Verify Job
++++++++++

The verify job name is **doc-{stream}-verify-rtd**

Proposed changes in doc or any other repository that has been added as a
git submodule will be verified by this job prior to a gerrit code review.
Please check the Jenkins log carefully for warnings.
You can improve your document even if the verify job succeeded.

Merge Job
+++++++++

The merge job name is **doc-{stream}-merge-rtd**.

When a committer merges a patch, Jenkins will automatically trigger building of
the new documentation. This might take about 15 minutes while readthedocs
builds the documentation. The newly built documentation shall show up
as appropriate placed in docs.onap.org/{branch}/path-to-file.
