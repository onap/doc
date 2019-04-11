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

As a result, you should get one JSON file per API:

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


The code is available here:

.. code:: rst

   ..csv-table::
     :header: "API name", "Swagger JSON"
     :widths: 10,5

     "myAPI1", ":download:`link <myAPI1.json>`"
     "myAPI2", ":download:`link <myAPI2.json>`"

API Swagger
-----------
For each API, the ``swaggerv2doc`` directive must be used as follows:

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
