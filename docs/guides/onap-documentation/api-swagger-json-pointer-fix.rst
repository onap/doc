.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2025 The ONAP Contributors.  All rights reserved.

.. _api-swagger-json-pointer-fix:

Advisory: JSON Pointer Errors in OpenAPI Spec Files
====================================================

Summary
-------

When migrating API documentation from the deprecated ``.. swaggerv2doc::``
directive to the ``.. openapi::`` directive, some Swagger 2.0 JSON spec files
cause Sphinx builds to fail with an error like:

.. code-block:: none

   jsonschema.exceptions._RefResolutionError: Unresolvable JSON pointer:
       'definitions/ASDC-API/artifacts(config)artifact'

This error occurs when **definition key names contain forward slash** (``/``)
**characters**. The ``/`` character is the path separator in JSON Pointer
(`RFC 6901 <https://www.rfc-editor.org/rfc/rfc6901>`_), so the JSON schema
resolver misinterprets the key name as a nested path rather than a single key
at the ``definitions`` level.

Background
----------

Several ONAP projects use auto-generated Swagger 2.0 JSON specs originally
produced by OpenDaylight YANG tooling. These specs contain definition names
that embed hierarchical paths using ``/`` as a separator, for example:

- ``ASDC-API/artifacts(config)artifact``
- ``ASDC-API/vf-license-model-versions(config)vf-license-model-version``
- ``LCM/common-header(config)flags``

These names appear both as keys under ``definitions`` and inside ``$ref``
pointer values:

.. code-block:: json

   {
     "definitions": {
       "ASDC-API/artifacts(config)artifact": {
         "properties": { }
       }
     },
     "paths": {
       "/config/ASDC-API:artifacts": {
         "post": {
           "parameters": [{
             "schema": {
               "$ref": "#/definitions/ASDC-API/artifacts(config)artifact"
             }
           }]
         }
       }
     }
   }

While having ``/`` in a JSON object key is valid JSON, it creates an
unresolvable ``$ref`` when parsed as a JSON Pointer. The pointer
``#/definitions/ASDC-API/artifacts(config)artifact`` is interpreted as:

1. Navigate into ``definitions`` ✓
2. Navigate into ``ASDC-API`` ✗ — no such nested key exists

The actual definition lives at ``definitions["ASDC-API/artifacts(config)artifact"]``
as a single flat key, but the JSON Pointer specification has no way to
distinguish a ``/`` that is part of a key name from a ``/`` that is a path
separator — unless the reference is properly escaped.

Affected Projects
-----------------

This issue was originally identified on Gerrit change
`143029 <https://gerrit.onap.org/r/c/ccsdk/distribution/+/143029>`_
(``ccsdk/distribution``, topic: ``remove-swaggerdoc``), where the GitHub
documentation workflow failed during ``sphinx-build`` for both the ``docs``
and ``docs-linkcheck`` tox environments.

Any project with auto-generated Swagger specs from OpenDaylight YANG tooling
may be affected. The issue only manifests when using ``sphinxcontrib-openapi``
(the ``.. openapi::`` directive); the older ``sphinxcontrib-swaggerdoc``
extension did not perform strict JSON Pointer resolution on ``$ref`` values.

Fix: Rename Definition Keys (Option A — Recommended)
-----------------------------------------------------

Replace ``/`` in definition key names with a safe separator character such as
``.`` (period), and update all corresponding ``$ref`` values to match.

**Before:**

.. code-block:: json

   {
     "definitions": {
       "ASDC-API/artifacts(config)artifact": { }
     },
     "$ref": "#/definitions/ASDC-API/artifacts(config)artifact"
   }

**After:**

.. code-block:: json

   {
     "definitions": {
       "ASDC-API.artifacts(config)artifact": { }
     },
     "$ref": "#/definitions/ASDC-API.artifacts(config)artifact"
   }

This can be accomplished with a script that:

1. Loads the JSON spec.
2. Identifies all definition keys containing ``/``.
3. Replaces ``/`` with ``.`` in those keys.
4. Performs a global find-and-replace of all ``$ref`` values referencing the
   old key names.
5. Writes the corrected JSON back out.

**Example (Python):**

.. code-block:: python

   import json, re, sys

   with open(sys.argv[1], "r") as f:
       raw = f.read()

   data = json.loads(raw)
   definitions = data.get("definitions", {})

   # Build a mapping of old key -> new key for any key containing "/"
   renames = {}
   for key in list(definitions.keys()):
       if "/" in key:
           new_key = key.replace("/", ".")
           renames[key] = new_key

   # Replace in $ref strings (operate on raw text for simplicity)
   for old_key, new_key in renames.items():
       old_ref = f"#/definitions/{old_key}"
       new_ref = f"#/definitions/{new_key}"
       raw = raw.replace(f'"{old_ref}"', f'"{new_ref}"')

   # Replace definition keys
   data = json.loads(raw)
   new_definitions = {}
   for key, value in data["definitions"].items():
       new_definitions[renames.get(key, key)] = value
   data["definitions"] = new_definitions

   with open(sys.argv[1], "w") as f:
       json.dump(data, f, indent=2)

Run as:

.. code-block:: bash

   python fix_json_pointers.py docs/sli/apis/specs/asdc-api.json
   python fix_json_pointers.py docs/sli/apis/specs/lcm.json

Alternative: JSON Pointer Tilde Escaping (Option B)
----------------------------------------------------

RFC 6901 defines ``~1`` as the escape sequence for a literal ``/`` inside a
JSON Pointer token. Under this approach, definition key names are left
unchanged, but all ``$ref`` values are updated to use the escaped form:

**Before:**

.. code-block:: json

   "$ref": "#/definitions/ASDC-API/artifacts(config)artifact"

**After:**

.. code-block:: json

   "$ref": "#/definitions/ASDC-API~1artifacts(config)artifact"

This is technically correct per the RFC, but has drawbacks:

- Less readable and harder to maintain.
- Requires that all consumers (including ``sphinxcontrib-openapi`` and any
  other tooling) correctly implement ``~1`` decoding, which is not always
  guaranteed in practice.
- The definition keys still contain ``/``, which may cause issues with other
  tools in the future.

**Option A (renaming keys) is preferred** for clarity and portability.

Verification
------------

After applying the fix, verify the documentation builds cleanly:

.. code-block:: bash

   cd docs
   tox -e docs,docs-linkcheck

Both environments should complete without ``_RefResolutionError`` exceptions.

References
----------

- `RFC 6901 — JavaScript Object Notation (JSON) Pointer <https://www.rfc-editor.org/rfc/rfc6901>`_
- `Swagger 2.0 Specification — Reference Object <https://swagger.io/specification/v2/#reference-object>`_
- `sphinxcontrib-openapi documentation <https://sphinxcontrib-openapi.readthedocs.io/>`_
- `Gerrit Change 143029 <https://gerrit.onap.org/r/c/ccsdk/distribution/+/143029>`_