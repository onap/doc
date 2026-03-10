.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0

.. _needs-sphinxcontrib-to-sphinx-needs:

Migrating from sphinxcontrib-needs to sphinx-needs
===================================================

This guide documents the migration from the abandoned
``sphinxcontrib-needs`` package to its maintained successor
``sphinx-needs``, and provides instructions for repositories that use
Sphinx-Needs directives (``.. req::``, ``.. spec::``, ``.. need::``,
etc.) for requirements tracking.

.. contents:: Table of Contents
   :depth: 2
   :local:

Background
----------

ONAP uses `Sphinx-Needs <https://sphinx-needs.readthedocs.io/>`_ to
manage and cross-reference VNF/PNF requirements across documentation.
The original package was published as **sphinxcontrib-needs** on PyPI;
its maintained successor is **sphinx-needs** (same maintainers at
`useblocks <https://useblocks.com/>`_, different package name).

Problem statement
-----------------

``sphinxcontrib-needs`` 0.7.9 (the final release) has two
incompatibilities that prevent it from working in modern Python
environments:

1. **pkg_resources removal** --- ``sphinxcontrib-needs`` imports
   ``pkg_resources`` (in ``sphinxcontrib/needs/logging.py``), which was
   `removed from setuptools 82.0
   <https://setuptools.pypa.io/en/latest/history.html#v82-0-0>`_.
   Read the Docs runs ``pip install --upgrade setuptools`` before
   processing ``requirements-docs.txt``, installing setuptools 82+
   and triggering:

   .. code-block:: text

      ModuleNotFoundError: No module named 'pkg_resources'

2. **Sphinx 8.2+ incompatibility** --- ``sphinxcontrib-needs`` imports
   ``sphinx.util.status_iterator`` (in
   ``sphinxcontrib/needs/environment.py``), which was moved to
   ``sphinx.util.display`` in Sphinx 7.x and removed from
   ``sphinx.util`` entirely in Sphinx 8.2.  This triggers:

   .. code-block:: text

      ImportError: cannot import name 'status_iterator' from 'sphinx.util'

These failures affect **Read the Docs builds** specifically because RTD
upgrades both ``setuptools`` and ``sphinx`` to the latest available
versions before processing ``requirements-docs.txt``.  The ONAP
upper-constraints file (used by ``tox.ini``) pins ``setuptools==69.0.3``
which still includes ``pkg_resources``, so **GHA CI tox builds are not
affected** --- only RTD.

Why not just pin upper bounds?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Pinning ``setuptools<81`` and ``sphinx<8.2`` in ``requirements-docs.txt``
works as a short-term workaround, but is fragile:

- Each new setuptools or Sphinx release risks introducing another
  incompatibility in the abandoned ``sphinxcontrib-needs`` codebase.
- Upper-bound pins require ongoing maintenance and create confusion
  when the same file is used by both tox (with constraints) and RTD
  (without constraints).

The permanent fix is to migrate to ``sphinx-needs``.

Solution: migrate to sphinx-needs
----------------------------------

``sphinx-needs`` is the direct successor to ``sphinxcontrib-needs``,
maintained by the same team.  It is compatible with:

- Python 3.9 -- 3.13+
- Sphinx 7.x -- 9.x
- setuptools 82+ (no ``pkg_resources`` dependency)

The migration is a drop-in replacement at the configuration level:

- All RST directives (``.. req::``, ``.. spec::``, ``.. need::``,
  ``.. needtable::``, etc.) work unchanged.
- All ``conf.py`` settings (``needs_extra_options``, ``needs_id_regex``,
  ``needs_id_required``, ``needs_title_optional``) are backward
  compatible.

.. note::

   ``needs_extra_options`` is deprecated in ``sphinx-needs`` 7.x in
   favour of ``needs_fields``.  The old setting still works but will
   emit a deprecation warning.  Repositories should plan to update
   their ``conf.py`` to use ``needs_fields`` in a future change.

Migration steps
---------------

Step 1 --- Update docs/requirements-docs.txt
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Replace the package name.  Remove any ``setuptools`` or ``sphinx`` upper
bounds that were added solely to work around ``sphinxcontrib-needs``
incompatibilities:

**Before:**

.. code-block:: text

   setuptools>=65.0.0,<81  # pkg_resources required by sphinxcontrib-needs
   sphinx>=7.1.2,<9  # sphinxcontrib-needs 0.7.9 compatibility
   sphinxcontrib-needs

**After:**

.. code-block:: text

   setuptools>=65.0.0
   sphinx>=7.1.2
   sphinx-needs>=4.0.0

Step 2 --- Update docs/conf.py
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Change the extension name in the ``extensions`` list:

**Before:**

.. code-block:: python

   extensions = [
       # ...
       "sphinxcontrib.needs",
       # ...
   ]

**After:**

.. code-block:: python

   extensions = [
       # ...
       "sphinx_needs",
       # ...
   ]

.. important::

   Note the underscore: the module is ``sphinx_needs`` (not
   ``sphinxcontrib.needs`` and not ``sphinx-needs``).

Step 3 --- Update etc/upper-constraints.onap.txt (if applicable)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the repository has a local constraints file, replace the pin:

**Before:**

.. code-block:: text

   sphinxcontrib-needs==0.7.9

**After:**

.. code-block:: text

   sphinx-needs==7.0.0

The central ONAP constraints file (``doc/etc/upper-constraints.onap.txt``)
has been updated to include ``sphinx-needs==7.0.0``.

Step 4 --- Verify the build
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Run the documentation build locally to confirm everything works:

.. code-block:: bash

   cd docs/
   tox -e docs

All existing ``.. req::``, ``.. spec::``, and ``.. need::`` directives
should render correctly without any changes to the RST source files.

.. tip::

   To simulate the Read the Docs environment (which does not use the
   ONAP upper-constraints file), test with an unconstrained install:

   .. code-block:: bash

      python3 -m venv .venv-rtd-test
      .venv-rtd-test/bin/pip install --upgrade pip setuptools
      .venv-rtd-test/bin/pip install -r requirements-docs.txt
      .venv-rtd-test/bin/sphinx-build -q -b html -n -d /tmp/doctrees . /tmp/_build/html

Changes to the doc repository
-----------------------------

The central ``doc`` repository has been updated as part of this
migration:

etc/upper-constraints.onap.txt
   Added ``sphinx-needs==7.0.0`` pin.

This guide
   Added to ``docs/guides/onap-documentation/`` to document the
   migration procedure.

Affected repositories
---------------------

The following ONAP repository uses ``sphinxcontrib-needs`` directives
and requires this migration:

.. list-table::
   :header-rows: 1
   :widths: 30 20 50

   * - Repository
     - Gerrit Change
     - Status
   * - ``vnfrqts/requirements``
     - `143564 <https://gerrit.onap.org/r/c/vnfrqts/requirements/+/143564>`_
     - Migration to ``sphinx-needs``

.. note::

   ``vnfrqts/requirements`` is currently the only ONAP repository that
   uses Sphinx-Needs directives.  If other repositories adopt
   requirements tracking in the future, they should use ``sphinx-needs``
   (not ``sphinxcontrib-needs``).

Relationship to the blockdiag migration
---------------------------------------

This migration is related to, but separate from, the
:ref:`blockdiag/seqdiag to Mermaid migration
<diagrams-blockdiag-to-mermaid>`.  Both address the same root cause ---
abandoned Sphinx extensions with ``pkg_resources`` dependencies that
break on modern setuptools --- but affect different packages:

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - Abandoned Package
     - Replacement
     - Guide
   * - ``sphinxcontrib-blockdiag``
     - ``sphinxcontrib-mermaid``
     - :ref:`diagrams-blockdiag-to-mermaid`
   * - ``sphinxcontrib-seqdiag``
     - ``sphinxcontrib-mermaid``
     - :ref:`diagrams-blockdiag-to-mermaid`
   * - ``sphinxcontrib-needs``
     - ``sphinx-needs``
     - :ref:`needs-sphinxcontrib-to-sphinx-needs` (this guide)

Further reading
---------------

- `sphinx-needs documentation <https://sphinx-needs.readthedocs.io/>`_
- `sphinx-needs on PyPI <https://pypi.org/project/sphinx-needs/>`_
- `sphinx-needs on GitHub <https://github.com/useblocks/sphinx-needs>`_
- `sphinxcontrib-needs (archived)
  <https://pypi.org/project/sphinxcontrib-needs/>`_
- `setuptools 82.0.0 changelog
  <https://setuptools.pypa.io/en/latest/history.html#v82-0-0>`_
  (pkg_resources removal)
