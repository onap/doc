.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.

Style guide
===========

This style guide is for ONAP documentation contributors, reviewers and
committers.

Writing guidelines
------------------
Following these writing guidelines will keep ONAP documentation
consistent and readable. Only a few areas are covered below, as
we don't want to make it too complex. Try to keep things simple
and clear, and you can't go far wrong.

Don’t get too hung up on using correct style. We’d rather have you
submit good information that does not conform to this guide than no
information at all. ONAP’s Documentation project team will be happy
to help you with the prose.

General guidelines for all documents
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-  Use standard American English and spelling
-  Use consistent terminology
-  Write in the active voice, using present simple tense when possible
-  Write objective, professional content
-  Keep sentences and paragraphs short and clear
-  Use a spell checker

Abbreviations and acronyms
^^^^^^^^^^^^^^^^^^^^^^^^^^
-  Write out the term the first time it appears in the document,
   immediately followed by the acronym or abbreviation in parenthesis.
   Then use the acronym in the rest of the document. In diagrams, if
   space allows, write out the full term.

-  Use “an” before an acronym that begins with a vowel sound when spoken
   aloud; use "a" before an acronym that begins with a consonant
   sound when spoken aloud.

   +  Examples: an MSO component, a LAN, an L3-VPN


ONAP terms
^^^^^^^^^^
-  AA&I vs AAI: AAI should be used.

-  APP-C vs APPC: APPC should be used.

-  SDN-C vs SDNC: SDNC should be used.

-  Heat vs HEAT: Both are in use. The official website uses "Heat".

-  life cycle vs lifecycle or life-cycle: "life cycle" is preferred.

-  open source (adjective): capitalize only in titles; avoid
   "open-source". (Based on prevalence on the web.)

-  run-time vs. execution-time (adjective): prefer run-time.
   Example: "run-time logging of events"

-  run time (noun). Example: "logging of events at run time".

GUI elements
^^^^^^^^^^^^
-  In general, write menu names as they appear in the UI.
   For example, if a menu or item name is all caps, then write
   it all caps in the document.

Headings (Titles)
^^^^^^^^^^^^^^^^^
-  Use brief, but specific, informative titles. Titles should give
   context when possible.

-  Use sentence-style capitalization; do not end with a period or colon.

-  Use a gerund to begin section titles. Examples: Configuring,
   Managing, Starting.

-  Use descriptive titles for tables and figures titles. Do not
   number tables or figures. Do not (in general) add titles for screen shots.

Tasks
^^^^^
-  Start task titles with an action word. Examples: Create, Add,
   Validate, Update.

-  Use [Optional] at the beginning of an optional step.

-  Provide information on the expected outcome of a step, especially
   when it is not obvious.

-  Break down end-to-end tasks into manageable chunks.


ONAP Conventions for the Use of Sphinx Directives
-------------------------------------------------

Needs Directive
^^^^^^^^^^^^^^^

 * Needs IDs must match the regular expression "^[A-Z0-9]+-[A-Z0-9]+"

 * The prefix (string before the dash) must be described in the following table

.. list-table:: Needs Prefix Use
   :align: center
   :widths: 8 40 40
   :header-rows: 1

   * - Prefix
     - Description
     - Use

   * - R
     - Represents a requirement that must be met by a VNF provider
     - Defined only in the vnfrqts project repositories, may be referenced in any project repository source
