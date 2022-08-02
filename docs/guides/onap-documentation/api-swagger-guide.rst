.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 Orange.  All rights reserved.

.. _api-swagger-guide:

API documentation
=================

Swagger
-------

The API should be described using OpenAPI specifications and available as a
`JSON file <https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md>`_

A Swagger editor is available here `<http://editor.swagger.io/>`_ to generate
such JSON files.

As a result, you should get one JSON file per API. For example the project
**my** has 2 API: **myAPI1** and **myAPI2**.

- myAPI1.json
- myAPI2.json

Global API table
----------------
It is recommended to list the following API available with an access to the
Swagger JSON files to help the developers/users to play with JSON.

We propose the following table:

.. csv-table::
   :header: "API name", "Swagger JSON"
   :widths: 10,5

   "myAPI1", ":download:`link <myAPI1.json>`"
   "myAPI12", ":download:`link <myAPI2.json>`"

.. note::
   During documentation merge/publish at RTD, any file referenced in an RST file with
   ':download:' and relative path to a contributing project repository is copied, uniquely
   named, and published with the generated HTML pages.

The code is available here:

.. code:: rst

   .. csv-table::
      :header: "API name", "Swagger JSON"
      :widths: 10,5

      "myAPI1", ":download:`link <myAPI1.json>`"
      "myAPI2", ":download:`link <myAPI2.json>`"

.. note::
   The syntax of <myAPI1.json> is to be taken literally. Keep '<' and '>'.


API Swagger
-----------
For each API, the ``swaggerv2doc`` directive must be used as follows:

.. note::
   Note the “v” in  swaggerv2doc!
   If your JSON file has multiple endpoints, this directive does not preserve the order.

.. note::
   swaggerv2doc directive may generate errors when Swagger file contains specific
   information. In such case, do not use this direcive.

.. code:: rst

   myAPI1
   ......
   .. swaggerv2doc:: myAPI1.json

   myAPI2
   ......
   .. swaggerv2doc:: myAPI2.json

It will produce the following output:

myAPI1
......
.. swaggerv2doc:: myAPI1.json

myAPI2
......
.. swaggerv2doc:: myAPI2.json
