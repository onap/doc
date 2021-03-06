.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 ONAP Contributors.  All rights reserved.

.. _doc_guide_user_ser_inst_so1:


A La Carte mode Service Instantiation via ONAP SO API
=====================================================

Using ONAP SO API in "A La Carte" mode, the user needs to send
a request to instantiate the service object but also for each VNF/VF-module
and network that compose the Service.

ONAP will instantiate resources on Cloud platforms only when user is requesting
to instantiate VF-module or Network (openstack neutron or contrail).

To instantiate a VF-module, it is required to have instantiated a VNF object.

To instantiate a VNF object, it is required to have instantiated
a Service object.

To instantiate a Network object, it is required to have instantiated
a Service object.

**Requests**
    * `Request to instantiate Service object`_
    * `Request to instantiate VNF object`_
    * `Requests to instantiate VF-module object`_
    * `Requests to instantiate Neutron Network object`_
    * `Requests to instantiate a Contrail Network object`_


Request to instantiate Service object
-------------------------------------

Example to request a service instance directly to ONAP SO

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
      "requestInfo": {
        "instanceName": "integration_test_service_instance_001",
        "source": "VID",
        "suppressRollback": false,
        "requestorId": "demo"
      },
      "modelInfo": {
        "modelType": "service",
        "modelInvariantId": "48d7ceec-7975-406c-8b96-cb3fbdbcfa33",
        "modelVersionId": "33a99ef7-b5a3-4603-b21e-790582b4567e",
        "modelName": "integration_test_service_ubuntu16",
        "modelVersion": "1.0"
      },
          "cloudConfiguration": {
              "tenantId": "dd8fce79e74a4989a6be6b6c5e55acef",
              "cloudOwner": "cloudOwner",
              "lcpCloudRegionId": "RegionOne"
          },
      "requestParameters": {
        "userParams": [],
        "testApi": "VNF_API",
        "subscriptionServiceType": "integration_test_service_ubuntu16",
        "aLaCarte": true
      },
      "subscriberInfo": {
        "globalSubscriberId": "integration_test_customer"
      },
      "project": {
        "projectName": "integration_test_project"
      },
      "owningEntity": {
        "owningEntityId": "8874891f-5120-4b98-b452-46284513958d",
        "owningEntityName": "OE-Generic"
      }
    }
  }'


In the response, you will obtain the serviceOrderId value.

Then you have the possibility to check about the SO request
(here after the requestId=e3ad8df6-ea0d-4384-be95-bcb7dd39bbde).

This will allow you to get the serviceOrder Status (completed, failed...)

::

  curl -X GET \
    http://so.api.simpledemo.onap.org:30277/onap/so/infra/orchestrationRequests/v6/e3ad8df6-ea0d-4384-be95-bcb7dd39bbde \
    -H 'Accept: application/json' \
    -H 'Authorization: Basic SW5mcmFQb3J0YWxDbGllbnQ6cGFzc3dvcmQxJA==' \
    -H 'Content-Type: application/json' \
    -H 'X-FromAppId: AAI' \
    -H 'X-TransactionId: get_aai_subscr' \
    -H 'cache-control: no-cache'


Request to instantiate VNF object
---------------------------------

To instantiate a VNF, you need to build an other request.
All necessary parameters are available in the Tosca service template
generated by SDC when you defined your service model.

::

  curl -X POST \
    http://so.api.simpledemo.onap.org:30277/onap/so/infra/serviceInstantiation/v7/serviceInstances/7d550d9e-e1c4-4a21-a2bb-1c3ced8a8722/vnfs \
    -H 'Accept: application/json' \
    -H 'Authorization: Basic SW5mcmFQb3J0YWxDbGllbnQ6cGFzc3dvcmQxJA==' \
    -H 'Content-Type: application/json' \
    -H 'X-ONAP-PartnerName: NBI' \
    -H 'cache-control: no-cache' \
    -d '{
    "requestDetails": {
      "requestInfo": {
        "instanceName": "integration_test_vnf_instance_002",
        "source": "VID",
        "suppressRollback": false,
        "requestorId": "test",
      "productFamilyId": "1234"
      },
    "modelInfo": {
      "modelType": "vnf",
      "modelInvariantId": "661a34ce-6f76-4ebf-ad94-814a9fc8a2aa",
        "modelVersionId": "7e7d453c-0085-4df2-b4b5-91281ea2e710",
        "modelName": "integration_test_VF_ubuntu16_2",
        "modelVersion": "1.0",
        "modelCustomizationId": "342c14b4-8a24-46dd-a8c3-ff39dd7949e9",
        "modelCustomizationName": "integration_test_VF_ubuntu16_2 0"
      },
      "requestParameters": {
        "userParams": [],
        "aLaCarte": true,
      "testApi": "VNF_API"
      },
      "cloudConfiguration": {
        "lcpCloudRegionId": "RegionOne",
        "cloudOwner": "cloudOwner",
        "tenantId": "dd8fce79e74a4989a6be6b6c5e55acef"
      },
      "lineOfBusiness": {
        "lineOfBusinessName": "integration_test_LOB"
      },
      "platform": {
        "platformName": "integration_test_platform"
      },
      "relatedInstanceList": [{
        "relatedInstance": {
          "instanceId": "7d550d9e-e1c4-4a21-a2bb-1c3ced8a8722",
          "modelInfo": {
            "modelType": "service",
            "modelName": "integration_test_service_ubuntu16",
            "modelInvariantId": "48d7ceec-7975-406c-8b96-cb3fbdbcfa33",
            "modelVersion": "1.0",
            "modelVersionId": "33a99ef7-b5a3-4603-b21e-790582b4567e"
          }
        }
      }]
    }
  }

  '


Requests to instantiate VF-module object
----------------------------------------

To instantiate a VF module, you need to build two complex requests
All necessary parameters are available in the Tosca service template
generated by SDC when you defined your service model.

1st request is called a "SDNC-preload" for a VNF object and is used
to store in SDNC some VNF parameters values
that will be needed for the instantiation

::

  curl -X POST \
    https://sdnc.api.simpledemo.onap.org:30267/restconf/operations/VNF-API:preload-vnf-topology-operation \
    -H 'Accept: application/json' \
    -H 'Authorization: Basic YWRtaW46S3A4Yko0U1hzek0wV1hsaGFrM2VIbGNzZTJnQXc4NHZhb0dHbUp2VXkyVQ==' \
    -H 'Content-Type: application/json' \
    -H 'X-FromAppId: API client' \
    -H 'X-TransactionId: 0a3f6713-ba96-4971-a6f8-c2da85a3176e' \
    -H 'cache-control: no-cache' \
    -d '{
      "input": {
          "request-information": {
              "notification-url": "onap.org",
              "order-number": "1",
              "order-version": "1",
              "request-action": "PreloadVNFRequest",
              "request-id": "test"
          },
          "sdnc-request-header": {
              "svc-action": "reserve",
              "svc-notification-url": "http:\/\/onap.org:8080\/adapters\/rest\/SDNCNotify",
              "svc-request-id": "test"
          },
          "vnf-topology-information": {
              "vnf-assignments": {
                  "availability-zones": [],
                  "vnf-networks": [],
                  "vnf-vms": []
              },
              "vnf-parameters": [],
              "vnf-topology-identifier": {
                  "generic-vnf-name": "integration_test_vnf_instance_002",
                  "generic-vnf-type": "integration_test_VF_ubuntu16_2 0",
                  "service-type": "7d550d9e-e1c4-4a21-a2bb-1c3ced8a8722",
                  "vnf-name": "integration_test_vfmodule_002",
                  "vnf-type": "IntegrationTestVfUbuntu162..base_ubuntu16..module-0"
              }
          }
      }
  }'

The 2nd request is to instantiate the VF module via ONAP SO
(instance name must be identical in both requests)

::

  curl -X POST \
    http://so.api.simpledemo.onap.org:30277/onap/so/infra/serviceInstantiation/v7/serviceInstances/7d550d9e-e1c4-4a21-a2bb-1c3ced8a8722/vnfs/9764c2af-e4b0-413d-80cd-b65014ea0926/vfModules \
    -H 'Accept: application/json' \
    -H 'Authorization: Basic SW5mcmFQb3J0YWxDbGllbnQ6cGFzc3dvcmQxJA==' \
    -H 'Content-Type: application/json' \
    -H 'X-ONAP-PartnerName: NBI' \
    -H 'cache-control: no-cache' \
    -d '{
    "requestDetails": {
      "requestInfo": {
        "instanceName": "integration_test_vfmodule_002",
        "source": "VID",
        "suppressRollback": false,
        "requestorId": "test"
      },
    "modelInfo": {
      "modelType": "vfModule",
      "modelInvariantId": "273bef63-1f26-4b14-91e0-003fa203ead2",
      "modelVersionId": "7cdf75de-ff3c-4a7d-a7e0-ecbc00693e8e",
      "modelName": "IntegrationTestVfUbuntu162..base_ubuntu16..module-0",
      "modelVersion": "1",
      "modelCustomizationId": "470956aa-b739-4cdd-b114-7ce032f65b18",
      "modelCustomizationName": "IntegrationTestVfUbuntu162..base_ubuntu16..module-0"
    },
    "requestParameters": {
      "userParams": [],
      "testApi": "VNF_API",
      "usePreload": true
    },
      "cloudConfiguration": {
        "lcpCloudRegionId": "RegionOne",
        "cloudOwner": "cloudOwner",
        "tenantId": "dd8fce79e74a4989a6be6b6c5e55acef"
      },
      "relatedInstanceList": [{
        "relatedInstance": {
          "instanceId": "7d550d9e-e1c4-4a21-a2bb-1c3ced8a8722",
          "modelInfo": {
            "modelType": "service",
            "modelName": "integration_test_service_ubuntu16",
            "modelInvariantId": "48d7ceec-7975-406c-8b96-cb3fbdbcfa33",
            "modelVersion": "1.0",
            "modelVersionId": "33a99ef7-b5a3-4603-b21e-790582b4567e"
          }
        }
      },
      {
        "relatedInstance": {
          "instanceId": "9764c2af-e4b0-413d-80cd-b65014ea0926",
          "modelInfo": {
            "modelType": "vnf",
            "modelName": "integration_test_VF_ubuntu16_2",
            "modelInvariantId": "661a34ce-6f76-4ebf-ad94-814a9fc8a2aa",
            "modelVersion": "1.0",
            "modelVersionId": "7e7d453c-0085-4df2-b4b5-91281ea2e710",
            "modelCustomizationId": "342c14b4-8a24-46dd-a8c3-ff39dd7949e9",
            "modelCustomizationName": "integration_test_VF_ubuntu16_2 0"
          }
        }
      }]
    }
  }'



Requests to instantiate Neutron Network object
----------------------------------------------

To instantiate a Neutron Network, you need to build two complex request.
All necessary parameters are available in the Tosca service template
generated by SDC when you defined your service model.


1st request is the "SDNC-preload" for a neutron network object:

::

  curl -X POST \
  http://sdnc.api.simpledemo.onap.org:30202/restconf/operations/VNF-API:preload-network-topology-operation \
  -H 'Accept: application/json' \
  -H 'Authorization: Basic YWRtaW46S3A4Yko0U1hzek0wV1hsaGFrM2VIbGNzZTJnQXc4NHZhb0dHbUp2VXkyVQ==' \
  -H 'Content-Type: application/json' \
  -H 'X-FromAppId: API client' \
  -H 'X-TransactionId: 0a3f6713-ba96-4971-a6f8-c2da85a3176e' \
  -H 'cache-control: no-cache' \
  -d '{
  "input": {
    "request-information": {
      "request-id": "postman001",
      "notification-url": "http://so.onap.org",
      "order-number": "postman001",
      "request-sub-action": "SUPP",
      "request-action": "PreloadNetworkRequest",
      "source": "postman",
      "order-version": "1.0"
    },
    "network-topology-information": {
      "network-policy": [],
      "route-table-reference": [],
      "vpn-bindings": [],
      "network-topology-identifier": {
        "network-role": "integration_test_net",
        "network-technology": "neutron",
        "service-type": "my-service-2",
        "network-name": "my_network_01",
        "network-type": "Generic NeutronNet"
      },
      "provider-network-information": {
        "is-external-network": "false",
        "is-provider-network": "false",
        "is-shared-network": "false"
      },
      "subnets": [
        {
      "subnet-name": "my_subnet_01",
      "subnet-role": "OAM",
          "start-address": "192.168.90.0",
          "cidr-mask": "24",
          "ip-version": "4",
          "dhcp-enabled": "Y",
      "dhcp-start-address": "",
      "dhcp-end-address": "",
          "gateway-address": "192.168.90.1",
      "host-routes":[]
        }
              ]
    },
    "sdnc-request-header": {
      "svc-action": "reserve",
      "svc-notification-url": "http://so.onap.org",
      "svc-request-id": "postman001"
    }
  }
  }'


2nd request is to instantiate the neutron network via ONAP SO
(instance name must be identical in both requests)


::

  curl -X POST \
  http://so.api.simpledemo.onap.org:30277/onap/so/infra/serviceInstantiation/v7/95762b50-0244-4723-8fde-35f911db9263/networks \
  -H 'Accept: application/json' \
  -H 'Authorization: Basic SW5mcmFQb3J0YWxDbGllbnQ6cGFzc3dvcmQxJA==' \
  -H 'Content-Type: application/json' \
  -H 'X-FromAppId: AAI' \
  -H 'X-TransactionId: get_aai_subscr' \
  -H 'cache-control: no-cache' \
  -d '{
  "requestDetails": {
      "requestInfo": {
          "instanceName": "my_network_01",
          "source": "VID",
          "suppressRollback": false,
          "requestorId": "demo"
      },
      "modelInfo": {
          "modelType": "network",
          "modelInvariantId": "0070b65c-48cb-4985-b4df-7c67ca99cd95",
          "modelVersionId": "4f738bed-e804-4765-8d22-07bb4d11f14b",
          "modelName": "Generic NeutronNet",
          "modelVersion": "1.0",
          "modelCustomizationId": "95534a95-dc8d-4ffb-89c7-091e2c49b55d",
          "modelCustomizationName": "Generic NeutronNet 0"
      },
    "requestParameters": {
      "userParams": [],
      "aLaCarte": true,
    "testApi": "VNF_API"
    },
    "cloudConfiguration": {
      "lcpCloudRegionId": "my_cloud_site",
      "tenantId": "5906b9b8fd9642df9ba1c9e290063439"
    },
      "lineOfBusiness": {
          "lineOfBusinessName": "Test_LOB"
      },
      "platform": {
          "platformName": "Test_platform"
      },
      "relatedInstanceList": [{
          "relatedInstance": {
              "instanceId": "95762b50-0244-4723-8fde-35f911db9263",
              "modelInfo": {
                  "modelType": "service",
                  "modelName": "my_service_model_name",
                  "modelInvariantId": "11265d8c-2cc2-40e5-95d8-57cad81c18da",
                  "modelVersion": "1.0",
                  "modelVersionId": "0d463b0c-e559-4def-8d7b-df64cfbd3159"
              }
          }
      }]
    }
  }'


It is then possible to get information about that network from AAI:
replace {{virtual_link_UUID}} by the UUID of the virtual link


::

  curl -X GET \
    https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/network/l3-networks/l3-network/{{virtual_link_UUID}} \
    -H 'Accept: application/json' \
    -H 'Authorization: Basic QUFJOkFBSQ==' \
    -H 'Content-Type: application/json' \
    -H 'X-FromAppId: AAI' \
    -H 'X-TransactionId: get_aai_subscr' \
    -H 'cache-control: no-cache'


And also about subnet:

::

  curl -X GET \
    https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/network/l3-networks/l3-network/{{virtual_link_UUID}}/subnets \
    -H 'Accept: application/json' \
    -H 'Authorization: Basic QUFJOkFBSQ==' \
    -H 'Content-Type: application/json' \
    -H 'X-FromAppId: AAI' \
    -H 'X-TransactionId: get_aai_subscr' \
    -H 'cache-control: no-cache'



Requests to instantiate a Contrail Network object
-------------------------------------------------

TO BE COMPLETED
