.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 ONAP Contributors. All rights reserved.

.. _doc_guide_user_des_param_assign:

VNF Parameter resolution templating
===================================

Overview
--------

When instantiating a Service composed of PNF, VNF or CNF there is the need to
get some values for some parameters.

For example, it may be necessary to provide a VNF management @ip
Address or a VNF instance name. Those parameters can be necessary
to create cloud resources or to configure the VNF at application level.

The initial implementation of ONAP required operators to provide
preload data spreadsheet for each PNF/VNF/CNF Instance that is being
instantiated via ONAP which was error prone and was not operationally
a scalable solution for telcos. As part of the ONAP CDS component introduction
in Casablanca release, the user, that wants to instantiate a new VNF/CNF,
does not need to get and provide those data.

Of course the “user” may be a human but may be also an application that uses
the “instantiation” API on ONAP NBI or ONAP SO.

ONAP CDS component is then in charge of resolving those parameters
automatically.

.. toctree::
   :maxdepth: 1
   :titlesonly:

   Full CDS documentation is here <../../../../submodules/ccsdk/cds.git/docs/index.rst>

It offers automated solution out of the box by delivering network intent
declarative package during design time phase that automated the provisioning
and/or network configuration network intent.

At instantiation time, CDS controller will find (assign) the values
according some “recipies” described in a "Controller Blueprint Archive”:
a collection of files that CDS controller will use to proceed
parameter resolution.

Thanks to CDS, at instantiation time, the user, that wants to instantiate
a new VNF, does not need to get and provide those data himself.
Of course the “user” may be a human but may be also
an application that uses the “instantiation” API on ONAP NBI or ONAP SO.

Less effort for the “user”, but more effort for the “designer”
that needs to pre-defined all necessary recipies
during design time.

The purpose of the following text is to describe various files and content
that are necessary to the CDS controller to resolve any parameters.

To illustrate the subject, let's take an example: a service composed of
a freeradius VNF.

That software will be installed on a simple ubuntu image.


Design process
--------------

    * `Step 1 : identify the parameters needed for instantiation`_
    * `Step 2: identify the parameters needed for post-instantiation`_
    * `Step 3: identify the data source for each parameter`_
    * `Step 4: add new data definition in CDS resource dictionary`_
    * `Step 5: write template files`_
    * `Step 6: write mapping files`_
    * `Step 7: write scripts`_
    * `Step 8: write the "CDS blueprint" file`_
    * `Step 9: build the "Controller Blueprint Archive” (cba)`_
    * `Step 10: attached the cba to a service definition`_
    * `Step 11: distribute the service`_
    * `Step 12: instantiate the service and check`_


Step 1 : identify the parameters needed for instantiation
---------------------------------------------------------

To instantiate a freeradius VNF, a Heat Template can be used. Several
parameters are defined in that template: vnf_name, image_name,
management @ip...

This Heat Template is a first place to find the parameters that need
to be resolved.

Our example:

::

   parameters:
   # Metadata required by ONAP
   vnf_id: FreeRadius-VNF
   vf_module_id: FreeRadius-VF-module
   vnf_name: FreeRadius-VNF-name

   # Server parameters, naming required by ONAP
   image_name: ubuntu-16.04-daily
   flavor_name: onap.small
   pub_key: ssh-rsa AAAAB3Nza...UwMtE0oHV47zQABx root@qvocrobot-virtual-machine
   key_name: FreeRadius-key
   freeRadius_name_0: FreeRadius-VM-name
   freeradius_ip: 10.0.0.100

   # Network parameters, naming required by ONAP
   onap_private_net_id: admin
   public_net_id: admin


In the following section, only part of those parameters will be automated
by CDS (just for illustration).

- vnf_name
- flavor_name
- pub_key
- image_name
- freeradius_ip

In real, all parameters need to be  processed
(or at least those that change from one VNF instance to the other)

Step 2: identify the parameters needed for post-instantiation
-------------------------------------------------------------

Also, a freeradius VNF is software that will be able to accept or reject
some connection requests. Only declared "users" can be accepted by
the freeradius.

To be able to proceed, it is necessary to declare (=configure) some "users"
in a file located in /etc/freeradius/users in the VM where the freeradius
software is installed.

At this step, the designer needs to know the VNF specificities. It is
application-level parameters. For example: configure a firewall rule in
a firewall VNF, declare a "user" in a AAA radius VNF...

In the freeradius example (an opensource AAA radius solution),
the following parameters can be automated via CDS:

- user_name
- user_password

Step 3: identify the data source for each parameter
---------------------------------------------------

The parameter list that the Designer decided to automate:

- vnf_name
- flavor_name
- pub_key
- image_name
- freeradius_ip
- user_name
- user_password

Here after the decision/solution that the designer may take:

**vnf_name** will be resolved using a "naming" application (micro-service),
provided by ONAP.

**image_name** will be resolved via a default value in the template

**flavor_name** will be resolved via an input that will be provided
in the instantiation request.

**pub_key** will be resolved via an input that will be provided
in the instantiation request.

**freeradius_ip** will be resolved using an IP Address Management (IPAM)
application, provided by ONAP (Netbox).

**user_name** and **user_password** will be resolved via inputs
that will be provided in the instantiation request.

Step 4: add new data definition in CDS resource dictionary
----------------------------------------------------------

In CDS, there is a database that will contain all resource Definitions
in order to be able to re-use those resources.

Service Designer needs to check about existing resources in the disctionary.

By default, some resources are pre-loaded when installing ONAP platform.

Preloaded resources (parameter definition): Resources_.

For the freeradius use-case, there are 3 resources to add
in the resource dictionary:

::

   curl -k 'https://cds-ui:30497/resourcedictionary/save' -X POST -H 'Content-type: application/json' \
   -d '{
      "name": "radius_test_user",
      "tags": "radius_test_user",
      "data_type": "string",
      "description": "radius_test_user",
      "entry_schema": "string",
      "updatedBy": "Seaudi, Abdelmuhaimen <abdelmuhaimen.seaudi@orange.com>",
      "definition": {
         "tags": "radius_test_user",
         "name": "radius_test_user",
         "property": {
            "description": "radius_test_user",
            "type": "string"
         },
         "updated-by": "Seaudi, Abdelmuhaimen <abdelmuhaimen.seaudi@orange.com>",
         "sources": {
            "input": {
               "type": "source-input"
            },
            "default": {
               "type": "source-default",
               "properties": {}
            },
            "sdnc": {
               "type": "source-rest",
               "properties": {
                  "verb": "GET",
                  "type": "JSON",
                  "url-path": "/restconf/config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/radius_test_user",
                  "path": "/param/0/value",
                  "input-key-mapping": {
                     "service-instance-id": "service-instance-id",
                     "vnf-id": "vnf-id"
                  },
                  "output-key-mapping": {
                     "radius_test_user": "value"
                  },
                  "key-dependencies": ["service-instance-id",
                  "vnf-id"]
               }
            }
         }
      }
   }'


::

   curl -k 'https://cds-ui:30497/resourcedictionary/save' -X POST -H 'Content-type: application/json' \
   '{
      "name": "radius_test_password",
      "tags": "radius_test_password",
      "data_type": "string",
      "description": "radius_test_password",
      "entry_schema": "string",
      "updatedBy": "Seaudi, Abdelmuhaimen <abdelmuhaimen.seaudi@orange.com>",
      "definition": {
         "tags": "radius_test_password",
         "name": "radius_test_password",
         "property": {
            "description": "radius_test_password",
            "type": "string"
         },
         "updated-by": "Seaudi, Abdelmuhaimen <abdelmuhaimen.seaudi@orange.com>",
         "sources": {
            "input": {
               "type": "source-input"
            },
            "default": {
               "type": "source-default",
               "properties": {}
            },
            "sdnc": {
               "type": "source-rest",
               "properties": {
                  "verb": "GET",
                  "type": "JSON",
                  "url-path": "/restconf/config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/radius_test_password",
                  "path": "/param/0/value",
                  "input-key-mapping": {
                     "service-instance-id": "service-instance-id",
                     "vnf-id": "vnf-id"
                  },
                  "output-key-mapping": {
                     "radius_test_password": "value"
                  },
                  "key-dependencies": ["service-instance-id",
                  "vnf-id"]
               }
            }
         }
      }
   }'


::

   curl -k 'https://cds-ui:30497/resourcedictionary/save' -X POST -H 'Content-type: application/json' \
   '{
      "name": "freeradius_ip",
      "tags": "freeradius_ip",
      "data_type": "string",
      "description": "freeradius_ip",
      "entry_schema": "string",
      "updatedBy": "Seaudi, Abdelmuhaimen <abdelmuhaimen.seaudi@orange.com>",
      "definition": {
         "tags": "freeradius_ip",
         "name": "freeradius_ip",
         "property": {
            "description": "freeradius_ip",
            "type": "string"
         },
         "updated-by": "Seaudi, Abdelmuhaimen <abdelmuhaimen.seaudi@orange.com>",
         "sources": {
            "input": {
               "type": "source-input"
            },
            "default": {
               "type": "source-default",
               "properties": {}
            },
            "sdnc": {
               "type": "source-rest",
               "properties": {
                  "verb": "GET",
                  "type": "JSON",
                  "url-path": "/restconf/config/GENERIC-RESOURCE-API:services/service/$service-instance-id/service-data/vnfs/vnf/$vnf-id/vnf-data/vnf-topology/vnf-parameters-data/param/freeradius_ip",
                  "path": "/param/0/value",
                  "input-key-mapping": {
                     "service-instance-id": "service-instance-id",
                     "vnf-id": "vnf-id"
                  },
                  "output-key-mapping": {
                     "freeradius_ip": "value"
                  },
                  "key-dependencies": ["service-instance-id",
                  "vnf-id"]
               }
            }
         }
      }
   }'



Step 5: write template files
----------------------------

In this example, Designer needs to create 3 "templates".

- VNF level :download:`VNF_template_file <freeradius_example/before_enrichment/CBA_freeradius/Templates/vnf-template.vtl>`
- VFmodule level :download:`VFmodule_template_file <freeradius_example/before_enrichment/CBA_freeradius/Templates/radius-template.vtl>`
- post-instantiation VNF level :download:`VNF_config_template_file <freeradius_example/before_enrichment/CBA_freeradius/Templates/userconfig-template.vtl>`

CDS makes use of "velocity template" or "Jinja template" files.

This way, CDS is able to generate the desired datastructure
with resolved values, that will then be sent to the target system:

- openstack when instantiating the VNF/VF-module
- instantiated VNF when doing some post-instantiation operation

There are two sections in each velocity file:

- "resource-accumulator-resolved-data": a list of all parameters
- "capability-data": a list of "capabilities" to process and resolv a parameter

ONAP SDNC provides some "capabilities":

- generate-name
- vlan-tag-assign
- netbox-ip-assign
- aai-vnf-put
- ...

There is an SDNC Directed Graph associated to each of those "capability".

Service Designer needs to know about those capabilitie with their
input/output, in order to re-use them.

In case, Service Designer wants to use a new capability, a solution will be
to create a Directed Graph and update the Self-serve-vnf-assign and/or
Self-serve-vf-module-assign Directed Graph by adding a new
entry in the list of capabilities (node: set ss.capability.execution-order[])

|image3|

Step 6: write mapping files
---------------------------

Along with each velocity template, Designer needs to create a
"mapping" file.

This is the place where the Designer explains, for each parameter:

- value source: the system or database that will provide the value
- default value

At VNF instantiation step, values are often coming from input (in the request
sent by the user).

At VF module instantion step, values are often coming from SDNC database
(stored values from VNF instantiation step).

Resolved data are always stored in SDNC database (MDSAL)

About sources:

- "input": parameter/value is provided in the request
- "sdnc": parameter/value is coming from the SDNC database (MDSAL)
  via a Rest call
- "default": always take the default value
- "processor-db": coming from SDNC but MariaDB database via SQL request

Other sources are possible.

For the freeradius example, there are then 3 mapping files:

- VNF level :download:`VNF_mapping_file <freeradius_example/before_enrichment/CBA_freeradius/Templates/vnf-mapping.json>`
- VFmodule level :download:`VFmodule_mapping_file <freeradius_example/before_enrichment/CBA_freeradius/Templates/radius-mapping.json>`
- post-instantiation VNF level :download:`VNF_config_mapping_file <freeradius_example/before_enrichment/CBA_freeradius/Templates/userconfig-mapping.json>`

Step 7: write scripts
---------------------

Sometimes, it will be necessary to use some scripts (python, kotlin,
ansible...) to process some operation.

Those scripts needs to be part of the "Controller Blueprint Archive” (cba).

In freeradius example, a :download:`Kotlin script <freeradius_example/before_enrichment/CBA_freeradius/Scripts/kotlin/kotlin.kt>` is used
to get data, open an ssh tunnel to the VNF and add the user/password
in the /etc/freeradius/users file.

Step 8: write the "CDS blueprint" file
--------------------------------------

The "designer" will then create a "CDS blueprint".

It is a JSON file and for the freeradius usecase, it is called
freeradius.json.

This file will be the main entry point for CDS controller
to understand what need to be processed and how to process it.

The content of that file is composed of several sections conforming to TOSCA
specifications.

Part of the file is provided by the Service Designer but it will them be
automatically completed by CDS controller via an "enrichment" operation
(see next step)

|image1|

In a short, this file will contain information about:

- any parameters or external sources needed to resolve parameters,
- all the resolve actions needed during the instantiation of a service,
- any post-instantiation steps that need to run after the service
  instance is up and running
- all necessary template files

For the freeradius example, here is the :download:`CDS blueprint <freeradius_example/before_enrichment/CBA_freeradius/Definitions/freeradius.json>`
before enrichment.

Step 9: build the "Controller Blueprint Archive” (cba)
------------------------------------------------------

Having created velocity templates, mapping files, scripts and a first
CDS blueprint version,
it is now simple to create the "Controller Blueprint Archive” (cba).

This is a "zip-like" archive file that will have the following structure
and content:

|image2|

For the freeradius example, here is the :download:`cba archive <freeradius_example/before_enrichment/CBA_freeradius.cba>` before enrichment.

To complete that cba, an "enrichment" operation is needed.

Service Designer can use two methods:

- using CDS User Interface
- using CDS rest API

Service Designer needs to send the cba to CDS-UI pod and requests
the enrichment.

Here is the example using CDS-UI rest API:

::

   curl -X POST \
   https://cds-ui:30497/controllerblueprint/enrich-blueprint \
   -H 'Accept: application/json, text/plain, */*' \
   -H 'Accept-Encoding: gzip, deflate, br' \
   -H 'Accept-Language: en-US,en;q=0.9,ar;q=0.8,fr;q=0.7' \
   -H 'Cache-Control: no-cache' \
   -H 'Connection: keep-alive' \
   -H 'Content-Length: 16488' \
   -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryamjjRAAflAzY4XR5' \
   -H 'Host: cds-ui:30497' \
   -H 'Origin: https://cds-ui:30497' \
   -H 'Postman-Token: 5e895c04-577a-4610-97e6-5d3881fd96c5,508c40d9-65da-47bc-a3a8-038d64f44a94' \
   -H 'Referer: https://cds-ui:30497/blueprint' \
   -H 'Sec-Fetch-Mode: cors' \
   -H 'Sec-Fetch-Site: same-origin' \
   -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.70 Safari/537.36' \
   -H 'cache-control: no-cache' \
   -H 'content-type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW' \
   -F 'file=@/home/user/dev/CBA_freeradius.cba' -k

Result will be that the cba will contains several new files in "Definition"
folder of the cba. Also, the CDS blueprint file (freeradius.json) will
be completed.

The cba is now ready to be onboarded in ONAP SDC along with
a service definition.

For the freeradius example, here is the :download:`cba archive <freeradius_example/after_enrichment/CBA_freeradius.cba>` after enrichment.

Step 10: attached the cba to a service definition
-------------------------------------------------

In SDC, when defining a service, Designer will attach the cba archive
to the service definition, using the "deployment" section.

Note that the template_name and template_version are to be added to the
service model in SDC under assignment parameters section, and this will
tell SO which blueprint to use for the service model that is being
instantiated.

SDC sdnc_artifact_name = CBA blueprint json filename, e.g. “vnf”,
we will see below that we will have vnf-mapping.json and vnf-template.vtl
templates in the blueprint.

SDC sdnc_model_name = CBA Metadata template_name, e.g. “test”,
we can see in the below screenshot the metadata section showing template name.

SDC sdnc_model_verion = CBA Metadata template_version, e.g. “1.0.0”,
we can see in the below screenshot the metadata section showing
template version.

|image4|

Step 11: distribute the service
-------------------------------

In SDC, when distributing the service, the CDS controller will be
informed that a new cba archive is available.

CDS controller will then collect the cba archive.

Step 12: instantiate the service and check
------------------------------------------

Here is the ONAP SO api request to instantiate the freeradius service:

::

   curl -X POST \
   http://84.39.34.234:30277/onap/so/infra/serviceInstantiation/v7/serviceInstances \
   -H 'Accept: */*' \
   -H 'Accept-Encoding: gzip, deflate' \
   -H 'Authorization: Basic SW5mcmFQb3J0YWxDbGllbnQ6cGFzc3dvcmQxJA==' \
   -H 'Cache-Control: no-cache' \
   -H 'Connection: keep-alive' \
   -H 'Content-Length: 4581' \
   -H 'Content-Type: application/json' \
   -H 'Cookie: JSESSIONID=DAFA0915D8D644A5E01BB499A1769365' \
   -H 'Host: 84.39.34.234:30277' \
   -H 'Postman-Token: 02273554-69e5-426b-83ce-675462a14436,eea8e2dc-fbce-45ac-82d7-19fdca83804a' \
   -H 'User-Agent: PostmanRuntime/7.19.0' \
   -H 'cache-control: no-cache' \
   -d '{
   "requestDetails": {
      "subscriberInfo": {
         "globalSubscriberId": "Demonstration"
      },
      "requestInfo": {
         "suppressRollback": false,
         "productFamilyId": "a9a77d5a-123e-4ca2-9eb9-0b015d2ee0fb",
         "requestorId": "adt",
         "source": "VID"
      },
      "cloudConfiguration": {
         "lcpCloudRegionId": "fr1",
         "tenantId": "6270eaa820934710960682c506115453",
         "cloudOwner":"CloudOwner"
      },
      "requestParameters": {
         "subscriptionServiceType": "vLB",
         "userParams": [
         {
            "Homing_Solution": "none"
         },
         {
            "service": {
               "instanceParams": [
               ],
               "resources": {
               "vnfs": [
                  {
                     "modelInfo": {
                  "modelName": "freeradius5",
                  "modelVersionId": "f7538c8d-c27c-46f9-8c2c-f01eb2a19bfa",
                  "modelInvariantUuid": "cd322f8b-0496-4126-b3d6-200adceaf11f",
                  "modelVersion": "1.0",
                  "modelCustomizationId": "bc976d7c-bf2c-4da5-9b6b-815d9ea22b92",
                  "modelInstanceName": "freeradius5 0"
                     },
                     "cloudConfiguration": {
                     "lcpCloudRegionId": "fr1",
                     "tenantId": "6270eaa820934710960682c506115453"
                     },
                     "platform": {
                     "platformName": "test"
                     },
                     "lineOfBusiness": {
                     "lineOfBusinessName": "LOB-Demonstration"
                     },
                     "productFamilyId": "a9a77d5a-123e-4ca2-9eb9-0b015d2ee0fb",
                     "instanceName": "freeradius5 0",
                     "instanceParams": [
                     {
                        "onap_private_net_id": "olc-onap",
                        "onap_private_subnet_id": "olc-onap",
                        "pub_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs84Cy8+qi/jvucay0BwFtOq3ian0ulTXFGxkZcZCR0N48j88pbHJaEqb9e25MAsrfH+7Etb9Kd5nbBThEL/i0AyHXnDsc80Oq0sqlLcfLo3SGSurkrNoRofHboJ5Hn+N9SlWN5FCQGbTx1w3rjqR4LasAI6XxH9xpXSFyyge6ysVXH0cYaZ8sg98nFZa1fPJR9L8COjZvF+EYudub2RC5HVyV/sx7bliNFo9JwQh6du1abG4G7ZDjTIcYwYp21iq52UzWU28RVcAyY6AQZJu2lHLdsr8fPvyeWZpC5EqGsxI1G609m9G/dURRKwYfez/f2ATzpn5QjEX7LrLWBM8r Generated-by-Nova",
                        "image_name": "Ubuntu 16.04",
                        "flavor_name":"n1.cw.standard-1",
                        "sec_group":"olc-open",
                        "cloud_env":"openstack",
                        "public_net_id": "olc-public",
                        "aic-cloud-region": "fr1",
                        "key_name":"olc-key",
                        "vf-naming-policy": "SDNC_Policy.Config_MS_ONAP_VNF_NAMING_TIMESTAMP",
                        "radius_test_user": "Rene-Robert",
                        "radius_test_password": "SecretPassword"
                     }
                     ],
                     "vfModules": [
                     {
                        "modelInfo": {
                           "modelName": "Freeradius5..radius..module-0",
                           "modelVersionId": "e08d6d0f-27ea-4b46-a2d1-0d60c49fca59",
                           "modelInvariantUuid": "fdb408c6-6dd1-4a0c-88ca-ebc3ff77b445",
                           "modelVersion": "1",
                           "modelCustomizationId": "e82a94de-6dff-4dc9-a57e-335315c8fdae"
                        },
                        "instanceName": "Freeradius5..radius..module-0",
                        "instanceParams": [
                                                   {  }
                        ]
                     }
                     ]
                  }
               ]
               },
               "modelInfo": {
               "modelVersion": "1.0",
         "modelVersionId": "4dacb612-935f-4755-91a1-78af64331c42",
         "modelInvariantId": "98d65302-3be3-4828-a116-1bedb2919048",
         "modelName": "freeradius5",
               "modelType": "service"
               }
            }
         }
         ],
         "aLaCarte": false
      },
      "project": {
         "projectName": "Project-Demonstration"
      },
      "owningEntity": {
         "owningEntityId": "67f2e84c-734d-4e90-a1e4-d2ffa2e75849",
         "owningEntityName": "OE-Demonstration"
      },
      "modelInfo": {
         "modelVersion": "1.0",
         "modelVersionId": "4dacb612-935f-4755-91a1-78af64331c42",
         "modelInvariantId": "98d65302-3be3-4828-a116-1bedb2919048",
         "modelName": "freeradius5",
      "modelType": "service"
      }
   }
   }'

.. |image1| image:: ../media/cds-blueprint.png
.. |image2| image:: ../media/cba.png
.. |image3| image:: ../media/capabilities.png
.. |image4| image:: ../media/sdc.png
.. _Resources: https://git.onap.org/ccsdk/cds/tree/components/model-catalog/resource-dictionary/starter-dictionary 
