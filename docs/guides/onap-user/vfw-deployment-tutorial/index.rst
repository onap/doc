.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright © 2017-2020 Aarna Networks, Inc.

vFW Service Deployment Tutorial
###############################

In this tutorial, we will deploy the service created in the previous Service Design tutorial onto OpenStack.
We will do so by using the VID GUI from the ONAP Portal. Login as user demo.

In this section, you will learn the following through VID GUI

* How to Instantiate a Service
* How to Instantiate a VNF
* How to Instantiate VF Module
* How to Instantiate Network

Let us start by running Robot init script

1. Run Robot init script to populate demo models.

.. code-block::

  cd ~/oom/kubernetes/robot
  ./demo-k8s.sh onap init

  Result:
  All tests must pass, below is sample output.

  Number of parameters:
  2
  KEY:
  init
  ++ kubectl --namespace onap get pods
  ++ sed 's/ .*//'
  ++ grep robot
  + POD=dev-robot-578b965f4d-vlk8b
  ++ dirname ./demo-k8s.sh
  + DIR=.
  + SCRIPTDIR=scripts/demoscript
  + ETEHOME=/var/opt/ONAP
  + '[' ']'
  ++ kubectl --namespace onap exec dev-robot-578b965f4d-vlk8b -- bash -c 'ls -1q /share/logs/ | wc -l'
  + export GLOBAL_BUILD_NUMBER=3
  + GLOBAL_BUILD_NUMBER=3
  ++ printf %04d 3
  + OUTPUT_FOLDER=0003_demo_init
  + DISPLAY_NUM=93
  + VARIABLEFILES='-V /share/config/robot_properties.py'
  + kubectl --namespace onap exec dev-robot-578b965f4d-vlk8b -- /var/opt/ONAP/runTags.sh -V /share/config/robot_properties.py
  -d /share/logs/0003_demo_init -i InitDemo   --display 93
  Starting Xvfb on display :93 with res 1280x1024x24
  Executing robot tests at log level TRACE
  ==============================================================================
  Testsuites
  ==============================================================================
  Testsuites.Demo :: Executes the VNF Orchestration Test cases including setu...
  ==============================================================================
  Initialize Customer And Models                                        | PASS |
  ------------------------------------------------------------------------------
  Initialize SO Openstack Identity For V3                               | PASS |
  ------------------------------------------------------------------------------
  Testsuites.Demo :: Executes the VNF Orchestration Test cases inclu... | PASS |
  2 critical tests, 2 passed, 0 failed
  2 tests total, 2 passed, 0 failed
  ==============================================================================
  Testsuites                                                            | PASS |
  2 critical tests, 2 passed, 0 failed
  2 tests total, 2 passed, 0 failed
  ==============================================================================
  Output:  /share/logs/0003_demo_init/output.xml
  Log:     /share/logs/0003_demo_init/log.html
  Report:  /share/logs/0003_demo_init/report.html

2. Create vFW_demo_service Instance

 A. Login into the ONAP portal as user demo / demo123456!

 |image4|

 B. Go to Home and select Virtual Infrastructure Deployment (VID) application

 |image11|

If you see VID reporting a Security failure, and the browser does not give option to Allow Exception button as below

|image22|

Apply the below workaround for the above issue

Copy the vid.api.simpledemo.onap.org:30200 from the above window, open new tab and paste the copied URL
as https://vid.api.simpledemo.onap.org:30200 and click on Advanced then click on Accept the Risk and Continue tab

|image13|

Then Close the tab, go to the ONAP Home page and load the VID UI again, you will see VID home page

|image17|

 C. Select Test API for A-la-carte as VNF_API(old) then click Browse SDC Service Models (Left side panel)

 |image10|

 D. Search for the service to instantiate, select a service (vfw_demo_service) distributed in SDC and click Deploy

 |image1|

 E. Complete the fields indicated by the red star and click Confirm
  * Instance Name = vFW_service_00
  * Subscriber Name = Demonstration
  * Service Type = vFW
  * Owning Entity = OE-Demonstration

 |image24|

 F. Select Confirm Button
  We should see the “Service instance was created successfully” message

 |image15|

 G. Click Close and the next screen should appear. It will allow you to declare VNF(s) and Network(s)
 that are part of the service model composition

 |image29|

3. Instantiate a VNF

 A. click on “Add node instance” and select the VNF you want to instantiate in the list

 |image9|

 B. Complete the fields indicated by the red star and click Confirm
  * Instance Name = vFW_demo_VNF
  * Product Family = vFW
  * Region = RegionOne(CLOUDOWNER)
  * Tenant = admin
  * Line Of Business = LOB-Demonstration
  * Platform = Platform-Demonstration

 |image6|

You will get a status complete dialog message

|image18|

 C. Click on close button, the following screen then should appear

 |image16|

4. Instantiate VF Module
 Note: Before creating VF module get the required parameter values to prepare SDNC preload data

 A. Copy the following VNF attributes from VNF instance detail screen
  * generic-vnf-name = vFW_demo_VNF (value must be equal to the VNF instance name value)

  |image25|

  * generic-vnf-type = vFW_demo_service/vFW_demo 0 (value must be equal to VNF Type value)

  |image20|

  * service-type =  f7c80167-ed06-48ef-a991-61b43196f98f (value must be equal to the service instance id value)

  |image26|

 B. Copy the following attributes From Create VF Module screen

  * vnf-name = lfn_vf_module (value must be equal to the VF module instance name value)
  * vnf-type = VfwDemo..base_vfw..module-0 (value must be equal to the “Model Name” value - see create VF module screen)

  |image27|

 C. Get the required vnf-parameters values from Heat env file imported while SDC design
 (refer  https://github.com/onap/demo/blob/master/heat/vFW/base_vfw.env)

 Login to Openstack and execute the below commands and get the required openstack related parameter values
 to update in SDNC preload data

 * download the image ubuntu-14.04 from cloud images & create an image with "ubuntu-14-04-cloud-amd6" name
 * create the flavor with m1.medium
 * create OAM_NETWORK ID  & OAM_SUBNET ID (use subnet range from base_vfw.env file)
 * execute openstack security group rule to open all ports for onap

 D. Run the SDNC preload curl command
 Below is the sample curl command updated with all the required parameters

 .. code-block::

   curl -k -X POST \
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
    "vnf-parameters": [{
    "vnf-parameter-name": "vfw_image_name",
    "vnf-parameter-value": "ubuntu-14-04-cloud-amd6"
    },
    {
    "vnf-parameter-name": "vfw_flavor_name",
    "vnf-parameter-value": "m1.medium"
    },
    {
    "vnf-parameter-name": "vfw_name_0",
    "vnf-parameter-value": "zdfw1fwl01fwl01"
    },
    {
    "vnf-parameter-name": "vfw_int_unprotected_private_ip_0",
    "vnf-parameter-value": "192.168.10.101"
    },
    {
    "vnf-parameter-name": "vfw_int_protected_private_ip_0",
    "vnf-parameter-value": "192.168.20.101"
    },
    {
    "vnf-parameter-name": "vfw_onap_private_ip_0",
    "vnf-parameter-value": "10.0.100.5"
    },
    {
    "vnf-parameter-name": "vfw_int_protected_private_floating_ip",
    "vnf-parameter-value": "192.168.10.200"
    },
    {
    "vnf-parameter-name": "vpg_int_unprotected_private_ip_0",
    "vnf-parameter-value": "192.168.10.201"
    },
    {
    "vnf-parameter-name": "vpg_image_name",
    "vnf-parameter-value": "ubuntu-14-04-cloud-amd6"
    },
    {
    "vnf-parameter-name": "vpg_flavor_name",
    "vnf-parameter-value": "m1.medium"
    },
    {
    "vnf-parameter-name": "vpg_name_0",
    "vnf-parameter-value": "zdfw1fwl01pgn01"
    },
    {
    "vnf-parameter-name": "vpg_onap_private_ip_0",
    "vnf-parameter-value": "10.0.100.6"
    },
    {
    "vnf-parameter-name": "vsn_image_name",
    "vnf-parameter-value": "ubuntu-14-04-cloud-amd6"
    },
    {
    "vnf-parameter-name": "vsn_flavor_name",
    "vnf-parameter-value": "m1.medium"
    },
    {
    "vnf-parameter-name": "vsn_name_0",
    "vnf-parameter-value": "zdfw1fwl01snk01"
    },
    {
    "vnf-parameter-name": "vsn_int_protected_private_ip_0",
    "vnf-parameter-value": "192.168.20.251"
    },
    {
    "vnf-parameter-name": "vsn_onap_private_ip_0",
    "vnf-parameter-value": "10.0.100.7"
    },
    {
    "vnf-parameter-name": "public_net_id",
    "vnf-parameter-value": "07e85197-0f0a-45ca-8a6e-8eee47cec56b"
    },
    {
    "vnf-parameter-name": "unprotected_private_net_id",
    "vnf-parameter-value": "zdfw1fwl01_unprotected"
    },
    {
    "vnf-parameter-name": "unprotected_private_net_cidr",
    "vnf-parameter-value": "192.168.10.0/24"
    },
    {
    "vnf-parameter-name": "protected_private_net_id",
    "vnf-parameter-value": "zdfw1fwl01_protected"
    },
    {
    "vnf-parameter-name": "protected_private_net_cidr",
    "vnf-parameter-value": "192.168.20.0/24"
    },
    {
    "vnf-parameter-name": "onap_private_net_id",
    "vnf-parameter-value": "OAM_NETWORK"
    },
    {
    "vnf-parameter-name": "onap_private_subnet_id",
    "vnf-parameter-value": "OAM_SUBNET"
    },
    {
    "vnf-parameter-name": "onap_private_net_cidr",
    "vnf-parameter-value": "10.0.0.0/16"
    },
    {
    "vnf-parameter-name": "vfw_name",
    "vnf-parameter-value": "vFW_demo_VNF"
    },
    {
    "vnf-parameter-name": "vnf_id:",
    "vnf-parameter-value": "vFirewall_demo_app"
    },
    {
    "vnf-parameter-name": "vf_module_id:",
    "vnf-parameter-value": "vFirewall"
    },
    {
    "vnf-parameter-name": "dcae_collector_ip",
    "vnf-parameter-value": "10.43.134.33"
    },
    {
    "vnf-parameter-name": "dcae_collector_port",
    "vnf-parameter-value": "30417"
    },
    {
    "vnf-parameter-name": "demo_artifacts_version",
    "vnf-parameter-value": "1.6.0-SNAPSHOT"
    },
    {
    "vnf-parameter-name": "install_script_version",
    "vnf-parameter-value": "1.6.0-SNAPSHOT"
    },
    {
    "vnf-parameter-name": "key_name",
    "vnf-parameter-value": "vfw_key"
    },
    {
    "vnf-parameter-name": "pub_key",
    "vnf-parameter-value": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCofPKCypUIALLlSAa/INJZpnz6dPnTKuKkqO5Wxkv35PnHpXVmKit1iXNcy85+ceoMUrMre8O7SjIhdRklnOckW68WmkM9A+pFIFhxoKRfO0WR2/qZyXxM9WuQ5ESdXuBj5ydx7XlWWDtGTWF3wWxrFwob2EkWm+EXFrx18bNs8OqJF+1DDJfjLcC8kKgCwSKNcuRelDSBBaIrIDROdHi1r2AbdL/REZ4sprUTICVAhezX9mPowMX8Mr3ZuTxV9HpU43nlxfWxm9vDstyhiUMpYYCOWUfA/Gzxz/F1pli9L4MfpDsiwGaJtnnQ3vWiYRPZBTv+6h1miYlw4Fm7vJq9 aarna-onap"
    },
    {
    "vnf-parameter-name": "cloud_env",
    "vnf-parameter-value": "openstack"
    },
    {
    "vnf-parameter-name": "sec_group",
    "vnf-parameter-value": "default"
    },
    {
    "vnf-parameter-name": "nexus_artifact_repo",
    "vnf-parameter-value": "https://nexus.onap.org"
    }
    ],
    "vnf-topology-identifier": {
    "generic-vnf-name": "vFW_demo_VNF",
    "generic-vnf-type": "vFW_demo_service/vFW_demo 0",
    "service-type": "f7c80167-ed06-48ef-a991-61b43196f98f",
    "vnf-name": "lfn_vf_module",
    "vnf-type": "VfwDemo..base_vfw..module-0"
    }
    }
    }
   }'

   Output looks somthing like below
   {"output":{"svc-request-id":"test","response-code":"200","ack-final-indicator":"Y"}}

 E. Now click on Add VF-Module with the same name as updated through SDNC preload, click on SDN-C Preload
 check box then press confirm

 |image28|

You will get a status complete dialog message

|image2|

 F. Click on close, now the following screen should appear

 |image19|

5. Instantiate Network
 A. Prepare the “SDNC preload” data before creating network instance

  * network-role =  integration_test_net (provide any value)
  * network-technology = neutron (use “neutron” as this example will instantiate a network using openstack neutron application)
  * service-type = vFW_demo_service (value must be equal to “Service Name” (=service model name) displayed on VID screen)

  |image5|

  * network-name = lfn_nwt_001 (value must be equal to the desired network instance name)

  |image7|

  * network-type = Generic NeutronNet (value must be equal to “Model Name”“Generic NeutronNet” displayed on VID screen)

  |image8|

 B. Run the below SDNC preload curl command

 .. code-block::

   curl -k -X POST \
   https://sdnc.api.simpledemo.onap.org:30267/restconf/operations/VNF-API:preload-network-topology-operation \
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
        "service-type": "vFW_demo_service",
        "network-name": "lfn_nwt_001",
        "network-type": "Generic NeutronNet"
    },
    "provider-network-information": {
        "is-external-network": "false",
        "is-provider-network": "false",
        "is-shared-network": "false"
    },
    "subnets": [
        {
        "subnet-name": "test-subnet-001",
        "subnet-role": "OAM",
        "start-address": "10.0.0.11",
        "cidr-mask": "16",
        "ip-version": "4",
        "dhcp-enabled": "Y",
        "dhcp-start-address": "",
        "dhcp-end-address": "",
        "gateway-address": "10.0.0.1",
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
   }
   '

   Output looks something like below
   {"output":{"svc-request-id":"postman001","response-code":"200","ack-final-indicator":"Y"}}

 C. Click on “Add Network” and select the Network you want to instantiate in the list

 |image12|

 D. Click Confirm, We will get a status complete dialog message

 |image14|

 E. Click close, the following screen should appear

 |image3|

 At this point, the Network and subnets are now instantiated in the cloud platform

6. Now login to OpenStack Horizon dashboard, see stacks created in Openstack
 A. Go to Project → Orchestration → Stacks
 We can see the VF module and Network stacks status

 |image23|

 B. Now we can go to Admin → Compute → Instances to check the instances status

 |image21|


.. |image4| image:: media/image4.png
.. |image11| image:: media/image11.png
.. |image22| image:: media/image22.png
.. |image13| image:: media/image13.png
.. |image17| image:: media/image17.png
.. |image10| image:: media/image10.png
.. |image1| image:: media/image1.png
.. |image24| image:: media/image24.png
.. |image15| image:: media/image15.png
.. |image29| image:: media/image29.png
.. |image9| image:: media/image9.png
.. |image6| image:: media/image6.png
.. |image18| image:: media/image18.png
.. |image16| image:: media/image16.png
.. |image25| image:: media/image25.png
.. |image20| image:: media/image20.png
.. |image26| image:: media/image26.png
.. |image27| image:: media/image27.png
.. |image28| image:: media/image28.png
.. |image2| image:: media/image2.png
.. |image19| image:: media/image19.png
.. |image5| image:: media/image5.png
.. |image7| image:: media/image7.png
.. |image8| image:: media/image8.png
.. |image12| image:: media/image12.png
.. |image14| image:: media/image14.png
.. |image3| image:: media/image3.png
.. |image23| image:: media/image23.png
.. |image21| image:: media/image21.png





















