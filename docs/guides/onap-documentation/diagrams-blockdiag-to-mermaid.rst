.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2026 The Linux Foundation

.. _diagrams-blockdiag-to-mermaid:

Migrating from blockdiag/seqdiag to Mermaid
============================================

This guide explains why the ONAP documentation project is replacing
``sphinxcontrib-blockdiag`` and ``sphinxcontrib-seqdiag`` with
``sphinxcontrib-mermaid``, and provides instructions for migrating
existing diagrams.

.. contents:: Table of Contents
   :depth: 3
   :local:

Background
----------

The ONAP documentation toolchain has historically used two Sphinx extensions
from the `blockdiag <https://github.com/blockdiag>`_ family for embedding
diagrams in reStructuredText:

- **sphinxcontrib-blockdiag** --- block (box-and-arrow) diagrams
- **sphinxcontrib-seqdiag** --- sequence diagrams

Both extensions are now effectively **abandoned** and cause cascading build
failures across ONAP repositories. This document details the problems,
evaluates alternatives, and provides a concrete migration path.

Problem statement
-----------------

Both packages were last released on **2021-12-05** (version 3.0.0) and have
received no maintenance since. Their classifiers list only Python 3.7--3.9
as supported. The underlying ``blockdiag`` rendering library on which they
depend has the same maintenance status.

The lack of maintenance creates two critical incompatibilities that currently
break ONAP documentation builds.

Python 3.12+ incompatibility
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``sphinxcontrib-blockdiag`` (and its dependency ``blockdiag``) uses
``ast.NameConstant``, which was deprecated in Python 3.8 and **removed in
Python 3.12**. Any documentation build running on Python 3.12 or later will
crash with an ``AttributeError``.

Repositories that set ``basepython = python3`` in ``tox.ini`` without pinning
a version are particularly affected, because modern CI runners resolve this to
Python 3.12 or newer.

Pillow 10+ incompatibility
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``blockdiag 3.0.0`` calls ``ImageDraw.textsize()``, a method that was
deprecated in Pillow 9.2.0 and **removed in Pillow 10.0**. The ONAP
upper-constraints file pins ``Pillow===10.4.0``, so every repository that
renders a ``.. blockdiag::`` directive fails with:

.. code-block:: text

   AttributeError: 'ImageDraw' object has no attribute 'textsize'

The current workaround---forcing ``Pillow<10`` via ``commands_pre`` in
``tox.ini``---limits those repositories to Python 3.11 (Pillow 9.x does not
ship wheels for Python 3.12+), prevents them from receiving Pillow security
updates, and adds fragile per-repository configuration that is easy to forget.

Impact on ONAP repositories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following table summarises how these incompatibilities have affected
ONAP documentation builds:

.. list-table:: Affected Repositories and Workarounds
   :header-rows: 1
   :widths: 30 40 30

   * - Repository
     - Issue
     - Current Workaround
   * - ``dmaap/buscontroller``
     - Pillow/blockdiag crash
     - ``python3.11`` + ``Pillow<10``
   * - ``dmaap/datarouter``
     - Pillow/blockdiag crash
     - ``python3.11`` + ``Pillow<10``
   * - ``sdc/sdc-docker-base``
     - ``ast.NameConstant`` crash on Python 3.12+
     - None (build broken)
   * - ``ccsdk/distribution``
     - Extensions loaded but no directives in use
     - Pinned constraints

Evaluation of alternatives
--------------------------

Three actively maintained Sphinx extensions can produce the same types of
diagrams that ``blockdiag`` and ``seqdiag`` provide.

sphinxcontrib-mermaid (recommended)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75

   * - **PyPI**
     - `sphinxcontrib-mermaid <https://pypi.org/project/sphinxcontrib-mermaid/>`_
   * - **Repository**
     - https://github.com/mgaitan/sphinxcontrib-mermaid
   * - **Latest release**
     - 2.0.0 (2026-01-13)
   * - **Python support**
     - 3.10--3.14
   * - **Diagram types**
     - Flowcharts, sequence diagrams, Gantt charts, class diagrams, state
       diagrams, ER diagrams, pie charts, git graphs, and more
   * - **Runtime dependencies**
     - ``sphinx``, ``jinja2``, ``pyyaml`` --- **no Pillow dependency**
   * - **Rendering**
     - Client-side JavaScript (Mermaid.js) for HTML output, or server-side
       via the ``mmdc`` CLI for PDF/image output
   * - **External tools**
     - None required for HTML builds

`Mermaid <https://mermaid.js.org/>`_ is the industry-standard text-based
diagramming language, natively supported by GitHub, GitLab, Notion, Obsidian
and many other platforms.

sphinxcontrib-plantuml (already in use)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75

   * - **PyPI**
     - `sphinxcontrib-plantuml <https://pypi.org/project/sphinxcontrib-plantuml/>`_
   * - **Repository**
     - https://github.com/sphinx-contrib/plantuml/
   * - **Latest release**
     - 0.31 (2025-09-03)
   * - **Python support**
     - No explicit constraint (works with 3.8+)
   * - **Diagram types**
     - Sequence, class, activity, component, state, object, deployment,
       timing, and many more
   * - **External tools**
     - **Requires Java** and the PlantUML JAR file

ONAP already uses ``sphinxcontrib-plantuml`` in several repositories.
PlantUML is a capable alternative but requires a Java runtime, which
adds complexity to CI environments and local developer setups.

sphinx.ext.graphviz (built-in)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 75

   * - **Documentation**
     - `sphinx.ext.graphviz <https://www.sphinx-doc.org/en/master/usage/extensions/graphviz.html>`_
   * - **Maintenance**
     - Maintained as part of Sphinx itself
   * - **Diagram types**
     - Directed and undirected graphs
   * - **External tools**
     - Requires the Graphviz ``dot`` binary

Graphviz is well suited for dependency graphs and network topologies. It is
less natural for sequence diagrams and does not support the box-and-arrow
style that ``blockdiag`` provides.

Comparison matrix
^^^^^^^^^^^^^^^^^

.. list-table:: Extension Comparison
   :header-rows: 1
   :widths: 24 19 19 19 19

   * - Criterion
     - blockdiag/seqdiag
     - Mermaid
     - PlantUML
     - Graphviz
   * - Actively maintained
     - **No** (last release 2021)
     - **Yes** (2026-01)
     - **Yes** (2025-09)
     - **Yes** (part of Sphinx)
   * - Python 3.12+ support
     - **No**
     - **Yes** (to 3.14)
     - **Yes**
     - **Yes**
   * - Pillow dependency
     - **Yes** (broken >=10)
     - **No**
     - No
     - No
   * - Block diagrams
     - Yes
     - **Yes**
     - Yes
     - Partial
   * - Sequence diagrams
     - Yes
     - **Yes**
     - Yes
     - No
   * - External runtime
     - None
     - **None** (HTML)
     - Java
     - Graphviz binary
   * - GitHub rendering
     - No
     - **Yes** (native)
     - No
     - No
   * - Single extension for both
     - No (two packages)
     - **Yes**
     - Yes
     - No

Recommendation
--------------

**Replace both** ``sphinxcontrib-blockdiag`` **and**
``sphinxcontrib-seqdiag`` **with** ``sphinxcontrib-mermaid``.

Key reasons:

1. **One package replaces two** --- Mermaid handles both block and sequence
   diagrams (and many more types) with a single Sphinx extension.

2. **No Pillow dependency** --- eliminates the entire
   ``ImageDraw.textsize()`` / ``Pillow<10`` compatibility problem.

3. **No Java dependency** --- unlike PlantUML, Mermaid renders via
   JavaScript for HTML output, with no external binary required for the
   most common build target.

4. **Python 3.10--3.14 support** --- future-proof, with no
   ``ast.NameConstant`` issues.

5. **Actively maintained** --- regular release cadence, latest release
   January 2026.

6. **Industry standard** --- Mermaid is natively rendered by GitHub, GitLab,
   Notion, Obsidian, and many other platforms, so contributors can preview
   diagrams without building the full documentation.

7. **ReadTheDocs compatible** --- works with the Sphinx HTML builder without
   any server-side tools.

Migration guide
---------------

This section provides step-by-step instructions for migrating a repository
from ``blockdiag``/``seqdiag`` to Mermaid.

Step 1 --- Update docs/conf.py
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove the old extensions and add the Mermaid extension:

.. code-block:: python

   # Before
   extensions = [
       'sphinx.ext.intersphinx',
       'sphinx.ext.graphviz',
       'sphinxcontrib.blockdiag',
       'sphinxcontrib.seqdiag',
       'sphinxcontrib.plantuml',
   ]

   # After
   extensions = [
       'sphinx.ext.intersphinx',
       'sphinx.ext.graphviz',
       'sphinxcontrib.mermaid',
       'sphinxcontrib.plantuml',
   ]

Step 2 --- Update requirements-docs.txt
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Replace the diagram extension entries:

.. code-block:: text

   # Before
   sphinxcontrib-blockdiag>=3.0.0
   sphinxcontrib-seqdiag>=3.0.0

   # After
   sphinxcontrib-mermaid>=1.0.0

If your repository also has an ``upper-constraints.onap.txt`` or similar
constraints file, update it accordingly:

.. code-block:: text

   # Before
   sphinxcontrib-blockdiag===3.0.0
   sphinxcontrib-seqdiag===3.0.0

   # After
   sphinxcontrib-mermaid===2.0.0

Step 3 --- Remove Pillow workarounds from tox.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If your ``tox.ini`` contains workarounds for the Pillow/blockdiag
incompatibility, they can be removed:

.. code-block:: ini

   # Remove this line if present:
   commands_pre = pip install 'Pillow<10'

You can also upgrade ``basepython`` from ``python3.11`` to ``python3.12``
(or later) if it was held back specifically for blockdiag compatibility.

Step 4 --- Convert blockdiag directives to Mermaid
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Each ``.. blockdiag::`` directive must be rewritten as a ``.. mermaid::``
directive. The examples below cover the most common patterns.

Simple block diagram
""""""""""""""""""""

.. code-block:: rst

   .. blockdiag::

      blockdiag {
        A -> B -> C;
             B -> D;
      }

Becomes:

.. code-block:: rst

   .. mermaid::

      graph LR
        A --> B --> C
        B --> D

Block diagram with labels and colours
""""""""""""""""""""""""""""""""""""""

.. code-block:: rst

   .. blockdiag::

      blockdiag {
        A [label = "Client"];
        B [label = "Server", color = "#FF6600"];
        C [label = "Database"];
        A -> B -> C;
      }

Becomes:

.. code-block:: rst

   .. mermaid::

      graph LR
        A["Client"] --> B["Server"] --> C["Database"]
        style B fill:#FF6600,color:#fff

Block diagram with groups
"""""""""""""""""""""""""

.. code-block:: rst

   .. blockdiag::

      blockdiag {
        A -> B -> C;

        group {
          label = "Group 1";
          color = "#99CCFF";
          A; B;
        }
      }

Becomes:

.. code-block:: rst

   .. mermaid::

      graph LR
        subgraph Group 1
          A --> B
        end
        B --> C

Vertical orientation
""""""""""""""""""""

``blockdiag`` renders left-to-right by default. If you need top-to-bottom
flow (or if the original used ``orientation = portrait``):

.. code-block:: rst

   .. mermaid::

      graph TB
        A --> B --> C

The orientation keyword controls layout direction:

- ``graph LR`` --- left to right (default blockdiag style)
- ``graph TB`` --- top to bottom
- ``graph RL`` --- right to left
- ``graph BT`` --- bottom to top

Step 5 --- Convert seqdiag directives to Mermaid
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Each ``.. seqdiag::`` directive must be rewritten as a ``.. mermaid::``
directive using the ``sequenceDiagram`` type.

Simple sequence diagram
"""""""""""""""""""""""

.. code-block:: rst

   .. seqdiag::

      seqdiag {
        browser => webserver => database;
      }

Becomes:

.. code-block:: rst

   .. mermaid::

      sequenceDiagram
        browser->>webserver: request
        webserver->>database: query
        database-->>webserver: result
        webserver-->>browser: response

.. note::

   Mermaid sequence diagrams require explicit message labels on every arrow.
   The ``seqdiag`` shorthand ``A => B => C;`` (which implies unlabelled
   request-response pairs) must be expanded into individual messages with
   descriptive labels. This improves documentation clarity.

Sequence diagram with labels and notes
"""""""""""""""""""""""""""""""""""""""

.. code-block:: rst

   .. seqdiag::

      seqdiag {
        browser -> webserver [label = "GET /index.html"];
        browser <-- webserver [label = "200 OK"];

        browser -> webserver [label = "POST /api/data"];
        browser <-- webserver [label = "201 Created"];
      }

Becomes:

.. code-block:: rst

   .. mermaid::

      sequenceDiagram
        browser->>webserver: GET /index.html
        webserver-->>browser: 200 OK
        browser->>webserver: POST /api/data
        webserver-->>browser: 201 Created

Sequence diagram with activation and notes
""""""""""""""""""""""""""""""""""""""""""

.. code-block:: rst

   .. seqdiag::

      seqdiag {
        browser -> webserver [label = "request"];
        webserver -> database [label = "query"];
        webserver <-- database [label = "result"];
        webserver -> webserver [label = "process"];
        browser <-- webserver [label = "response"];
      }

Becomes:

.. code-block:: rst

   .. mermaid::

      sequenceDiagram
        browser->>webserver: request
        activate webserver
        webserver->>database: query
        database-->>webserver: result
        webserver->>webserver: process
        webserver-->>browser: response
        deactivate webserver

Mermaid arrow syntax reference
""""""""""""""""""""""""""""""

.. list-table:: Mermaid Sequence Diagram Arrow Types
   :header-rows: 1
   :widths: 20 40 40

   * - Arrow
     - Meaning
     - seqdiag equivalent
   * - ``->>``
     - Solid line with arrowhead (synchronous)
     - ``->`` or ``=>``
   * - ``-->>``
     - Dashed line with arrowhead (response)
     - ``<--`` or ``<==``
   * - ``-)``
     - Solid line with open arrowhead (asynchronous)
     - ``->`` (no direct equivalent)
   * - ``--)``
     - Dashed line with open arrowhead
     - (no direct equivalent)
   * - ``-x``
     - Solid line with cross (lost message)
     - (no direct equivalent)

Step 6 --- Configure Mermaid options (optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can add optional Mermaid configuration to ``conf.py``:

.. code-block:: python

   # Use a specific Mermaid JS version (default: latest)
   mermaid_version = "11.4.1"

   # Generate raw Mermaid source alongside images for accessibility
   mermaid_output_format = "raw"

   # For PDF output, specify the mmdc CLI path (requires Node.js)
   # mermaid_cmd = "/usr/local/bin/mmdc"

For HTML output (including ReadTheDocs), no additional configuration is
needed. The extension embeds Mermaid.js from a CDN by default.

Step 7 --- Verify the build
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Run the documentation build locally and check that all diagrams render
correctly:

.. code-block:: bash

   cd <repository>
   tox -edocs

Open the generated HTML in a browser and visually inspect each diagram.

Changes to the doc repository
-----------------------------

The central ``doc`` repository files will be updated as part of this
migration:

docs/conf.py
   Remove ``sphinxcontrib.blockdiag`` and ``sphinxcontrib.seqdiag`` from the
   ``extensions`` list. Add ``sphinxcontrib.mermaid``.

docs/requirements-docs.txt
   Remove ``sphinxcontrib-blockdiag`` and ``sphinxcontrib-seqdiag``. Add
   ``sphinxcontrib-mermaid>=1.0.0``.

etc/upper-constraints.onap.txt
   Remove ``sphinxcontrib-blockdiag===3.0.0`` and
   ``sphinxcontrib-seqdiag===3.0.0``. Add ``sphinxcontrib-mermaid===2.0.0``.
   The ``Pillow`` pin can remain at 10.4.0 as Mermaid does not depend on it.

These changes will propagate to all downstream repositories that inherit
the shared documentation configuration.

Downstream repository checklist
-------------------------------

For each repository that currently uses ``blockdiag`` or ``seqdiag``
directives, the following changes are required:

.. list-table:: Migration Checklist
   :header-rows: 1
   :widths: 5 60 35

   * - #
     - Action
     - Files
   * - 1
     - Replace ``sphinxcontrib.blockdiag`` and ``sphinxcontrib.seqdiag``
       with ``sphinxcontrib.mermaid`` in the extensions list
     - ``docs/conf.py``
   * - 2
     - Replace ``sphinxcontrib-blockdiag`` and ``sphinxcontrib-seqdiag``
       with ``sphinxcontrib-mermaid`` in documentation requirements
     - ``docs/requirements-docs.txt``
   * - 3
     - Update pinned versions if a local constraints file exists
     - ``etc/upper-constraints.onap.txt``
   * - 4
     - Convert all ``.. blockdiag::`` directives to ``.. mermaid::``
       using the syntax examples in this guide
     - ``docs/**/*.rst``
   * - 5
     - Convert all ``.. seqdiag::`` directives to ``.. mermaid::``
       using the syntax examples in this guide
     - ``docs/**/*.rst``
   * - 6
     - Remove any ``commands_pre = pip install 'Pillow<10'`` workarounds
     - ``tox.ini``
   * - 7
     - Upgrade ``basepython`` to ``python3.12`` if it was pinned to
       ``python3.11`` solely for blockdiag compatibility
     - ``tox.ini``
   * - 8
     - Build locally and verify all diagrams render correctly
     - (local test)

Further reading
---------------

- `Mermaid documentation <https://mermaid.js.org/intro/>`_
- `Mermaid live editor <https://mermaid.live/>`_ --- interactive browser-based
  editor for prototyping diagrams
- `sphinxcontrib-mermaid documentation
  <https://sphinxcontrib-mermaid-demo.readthedocs.io/en/latest/>`_
- `sphinxcontrib-mermaid on PyPI
  <https://pypi.org/project/sphinxcontrib-mermaid/>`_
- `Mermaid syntax for flowcharts <https://mermaid.js.org/syntax/flowchart.html>`_
- `Mermaid syntax for sequence diagrams
  <https://mermaid.js.org/syntax/sequenceDiagram.html>`_
