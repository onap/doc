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

   curl -k -X  POST https://sdnc.api.simpledemo.onap.org:30267/restconf/operations/GENERIC-RESOURCE-API:preload-vf-module-topology-operation \
   -H 'Accept:    application/json' \
   -H 'Authorization: Basic YWRtaW46S3A4Yko0U1hzek0wV1hsaGFrM2VIbGNzZTJnQXc4NHZhb0dHbUp2VXkyVQ==' \
   -H 'Content-Type: application/json' \
   -H 'X-   FromAppId: API client' \
   -H 'cache-control: no-cache' \
   -d @vFW_sdnc_VF_preload.json

   Below is the json file payload content
   cat vFW_sdnc_VF_preload.json
   {
        "input": {
                "request-information": {
                        "notification-url": "onap.org",
                        "order-number": "1",
                        "order-version": "1",
                        "request-action": "PreloadVfModuleRequest",
                        "request-id": "test"
                },
                "sdnc-request-header": {
                        "svc-action": "reserve",
                        "svc-notification-url": "http:\/\/onap.org:8080\/adapters\/rest\/SDNCNotify",
                        "svc-request-id": "test"
                },
                "preload-vf-module-topology-information": {
                        "vnf-resource-assignments": {
                                "availability-zones": {
                                        "availability-zone": [
                                                "nova"
                                        ],
                                        "max-count": "1"
                                },
                                "vnf-networks": {
                                        "vnf-network": []
                                }
                        },
                        "vf-module-topology": {
                                "vf-module-topology-identifier": {
                                        "vf-module-name": "lfn_vf_module"
                                },
                                "vf-module-parameters": {
                                        "param":[{
                                                "name": "vfw_image_name",
                                                "value": "ubuntu-14-04-cloud-amd6"
                                        },
                                        {
                                                "name": "vfw_flavor_name",
                                                "value": "m1.medium"
                                        },
                                        {
                                                "name": "vfw_name_0",
                                                "value": "zdfw1fwl01fwl09"
                                        },
                                        {
                                                "name": "vfw_int_unprotected_private_ip_0",
                                                "value": "192.168.10.109"
                                        },
                                        {
                                                "name": "vfw_int_protected_private_ip_0",
                                                "value": "192.168.20.109"
                                        },
                                        {
                                                "name": "vfw_onap_private_ip_0",
                                                "value": "10.10.10.15"
                                        },
                                        {
                                                "name": "vfw_int_protected_private_floating_ip",
                                                "value": "192.168.10.209"
                                        },
                                        {
                                                "name": "vpg_int_unprotected_private_ip_0",
                                                "value": "192.168.10.209"
                                        },
                                        {
                                                "name": "vpg_image_name",
                                                "value": "ubuntu-14-04-cloud-amd6"
                                        },
                                        {
                                                "name": "vpg_flavor_name",
                                                "value": "m1.medium"
                                        },
                                        {
                                                "name": "vpg_name_0",
                                                "value": "zdfw1fwl01pgn09"
                                        },
                                        {
                                                "name": "vpg_onap_private_ip_0",
                                                "value": "10.10.10.16"
                                        },
                                        {
                                                "name": "vsn_image_name",
                                                "value": "ubuntu-14-04-cloud-amd6"
                                        },
                                        {
                                                "name": "vsn_flavor_name",
                                                "value": "m1.medium"
                                        },
                                        {
                                                "name": "vsn_name_0",
                                                "value": "zdfw1fwl01snk09"
                                        },
                                        {
                                                "name": "vsn_int_protected_private_ip_0",
                                                "value": "192.168.20.251"
                                        },
                                        {
                                                "name": "vsn_onap_private_ip_0",
                                                "value": "10.10.10.17"
                                        },
                                        {
                                                "name": "public_net_id",
                                                "value": "9af666a2-73db-4dd4-bdad-a5dd82f6fddc"
                                        },
                                        {
                                                "name": "unprotected_private_net_id",
                                                "value": "zdfw1fwl09_unprotected"
                                        },
                                        {
                                                "name": "unprotected_private_net_cidr",
                                                "value": "192.168.10.0/24"
                                        },
                                        {
                                                "name": "protected_private_net_id",
                                                "value": "zdfw1fwl09_protected"
                                        },
                                        {
                                                "name": "protected_private_net_cidr",
                                                "value": "192.168.20.0/24"
                                        },
                                        {
                                                "name": "onap_private_net_id",
                                                "value": "OAM_NETWORK"
                                        },
                                        {
                                                "name": "onap_private_subnet_id",
                                                "value": "OAM_SUBNET"
                                        },
                                        {
                                                "name": "onap_private_net_cidr",
                                                "value": "10.10.10.0/24"
                                        },
                                        {
                                                "name": "vfw_name",
                                                "value": "vFW_demo_VNF"
                                        },
                                        {
                                                "name": "vnf_id:",
                                                "value": "vFirewall_demo_app"
                                        },
                                        {
                                                "name": "vf_module_id:",
                                                "value": "vFirewall"
                                        },
                                        {
                                                "name": "dcae_collector_ip",
                                                "value": "127.0.0.1"
                                        },
                                        {
                                                "name": "dcae_collector_port",
                                                "value": "30235"
                                        },
                                        {
                                                "name": "demo_artifacts_version",
                                                "value": "1.6.0-SNAPSHOT"
                                        },
                                        {
                                                "name": "install_script_version",
                                                "value": "1.6.0-SNAPSHOT"
                                        },
                                        {
                                                "name": "key_name",
                                                "value": "vfw_key"
                                        },
                                        {
                                                "name": "pub_key",
                                                "value": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD1Bv4Vb3RzfKoW3R6j+bk4fqCVkrHSqnK2Xo1A2139jGm6wvUocQznaawoL5kfqTATPOl1kwi6EvWgy+aVV7UmELdm2nFPUErcPT8B73hfFImpNkz6q93TCmx4lJNz+5k6nemUn+K4fz7a1ggLYahTOTzJsNBffaVE7LA/ahGxzK7zVqWrdO0hoJAxnENp46qEtrQk3PIoWn4MRy2xj4hnnLFETWxYcktIdV6YQzJUlK/wZOWrGdkPdnjLaIO84ZxjPedxgGl1BOuUKAWqlC0g9I1Q9tcCrBnahVFLt3ibloFcLSEl1zrzYtJtF2w1i/SDBSpqxIr68TEo7/FPfAP1"
                                        },
                                        {
                                                "name": "cloud_env",
                                                "value": "openstack"
                                        },
                                        {
                                                "name": "sec_group",
                                                "value": "default"
                                        },
                                        {
                                                "name": "nexus_artifact_repo",
                                                "value": "https://nexus.onap.org"
                                        }

                                ]
                        }
                },
                "vnf-topology-identifier-structure": {
                        "vnf-name": "vFW_demo_VNF",
                        "vnf-type": "vFW_demo_service/vFW_demo 0"
                }
        }
     }
   }

   Output looks somthing like below
   {"output":{"response-message":"success","ack-final-indicator":"Y","svc-request-id":"test","response-code":"200"}}

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

   curl -k -X  POST https://sdnc.api.simpledemo.onap.org:30267/restconf/operations/GENERIC-RESOURCE-API:preload-network-topology-operation \
   -H 'Accept:      application/json' \
   -H 'Authorization: Basic YWRtaW46S3A4Yko0U1hzek0wV1hsaGFrM2VIbGNzZTJnQXc4NHZhb0dHbUp2VXkyVQ==' \
   -H 'Content-Type: application/json' \
   -H 'X-     FromAppId: API client' \
   -H 'cache-control: no-cache' \
   -d @vFW_sdnc_Network_preload.json

   Below is the json file payload content
   cat vFW_sdnc_Network_preload.json

   {
	"input": {
		"preload-network-topology-information": {
			"network-policy": [],
			"route-table-reference": [],
			"vpn-bindings": [],
			"network-topology-identifier-structure": {
				"network-role": "integration_test_net",
				"network-technology": "neutron",
				"network-name": "lfn_nwt_001",
				"network-type": "Generic NeutronNet"
			},
			"is-external-network": false,
			"is-shared-network": false,
			"is-provider-network": false,
			"physical-network-name": "Not Aplicable",
			"subnets": [{
				"cidr-mask": "24",
				"dhcp-enabled": "N",
				"gateway-address": "10.10.10.1",
				"ip-version": "4",
				"start-address": "10.10.10.20",
				"subnet-name": "test-subnet-005"
			}]
		},
		"sdnc-request-header": {
			"svc-request-id": "test",
			"svc-notification-url": "http:\/\/onap.org:8080\/adapters\/rest\/SDNCNotify",
			"svc-action": "reserve"
		}
	}
   }

   Output looks something like below
   {"output":{"response-message":"success","ack-final-indicator":"Y","svc-request-id":"test","response-code":"200"}}

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





















