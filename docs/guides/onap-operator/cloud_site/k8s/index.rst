.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.  http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.


Adding a Kubernetes (K8S) Cloud Site to ONAP
============================================

The following guide describes how to configure ONAP to be able to instantiate
a service in a new cloud site based on Kubernetes.

There are three major steps to configure a new k8s cloud site.

* Declare the new cloud site within SO
* Declare the new cloud site (or new Region Name) in AAI
* Multicloud registration and declaration

In this guideline the following parameters/values will be used

* Complex Name: My_Complex
* Region Name: K8S_Cloud_Region_Name
* Openstack Tenant Region Value: TenantRegion
* Cloud Owner: MyCompanyName

STEP 1 : Declare the new cloud site within SO
---------------------------------------------

Add new k8s cloud site in mariadb database
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In a Unix Terminal, to get the pod id that is providing
the MariaDB database:

::

  kubectl -n onap get pod | grep mariadb-galera

To connect to this pod
(in this example, the SO pod id is "onap-mariadb-galera-mariadb-galera-0"):

::

  kubectl -n onap exec -ti onap-mariadb-galera-mariadb-galera-0 sh

Then modify the data in the MariaDB:

::

  mysql --user=so_admin --password=so_Admin123
  USE catalogdb
  INSERT INTO cloud_sites(ID, REGION_ID, IDENTITY_SERVICE_ID, CLOUD_VERSION, CLLI, ORCHESTRATOR) values("K8S_Cloud_Region_Name", "K8S_Cloud_Region_Name", "DEFAULT_KEYSTONE", "2.5", "My_Complex", "multicloud");

ONAP SO VNF Adapter Rest API endpoint version shall be set to version "v2"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

in a unix terminal:

to find the right config map name:

::

  kubectl -n onap get configmap | grep so-so-bpmn-infra-app-configmap


to edit and change the configmap:

::

  kubectl -n onap edit configmap onap-so-so-bpmn-infra-app-configmap

in the section "vnf", modify the rest endpoint:

::

           vnf:
             endpoint: http://so-openstack-adapter.onap:8087/services/VnfAdapter
             rest:
  -            endpoint: http://so-openstack-adapter.onap:8087/services/rest/v1/vnfs
  +            endpoint: http://so-openstack-adapter.onap:8087/services/rest/v2/vnfs
           volume-groups:
             rest:
               endpoint: http://so-openstack-adapter.onapg:8087/services/rest/v1/volume-groups


Having modified the configmap, it is necessary to delete the pod bpmn-infra in
order it takes the modification into account.

to find the right pod name:

::

  kubectl get po -n onap |grep bpmn-infra


You need to find the pod that is similar to the following pod id:

"onap-so-so-bpmn-infra-79fdf6f9d5-t8qr4"


to delete the pod:

::

  kubectl -n onap delete onap-so-so-bpmn-infra-79fdf6f9d5-t8qr4


Then, wait for the pod to restart. To check:

::

  kubectl -n onap get po | grep so-so

STEP 2 : Declare the new cloud site in AAI
------------------------------------------

Declare a Complex in ONAP AAI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


A Cloud Site is located in a Building called "Complex" object
in ONAP AAI datamodel.

AAI REST API is used to declare the complex object.

Here is an example using "curl" tool to send the API request.

The new Complex is named "My_Complex" in this example.


::

  curl -X PUT \
  https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/cloud-infrastructure/complexes/complex/My_Complex \
  -H 'Accept: application/json' \
  -H 'Authorization: Basic QUFJOkFBSQ==' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'Real-Time: true' \
  -H 'X-FromAppId: jimmy-postman' \
  -H 'X-TransactionId: 9999' \
  -d '{
    "physical-location-id": "My_Complex",
    "data-center-code": "example-data-center-code-val-5556",
    "complex-name": "My_Complex",
    "identity-url": "example-identity-url-val-56898",
    "physical-location-type": "example-physical-location-type-val-7608",
    "street1": "example-street1-val-34205",
    "street2": "example-street2-val-99210",
    "city": "Beijing",
    "state": "example-state-val-59487",
    "postal-code": "100000",
    "country": "example-country-val-94173",
    "region": "example-region-val-13893",
    "latitude": "39.9042",
    "longitude": "106.4074",
    "elevation": "example-elevation-val-30253",
    "lata": "example-lata-val-46073"
    }' -k


Check the Complexes in ONAP AAI:

::

  curl -X GET \
    https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/cloud-infrastructure/complexes \
    -H 'Accept: application/json' \
    -H 'Authorization: Basic QUFJOkFBSQ==' \
    -H 'X-FromAppId: AAI' \
    -H 'X-TransactionId: 808b54e3-e563-4144-a1b9-e24e2ed93d4f' \
    -H 'cache-control: no-cache' -k

Declare a Cloud Site in ONAP AAI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To declare a Cloud Site, you need to use the AAI REST API.

The new Cloud site is named "K8S_Cloud_Region_Name" in this example.

The Cloud Owner is named "MyCompanyName" in this example.

parameter "complex-name" relates to the Complex you previously declared.

parameter "cloud-type" takes the value "k8s"

The following parameters specifying openstack cloud tenant are set with dummy
values:

* parameter "cloud-extra-info"
* parameter "esr-system-info-list"

The association to the complex object is set in the curl request to create the
k8s cloud region.

::

  curl -X PUT \
  https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/cloud-infrastructure/cloud-regions/cloud-region/MyCompanyName/K8S_Cloud_Region_Name \
  -H 'Accept: application/json' \
  -H 'Authorization: Basic QUFJOkFBSQ==' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 8b9b95ae-91d6-4436-90fa-69cb4d2db99c' \
  -H 'Real-Time: true' \
  -H 'X-FromAppId: jimmy-postman' \
  -H 'X-TransactionId: 9999' \
  -d '{
      "cloud-owner": "MyCompanyName",
      "cloud-region-id": "K8S_Cloud_Region_Name",
      "cloud-type": "k8s",
      "owner-defined-type": "t1",
      "cloud-region-version": "1.0",
      "complex-name": "My_Complex",
      "cloud-zone": "CloudZone",
      "sriov-automation": false,
      "identity-url": "",
      "cloud-extra-info":"{\"openstack-region-id\":\"TenantRegion\"}",
      "esr-system-info-list": {
          "esr-system-info": [
              {
                "esr-system-info-id": "55f97d59-6cc3-49df-8e69-926565f00066",
                "service-url": "http://10.12.25.2:5000/v3",
                "user-name": "demo",
                "password": "onapdemo",
                "system-type": "VIM",
                "ssl-insecure": true,
                "cloud-domain": "Default",
                "default-tenant": "OOF",
                "tenant-id": "6bbd2981b210461dbc8fe846df1a7808",
                "system-status": "active"
              }
          ]
        },
        "relationship-list": {
            "relationship": [
                {
                    "related-to": "complex",
                    "relationship-label": "org.onap.relationships.inventory.LocatedIn",
                    "related-link": "/aai/v13/cloud-infrastructure/complexes/complex/My_Complex",
                    "relationship-data": [
                        {
                            "relationship-key": "complex.physical-location-id",
                            "relationship-value": "My_Complex"
                        }
                    ]
                }
            ]
        }
    }' -k


Check the Cloud Site creation in ONAP AAI:

::

  curl -X GET \
    https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/cloud-infrastructure/cloud-regions \
    -H 'Accept: application/json' \
    -H 'Authorization: Basic QUFJOkFBSQ==' \
    -H 'X-FromAppId: AAI' \
    -H 'X-TransactionId: 808b54e3-e563-4144-a1b9-e24e2ed93d4f' \
    -H 'cache-control: no-cache' -k

STEP 3 : Multicloud registration and declaration
------------------------------------------------

Register k8s site in multicloud
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The k8s site (K8S_Cloud_Region_Name) associated to the cloud owner
(MyCompanyName) shall be registered in multicloud.

::

  curl -X POST \
  https://msb.api.discovery.simpledemo.onap.org:30283/api/multicloud-titaniumcloud/v1/MyCompanyName/K8S_Cloud_Region_Name/registry \
  -H 'Accept: application/json' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' -k


The registration is successfull if the answer is : 202 Accepted.

Looking at the log of windriver multicloud pod, some errors are raised due to
the fact that the pod attempts to contact the dummy openstack tenant.
::

  kubectl -n onap logs -f onap-multicloud-multicloud-windriver-77dbc6b694-t74qm -c multicloud-windriver


Declare k8s connnectivity information in multicloud
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  curl -X POST \
  https://msb.api.discovery.simpledemo.onap.org:30283/api/multicloud-k8s/v1/v1/connectivity-info \
  -i -F "metadata=<post.json;type=application/json" \
  -F file=@config/config -k

  # Content of post.json
  {
    "cloud-region" : "K8S_Cloud_Region_Name",
    "cloud-owner" :  "MyCompanyName",
    "other-connectivity-list" : {
    }
  }

  #config is the .kube/config file of your k8s cloud environment

To check that the connectivity information is correctly applied:

::

  curl -i GET \
  https://msb.api.discovery.simpledemo.onap.org:30283/api/multicloud-k8s/v1/v1/connectivity-info/K8S_Cloud_Region_Name -k
