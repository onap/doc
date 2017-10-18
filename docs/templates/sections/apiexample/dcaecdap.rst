===============
CDAP Broker API
===============

:Date:   2017-10-09

.. contents::
   :depth: 3
..

Overview
========

Version information
-------------------

*Version* : 4.0.10

Paths
=====

GET /
-----

Description
~~~~~~~~~~~

shows some information about this service

Responses
~~~~~~~~~

+---------+--------------------------------------------+-------------------+
| HTTP    | Description                                | Schema            |
| Code    |                                            |                   |
+=========+============================================+===================+
| **200** | successful response                        | `info <#_info>`__ |
+---------+--------------------------------------------+-------------------+

GET /application
----------------

Description
~~~~~~~~~~~

get all applications registered with this broker

Responses
~~~~~~~~~

+---------+-------------------------------------------+---------------+
| HTTP    | Description                               | Schema        |
| Code    |                                           |               |
+=========+===========================================+===============+
| **200** | successful response                       | `appname <#_a |
|         |                                           | ppname>`__    |
|         |                                           | (array)       |
+---------+-------------------------------------------+---------------+

PUT /application/{appname}
--------------------------

Description
~~~~~~~~~~~

(This is a hacky way of supporting "oneOf" because Swagger does not
support oneOf https://github.com/OAI/OpenAPI-Specification/issues/333.
This is the same endpoint as PUT /application/appname, except the PUT
body is different.)

Register a hydrator app for service and configuration discovery. This
will light up a metrics and health endpoint for this app. ``appname`` is
assumed to also be the key in consul.

Parameters
~~~~~~~~~~

+----------+---------------+---------------------------------+------------------+
| Type     | Name          | Description                     | Schema           |
+==========+===============+=================================+==================+
| **Path** | | **appname** | Name of the application.        | string (text)    |
|          | | *required*  |                                 |                  |
+----------+---------------+---------------------------------+------------------+
| **Body** | | **putbody** | required put body               | `hydratorappput  |
|          | | *required*  |                                 | <#_hydratorapppu |
|          |               |                                 | t>`__            |
+----------+---------------+---------------------------------+------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------------+---------------+
| HTTP    | Description                                        | Schema        |
| Code    |                                                    |               |
+=========+====================================================+===============+
| **200** | Successful response                                | `application  |
|         |                                                    | <#_applicatio |
|         |                                                    | n>`__         |
+---------+----------------------------------------------------+---------------+
| **400** | put was performed but the appname was already      | No Content    |
|         | registered with the broker, or Invalid PUT body    |               |
+---------+----------------------------------------------------+---------------+

Consumes
~~~~~~~~

-  ``application/json``

Produces
~~~~~~~~

-  ``application/json``

POST /application/delete
------------------------

Description
~~~~~~~~~~~

endpoint to delete multiple applications at once. Returns an array of
status codes, where statuscode[i] = response returned from
DELETE(application/i)

Parameters
~~~~~~~~~~

+----------+----------------+------------------------------+------------------+
| Type     | Name           | Description                  | Schema           |
+==========+================+==============================+==================+
| **Body** | | **postbody** | required post body           | `multideleteput  |
|          | | *required*   |                              | <#_multideletepu |
|          |                |                              | t>`__            |
+----------+----------------+------------------------------+------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------+-------------------+
| HTTP    | Description                                  | Schema            |
| Code    |                                              |                   |
+=========+==============================================+===================+
| **200** | successful response                          | `returncode       |
|         |                                              | <#_returncode>`__ |
|         |                                              | (array)           |
+---------+----------------------------------------------+-------------------+

GET /application/{appname}
--------------------------

Description
~~~~~~~~~~~

Returns the representation of the application resource, including the
links for healthcheck and metrics.

Parameters
~~~~~~~~~~

+----------+---------------+--------------------------------+------------------+
| Type     | Name          | Description                    | Schema           |
+==========+===============+================================+==================+
| **Path** | | **appname** | Name of the application.       | string (text)    |
|          | | *required*  |                                |                  |
+----------+---------------+--------------------------------+------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------------+---------------+
| HTTP    | Description                                        | Schema        |
| Code    |                                                    |               |
+=========+====================================================+===============+
| **200** | Successful response                                | `application  |
|         |                                                    | <#_applicatio |
|         |                                                    | n>`__         |
+---------+----------------------------------------------------+---------------+
| **404** | no app with name 'appname' registered with this    | No Content    |
|         | broker.                                            |               |
+---------+----------------------------------------------------+---------------+

PUT /application/{appname}
--------------------------

Description
~~~~~~~~~~~

Register an app for service and configuration discovery. This will light
up a metrics and health endpoint for this app. ``appname`` is assumed to
also be the key in consul.

Parameters
~~~~~~~~~~

+----------+---------------+--------------------------------+------------------+
| Type     | Name          | Description                    | Schema           |
+==========+===============+================================+==================+
| **Path** | | **appname** | Name of the application.       | string (text)    |
|          | | *required*  |                                |                  |
+----------+---------------+--------------------------------+------------------+
| **Body** | | **putbody** | required put body              | `appput <#_apppu |
|          | | *required*  |                                | t>`__            |
+----------+---------------+--------------------------------+------------------+

Responses
~~~~~~~~~

+---------+--------------------------------------------------+---------------+
| HTTP    | Description                                      | Schema        |
| Code    |                                                  |               |
+=========+==================================================+===============+
| **200** | Successful response                              | `Application  |
|         |                                                  | <#_applicatio |
|         |                                                  | n>`__         |
+---------+--------------------------------------------------+---------------+
| **400** | put was performed but the appname was already    | No Content    |
|         | registered with the broker, or Invalid PUT body  |               |
+---------+--------------------------------------------------+---------------+

Consumes
~~~~~~~~

-  ``application/json``

Produces
~~~~~~~~

-  ``application/json``

DELETE /application/{appname}
-----------------------------

Description
~~~~~~~~~~~

Remove an app for service and configuration discovery. This will remove
the metrics and health endpoints for this app.

Parameters
~~~~~~~~~~

+----------+---------------+--------------------------------+------------------+
| Type     | Name          | Description                    | Schema           |
+==========+===============+================================+==================+
| **Path** | | **appname** | Name of the application.       | string (text)    |
|          | | *required*  |                                |                  |
+----------+---------------+--------------------------------+------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------------+----------------+
| HTTP    | Description                                        | Schema         |
| Code    |                                                    |                |
+=========+====================================================+================+
| **200** | Successful response                                | No Content     |
+---------+----------------------------------------------------+----------------+
| **404** | no app with name 'appname' registered with this    | No Content     |
|         | broker.                                            |                |
+---------+----------------------------------------------------+----------------+

GET /application/{appname}/healthcheck
--------------------------------------

Description
~~~~~~~~~~~

Perform a healthcheck on the running app appname.

Parameters
~~~~~~~~~~

+----------+---------------+--------------------------------+------------------+
| Type     | Name          | Description                    | Schema           |
+==========+===============+================================+==================+
| **Path** | | **appname** | Name of the application to get | string (text)    |
|          | | *required*  | the healthcheck for.           |                  |
+----------+---------------+--------------------------------+------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------------+----------------+
| HTTP    | Description                                        | Schema         |
| Code    |                                                    |                |
+=========+====================================================+================+
| **200** | Successful response, healthcheck pass              | No Content     |
+---------+----------------------------------------------------+----------------+
| **404** | no app with name 'appname' registered with this    | No Content     |
|         | broker, or the healthcheck has failed (though I    |                |
|         | would like to disambiguiate from the first case,   |                |
|         | CDAP returns a 404 for this).                      |                |
+---------+----------------------------------------------------+----------------+

GET /application/{appname}/metrics
----------------------------------

Description
~~~~~~~~~~~

Get live (real-time) app specific metrics for the running app appname.
Metrics are customized per each app by the component developer

Parameters
~~~~~~~~~~

+----------+---------------+--------------------------------+------------------+
| Type     | Name          | Description                    | Schema           |
+==========+===============+================================+==================+
| **Path** | | **appname** | Name of the application to get | string (text)    |
|          | | *required*  | metrics for.                   |                  |
+----------+---------------+--------------------------------+------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------------+----------------+
| HTTP    | Description                                        | Schema         |
| Code    |                                                    |                |
+=========+====================================================+================+
| **200** | Successful response                                | `MetricsObject |
|         |                                                    | <#_metricsobje |
|         |                                                    | ct>`__         |
+---------+----------------------------------------------------+----------------+
| **404** | no app with name 'appname' registered with this    | No Content     |
|         | broker.                                            |                |
+---------+----------------------------------------------------+----------------+

PUT /application/{appname}/reconfigure
--------------------------------------

Description
~~~~~~~~~~~

Reconfigures the application.

Parameters
~~~~~~~~~~

+----------+---------------+----------------------------+--------------------+
| Type     | Name          | Description                | Schema             |
+==========+===============+============================+====================+
| **Path** | | **appname** | Name of the application.   | string (text)      |
|          | | *required*  |                            |                    |
+----------+---------------+----------------------------+--------------------+
| **Body** | | **putbody** | required put body          | `reconfigput       |
|          | | *required*  |                            | <#_reconfigput>`__ |
+----------+---------------+----------------------------+--------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------------+----------------+
| HTTP    | Description                                        | Schema         |
| Code    |                                                    |                |
+=========+====================================================+================+
| **200** | Successful response                                | No Content     |
+---------+----------------------------------------------------+----------------+
| **400** | Bad request. Can happen with 1) {appname} is not   | No Content     |
|         | registered with the broker, 2) the required PUT    |                |
|         | body is wrong, or 3) the smart interface was       |                |
|         | chosen and none of the config keys match anything  |                |
|         | in app\_config or app\_preferences                 |                |
+---------+----------------------------------------------------+----------------+

Definitions
===========

Application
-----------

+---------------------+---------------------------------------------+------------------+
| Name                | Description                                 | Schema           |
+=====================+=============================================+==================+
| | **appname**       | application name                            | string           |
| | *optional*        |                                             |                  |
+---------------------+---------------------------------------------+------------------+
| | **connectionurl** | input URL that you can POST data into (URL  | string           |
| | *optional*        | of the CDAP stream)                         |                  |
+---------------------+---------------------------------------------+------------------+
| | **healthcheckurl**| fully qualified url to perform healthcheck  | string           |
| | *optional*        |                                             |                  |
+---------------------+---------------------------------------------+------------------+
| | **metricsurl**    | fully qualified url to get metrics from     | string           |
| | *optional*        |                                             |                  |
+---------------------+---------------------------------------------+------------------+
| | **service         | a list of HTTP services exposed by this     | `service\_method |
|  endpoints**        | CDAP application                            | <#_service_metho |
| | *optional*        |                                             | d>`__            |
|                     |                                             | (array)          |
+---------------------+---------------------------------------------+------------------+
| | **url**           | fully qualified url of the resource         | string           |
| | *optional*        |                                             |                  |
+---------------------+---------------------------------------------+------------------+

MetricsObject
-------------

key,value object where the key is 'appmetrics' and the value is an app
dependent json and specified by the component developer

+--------------------------------+-------------------------------------------+
| Name                           | Schema                                    |
+================================+===========================================+
| | **appmetrics**               | object                                    |
| | *optional*                   |                                           |
+--------------------------------+-------------------------------------------+

appname
-------

an application name

*Type* : string

appput
------

+-------------------------------+---------------------------------------------+--------------------+
| Name                          | Description                                 | Schema             |
+===============================+=============================================+====================+
| | **app\_config**             | the application config JSON                 | object             |
| | *optional*                  |                                             |                    |
+-------------------------------+---------------------------------------------+--------------------+
| | **app\_preferences**        | the application preferences JSON            | object             |
| | *optional*                  |                                             |                    |
+-------------------------------+---------------------------------------------+--------------------+
| | **artifact\_name**          | the name of the CDAP artifact to be added   | string             |
| | *optional*                  |                                             |                    |
+-------------------------------+---------------------------------------------+--------------------+
| | **cdap\_application\_type** | denotes whether this is a program-flowlet   | enum               |
| | *optional*                  | style application or a hydrator pipeline.   | (program-flowlet   |
|                               | For program-flowlet style apps, this value  | )                  |
|                               | must be "program-flowlet"                   |                    |
+-------------------------------+---------------------------------------------+--------------------+
| | **jar\_url**                | the URL that the JAR you’re deploying       | string             |
| | *optional*                  | resides                                     |                    |
+-------------------------------+---------------------------------------------+--------------------+
| | **namespace**               | the cdap namespace this is deployed into    | string             |
| | *optional*                  |                                             |                    |
+-------------------------------+---------------------------------------------+--------------------+
| | **program\_preferences**    |                                             | `programpref       |
| | *optional*                  |                                             | <#_programpref>`__ |
|                               |                                             | (array)            |
+-------------------------------+---------------------------------------------+--------------------+
| | **programs**                |                                             | `programs          |
| | *optional*                  |                                             | <#_programs>`__    |
|                               |                                             | (array)            |
+-------------------------------+---------------------------------------------+--------------------+
| | **services**                |                                             | `service\_endpoint |
| | *optional*                  |                                             | <#_service_endpoin |
|                               |                                             | t>`__  (array)     |
+-------------------------------+---------------------------------------------+--------------------+
| | **streamname**              | name of the CDAP stream to ingest data into | string             |
| | *optional*                  | this app. Should come from the developer    |                    |
|                               | and Tosca model.                            |                    |
+-------------------------------+---------------------------------------------+--------------------+

hydratorappput
--------------

+-----------------------------------+---------------------------------------------+---------------+
| Name                              | Description                                 | Schema        |
+===================================+=============================================+===============+
| | **cdap\_application\_TYPE**     | denotes whether this is a program-flowlet   | enum          |
|                                   | style application or a hydrator pipeline.   | (hydrator-pip |
| | *required*                      | For hydrator, this value must be            | eline)        |
|                                   | "hydrator-pipeline"                         |               |
+-----------------------------------+---------------------------------------------+---------------+
| | **dependencies**                | represents a list of dependencies to be     | `hydratordep  |
| | *optional*                      | loaded for this pipeline. Not required.     | <#_hydratorde |
|                                   |                                             | p>`__ (array) |
+-----------------------------------+---------------------------------------------+---------------+
| | **namespace**                   | the cdap namespace this is deployed into    | string        |
| | *required*                      |                                             |               |
+-----------------------------------+---------------------------------------------+---------------+
| | **pipeline\_config\_json\_url** | the URL of the config.json for this         | string        |
| | *required*                      | pipeline                                    |               |
+-----------------------------------+---------------------------------------------+---------------+
| | **streamname**                  | name of the CDAP stream to ingest data into | string        |
| | *required*                      | this app. Should come from the developer    |               |
|                                   | and Tosca model.                            |               |
+-----------------------------------+---------------------------------------------+---------------+

hydratordep
-----------

represents a hydrator pipeline dependency. An equivalent to the
following CURLs are formed with the below four params shown in CAPS::

   curl -v -w"\\n" -X POST
   http://cdapurl:11015/v3/namespaces/setelsewhere/artifacts/ARTIFACT_NAME
   -H "Artifact-Extends:ARTIFACT\_EXTENDS\_HEADER" -H
   “Artifact-Version:ARTIFACT\_VERSION\_HEADER” –data-binary @(DOWNLOADED
   FROM ARTIFACT\_URL)","curl -v -w"\\n" -X PUT
   http://cdapurl:11015/v3/namespaces/setelsewhere/artifacts/ARTIFACT_NAME/versions/ARTIFACT_VERSION_HEADER/properties
   -d (DOWNLOADED FROM UI\_PROPERTIES\_URL)"

+---------------------------------+---------------------------------------------+----------+
| Name                            | Description                                 | Schema   |
+=================================+=============================================+==========+
| | **artifact\_extends\_header** | the value of the header that gets passed in | string   |
| | *required*                    | for artifact-extends, e.g.,                 |          |
|                                 | "Artifact-Extends:system:cdap-data-pipeline |          |
|                                 | [4.0.1,5.0.0)"                              |          |
+---------------------------------+---------------------------------------------+----------+
| | **artifact\_name**            | the name of the artifact                    | string   |
| | *required*                    |                                             |          |
+---------------------------------+---------------------------------------------+----------+
| | **artifact\_url**             | the URL of the artifact JAR                 | string   |
| | *required*                    |                                             |          |
+---------------------------------+---------------------------------------------+----------+
| | **artifact\_version\_header** | the value of the header that gets passed in | string   |
| | *required*                    | for artifact-version, e.g.,                 |          |
|                                 | "Artifact-Version:1.0.0-SNAPSHOT"           |          |
+---------------------------------+---------------------------------------------+----------+
| | **ui\_properties\_url**       | the URL of the properties.json if the       | string   |
| | *optional*                    | custom artifact has UI properties. This is  |          |
|                                 | optional.                                   |          |
+---------------------------------+---------------------------------------------+----------+

info
----

some broker information

+------------------+---------------------------------------------+-----------+
| Name             | Description                                 | Schema    |
+==================+=============================================+===========+
| | **broker API   | the API version of this running broker      | string    |
|  version**       |                                             |           |
| | *optional*     |                                             |           |
+------------------+---------------------------------------------+-----------+
| | **cdap GUI     | The GUI port of the CDAP cluster this       | integer   |
|  port**          | broker is managing. Mostly to help users of |           |
| | *optional*     | this API check their application in cdap.   |           |
|                  | Note, will return UNKNOWN\_CDAP\_VERSION if |           |
|                  | it cannot be determined.                    |           |
+------------------+---------------------------------------------+-----------+
| | **cdap         | the version of the CDAP cluster this broker | string    |
|  cluster         | is managing. Note, will return              |           |
|  version**       | UKNOWN\_CDAP\_VERSION if it cannot be       |           |
| | *optional*     | determined.                                 |           |
+------------------+---------------------------------------------+-----------+
| | **managed cdap | the url of the CDAP cluster API this broker | string    |
|  url**           | is managing                                 |           |
| | *optional*     |                                             |           |
+------------------+---------------------------------------------+-----------+
| | **number       |                                             | integer   |
|  of applications |                                             |           |
|  registered**    |                                             |           |
| | *optional*     |                                             |           |
+------------------+---------------------------------------------+-----------+
| | **uptime (s)** |                                             | integer   |
| | *optional*     |                                             |           |
+------------------+---------------------------------------------+-----------+

multideleteput
--------------

+--------------------------------+----------------------------------+
| Name                           | Schema                           |
+================================+==================================+
| | **appnames**                 | `appname <#_appname>`__  (array) |
| | *optional*                   |                                  |
+--------------------------------+----------------------------------+

programpref
-----------

the list of programs in this CDAP app

+--------------+---------------------------------------------+----------+
| Name         | Description                                 | Schema   |
+==============+=============================================+==========+
| | **program\ | the name of the program                     | string   |
|  _id**       |                                             |          |
| | *optional* |                                             |          |
+--------------+---------------------------------------------+----------+
| | **program_ | the preference JSON to set for this program | object   |
|  \pref**     |                                             |          |
| | *optional* |                                             |          |
+--------------+---------------------------------------------+----------+
| | **program\ | must be one of flows, mapreduce, schedules, | string   |
|  _type**     | spark, workflows, workers, or services      |          |
| | *optional* |                                             |          |
+--------------+---------------------------------------------+----------+

programs
--------

the list of programs in this CDAP app

+--------------+---------------------------------------------+-----------+
| Name         | Description                                 | Schema    |
+==============+=============================================+===========+
| | **program\ | the name of the program                     | string    |
|  _id**       |                                             |           |
| | *optional* |                                             |           |
+--------------+---------------------------------------------+-----------+
| | **program\ | must be one of flows, mapreduce, schedules, | string    |
|  _type**     | spark, workflows, workers, or services      |           |
| | *optional* |                                             |           |
+--------------+---------------------------------------------+-----------+

reconfigput
-----------

+-----------------------------+-----------------------------+------------------+
| Name                        | Description                 | Schema           |
+=============================+=============================+==================+
| | **config**                | the config JSON             | object           |
| | *required*                |                             |                  |
+-----------------------------+-----------------------------+------------------+
| | **reconfiguration\_type** | the type of reconfiguration | enum             |
| | *required*                |                             | (program-flowlet |
|                             |                             | -app-config,     |
|                             |                             | program-flowlet- |
|                             |                             | app-preferences, |
|                             |                             | program-flowlet- |
|                             |                             | smart)           |
+-----------------------------+-----------------------------+------------------+

returncode
----------

an httpreturncode

*Type* : integer

service\_endpoint
-----------------

descirbes a service endpoint, including the service name, the method
name, and the method type (GET, PUT, etc, most of the time will be GET)

+--------------------------+-----------------------------------------+---------+
| Name                     | Description                             | Schema  |
+==========================+=========================================+=========+
| | **endpoint\_method**   | GET, POST, PUT, etc                     | string  |
| | *optional*             |                                         |         |
+--------------------------+-----------------------------------------+---------+
| | **service\ _endpoint** | the name of the endpoint on the service | string  |
| | *optional*             |                                         |         |
+--------------------------+-----------------------------------------+---------+
| | **service\_name**      | the name of the service                 | string  |
| | *optional*             |                                         |         |
+--------------------------+-----------------------------------------+---------+

service\_method
---------------

a URL and HTTP method exposed via a CDAP service

+--------------+---------------------------------------------+----------+
| Name         | Description                                 | Schema   |
+==============+=============================================+==========+
| | **method** | HTTP method you can perform on the URL,     | string   |
| | *optional* | e.g., GET, PUT, etc                         |          |
+--------------+---------------------------------------------+----------+
| | **url**    | the fully qualified URL in CDAP for this    | string   |
| | *optional* |                                             |          |
+--------------+---------------------------------------------+----------+
