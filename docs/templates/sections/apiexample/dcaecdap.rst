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

+---------+----------------------------------------------------+----------------+
| HTTP    | Description                                        | Schema         |
| Code    |                                                    |                |
+=========+====================================================+================+
| **200** | successful response                                | `info <#_info> |
|         |                                                    | `__            |
+---------+----------------------------------------------------+----------------+

GET /application
----------------

Description
~~~~~~~~~~~

get all applications registered with this broker

Responses
~~~~~~~~~

+---------+----------------------------------------------------+----------------+
| HTTP    | Description                                        | Schema         |
| Code    |                                                    |                |
+=========+====================================================+================+
| **200** | successful response                                | <              |
|         |                                                    | `appname <#_ap |
|         |                                                    | pname>`__      |
|         |                                                    | > array        |
+---------+----------------------------------------------------+----------------+

PUT /application\*/{appname}
----------------------------

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

+---------+-------------+--------------------------------------+------------------+
| Type    | Name        | Description                          | Schema           |
+=========+=============+======================================+==================+
| **Path* | | **appname | Name of the application.             | string (text)    |
| *       | **          |                                      |                  |
|         | | *required |                                      |                  |
|         | *           |                                      |                  |
+---------+-------------+--------------------------------------+------------------+
| **Body* | | **putbody | required put body                    | `hydratorappput  |
| *       | **          |                                      | <#_hydratorapppu |
|         | | *required |                                      | t>`__            |
|         | *           |                                      |                  |
+---------+-------------+--------------------------------------+------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------------+----------------+
| HTTP    | Description                                        | Schema         |
| Code    |                                                    |                |
+=========+====================================================+================+
| **200** | Successful response                                | `Application < |
|         |                                                    | #_application> |
|         |                                                    | `__            |
+---------+----------------------------------------------------+----------------+
| **400** | put was performed but the appname was already      | No Content     |
|         | registered with the broker, or Invalid PUT body    |                |
+---------+----------------------------------------------------+----------------+

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

+---------+-------------+--------------------------------------+------------------+
| Type    | Name        | Description                          | Schema           |
+=========+=============+======================================+==================+
| **Body* | | **postbod | required post body                   | `multideleteput  |
| *       | y**         |                                      | <#_multideletepu |
|         | | *required |                                      | t>`__            |
|         | *           |                                      |                  |
+---------+-------------+--------------------------------------+------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------------+----------------+
| HTTP    | Description                                        | Schema         |
| Code    |                                                    |                |
+=========+====================================================+================+
| **200** | successful response                                | <              |
|         |                                                    | `returncode <# |
|         |                                                    | _returncode>`_ |
|         |                                                    | _              |
|         |                                                    | > array        |
+---------+----------------------------------------------------+----------------+

GET /application/{appname}
--------------------------

Description
~~~~~~~~~~~

Returns the representation of the application resource, including the
links for healthcheck and metrics.

Parameters
~~~~~~~~~~

+---------+-------------+--------------------------------------+------------------+
| Type    | Name        | Description                          | Schema           |
+=========+=============+======================================+==================+
| **Path* | | **appname | Name of the application.             | string (text)    |
| *       | **          |                                      |                  |
|         | | *required |                                      |                  |
|         | *           |                                      |                  |
+---------+-------------+--------------------------------------+------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------------+----------------+
| HTTP    | Description                                        | Schema         |
| Code    |                                                    |                |
+=========+====================================================+================+
| **200** | Successful response                                | `Application < |
|         |                                                    | #_application> |
|         |                                                    | `__            |
+---------+----------------------------------------------------+----------------+
| **404** | no app with name 'appname' registered with this    | No Content     |
|         | broker.                                            |                |
+---------+----------------------------------------------------+----------------+

PUT /application/{appname}
--------------------------

Description
~~~~~~~~~~~

Register an app for service and configuration discovery. This will light
up a metrics and health endpoint for this app. ``appname`` is assumed to
also be the key in consul.

Parameters
~~~~~~~~~~

+---------+-------------+--------------------------------------+------------------+
| Type    | Name        | Description                          | Schema           |
+=========+=============+======================================+==================+
| **Path* | | **appname | Name of the application.             | string (text)    |
| *       | **          |                                      |                  |
|         | | *required |                                      |                  |
|         | *           |                                      |                  |
+---------+-------------+--------------------------------------+------------------+
| **Body* | | **putbody | required put body                    | `appput <#_apppu |
| *       | **          |                                      | t>`__            |
|         | | *required |                                      |                  |
|         | *           |                                      |                  |
+---------+-------------+--------------------------------------+------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------------+----------------+
| HTTP    | Description                                        | Schema         |
| Code    |                                                    |                |
+=========+====================================================+================+
| **200** | Successful response                                | `Application < |
|         |                                                    | #_application> |
|         |                                                    | `__            |
+---------+----------------------------------------------------+----------------+
| **400** | put was performed but the appname was already      | No Content     |
|         | registered with the broker, or Invalid PUT body    |                |
+---------+----------------------------------------------------+----------------+

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

+---------+-------------+--------------------------------------+------------------+
| Type    | Name        | Description                          | Schema           |
+=========+=============+======================================+==================+
| **Path* | | **appname | Name of the application.             | string (text)    |
| *       | **          |                                      |                  |
|         | | *required |                                      |                  |
|         | *           |                                      |                  |
+---------+-------------+--------------------------------------+------------------+

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

+---------+-------------+--------------------------------------+------------------+
| Type    | Name        | Description                          | Schema           |
+=========+=============+======================================+==================+
| **Path* | | **appname | Name of the application to get the   | string (test)    |
| *       | **          | healthcheck for.                     |                  |
|         | | *required |                                      |                  |
|         | *           |                                      |                  |
+---------+-------------+--------------------------------------+------------------+

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

+---------+-------------+--------------------------------------+------------------+
| Type    | Name        | Description                          | Schema           |
+=========+=============+======================================+==================+
| **Path* | | **appname | Name of the application to get       | string (test)    |
| *       | **          | metrics for.                         |                  |
|         | | *required |                                      |                  |
|         | *           |                                      |                  |
+---------+-------------+--------------------------------------+------------------+

Responses
~~~~~~~~~

+---------+----------------------------------------------------+----------------+
| HTTP    | Description                                        | Schema         |
| Code    |                                                    |                |
+=========+====================================================+================+
| **200** | Successful response                                | `MetricsObject |
|         |                                                    |  <#_metricsobj |
|         |                                                    | ect>`__        |
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

+---------+-------------+--------------------------------------+------------------+
| Type    | Name        | Description                          | Schema           |
+=========+=============+======================================+==================+
| **Path* | | **appname | Name of the application.             | string (text)    |
| *       | **          |                                      |                  |
|         | | *required |                                      |                  |
|         | *           |                                      |                  |
+---------+-------------+--------------------------------------+------------------+
| **Body* | | **putbody | required put body                    | `reconfigput <#_ |
| *       | **          |                                      | reconfigput>`__  |
|         | | *required |                                      |                  |
|         | *           |                                      |                  |
+---------+-------------+--------------------------------------+------------------+

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

+-------------+---------------------------------------------+------------------+
| Name        | Description                                 | Schema           |
+=============+=============================================+==================+
| | **appname | application name                            | string           |
| **          |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **connect | input URL that you can POST data into (URL  | string           |
| ionurl**    | of the CDAP stream)                         |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **healthc | fully qualified url to perform healthcheck  | string           |
| heckurl**   |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **metrics | fully qualified url to get metrics from     | string           |
| url**       |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **service | a list of HTTP services exposed by this     | <                |
| endpoints** | CDAP application                            | `service\_method |
| | *optional |                                             |  <#_service_meth |
| *           |                                             | od>`__           |
|             |                                             | > array          |
+-------------+---------------------------------------------+------------------+
| | **url**   | fully qualified url of the resource         | string           |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+

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

+-------------+---------------------------------------------+------------------+
| Name        | Description                                 | Schema           |
+=============+=============================================+==================+
| | **app\_co | the application config JSON                 | object           |
| nfig**      |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **app\_pr | the application preferences JSON            | object           |
| eferences** |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **artifac | the name of the CDAP artifact to be added   | string           |
| t\_name**   |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **cdap\_a | denotes whether this is a program-flowlet   | enum             |
| pplication\ | style application or a hydrator pipeline.   | (program-flowlet |
| _type**     | For program-flowlet style apps, this value  | )                |
| | *optional | must be "program-flowlet"                   |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **jar\_ur | the URL that the JAR you’re deploying       | string           |
| l**         | resides                                     |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **namespa | the cdap namespace this is deployed into    | string           |
| ce**        |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **program |                                             | <                |
| \_preferenc |                                             | `programpref <#_ |
| es**        |                                             | programpref>`__  |
| | *optional |                                             | > array          |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **program |                                             | <                |
| s**         |                                             | `programs <#_pro |
| | *optional |                                             | grams>`__        |
| *           |                                             | > array          |
+-------------+---------------------------------------------+------------------+
| | **service |                                             | <                |
| s**         |                                             | `service\_endpoi |
| | *optional |                                             | nt <#_service_en |
| *           |                                             | dpoint>`__       |
|             |                                             | > array          |
+-------------+---------------------------------------------+------------------+
| | **streamn | name of the CDAP stream to ingest data into | string           |
| ame**       | this app. Should come from the developer    |                  |
| | *optional | and Tosca model.                            |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+

hydratorappput
--------------

+-------------+---------------------------------------------+------------------+
| Name        | Description                                 | Schema           |
+=============+=============================================+==================+
| | **cdap\_a | denotes whether this is a program-flowlet   | enum             |
| pplication\ | style application or a hydrator pipeline.   | (hydrator-pipeli |
| _type**     | For hydrator, this value must be            | ne)              |
| | *required | "hydrator-pipeline"                         |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **depende | represents a list of dependencies to be     | <                |
| ncies**     | loaded for this pipeline. Not required.     | `hydratordep <#_ |
| | *optional |                                             | hydratordep>`__  |
| *           |                                             | > array          |
+-------------+---------------------------------------------+------------------+
| | **namespa | the cdap namespace this is deployed into    | string           |
| ce**        |                                             |                  |
| | *required |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **pipelin | the URL of the config.json for this         | string           |
| e\_config\_ | pipeline                                    |                  |
| json\_url** |                                             |                  |
| | *required |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **streamn | name of the CDAP stream to ingest data into | string           |
| ame**       | this app. Should come from the developer    |                  |
| | *required | and Tosca model.                            |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+

hydratordep
-----------

represents a hydrator pipeline dependency. An equivelent to the
following CURLs are formed with the below four params shown in CAPS
"curl -v -w"\\n" -X POST
http://cdapurl:11015/v3/namespaces/setelsewhere/artifacts/ARTIFACT_NAME
-H "Artifact-Extends:ARTIFACT\_EXTENDS\_HEADER" -H
“Artifact-Version:ARTIFACT\_VERSION\_HEADER” –data-binary @(DOWNLOADED
FROM ARTIFACT\_URL)","curl -v -w"\\n" -X PUT
http://cdapurl:11015/v3/namespaces/setelsewhere/artifacts/ARTIFACT_NAME/versions/ARTIFACT_VERSION_HEADER/properties
-d (DOWNLOADED FROM UI\_PROPERTIES\_URL)"

+-------------+---------------------------------------------+------------------+
| Name        | Description                                 | Schema           |
+=============+=============================================+==================+
| | **artifac | the value of the header that gets passed in | string           |
| t\_extends\ | for artifact-extends, e.g.,                 |                  |
| _header**   | "Artifact-Extends:system:cdap-data-pipeline |                  |
| | *required | [4.0.1,5.0.0)"                              |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **artifac | the name of the artifact                    | string           |
| t\_name**   |                                             |                  |
| | *required |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **artifac | the URL of the artifact JAR                 | string           |
| t\_url**    |                                             |                  |
| | *required |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **artifac | the value of the header that gets passed in | string           |
| t\_version\ | for artifact-version, e.g.,                 |                  |
| _header**   | "Artifact-Version:1.0.0-SNAPSHOT"           |                  |
| | *required |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **ui\_pro | the URL of the properties.json if the       | string           |
| perties\_ur | custom artifact has UI properties. This is  |                  |
| l**         | optional.                                   |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+

info
----

some broker information

+-------------+---------------------------------------------+------------------+
| Name        | Description                                 | Schema           |
+=============+=============================================+==================+
| | **broker  | the API version of this running broker      | string           |
|   API       |                                             |                  |
|   version** |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **cdap    | The GUI port of the CDAP cluster this       | integer          |
|   GUI       | broker is managing. Mostly to help users of |                  |
|   port**    | this API check their application in cdap.   |                  |
| | *optional | Note, will return UNKNOWN\_CDAP\_VERSION if |                  |
| *           | it cannot be determined.                    |                  |
+-------------+---------------------------------------------+------------------+
| | **cdap    | the version of the CDAP cluster this broker | string           |
|   cluster   | is managing. Note, will return              |                  |
|   version** | UKNOWN\_CDAP\_VERSION if it cannot be       |                  |
| | *optional | determined.                                 |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **managed | the url of the CDAP cluster API this broker | string           |
|   cdap      | is managing                                 |                  |
|   url**     |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **number  |                                             | integer          |
|   of        |                                             |                  |
|   applicati |                                             |                  |
| ons         |                                             |                  |
|   registere |                                             |                  |
| d**         |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **uptime  |                                             | integer          |
|   (s)**     |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+

multideleteput
--------------

+--------------------------------+-------------------------------------------+
| Name                           | Schema                                    |
+================================+===========================================+
| | **appnames**                 | < `appname <#_appname>`__ > array         |
| | *optional*                   |                                           |
+--------------------------------+-------------------------------------------+

programpref
-----------

the list of programs in this CDAP app

+-------------+---------------------------------------------+------------------+
| Name        | Description                                 | Schema           |
+=============+=============================================+==================+
| | **program | the name of the program                     | string           |
| \_id**      |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **program | the preference JSON to set for this program | object           |
| \_pref**    |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **program | must be one of flows, mapreduce, schedules, | string           |
| \_type**    | spark, workflows, workers, or services      |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+

programs
--------

the list of programs in this CDAP app

+-------------+---------------------------------------------+------------------+
| Name        | Description                                 | Schema           |
+=============+=============================================+==================+
| | **program | the name of the program                     | string           |
| \_id**      |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **program | must be one of flows, mapreduce, schedules, | string           |
| \_type**    | spark, workflows, workers, or services      |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+

reconfigput
-----------

+-------------+---------------------------------------------+------------------+
| Name        | Description                                 | Schema           |
+=============+=============================================+==================+
| | **config* | the config JSON                             | object           |
| *           |                                             |                  |
| | *required |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **reconfi | the type of reconfiguration                 | enum             |
| guration\_t |                                             | (program-flowlet |
| ype**       |                                             | -app-config,     |
| | *required |                                             | program-flowlet- |
| *           |                                             | app-preferences, |
|             |                                             | program-flowlet- |
|             |                                             | smart)           |
+-------------+---------------------------------------------+------------------+

returncode
----------

an httpreturncode

*Type* : integer

service\_endpoint
-----------------

descirbes a service endpoint, including the service name, the method
name, and the method type (GET, PUT, etc, most of the time will be GET)

+-------------+---------------------------------------------+------------------+
| Name        | Description                                 | Schema           |
+=============+=============================================+==================+
| | **endpoin | GET, POST, PUT, etc                         | string           |
| t\_method** |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **service | the name of the endpoint on the service     | string           |
| \_endpoint* |                                             |                  |
| *           |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **service | the name of the service                     | string           |
| \_name**    |                                             |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+

service\_method
---------------

a URL and HTTP method exposed via a CDAP service

+-------------+---------------------------------------------+------------------+
| Name        | Description                                 | Schema           |
+=============+=============================================+==================+
| | **method* | HTTP method you can perform on the URL,     | string           |
| *           | e.g., GET, PUT, etc                         |                  |
| | *optional |                                             |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
| | **url**   | the fully qualified URL in CDAP for this    | string           |
| | *optional | service                                     |                  |
| *           |                                             |                  |
+-------------+---------------------------------------------+------------------+
