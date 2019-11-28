.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 ONAP Contributors. All rights reserved.

.. _doc_guide_user_des_param_assign:

VNF Parameter resolution templating
===================================

Overview
--------

When instantiating a Service composed of connectivity, PNF,
VNF or CNF there is the need to set the parameter values for the
created instances.

For example, it may be necessary to provide a VNF management @ip
Address or a VNF instance name. Those parameters can be necessary
to create cloud resources or to configure the VNF at application level.

In the first releases of ONAP the operator needed to provide these parameters
as preload data via datasheet or API call before instantiating each
PNF/VNF/CNF.
This was an error-prone manual step that interferes with an automated and
scalable service instantiation.
As part of the ONAP CDS component introduction
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
an "ubuntu" VNF. That service will be called "ubuntuCDS" in ONAP SDC
for that example.

That VNF will be based on a simple ubuntu image. That VF will be called
ubuntuCDS in ONAP SDC for that example.

WARNING: all operations need to be adapted to your context
(platform, service, identifiers...)

Pre-requisite
-------------

There are two problems with ONAP ElAlto release:

**wrong Directed Graphs**

In ONAP Elalto, a problem was detected about Directed Graphs: JIRA_SDNC_949_

The workaround is to upload/replace the following two Directed Graph in SDNC
(via DG Builder UI for example).

VNF topology assign: DG_VNF_ASSIGN_.

VF-Module topology assign: DG_VFMODULE_ASSIGN_.


**wrong URL in CDS-UI pod**

CDS-UI pod needs to communicate with CDS BluePrint processor to perform
"enrichment", "publish", "deploy" operations.

The URL is not correct in the OOM file used to deploy CDS UI.

If you have permission, you can change the url via:

::

   kubectl edit deployment -n onap {{cds ui pod id}}

API_BLUEPRINT_CONTROLLER_HTTP_BASE_URL parameter must have the following value

::

   http://cds-blueprints-processor-http:8080/api/v1


Those problems should be corrected in next ONAP release.

Design process
--------------

    * `Step 1: identify the parameters needed for instantiation`_
    * `Step 2: identify the parameters needed for post-instantiation`_
    * `Step 3: identify the resolution method for each parameter`_
    * `Step 4: add new data definition in CDS resource dictionary`_
    * `Step 5: write template files`_
    * `Step 6: write mapping files`_
    * `Step 7: write scripts`_
    * `Step 8: write the "blueprint" file`_
    * `Step 9: build the "Controller Blueprint Archive” (cba)`_
    * `Step 10: attached the cba to a service definition`_
    * `Step 11: distribute the service`_
    * `Step 12: instantiate the service and check`_


Step 1: identify the parameters needed for instantiation
--------------------------------------------------------

To instantiate an "ubuntu" VNF, a Heat Template can be used. Several
parameters are defined in that template: vnf_name, image_name,
management @ip...

This Heat Template is a first place to identify the parameters that need
to be resolved.

Our example:

::

   parameters:
   # Metadata required by ONAP
   vnf_id: ubuntuCDS-VNF
   vf_module_id: ubuntuCDS-VF-module
   vnf_name: ubuntuCDS-VNF-name

   # Server parameters, naming required by ONAP
   ubuntuCDS_image_name: ubuntu-18
   ubuntuCDS_flavor_name: onap.small
   ubuntuCDS_pub_key: ssh-rsa AAAAB3VHCx...vVL8l1BrX3BY0R8D imported-openssh-key
   ubuntuCDS_name_0: ubuntuCDS

   # Network parameters, naming required by ONAP
   admin_plane_net_name: admin

Step 2: identify the parameters needed for post-instantiation
-------------------------------------------------------------

Post-instantiation activity will occur after the VNF is instantiated.

Typically, it can be adding a first firewall rule in a firewall VNF.

In the ubuntuCDS example, there is no such parameter.


Step 3: identify the resolution method for each parameter
---------------------------------------------------------

Here after the decision/solution that the designer may take:

**vnf_name** will be resolved via an input that will be provided
in the instantiation request.

**ubuntuCDS_image_name** will be resolved via an input that will be provided
in the instantiation request.

**ubuntuCDS_flavor_name** will be resolved via an input that will be provided
in the instantiation request.

**ubuntuCDS_pub_key** will be resolved via an input that will be provided
in the instantiation request.

**admin_plane_net_name** will be resolved via an input that will be provided
in the instantiation request.

Service Designer needs also to know that some parameters will be
automatically resolved by ONAP SO and/or ONAP SDNC.

- service-instance-id
- vnf-id
- vf_module_id

For each resolution method, Service Designer needs to identify all
necessary parameters that must be provided to the resoluton method
in order to obtain the resolution.

Also, Service Designer needs to know that ONAP will instantiate
a service, a list of VNF that are composing the service and, for each VNF,
a "VF-module" will be instantiated.


Step 4: add new data definition in CDS resource dictionary
----------------------------------------------------------

In CDS, there is a database that will contain all resource Definitions
in order to be able to re-use those resources from one service to an other.

Service Designer needs to check about existing resource definitions
in the dictionary.

By default, some resources are pre-loaded when installing ONAP platform.

Preloaded resources (parameter definition): Resources_.

Be careful: the content of the resource dictionary is not the same from
one ONAP release to an other.

If Service Designer sees that there is an existing parameter
that corresponds to the need, he has the possibility to re-use it
in the mapping file(s), but maybe with a different name.

For example, "image_name" is already defined in the resource dictionary but,
it is named "freeRadius_image_name" in the Heat files.

For the ubuntuCDS example, there is no need to add any entry in the
data_dictionary

"curls" requests example to declare a new resource
:download:`Here <ubuntu_example/curls_resource_dictionary.txt>`

Step 5: write template files
----------------------------

In this Ubuntu example, Designer needs to create 2 "templates" files.
Naming of those files is important. For VNF, prefix name must be equal to the
VF name in ONAP SDC. For the VFmodule, prefix name must be equal to the name
of the Heat template.

- VNF level :download:`VNF_template_file <ubuntu_example/cba-before-enrichment/Templates/ubuntuCDS-template.vtl>`
- VF-module level :download:`VFmodule_template_file <ubuntu_example/cba-before-enrichment/Templates/base_ubuntuCDS-template.vtl>`

CDS makes use of "velocity template" or "Jinja template" files.

This way, CDS is able to generate the desired datastructure
with resolved values, that will then be sent to the target system:

- openstack when instantiating the Heat stack
- instantiated VNF when doing some post-instantiation operation

There are two sections in each velocity file:

- "resource-accumulator-resolved-data": a list of all parameters
- "capability-data": a list of "capabilities" to process and resolve
  a parameter

A capability can be an other way to resolve a parameter,
using a directed graph.

A capability may also be an action to be performed such as modifying
a data in ONAP AAI.

ONAP SDNC provides those "capabilities":

- generate-name
- vlan-tag-assign
- netbox-ip-assign
- aai-vnf-put
- ...

There is an SDNC Directed Graph associated to each of those "capability".

Service Designer needs to know about those capabilities with their
input/output, in order to re-use them. Especially, Service Designer needs
to know inputs because those inputs need to be part of the templates.

In case Service Designer wants to use a new capability, a solution is
to create a Directed Graph and update the self-serve-vnf-assign and/or
self-serve-vf-module-assign Directed Graph by adding a new
entry in the list of capabilities (node: set ss.capability.execution-order[])

The "aai-vfmodule-put" capability is important to be part of a vf-module
template because it will be used to put the vf-module-name in AAI
and ONAP SO will use that value to name the heat stack.

|image3|


About the name/value of each parameter, Service Designer needs to understand
how various information will map between the various files needed by CDS.

|image5|

And be very careful with "_" or "-"

Step 6: write mapping files
---------------------------

Along with each velocity template, Designer needs to create a
"mapping" file.

This is the place where the Designer explains, for each parameter:

- value source: the system or database that will provide the value
- default value

At VNF instantiation step, values are often coming from input (in the request
sent by the user, in the "instanceParams" section of the vnf).

At VF module instantion step, values can come form input also in the request
sent by the user, in the "instanceParams" section of the vf-module)

Resolved data are always stored in SDNC database (MDSAL)

Note1: if service designer wants to re-use for vf-module a
parameter/value from VNF "userParams" section,
then the source will be from "SDNC" in the vf-module mapping file.

Note2: service-instance-id, vnf-id and vf_module_id are parameters considered
as "input" from CDS point of view but in reality they are resolved by ONAP SO
with ONAP AAI. Thus, those parameters are not "input" from ONAP SO
point of view: service designer has not need to provide those parameters in
service instantiation request (step 12).

For the ubuntu example, there are then 2 mapping files.
File names are important and must be aligned with vtl template names.

- VNF level :download:`VNF_mapping_file <ubuntu_example/cba-before-enrichment/Templates/ubuntuCDS-mapping.json>`
- VFmodule level :download:`VFmodule_mapping_file <ubuntu_example/cba-before-enrichment/Templates/base_ubuntuCDS-mapping.json>`

Step 7: write scripts
---------------------

Sometimes, it will be necessary to use some scripts (python, kotlin,
ansible...) to process some post-configuration operation.

Those scripts needs to be part of the "Controller Blueprint Archive” (cba).

No such script for the ubuntuCDS example.


Step 8: write the "blueprint" file
--------------------------------------

The "designer" will then create a "blueprint".

It is a JSON file and for the ubuntuCDS usecase, it is called
ubuntuCDS.json.
Name must be aligned with VF name in ONAP SDC.

This file will be the main entry point for CDS blueprint processor.
This processor will use that file to understand what need to
be processed and how to process it.

The content of that file is composed of several sections conforming to TOSCA
specifications.

|image1|

For the ubuntu example :download:`CDS blueprint <ubuntu_example/cba-before-enrichment/Definitions/ubuntuCDS.json>` before enrichment.

This example is the minimum that is required to simply instantiate a
VNF.

Some extension can then be added in order to define additional
operations.

Step 9: build the "Controller Blueprint Archive” (cba)
------------------------------------------------------

Having created velocity templates, mapping files and a first
CDS blueprint version,
it is now simple to create the "Controller Blueprint Archive” (cba).

This is a "zip-like" archive file that will have the following structure
and content ("environment", "scripts" and "plans" are optional):

|image2|

For the ubuntu example :download:`cba archive <ubuntu_example/cba-before-enrichment/cba-ubuntuCDS-before-enrichment.zip>` before enrichment.

To complete that cba, an "enrichment" operation is needed.

Service Designer can use two methods:

- using CDS User Interface
- using CDS rest API

Service Designer needs to send the cba to CDS-UI pod and requests
the enrichment, then save and then download.

Result will be that the cba will now contains several new files in "Definition"
folder of the cba.

The "blueprint" file will also be completed.

The "enriched" cba is now ready to be onboarded in ONAP SDC along with
a service definition.

For the ubuntu example :download:`cba archive <ubuntu_example/cba-after-enrichment/cba-ubuntuCDS-enriched.zip>` after enrichment.

Step 10: attached the cba to a service definition
-------------------------------------------------

In SDC, when defining a VF, Designer will attach the cba archive
to the VF definition, using the "deployment artifact" section.

Having define all necessary VF, Service Designer will create a SERVICE in SDC.

Service Designer will compose the SERVICE with appropriate VF(s) and will have
to modify PROPERTIES in the "properties assignement" section.

Service Designer needs to provide values for sdnc_artifact_name,
sdnc_model_name and sdnc_model_verion.

This will tell SO which blueprint to use for the service model that is being
instantiate

SDC sdnc_artifact_name = CBA blueprint json filename, e.g. “ubuntuCDS”,
we will see below that we will have vnf-mapping.json and vnf-template.vtl
templates in the blueprint.

SDC sdnc_model_name = CBA Metadata template_name, e.g. “ubuntuCDS”,
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

Here is an example of an ONAP SO api request to
instantiate the ubuntu service.

This request is used to instantiate a service using the "Macro" mode.

Do not try to use that example as-is: you need to adapt all values to your
platform/service model.

In this example, the request contains several "inputs" at VNF level and
several "inputs" at VF-module level.

All various "id" and "version" are some copy/paste information that
Service Designer has the possibility to find in the TOSCA service
template created in ONAP SDC.

This request will instantiate a "service", a "VNF" and a "VF-module".
That "service" instance is attached to the customer named "JohnDoe" with
service subscription named "ubuntCDS"
(supposed already declared in your ONAP AAI).

In case the instantiation fails, a roolback is performed (parameter
"suppressRollback" = false)

For that example, no "homing" and the "cloud" tenant is explicitely
provided (supposed already declared in your ONAP AAI)

::

   curl -X POST \
   http://so.api.simpledemo.onap.org:30277/onap/so/infra/serviceInstantiation/v7/serviceInstances \
   -H 'Accept: application/json' \
   -H 'Authorization: Basic SW5mcmFQb3J0YWxDbGllbnQ6cGFzc3dvcmQxJA==' \
   -H 'Content-Type: application/json' \
   -H 'X-ONAP-PartnerName: NBI' \
   -H 'cache-control: no-cache' \
   -d '{
      "requestDetails": {
         "subscriberInfo": {
               "globalSubscriberId": "JohnDoe"
         },
         "requestInfo": {
               "suppressRollback": false,
               "productFamilyId": "Useless_But_Mandatory",
               "requestorId": "adt",
               "instanceName": "My_ubuntuCDS_service_instance_001",
               "source": "VID"
         },
         "cloudConfiguration": {
               "lcpCloudRegionId": "RegionOne",
               "tenantId": "71cf9d931d9e4b8e9fcca50d97c1cf96",
               "cloudOwner": "ONAP"
         },
         "requestParameters": {
               "subscriptionServiceType": "ubuntuCDS",
               "userParams": [
                  {
                     "Homing_Solution": "none"
                  },
                  {
                     "service": {
                           "instanceParams": [],
                           "instanceName": "My_ubuntuCDS_service_instance_001",
                           "resources": {
                              "vnfs": [
                                 {
                                       "modelInfo": {
                                          "modelName": "ubuntuCDS",
                                          "modelVersionId": "c6a5534e-76d5-4128-97bf-ad3b72208d53",
                                          "modelInvariantUuid": "ed3064e7-62c0-494c-bb9b-4f56d1ad157e",
                                          "modelVersion": "1.0",
                                          "modelCustomizationId": "6a32fb56-191e-4d11-a0cc-44b779aba4fc",
                                          "modelInstanceName": "ubuntuCDS 0"
                                       },
                                       "cloudConfiguration": {
                                          "lcpCloudRegionId": "RegionOne",
                                          "tenantId": "71cf9d931d9e4b8e9fcca50d97c1cf96"
                                       },
                                       "platform": {
                                          "platformName": "Useless_But_Mandatory"
                                       },
                                       "productFamilyId": "Useless_But_Mandatory",
                                       "instanceName": "My_VNF_ubuntuCDS_instance_001",
                                       "instanceParams": [
                                          {
                                             "vnf_name": "My_VNF_ubuntuCDS_instance_001"
                                          }
                                       ],
                                       "vfModules": [
                                          {
                                             "modelInfo": {
                                                   "modelName": "Ubuntucds..base_ubuntuCDS..module-0",
                                                   "modelVersionId": "3025cd36-b170-4667-abb1-2bae1f297844",
                                                   "modelInvariantUuid": "0101f9e0-7beb-4b58-92c7-ba3324b5a54d",
                                                   "modelVersion": "1",
                                                   "modelCustomizationId": "9bca4d4b-e27c-4652-a61e-b1b4ebca503d"
                                             },
                                             "instanceName": "My_vfModule_ubuntuCDS_instance_001",
                                             "instanceParams": [
                                                   {
                                                      "vnf_name": "My_VNF_ubuntuCDS_instance_001",
                                                      "vf_module_name": "My_vfModule_ubuntuCDS_instance_001",
                                                      "ubuntuCDS_pub_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDY15cdBmIs2XOpe4EiFCsaY6bmUmK/GysMoLl4UG51JCfJwvwoWCoA+6mDIbymZxhxq9IGxilp/yTA6WQ9s/5pBag1cUMJmFuda9PjOkXl04jgqh5tR6I+GZ97AvCg93KAECis5ubSqw1xOCj4utfEUtPoF1OuzqM/lE5mY4N6VKXn+fT7pCD6cifBEs6JHhVNvs5OLLp/tO8Pa3kKYQOdyS0xc3rh+t2lrzvKUSWGZbX+dLiFiEpjsUL3tDqzkEMNUn4pdv69OJuzWHCxRWPfdrY9Wg0j3mJesP29EBht+w+EC9/kBKq+1VKdmsXUXAcjEvjovVL8l1BrX3BY0R8D imported-openssh-key",
                                                      "ubuntuCDS_image_name": "ubuntu-18.04-daily",
                                                      "ubuntuCDS_flavor_name": "onap.small",
                                                      "ubuntuCDS_name_0": "ubuntuCDS-VM-001",
                                                      "admin_plane_net_name": "admin"
                                                   }
                                             ]
                                          }
                                       ]
                                 }
                              ]
                           },
                           "modelInfo": {
                              "modelVersion": "1.0",
                              "modelVersionId": "10369444-1e06-4d5d-974b-362bcfd19533",
                              "modelInvariantId": "32e00b49-eff8-443b-82a8-b75fbb6e3867",
                              "modelName": "ubuntuCDS",
                              "modelType": "service"
                           }
                     }
                  }
               ],
               "aLaCarte": false,
               "usePreload": false
         },
         "owningEntity": {
               "owningEntityId": "Useless_But_Mandatory",
               "owningEntityName": "Useless_But_Mandatory"
         },
         "modelInfo": {
               "modelVersion": "1.0",
               "modelVersionId": "10369444-1e06-4d5d-974b-362bcfd19533",
               "modelInvariantId": "32e00b49-eff8-443b-82a8-b75fbb6e3867",
               "modelName": "ubuntuCDS",
               "modelType": "service"
         }
      }
   }'

In response, ONAP SO will immediately provide a requestId and a service
instance id.

The instantiation will take some time. It will be necessary
to perform a "GET" on the request to check the result.

::

   curl -X GET \
      http://so.api.simpledemo.onap.org:30277/onap/so/infra/orchestrationRequests/v7/{{requestID}} \
      -H 'Accept: application/json' \
      -H 'Authorization: Basic SW5mcmFQb3J0YWxDbGllbnQ6cGFzc3dvcmQxJA==' \
      -H 'Content-Type: application/json' \
      -H 'X-FromAppId: AAI' \
      -H 'X-TransactionId: get_aai_subscr' \
      -H 'cache-control: no-cache'

Trouble shooting
----------------

Have a look to

- debug.log in CDS blueprint processor Pod
- debug.log into SO Bpmn pod
- karaf.log into SDNC pod

.. |image1| image:: ../media/cds-blueprint.png
.. |image2| image:: ../media/cba.png
.. |image3| image:: ../media/capabilities.png
.. |image4| image:: ../media/sdc.png
.. |image5| image:: ../media/mapping.png
.. _JIRA_SDNC_949: https://jira.onap.org/browse/SDNC-949
.. _Resources: https://git.onap.org/ccsdk/cds/tree/components/model-catalog/resource-dictionary/starter-dictionary
.. _DG_VNF_ASSIGN: https://gerrit.onap.org/r/gitweb?p=sdnc/oam.git;a=blob_plain;f=platform-logic/generic-resource-api/src/main/json/GENERIC-RESOURCE-API_vnf-topology-operation-assign.json;hb=HEAD
.. _DG_VFMODULE_ASSIGN: https://gerrit.onap.org/r/gitweb?p=sdnc/oam.git;a=blob_plain;f=platform-logic/generic-resource-api/src/main/json/GENERIC-RESOURCE-API_vf-module-topology-operation-assign.json;hb=HEAD
