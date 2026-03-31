.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0

.. _sphinx-toolbox-collapse-removal:

Removal of sphinx-toolbox from shared docs configuration
========================================================

``sphinx-toolbox`` has been removed from the shared ONAP documentation
configuration (``requirements-docs.txt``, ``conf.py``, and
``upper-constraints.onap.txt``).

.. contents:: Table of Contents
   :depth: 2
   :local:

Background
----------

The ``sphinx_toolbox.collapse`` extension was included in the standard
ONAP documentation template configuration. It provides the
``.. collapse::`` RST directive for collapsible content sections.

Problem
-------

``sphinx-toolbox`` 4.1.2 (the latest release as of March 2026) is
incompatible with Sphinx 9.x. The package imports ``logger`` from
``sphinx.ext.autodoc``, which was removed in Sphinx 9:

.. code-block:: text

   ImportError: cannot import name 'logger' from 'sphinx.ext.autodoc'

This breaks **all** Read the Docs builds for any repository that loads
``sphinx_toolbox.collapse``, regardless of whether the ``.. collapse::``
directive is actually used in the RST content.

The fix exists on the ``sphinx-toolbox``
`GitHub master branch <https://github.com/sphinx-toolbox/sphinx-toolbox>`_
but has not been included in a PyPI release.

Impact assessment
-----------------

An audit of all ONAP repositories found that ``sphinx_toolbox.collapse``
is loaded in ``conf.py`` by four repositories, but only two actually
use the ``.. collapse::`` directive in their RST content:

.. list-table::
   :header-rows: 1
   :widths: 30 15 15 40

   * - Repository
     - In ``conf.py``
     - Used in RST
     - Action
   * - ``doc``
     - Yes
     - **No**
     - Removed (this change)
   * - ``doc/doc-best-practice``
     - Yes
     - **No**
     - Removed
   * - ``oom``
     - Yes
     - **Yes** (16 usages)
     - Pin ``sphinx<9`` until resolved
   * - ``policy/parent``
     - Yes
     - **Yes** (1 usage)
     - Pin ``sphinx<9`` until resolved

Two additional repositories (``ccsdk/oran``, ``vnfrqts/guidelines``)
listed ``sphinx-toolbox`` in ``requirements-docs.txt`` but never loaded
it in ``conf.py``. These should remove the unused dependency.

Resolution
----------

For repositories that do **not** use ``.. collapse::`` directives
(the majority), the fix is to remove the extension:

1. Remove ``sphinx-toolbox`` from ``docs/requirements-docs.txt``
2. Remove ``'sphinx_toolbox.collapse'`` from the ``extensions`` list in
   ``docs/conf.py``

For repositories that **do** use ``.. collapse::`` directives
(currently ``oom`` and ``policy/parent``), the interim fix is to pin
Sphinx below version 9 in their ``docs/requirements-docs.txt``:

.. code-block:: text

   sphinx>=7.1.2,<9

This constraint must remain until either:

- ``sphinx-toolbox`` publishes a release compatible with Sphinx 9.x, **or**
- The ``.. collapse::`` directives are replaced with an alternative such
  as ``sphinx-design``'s
  `dropdown directive <https://sphinx-design.readthedocs.io/en/latest/dropdowns.html>`_

Migrating from collapse to sphinx-design dropdown
--------------------------------------------------

Repositories using ``.. collapse::`` can migrate to ``sphinx-design``,
which is actively maintained and compatible with Sphinx 9.x.

**Step 1** --- Replace the dependency:

.. code-block:: text

   # Remove
   sphinx-toolbox>=3.5.0

   # Add
   sphinx-design>=0.6.0

**Step 2** --- Replace the extension in ``conf.py``:

.. code-block:: python

   # Remove
   'sphinx_toolbox.collapse'

   # Add
   'sphinx_design'

**Step 3** --- Update RST directives:

.. code-block:: rst

   .. Before (sphinx-toolbox):
   .. collapse:: Title

      Content here

   .. After (sphinx-design):
   .. dropdown:: Title

      Content here

The ``.. dropdown::`` directive supports additional options such as
``:open:``, ``:color:``, and ``:icon:`` for enhanced styling.

Further reading
---------------

- `sphinx-toolbox on GitHub
  <https://github.com/sphinx-toolbox/sphinx-toolbox>`_
  (see ``utils.py`` for the Sphinx 9 compatibility fix on master)
- `sphinx-design documentation
  <https://sphinx-design.readthedocs.io/>`_
- `Read the Docs ubuntu-20.04 deprecation
  <https://about.readthedocs.com/blog/2026/03/ubuntu-20-04-deprecated/>`_
