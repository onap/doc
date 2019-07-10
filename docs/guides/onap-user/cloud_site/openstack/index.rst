.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.  http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.


Adding a new Openstack Cloud Site to ONAP
=========================================

The following guide describe how to configure ONAP to be able to instantiate
a service in a new cloud site based on Openstack.


STEP 1 : declare Cloud Site in ONAP SO to interact with ONAP multiCloud
-----------------------------------------------------------------------

You need to modify some information in the MariaDB database of ONAP SO.
In the ONAP SO, we need to indicate that SO will have to use ONAP Multicloud
for that any Cloud Site.

ONAP SO will communicate with ONAP MultiCloud like if MultiCloud would be
an Openstack system.


Connect to ONAP SO pod

In a Unix Terminal, to get the SO pods id that is providing
the MariaDB database:

::

  kubectl -n onap get pod | grep mariadb-galera

To connect to that SO pod
(in this example, the SO pod id is "onap-mariadb-galera-mariadb-galera-0"):

::

  kubectl -n onap exec -ti onap-mariadb-galera-mariadb-galera-0 sh

Then modify the data in the MariaDB:


A "mso_id" and "mso_pass" are required but not really used.
Nevertheless, you need to provide a correct encrypted value for the pass value.

"MyCompanyName" is a cloud owner value. WARNING : do not use underscore
in the value.

"INTEGRATION_CENTER" is the region name

::

  mysql --user=so_admin --password=so_Admin123
  USE catalogdb
  INSERT INTO identity_services VALUES('MC_KEYSTONE', 'http://msb-iag.onap:80/api/multicloud/v1/MyCompanyName_INTEGRATION_CENTER/identity/v2.0', 'admin', '5b6f369745f5f0e1c61da7f0656f3daf93c8030a2ea94b7964c67abdcfb49bdf2fa2266344b4caaca1eba8264d277831', 'service', 'admin', 1, 'KEYSTONE', 'USERNAME_PASSWORD', 'Thierry', '2019-07-05 10:32:00', '2019-07-05 10:32:00');
  INSERT INTO cloud_sites VALUES('INTEGRATION_CENTER', 'INTEGRATION_CENTER', 'MC_KEYSTONE', 2.5, 'INTEGRATION_CENTER', NULL, NULL, NULL, 'MySelf', '2019-07-05 10:32:00', '2019-07-05 10:32:00');


You need then to change the ONAP SO VNF Adapter Rest API endpoint version:

in a unix terminal:

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


STEP 2 : declare the new cloud Site in ONAP AAI
-----------------------------------------------


declare a Complex in ONAP AAI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A Cloud Site is located in a Building called "Complex" in ONAP AAI datamodel.

To declare a Complex, you need to use the AAI REST API.

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




declare a Cloud Site in ONAP AAI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To declare a Cloud Site, you need to use the AAI REST API.

Here is an example using "curl" tool to send the API request.

The new Cloud site is named "INTEGRATION_CENTER" in this example.

There is also a "Cloud Owner" notion in ONAP AAI datamodel.

The new Cloud Owner is named "MyCompanyName" in this example.

In Openstack, there is also a "region" notion. You need to get the value of
the region that has been set when deploying your openstack platform

In the following example the openstack region has the value "RegionOne"
(in the parameter "cloud-extra-info")

parameter "complex-name" relate to the Complex you previously declared.

parameter "cloud-type" take the value "openstack"

parameter "cloud-region-version" is refering to your openstack version

parameter "cloud-extra-info" will contain the Openstack "region".
You need to get the value of the region that has been set when deploying
the openstack Cloud site you want to connect to ONAP.

In the following example the openstack region has the value "RegionOne".

parameter "esr-system-info-list" will contain the list of openstack platform
credentials that will allow ONAP MultiCloud to communicate with the Cloud Site.


::

  curl -X PUT \
  https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/cloud-infrastructure/cloud-regions/cloud-region/MyCompanyName/INTEGRATION_CENTER \
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
      "cloud-region-id": "INTEGRATION_CENTER",
      "cloud-type": "openstack",
      "owner-defined-type": "N/A",
      "cloud-region-version": "pike",
      "complex-name": "My_Complex",
      "cloud-zone": "CloudZone",
      "sriov-automation": false,
      "identity-url": "WillBeUpdatedByMultiCloud",
      "cloud-extra-info":"{\"openstack-region-id\":\"RegionOne\"}"
      "esr-system-info-list": {
          "esr-system-info": [
              {
              "esr-system-info-id": "<random UUID, e.g. 5c85ce1f-aa78-4ebf-8d6f-4b62773e9bde>",
              "service-url": "http://<your openstack keystone endpoint, e.g. http://10.12.25.2:5000/v3>",
              "user-name": "<your openstack user>",
              "password": "<your openstack password>",
              "system-type": "VIM",
              "ssl-insecure": true,
              "cloud-domain": "Default",
              "default-tenant": "<your openstack project name>",
              "system-status": "active"
              }
          ]
        }
      }' -k


Associate Cloud site to a Complex in ONAP AAI:


::

  curl -X PUT \
    https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/cloud-infrastructure/cloud-regions/cloud-region/MyCompanyName/INTEGRATION_CENTER/relationship-list/relationship \
    -H 'Accept: application/json' \
    -H 'Authorization: Basic QUFJOkFBSQ==' \
    -H 'Content-Type: application/json' \
    -H 'X-FromAppId: AAI' \
    -H 'X-TransactionId: 808b54e3-e563-4144-a1b9-e24e2ed93d4f' \
    -H 'cache-control: no-cache' \
    -d '{
      "related-to": "complex",
      "related-link": "/aai/v16/cloud-infrastructure/complexes/complex/My_Complex",
      "relationship-data": [
          {
          "relationship-key": "complex.physical-location-id",
          "relationship-value": "My_Complex"
          }
          ]
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



STEP 3 : Register the Cloud Site in ONAP Multicloud
---------------------------------------------------

Warning : in the query, you need to put the CloudOwner value
(here "MyCompanyName") and the Cloud Site value (here : INTEGRATION_CENTER),
attached with an underscore.


::

  curl -X POST \
  http://msb.api.discovery.simpledemo.onap.org:30280/api/multicloud/v0/MyCompanyName_INTEGRATION_CENTER/registry \
  -H 'Accept: application/json' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \


check registration:

::

  curl -X GET \
  https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/cloud-infrastructure/cloud-regions/cloud-region/MyCompanyName/INTEGRATION_CENTER?depth=all \
  -H 'Accept: application/json' \
  -H 'Authorization: Basic QUFJOkFBSQ==' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'Real-Time: true' \
  -H 'X-FromAppId: jimmy-postman' \
  -H 'X-TransactionId: 9999' -k
