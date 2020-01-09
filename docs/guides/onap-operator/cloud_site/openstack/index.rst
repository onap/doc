.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.  http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.


Adding a new Openstack Cloud Site to ONAP
=========================================

The following guide describes how to configure ONAP to be able to instantiate
a service in a new cloud site based on Openstack.

There are 2 methods for ONAP to communicate with Openstack in order
to instantiate a service:

* method 1 : ONAP SO => Openstack
* method 2 : ONAP SO => ONAP MultiCloud => Openstack

In this guideline the following parameters/values will be used

* Complex Name: My_Complex
* Region Name: ONAPCloudRegionName
* Openstack Tenant Region Value: TenantRegion
* Cloud Owner: MyCompanyName


Method 1 : without ONAP MultiCloud
----------------------------------

TO BE DESCRIBED



Method 2 : using ONAP MultiCloud
--------------------------------

STEP 1 : declare Cloud Site in ONAP SO to interact with ONAP multiCloud
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MariaDB database of ONAP SO needs to be modified.

In the ONAP SO, the use of ONAP Multicloud for that Cloud Site needs to be
indicated.

ONAP SO will communicate with ONAP MultiCloud that interfaces target cloud
environment. Two configuration options are offered:

* First option: Declare multicloud URL in identity_services table

  * Openstack tenant credentials are still managed by SO
  * Openstack tenant region value is checked against Region_ID value in
    cloud_sites

* Second option (from Dublin version): Target solution managing all Openstack
  tenant information within AAI

  * ORCHESTRATOR value is set to `multicloud` in cloud_sites table
  * All Openstack tenant information are stored in AAI and managed by
    multicloud

Connect to ONAP SO pod
^^^^^^^^^^^^^^^^^^^^^^

In a Unix Terminal, to get the SO pods id that is providing
the MariaDB database:

::

  kubectl -n onap get pod | grep mariadb-galera

To connect to that SO pod
(in this example, the SO pod id is "onap-mariadb-galera-mariadb-galera-0"):

::

  kubectl -n onap exec -ti onap-mariadb-galera-mariadb-galera-0 sh

Then modify the data in the MariaDB:


A "mso_id" and "mso_pass" are required even if, with multicloud,
only credentials managed by ESR will be used.

Nevertheless, you need to provide a correct encrypted value for the pass value.

"MyCompanyName" is a cloud owner value. WARNING : do not use underscore
in the value.

"ONAPCloudRegionName" is the ONAP region name that can be different from
final Openstack tenant region name (TenantRegion in the example).
*** know restriction ****
Check status of https://jira.onap.org/projects/MULTICLOUD/issues/MULTICLOUD-970

::

  mysql --user=so_admin --password=so_Admin123
  USE catalogdb

  # First option: Without using ORCHESTRATOR VALUE set to multicloud
  INSERT INTO identity_services VALUES('MC_KEYSTONE', 'http://msb-iag.onap:80/api/multicloud/v1/MyCompanyName/ONAPCloudRegionName/identity/v2.0', 'admin', '5b6f369745f5f0e1c61da7f0656f3daf93c8030a2ea94b7964c67abdcfb49bdf2fa2266344b4caaca1eba8264d277831', 'service', 'admin', 1, 'KEYSTONE', 'USERNAME_PASSWORD', 'lastUser', '2019-07-05 10:32:00', '2019-07-05 10:32:00','PROJECT_DOMAIN_NAME','USER_DOMAIN_NAME');
  INSERT INTO cloud_sites VALUES('ONAPCloudRegionName', 'TenantRegion', 'MC_KEYSTONE', 2.5, 'ONAPCloudRegionName', NULL, NULL, NULL, 'MySelf', '2019-07-05 10:32:00', '2019-07-05 10:32:00');

  # Second option: using ORCHESTRATOR VALUE set to multicloud from Dublin version
  INSERT INTO cloud_sites(ID, REGION_ID, IDENTITY_SERVICE_ID, CLOUD_VERSION, CLLI, ORCHESTRATOR) values("ONAPCloudRegionName", "ONAPCloudRegionName", "DEFAULT_KEYSTONE", "2.5", "My_Complex", "multicloud");


**Known restriction with second option**

See the following tickets:

* `MULTICLOUD-846 <https://jira.onap.org/browse/MULTICLOUD-846>`_
* `MULTICLOUD-866 <https://jira.onap.org/browse/MULTICLOUD-866>`_

ONAP SO VNF Adapter Rest API endpoint version shall be set to version "v2"
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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




STEP 2 : declare the new cloud Site in ONAP AAI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


declare a Complex in ONAP AAI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


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
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


To declare a Cloud Site, you need to use the AAI REST API.

The new Cloud site is named "ONAPCloudRegionName" in this example.

There is also a "Cloud Owner" notion in ONAP AAI datamodel.

The new Cloud Owner is named "MyCompanyName" in this example.

In Openstack, there is also a "region" notion. You need to get the value of
the region that has been set when deploying your Openstack platform.

In the following example the Openstack region has the value "TenantRegion"
(in the parameter "cloud-extra-info")

parameter "complex-name" relate to the Complex you previously declared.

parameter "cloud-type" take the value "openstack"

parameter "cloud-region-version" is refering to your Openstack version

parameter "cloud-extra-info" will contain the Openstack "region".
Here, the region ID of the deployed Openstack cloud site will be set.

In the following example the Openstack region has the value "TenantRegion".

parameter "esr-system-info-list" will contain the list of Openstack platform
credentials that will allow ONAP MultiCloud to communicate with the Cloud Site.


::

  curl -X PUT \
  https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/cloud-infrastructure/cloud-regions/cloud-region/MyCompanyName/ONAPCloudRegionName \
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
      "cloud-region-id": "ONAPCloudRegionName",
      "cloud-type": "openstack",
      "owner-defined-type": "N/A",
      "cloud-region-version": "pike",
      "complex-name": "My_Complex",
      "cloud-zone": "CloudZone",
      "sriov-automation": false,
      "identity-url": "WillBeUpdatedByMultiCloud",
      "cloud-extra-info":"{\"openstack-region-id\":\"TenantRegion\"}",
      "esr-system-info-list": {
          "esr-system-info": [
              {
              "esr-system-info-id": "<random UUID, e.g. 5c85ce1f-aa78-4ebf-8d6f-4b62773e9bde>",
              "service-url": "http://<your openstack keystone endpoint, e.g. http://10.12.25.2:5000/v3>",
              "user-name": "<your openstack user>",
              "password": "<your openstack password>",
              "system-type": "VIM",
              "ssl-insecure": false,
              "cloud-domain": "Default",
              "default-tenant": "<your openstack project name>",
              "system-status": "active"
              }
          ]
        }
      }' -k

In this example, the cloud-region-version is set to `pike` that is the
Openstack pike version.

* Multicloud pike plugin is claimed to support Openstack pike
* It is possible but not guaranteed to support other Openstack version
  (e.g. rocky) since no testing has been done by multicloud project on all
  other Openstack versions.
* Whatever the Openstack version is tested against, if the cause of a bug roots
  in Openstack pike source code, this bug shall be reported.
* `starlingx` is another possible version value for Openstack clouds.

Associate Cloud site to a Complex in ONAP AAI:

::

  curl -X PUT \
    https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/cloud-infrastructure/cloud-regions/cloud-region/MyCompanyName/ONAPCloudRegionName/relationship-list/relationship \
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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

  curl -X POST \
  https://msb.api.discovery.simpledemo.onap.org:30283/api/multicloud/v1/MyCompanyName/ONAPCloudRegionName/registry \
  -H 'Accept: application/json' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \


check registration:

::

  curl -X GET \
  https://aai.api.sparky.simpledemo.onap.org:30233/aai/v16/cloud-infrastructure/cloud-regions/cloud-region/MyCompanyName/ONAPCloudRegionName?depth=all \
  -H 'Accept: application/json' \
  -H 'Authorization: Basic QUFJOkFBSQ==' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'Real-Time: true' \
  -H 'X-FromAppId: jimmy-postman' \
  -H 'X-TransactionId: 9999' -k

The registration is successfull if at least, the field `identity-url` is
updated with the multicloud http url. In addition, all the cloud information
are loaded in AAI (Flavors, images, etc) but only

* if ORCHESTRATOR value is set to `multicloud` in cloud_sites database table
* and if the Openstack cloud is configured to support only keystone v2 or v3
  having the version set in the service url. Multicloud pike and starlingx
  plugins do not support an Openstack cloud that exposes both v2 and v3.

::

  openstack endpoint list --service keystone
  +----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------------+
  | ID                               | Region    | Service Name | Service Type | Enabled | Interface | URL                               |
  +----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------------+
  | 53c0016ad22144b2883b3a9487206a4b | RegionOne | keystone     | identity     | True    | public    | https://specific_url:5000/v3      |
  | 85a7a334353a4b028d8005a454b6578f | RegionOne | keystone     | identity     | True    | admin     | http://10.x.x.9:35357/v3          |
  | 8d5274cd66884ec7b0e3edd965a53f69 | RegionOne | keystone     | identity     | True    | internal  | http://10.x.x.9:5000/v3           |
  +----------------------------------+-----------+--------------+--------------+---------+-----------+-----------------------------------+
