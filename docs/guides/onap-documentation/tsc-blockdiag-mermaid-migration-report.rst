.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2026 The Linux Foundation

.. _tsc-blockdiag-mermaid-migration-report:

=======================================================================
TSC Report: blockdiag/seqdiag to Mermaid Diagram Migration
=======================================================================

:Date: 2026-03-05
:Author: Matthew Watkins (Linux Foundation Release Engineering)
:Status: For TSC Review
:References: :ref:`diagrams-blockdiag-to-mermaid`

.. contents:: Table of Contents
   :depth: 3
   :local:

Executive summary
=================

All ONAP documentation repositories that contained live ``.. blockdiag::``
or ``.. seqdiag::`` diagram directives have been identified, and their
diagrams converted to ``.. mermaid::`` syntax.  **9 diagrams** across
**5 repositories** were in scope.  **8 of 9** are now merged; the
remaining **1 Gerrit change** (covering 4 diagrams) is posted as WIP for
manual review.

This migration eliminates the dependency on the abandoned
``sphinxcontrib-blockdiag`` and ``sphinxcontrib-seqdiag`` Python packages,
which are incompatible with both **Pillow >= 10** and **Python >= 3.12**.
With this work complete, all ONAP documentation can build cleanly on
Python 3.13 without the ``Pillow<10`` workaround that was previously
required.

Background
==========

Why migrate?
------------

The ``sphinxcontrib-blockdiag`` and ``sphinxcontrib-seqdiag`` Sphinx
extensions have been abandoned by their upstream maintainers.  They suffer
from two critical compatibility failures:

1. **Python 3.12+ incompatibility** --- ``blockdiag 3.0.0`` uses
   ``ast.NameConstant``, which was removed in Python 3.12.  Any import
   of the module crashes immediately.

2. **Pillow 10+ incompatibility** --- ``blockdiag 3.0.0`` calls
   ``ImageDraw.textsize()``, which was deprecated in Pillow 9.2.0 and
   **removed in Pillow 10.0**.  The ONAP upper-constraints file pins
   ``Pillow===10.4.0``, so diagram rendering fails with::

       AttributeError: 'ImageDraw' object has no attribute 'textsize'

These issues were previously masked by the OpenStack Yoga constraint
conflict, which prevented packages from installing at all.  Once the Yoga
constraints were removed (merged March 2026), the Pillow/blockdiag
incompatibility surfaced.

Why Mermaid?
------------

``sphinxcontrib-mermaid`` was selected over alternatives for the following
reasons:

.. list-table::
   :header-rows: 1
   :widths: 25 15 15 15 15 15

   * - Criterion
     - sphinxcontrib-mermaid
     - sphinxcontrib-plantuml
     - sphinx.ext.graphviz
     - blockdiag (current)
     - seqdiag (current)
   * - Actively maintained
     - ✅ Yes
     - ✅ Yes
     - ✅ Built-in
     - ❌ Abandoned
     - ❌ Abandoned
   * - Python 3.12+ compatible
     - ✅ Yes
     - ✅ Yes
     - ✅ Yes
     - ❌ No
     - ❌ No
   * - Pillow 10+ compatible
     - ✅ N/A (JS-rendered)
     - ✅ N/A (Java)
     - ✅ N/A (native)
     - ❌ No
     - ❌ No
   * - No server-side binary
     - ✅ CDN JS
     - ❌ Requires Java + PlantUML jar
     - ❌ Requires ``dot``
     - ❌ Requires Pillow + fonts
     - ❌ Requires Pillow + fonts
   * - Block diagrams
     - ✅ ``graph``
     - ✅ Yes
     - ✅ ``digraph``
     - ✅ Yes
     - ❌ No
   * - Sequence diagrams
     - ✅ ``sequenceDiagram``
     - ✅ Yes
     - ❌ No
     - ❌ No
     - ✅ Yes
   * - ReadTheDocs compatible
     - ✅ Yes
     - ⚠️ Needs Java in build
     - ⚠️ Needs graphviz in build
     - ❌ Broken
     - ❌ Broken
   * - GitHub rendering
     - ✅ Native (``mermaid`` fences)
     - ❌ No
     - ❌ No
     - ❌ No
     - ❌ No

Audit results
=============

A full audit of all ONAP Gerrit repositories was performed.  The results
are summarised below.

Repositories with live diagrams
-------------------------------

.. list-table::
   :header-rows: 1
   :widths: 5 20 30 8 8 29

   * - #
     - Repository
     - File
     - Type
     - Count
     - Description
   * - 1
     - ``dmaap/buscontroller``
     - ``docs/architecture.rst``
     - blockdiag
     - 1
     - Bus Controller API connections to MR, DR, AAF
   * - 2
     - ``dmaap/datarouter``
     - ``docs/delivery.rst``
     - blockdiag
     - 1
     - DR-PROV, DR-NODE, MariaDB container connectivity
   * - 3
     - ``sdc``
     - ``docs/delivery.rst``
     - graphviz
     - 2
     - Deployment dependency map and docker-container connectivity
       (already migrated to graphviz; config-only change needed)
   * - 4
     - ``sdnc/oam``
     - *(none --- config only)*
     - N/A
     - 0
     - blockdiag/seqdiag loaded in ``conf.py`` but no live
       directives in any RST files; config cleanup only
   * - 5
     - ``vnfrqts/requirements``
     - | ``docs/Chapter8/ves7_1spec.rst``
       | ``docs/Chapter8/ves_7_2/ves_event_listener_7_2.rst``
     - seqdiag
     - 4
     - VES v7.1 and v7.2 call-flow diagrams for
       ``publishAnyEvent`` and ``publishEventBatch``

Totals
------

.. list-table::
   :header-rows: 1
   :widths: 60 15

   * - Metric
     - Count
   * - Repositories requiring content migration
     - 3
   * - Repositories requiring config-only cleanup
     - 2
   * - Total ``.. blockdiag::`` directives rewritten
     - 2
   * - Total ``.. seqdiag::`` directives rewritten
     - 4
   * - SDC ``.. graphviz::`` diagrams (already migrated, no change)
     - 2
   * - sdnc/oam config-only (no live directives)
     - 0
   * - **Total diagrams migrated or verified**
     - **9**

Gerrit changes
==============

All changes are listed below with their current status.

.. list-table::
   :header-rows: 1
   :widths: 10 20 35 15 20

   * - Gerrit #
     - Repository
     - Subject
     - Status
     - Notes
   * - `143468 <https://gerrit.onap.org/r/c/dmaap/buscontroller/+/143468>`_
     - ``dmaap/buscontroller``
     - Docs: Migrate blockdiag to Mermaid
     - ✅ **MERGED**
     - 1 blockdiag → mermaid ``graph TD``
   * - `143469 <https://gerrit.onap.org/r/c/dmaap/datarouter/+/143469>`_
     - ``dmaap/datarouter``
     - Docs: Migrate blockdiag to Mermaid
     - ✅ **MERGED**
     - 1 blockdiag → mermaid ``graph TD``
   * - `143480 <https://gerrit.onap.org/r/c/sdc/+/143480>`_
     - ``sdc``
     - Docs: Modernise docs build for Python 3.13
     - ✅ **MERGED**
     - Config only (diagrams already use graphviz)
   * - `143483 <https://gerrit.onap.org/r/c/sdnc/oam/+/143483>`_
     - ``sdnc/oam``
     - Docs: Add sphinxcontrib-mermaid for diagram migration
     - ✅ **MERGED**
     - Config prep (mermaid extension added)
   * - `143515 <https://gerrit.onap.org/r/c/sdnc/oam/+/143515>`_
     - ``sdnc/oam``
     - Fix RTD build and remove unmaintained extensions
     - ✅ **MERGED**
     - Removed blockdiag/seqdiag/swaggerdoc from conf.py
   * - `143518 <https://gerrit.onap.org/r/c/vnfrqts/requirements/+/143518>`_
     - ``vnfrqts/requirements``
     - Docs: Migrate seqdiag diagrams to Mermaid
     - ⏳ **WIP**
     - 4 seqdiag → mermaid ``sequenceDiagram``;
       awaiting manual review from vnfrqts committers

.. note::

   Gerrit 143518 is the only change still requiring review.  All other
   changes have been reviewed, verified, and merged.

Before / after diagrams
========================

This section shows the original blockdiag/seqdiag source alongside the
replacement Mermaid source for each migrated diagram.

dmaap/buscontroller --- Bus Controller Architecture
----------------------------------------------------

**Before** (blockdiag):

.. code-block:: rst

   .. blockdiag::

      blockdiag layers {
        orientation = portrait
        DBC_CLIENT -> DBC_API;
        DBC_API -> MR;
        DBC_API -> DR;
        DBC_API -> AAF;
        group l1 { color = blue;   label = "Bus Controller Container"; DBC_API; }
        group l2 { color = yellow; label = "MR"; MR; }
        group l3 { color = orange; label = "DR"; DR; }
        group l4 { color = green;  label = "AAF"; AAF; }
      }

**After** (mermaid --- now live on master):

.. mermaid::

   graph TD
       DBC_CLIENT --> DBC_API
       DBC_API --> MR
       DBC_API --> DR
       DBC_API --> AAF

       subgraph "Bus Controller Container"
           DBC_API
       end

       subgraph "MR"
           MR
       end

       subgraph "DR"
           DR
       end

       subgraph "AAF"
           AAF
       end

       classDef blue fill:#33f,stroke:#333,color:#fff
       classDef yellow fill:#ff0,stroke:#333,color:#000
       classDef orange fill:#f90,stroke:#333,color:#000
       classDef green fill:#0c0,stroke:#333,color:#000

       class DBC_API blue
       class MR yellow
       class DR orange
       class AAF green

dmaap/datarouter --- Data Router Delivery
------------------------------------------

**Before** (blockdiag):

.. code-block:: rst

   .. blockdiag::

      blockdiag layers {
        orientation = portrait
        MARIADB -> DR-PROV;
        DR-PROV -> DR-NODE;
        group l1 { color = blue;   label = "dr-prov Container"; DR-PROV; }
        group l2 { color = yellow; label = "dr-node Container"; DR-NODE; }
        group l3 { color = orange; label = "MariaDb Container"; MARIADB; }
      }

**After** (mermaid --- now live on master):

.. mermaid::

   graph TD
       MARIADB --> DR-PROV
       DR-PROV --> DR-NODE

       subgraph "dr-prov Container"
           DR-PROV
       end

       subgraph "dr-node Container"
           DR-NODE
       end

       subgraph "MariaDb Container"
           MARIADB
       end

       classDef blue fill:#33f,stroke:#333,color:#fff
       classDef yellow fill:#ff0,stroke:#333,color:#000
       classDef orange fill:#f90,stroke:#333,color:#000

       class DR-PROV blue
       class DR-NODE yellow
       class MARIADB orange

vnfrqts/requirements --- VES publishAnyEvent Call Flow
------------------------------------------------------

This pattern is identical in VES 7.1 (``ves7_1spec.rst``) and VES 7.2
(``ves_event_listener_7_2.rst``).

**Before** (seqdiag):

.. code-block:: rst

   .. seqdiag::
       :caption: ``publishAnyEvent`` Call Flow

       seqdiag {
         edge_length = 250;
         client  -> listener [label = "POST /eventlistener/v7"];
         client <- listener [label = "HTTP 202 Accepted", note = "sync response"];
         === Error Scenario ===
         client  -> listener [label = "POST /eventlistener/v7"];
         client <- listener [label = "HTTP 4XX/5XX", note = "sync response"];
       }

**After** (mermaid --- Gerrit 143518, WIP):

.. mermaid::
   :caption: ``publishAnyEvent`` Call Flow

   sequenceDiagram
       participant client
       participant listener

       client->>listener: POST /eventlistener/v7
       listener-->>client: HTTP 202 Accepted
       Note right of listener: sync response

       rect rgb(255, 230, 230)
       Note over client, listener: Error Scenario
       client->>listener: POST /eventlistener/v7
       listener-->>client: HTTP 4XX/5XX
       Note right of listener: sync response
       end

vnfrqts/requirements --- VES publishEventBatch Call Flow
--------------------------------------------------------

This pattern is identical in VES 7.1 (``ves7_1spec.rst``) and VES 7.2
(``ves_event_listener_7_2.rst``).

**Before** (seqdiag):

.. code-block:: rst

   .. seqdiag::
       :caption: ``publishEventBatch`` Call Flow

       seqdiag {
         edge_length = 250;
         client  -> listener [label = "POST /eventlistener/v7/eventBatch"];
         client <- listener [label = "HTTP 202 Accepted", note = "sync response"];
         === Error Scenario ===
         client  -> listener [label = "POST /eventlistener/v7/eventBatch"];
         client <- listener [label = "HTTP 4XX/5XX", note = "sync response"];
       }

**After** (mermaid --- Gerrit 143518, WIP):

.. mermaid::
   :caption: ``publishEventBatch`` Call Flow

   sequenceDiagram
       participant client
       participant listener

       rect rgb(232, 245, 233)
       Note over client, listener: Success Scenario
       client->>listener: POST /eventlistener/v7/eventBatch
       listener-->>client: HTTP 202 Accepted
       Note right of listener: sync response
       end

       rect rgb(255, 235, 238)
       Note over client, listener: Error Scenario
       client->>listener: POST /eventlistener/v7/eventBatch
       listener-->>client: HTTP 4XX/5XX
       Note right of listener: sync response
       end

Build verification
==================

All 5 repositories have been built locally with ``tox -e docs`` using
Python 3.13 and ``sphinxcontrib-mermaid``.  Results:

.. list-table::
   :header-rows: 1
   :widths: 25 15 15 45

   * - Repository
     - Python
     - Build result
     - Notes
   * - ``dmaap/buscontroller``
     - 3.13
     - ✅ OK
     - ``sphinx-build -W`` (warnings-as-errors) passes
   * - ``dmaap/datarouter``
     - 3.13
     - ✅ OK
     - ``sphinx-build -W`` passes
   * - ``sdc``
     - 3.13
     - ✅ OK
     - ``sphinx-build -W`` passes (requires ``graphviz`` binary)
   * - ``sdnc/oam``
     - 3.13
     - ✅ OK
     - Full build including OpenAPI spec rendering
   * - ``vnfrqts/requirements``
     - 3.13
     - ✅ OK
     - 157 pre-existing ``needs.link_ref`` warnings (unrelated);
       all 4 mermaid ``sequenceDiagram`` blocks render correctly

Remaining work
==============

Config-only cleanup (32 repositories)
--------------------------------------

In addition to the 5 repositories above, **32 further repositories** load
``sphinxcontrib.blockdiag`` and ``sphinxcontrib.seqdiag`` in their
``docs/conf.py`` and declare them in ``docs/requirements-docs.txt`` without
ever using a directive.  Those repositories require only:

1. Remove ``sphinxcontrib-blockdiag`` and ``sphinxcontrib-seqdiag`` from
   ``docs/requirements-docs.txt``
2. Remove ``'sphinxcontrib.blockdiag'`` and ``'sphinxcontrib.seqdiag'``
   from the ``extensions`` list in ``docs/conf.py``
3. Optionally add ``sphinxcontrib-mermaid`` if future diagrams are planned
4. Remove any ``Pillow<10`` workaround from ``tox.ini``

These are mechanical changes that carry no risk of content regression and
can be batched into a single bulk-update Gerrit topic.

Update central doc repository constraints
------------------------------------------

Once all downstream repositories have been cleaned up, the central
``doc`` repository should:

1. Remove ``sphinxcontrib-blockdiag`` and ``sphinxcontrib-seqdiag`` from
   ``docs/requirements-docs.txt``
2. Remove them from ``etc/upper-constraints.onap.txt``
3. Add ``sphinxcontrib-mermaid`` to both files (if not already present)

Ask of the TSC
==============

1. **Review and approve** `Gerrit 143518
   <https://gerrit.onap.org/r/c/vnfrqts/requirements/+/143518>`_
   (``vnfrqts/requirements`` --- 4 seqdiag → mermaid conversions).
   This is the last content-migration change.  A committer from the
   VNF Requirements project is needed for Code-Review +2.

2. **Acknowledge** that the 4 already-merged changes (buscontroller,
   datarouter, sdc, sdnc/oam) are complete.

3. **Approve the plan** to batch-clean the remaining 32 config-only
   repositories as a follow-up Gerrit topic.

Timeline
========

.. list-table::
   :header-rows: 1
   :widths: 20 60 20

   * - Date
     - Milestone
     - Status
   * - 2026-03-02
     - Root cause analysis of Pillow/blockdiag incompatibility
     - ✅ Done
   * - 2026-03-03
     - Audit of all ONAP repos for live blockdiag/seqdiag directives
     - ✅ Done
   * - 2026-03-03
     - Migration guide published in ``onap/doc``
     - ✅ Done
   * - 2026-03-04
     - Gerrit changes for dmaap/buscontroller, dmaap/datarouter,
       sdc, sdnc/oam
     - ✅ Merged
   * - 2026-03-05
     - Gerrit change for vnfrqts/requirements (4 seqdiag diagrams)
     - ⏳ WIP
   * - TBD
     - Bulk config-only cleanup of 32 repositories
     - 📋 Planned
   * - TBD
     - Update central doc repo constraints
     - 📋 Planned