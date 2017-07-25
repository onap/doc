.. This work is licensed under a Creative Commons Attribution 4.0 International License.

Addendum
========

Index File
==========

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
============

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
====================

See http://sphinx-doc.org/rest.html .

**Hint:**
You can add html content that only appears in html output by using the 
'only' directive with build type
('html' and 'singlehtml') for an ONAP document. But, this is not encouraged.

.. code-block:: bash

    .. only:: html
        This line will be shown only in html version.

Verify Job
----------

The verify job name is **docs-verify-rtd-{branch}**.

When you send document changes to gerrit, jenkins will create your documents
in HTML formats (normal and single-page) to verify that new document can be
built successfully. Please check the jenkins log and artifact carefully.
You can improve your document even if the build job succeeded.

Merge Job
----------

The merge job name is **docs-merge-rtd-{branch}**.

Once the patch is merged, jenkins will automatically trigger building of
the new documentation. This might take about 15 minutes while readthedocs
builds the documentatation. The newly built documentation shall show up
as appropriate placed in docs.onap.org/{branch}/path-to-file.
