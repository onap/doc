.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright © 2017-2020 Aarna Networks, Inc.

vFWCL deployment Tutorial
#########################

Introduction
============

The instructions in this tutorial will enable you to deploy the vfw control loop specific usecase.

The vFW contol loop usecase consists in applying policy rules that aim to re-adjust the traffic volume
when high threshold (700 packets/10s) or low threshold (300 packets/10s) are crossed. In fact, the DCAE collects
events from the vFW, applies analytics (Threshold Crossing Analytics: TCA microservice) and publishes events to DMaap.
When detecting the triggering event, the policy engine executes the operational policy via the APP-C that modifies
vPKG application configurations in order to adjust the traffic volume to 500 packet per 10 seconds.

The vFW control loop is based on VES (VNF Event Stream) reported measurements that TCA analyses and publishes
related alams to DMaap. The policy has the responsibility for triggering ModifyConfig action that APPC executes
on the target vnf (vPKG). All closed loop interactions are relying on the Message router (DMaap) by publishing
topics and subscribing to them.

Prerequisite:
vFW service design and deployment should be completed before following the steps of this tutorial

Refer the below tutorials for doing vFW service design and deployment

.. toctree::
   :maxdepth: 1

   vFW Design Tutorial <../vfw-design-tutorial/index.rst>
   vFW Deployment Tutorial <../vfw-deployment-tutorial/index.rst>

Adding DCAE artifacts and policies
==================================

Follow the below steps to upload the blueprint for the TCA (Threshold Checking Application) DCAE microservice
and Distribute the service to the CLAMP

1. Login as DESIGNER (cs0008) and create the service, checkin and certify

|image16|

2. Add any VNF (ex: vfw_pg) that was already created during the SDC design phase

In the composition canvas drag and drop a resource of type VF from the abstract section in the Elements section (left hand side panel)

|image15|

3. Download the required DCAE MS blueprint to be attached to the service

Use the sample TCA blueprint located here:
https://git.onap.org/dcaegen2/platform/blueprints/tree/blueprints/k8s-tcagen2-clampnode.yaml

.. note::
  * Check if the version of the plugin used in the blueprint is different from existing, then update the blueprint import to match
  * To check the version run this: `cfy plugins list | grep k8splugin`

4. Now upload the Control Loop Artifact. The procedure to upload the artifact is

 * Click on the VF, as in the picture above the ‘vsp_pg 0’ is selected
 * Click on ‘DEPLOYMENT ARTIFACTS’  and then click on “Add Artifact”

 |image5|

 * Fill the details and in the type select DCAE_INVENTORY_BLUEPRINT, then click on Done as in the picture shown below
 
 |image13|

5. After uploading the DCAE artifact to the SDC Service, attach the policy model to the Service. From the left drop down,
select TCA policy under Policies, and click on the Add policy

|image1|

6. Click on Checkin on top right corner then click OK

|image12|

7. Search and select the same service from CATALOG and click on Certify on top right corner

|image14|

8. Click Distribute to distribute the service, then click on Distribution in the left hand side panel and monitor until
the distribution is complete. We should see artifacts deployed in CLAMP and Policy engine, as can be seen in the picture below

|image19|

At this point we can open the CLAMP GUI and verify that the DCAE microservice design template is in place

Deploy DCAE and Policy through CLAMP
====================================

CLAMP is a GUI tool which enables the users to design the policies, distribute them to the DROOLS engine and eventually deploy
the DCAE microservices.

1. Add the necessary certificates in the browser to login to the CLAMP GUI

The default certificate can be found here: https://gerrit.onap.org/r/gitweb?p=clamp.git;a=blob;f=src/main/resources/clds/aaf/org.onap.clamp.p12;h=268aa1a3ce56e01448f8043cc0b05b5fceb5a47d;hb=HEAD

The password is:  "China in the Spring"
The certificate must be loaded into your favorite browser before trying to load the CLAMP UI.

2. After the certificate is added, the CLAMP GUI can be accessed at:
`https://<host_IP>:30258` (host_IP is the node IP where CLAMP is running)

3. Before designing the policy we need to undeploy the default tca policy.
To undeploy default policy execute the below commands on control node

.. code-block::

  > kubectl get deployments -n onap | grep "dep-dcae-tca-analytics\|dcaegen2-analytics-tca" | awk '{print $1}' |
    xargs kubectl delete deployments -n onap
  > kubectl get svc -n onap | grep "dcae-tca-analytics\|dcaegen2-analytics-tca" | awk '{print $1}' |
    xargs kubectl delete svc -n onap
    To Verify there are no dcae-analytics POD, run the below command
  > kubectl get pods -n onap | grep 'analytics'

4. If the service has been distributed correctly, following is how the service design templates
listed in the Loop Templates as below

|image7|

Available Policy Models

|image10|

5. Create the loop from the templates distributed by SDC

|image4|

|image20|

6. Add the Operational Policy
Click on Loop Instance drop down and select Modify then click, select the policy model type then click Add

|image9|

|image3|

7. Click on the MS application box and configure
Fill the details in the pop up window and click on the save changes button.

 A. Click on app and Edit the Policy details, fill the below details

  * eventName: vFirewallBroadcastPackets
  * policyScope: DCAE
  * policyVersion: v0.0.1
  * Select controlLoopSchemaType as VM
  * policyName: DCAE.Config_tca-hi-lo
  * Select Pdp Group Info from the drop down as defaultGroup & xacm

 |image17|

 B. Click on the Add monitoring threshold1 button and fill the below details

  * version : 1.0.2
  * closedLoopControlName : name of the CL (ex: LOOP_TEMPLATE_mytest_srv_v1_0_vsp_pg0_k8s-tca)
  * select the direction from dropdown (ex: LESS)

 |image11|

 C. Click on the Add monitoring threshold2 button and fill the details same as above then click on Save Changes button

 |image24|

8. Click on the Operational policy box and configure
Fill the details in the pop window then click on save changes

|image22|

|image18|

9. Submit the control loop to the policy
From Loop Operations drop down select SUBMIT and click

|image23|

10. Deploy the control loop to DCAE
From Loop Operations drop down select DEPLOY and click, verify the details and click Deploy

|image2|

|image8|

Status Logs

|image21|

A successful deployment will make the service as DEPLOYED

11. You can login into the control node and verify whether your new analytics application got deployed using below command

.. code-block::
  
  > kubectl get pods -n onap | grep analytics
  Sample output
  dep-dcae-tca-analytics-7fccbf459-xkxlq             2/2     Running      0          6m15s

  > cfy deployment  list | grep CLAMP
  Sample output
  | CLAMP_615bb47a-ea3e-4a02-8928-0564df900826 | CLAMP_615bb47a-ea3e-4a02-8928-0564df900826 | 2020-11-10 19:23:22.286  |
  2020-11-10 19:23:22.286  |   tenant   |   default_tenant |   admin    |

Robot heatbridge
================

Run the Robot heatbridge script to populate the vserver (OAM IP, VM flavor name, ID etc.) related information in AAI.
This is required by APPC/SDNC for performing LCM operations.

Following is the command usage along with the example

./demo-k8s.sh <namespace> heatbridge <stack_name> <service_instance_id> <service> <oam-ip-address>

.. note::
  The stack_name & oam-ip-address of the VNF VM can be obtained from OpenStack Horizon and service_instance_id from the VID screen

.. code-block::

  ./demo-k8s.sh onap heatbridge vfw_sinc_vf e039b3d4-7ee5-4ad2-8108-ae31086ac7c0 vFW 172.29.249.157
  Number of parameters:
  6
  KEY:
  heatbridge
  ++ kubectl --namespace onap get pods
  ++ sed 's/ .*//'
  ++ grep robot
  + POD=dev-robot-58f85bb64d-zz5bh
  ++ dirname ./demo-k8s.sh
  + DIR=.
  + SCRIPTDIR=scripts/demoscript
  + ETEHOME=/var/opt/ONAP
  + '[' ']'
  ++ kubectl --namespace onap exec dev-robot-58f85bb64d-zz5bh -- bash -c 'ls -1q /share/logs/ | wc -l'
  + export GLOBAL_BUILD_NUMBER=13
  + GLOBAL_BUILD_NUMBER=13
  ++ printf %04d 13
  + OUTPUT_FOLDER=0013_demo_heatbridge
  + DISPLAY_NUM=103
  + VARIABLEFILES='-V /share/config/robot_properties.py'
  + kubectl --namespace onap exec dev-robot-58f85bb64d-zz5bh -- /var/opt/ONAP/runTags.sh -V /share/config/robot_properties.py -v HB_STACK:vfw_sinc_vf
  -v HB_VNF:e039b3d4-7ee5-4ad2-8108-ae31086ac7c0 -v HB_VNF:vFW -v HB_SERVICE:vFW -v HB_IPV4_OAM_ADDRESS:172.29.249.157 -d /share/logs/0013_demo_heatbridge
  -i heatbridge --display 103
  Starting Xvfb on display :103 with res 1280x1024x24
  Executing robot tests at log level TRACE
  ==============================================================================
  Testsuites
  ==============================================================================
  Testsuites.Demo :: Executes the VNF Orchestration Test cases including setu...
  ==============================================================================
  Run Heatbridge :: Try to run heatbridge                               | PASS |
  ------------------------------------------------------------------------------
  Testsuites.Demo :: Executes the VNF Orchestration Test cases inclu... | PASS |
  1 critical test, 1 passed, 0 failed
  1 test total, 1 passed, 0 failed
  ==============================================================================
  Testsuites                                                            | PASS |
  1 critical test, 1 passed, 0 failed
  1 test total, 1 passed, 0 failed
  ==============================================================================
  Output:  /share/logs/0013_demo_heatbridge/output.xml
  Log:     /share/logs/0013_demo_heatbridge/log.html
  Report:  /share/logs/0013_demo_heatbridge/report.html

Update the operational policy
=============================

1. GET the modelInvariantID of vPG from

Following is the command usage along with the sample output

.. code-block::

  curl -k -X GET https://<kubernetes-host>:30233/aai/v11/network/generic-vnfs/ -H 'Accept: application/json' -H 'Authorization: Basic QUFJOkFBSQ==' -H ' Content-Type: application/json' -H 'X-FromAppId: Postman' -H 'X-TransactionId: get_generic_vnf' | jq

  {
  "generic-vnf": [
    {
      "vnf-id": "edc085e8-5088-4b73-bcdc-b8b0bf5e528b",
      "vnf-name": "vfw_vpg_vnf",
      "vnf-type": "vFWCL_service/vsp_vpg 0",
      "service-id": "929190d1-fed1-4dff-883f-f0ede779065e",
      "prov-status": "PREPROV",
      "orchestration-status": "Created",
      "in-maint": false,
      "is-closed-loop-disabled": false,
      "resource-version": "1609783281808",
      "model-invariant-id": "7d4fef5e-f9b0-4e03-a653-712d6630f389",
      "model-version-id": "a248f68e-c1f2-4b25-8120-c4f7310b0d1e",
      "model-customization-id": "cf0019db-f51f-472a-996d-9da19d41f7b4",
      "relationship-list": {
        "relationship": [
          {
            "related-to": "service-instance",
            "related-link": "/aai/v11/business/customers/customer/Demonstration/service-subscriptions/service-subscription/vFWCL/service-instances/service-  instance/e039b3d4-7ee5-4ad2-8108-ae31086ac7c0",
            "relationship-data": [
              {
                "relationship-key": "customer.global-customer-id",
                "relationship-value": "Demonstration"
              },
              {
                "relationship-key": "service-subscription.service-type",
                "relationship-value": "vFWCL"
              },
              {
                "relationship-key": "service-instance.service-instance-id",
                "relationship-value": "e039b3d4-7ee5-4ad2-8108-ae31086ac7c0"
              }
            ],
            "related-to-property": [
              {
                "property-key": "service-instance.service-instance-name",
                "property-value": "vFWCL_srv_00"
              }
            ]
          },
          {
            "related-to": "platform",
            "related-link": "/aai/v11/business/platforms/platform/Platform-Demonstration",
            "relationship-data": [
              {
                "relationship-key": "platform.platform-name",
                "relationship-value": "Platform-Demonstration"
              }
            ]
          },
          {
            "related-to": "line-of-business",
            "related-link": "/aai/v11/business/lines-of-business/line-of-business/LOB-Demonstration",
            "relationship-data": [
              {
                "relationship-key": "line-of-business.line-of-business-name",
                "relationship-value": "LOB-Demonstration"
              }
            ]
          }
        ]
      }
    },
    {
      "vnf-id": "816040b6-d9bf-43ba-b852-e31e21a0a5f4",
      "vnf-name": "vfw_sinc_vnf",
      "vnf-type": "vFWCL_service/vsp_sinc 0",
      "service-id": "929190d1-fed1-4dff-883f-f0ede779065e",
      "prov-status": "ACTIVE",
      "orchestration-status": "Active",
      "in-maint": false,
      "is-closed-loop-disabled": false,
      "resource-version": "1609788164862",
      "model-invariant-id": "4d432903-4338-48ae-a105-47c0c8d19193",
      "model-version-id": "86b98636-150b-4f1c-a768-61e6c43a3199",
      "model-customization-id": "d3671119-5b65-40ed-abea-d1fe0d09c3ba",
      "relationship-list": {
        "relationship": [
          {
            "related-to": "vserver",
            "related-link": "/aai/v11/cloud-infrastructure/cloud-regions/cloud-  region/CloudOwner/RegionOne/tenants/tenant/747a01548b494670892413c496c1c250/vservers/vserver/3353a853-87cc-47cc-9e6a-4f45b6dc580f",
            "relationship-data": [
              {
                "relationship-key": "cloud-region.cloud-owner",
                "relationship-value": "CloudOwner"
              },
              {
                "relationship-key": "cloud-region.cloud-region-id",
                "relationship-value": "RegionOne"
              },
              {
                "relationship-key": "tenant.tenant-id",
                "relationship-value": "747a01548b494670892413c496c1c250"
              },
              {
                "relationship-key": "vserver.vserver-id",
                "relationship-value": "3353a853-87cc-47cc-9e6a-4f45b6dc580f"
              }
            ],
            "related-to-property": [
              {
                "property-key": "vserver.vserver-name",
                "property-value": "zdfw1fwl01snk01"
              }
            ]
          },
          {
            "related-to": "vserver",
            "related-link": "/aai/v11/cloud-infrastructure/cloud-regions/cloud-  region/CloudOwner/RegionOne/tenants/tenant/747a01548b494670892413c496c1c250/vservers/vserver/642b5709-4f3d-405b-bcb2-dc82884cb8de",
            "relationship-data": [
              {
                "relationship-key": "cloud-region.cloud-owner",
                "relationship-value": "CloudOwner"
              },
              {
                "relationship-key": "cloud-region.cloud-region-id",
                "relationship-value": "RegionOne"
              },
              {
                "relationship-key": "tenant.tenant-id",
                "relationship-value": "747a01548b494670892413c496c1c250"
              },
              {
                "relationship-key": "vserver.vserver-id",
                "relationship-value": "642b5709-4f3d-405b-bcb2-dc82884cb8de"
              }
            ],
            "related-to-property": [
              {
                "property-key": "vserver.vserver-name",
                "property-value": "zdfw1fwl01fwl01"
              }
            ]
          },
          {
            "related-to": "service-instance",
            "related-link": "/aai/v11/business/customers/customer/Demonstration/service-subscriptions/service-subscription/vFWCL/service-instances/service-  instance/e039b3d4-7ee5-4ad2-8108-ae31086ac7c0",
            "relationship-data": [
              {
                "relationship-key": "customer.global-customer-id",
                "relationship-value": "Demonstration"
              },
              {
                "relationship-key": "service-subscription.service-type",
                "relationship-value": "vFWCL"
              },
              {
                "relationship-key": "service-instance.service-instance-id",
                "relationship-value": "e039b3d4-7ee5-4ad2-8108-ae31086ac7c0"
              }
            ],
            "related-to-property": [
              {
                "property-key": "service-instance.service-instance-name",
                "property-value": "vFWCL_srv_00"
              }
            ]
          },
          {
            "related-to": "platform",
            "related-link": "/aai/v11/business/platforms/platform/Platform-Demonstration",
            "relationship-data": [
              {
                "relationship-key": "platform.platform-name",
                "relationship-value": "Platform-Demonstration"
              }
            ]
          },
          {
            "related-to": "line-of-business",
            "related-link": "/aai/v11/business/lines-of-business/line-of-business/LOB-Demonstration",
            "relationship-data": [
              {
                "relationship-key": "line-of-business.line-of-business-name",
                "relationship-value": "LOB-Demonstration"
              }
            ]
          }
        ]
      }
    }
  ]
  }

2. Get the Operational policy name and version

Following is the command usage and the sample output

.. code-block::

  curl -k -u 'healthcheck:zb!XztG34' -X GET -H 'Accept:application/json' https://<kubernetes-host>:6969/policy/pap/v1/pdps
  
  {
	"groups": [{
		"name": "defaultGroup",
		"description": "The default group that registers all supported policy types and pdps.",
		"pdpGroupState": "ACTIVE",
		"properties": {},
		"pdpSubgroups": [{
			"pdpType": "apex",
			"supportedPolicyTypes": [{
				"name": "onap.policies.controlloop.operational.Apex",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.controlloop.operational.common.Apex",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.native.Apex",
				"version": "1.0.0"
			}],
			"policies": [],
			"currentInstanceCount": 1,
			"desiredInstanceCount": 1,
			"properties": {},
			"pdpInstances": [{
				"instanceId": "dev-policy-apex-pdp-0",
				"pdpState": "ACTIVE",
				"healthy": "HEALTHY",
				"message": "Pdp Heartbeat"
			}]
		}, {
			"pdpType": "drools",
			"supportedPolicyTypes": [{
				"name": "onap.policies.controlloop.Operational",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.controlloop.operational.common.Drools",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.native.drools.Controller",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.native.drools.Artifact",
				"version": "1.0.0"
			}],
			"policies": [{
				"name": "OPERATIONAL_dcae_service_v1_0_Drools_1_0_0_of6",
				"version": "1.0.0"
			}],
			"currentInstanceCount": 1,
			"desiredInstanceCount": 1,
			"properties": {},
			"pdpInstances": [{
				"instanceId": "dev-drools-0",
				"pdpState": "ACTIVE",
				"healthy": "HEALTHY"
			}]
		}, {
			"pdpType": "xacml",
			"supportedPolicyTypes": [{
				"name": "onap.policies.controlloop.guard.common.FrequencyLimiter",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.controlloop.guard.common.MinMax",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.controlloop.guard.common.Blacklist",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.controlloop.guard.coordination.FirstBlocksSecond",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.monitoring.*",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.optimization.*",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.optimization.resource.AffinityPolicy",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.optimization.resource.DistancePolicy",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.optimization.resource.HpaPolicy",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.optimization.resource.OptimizationPolicy",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.optimization.resource.PciPolicy",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.optimization.service.QueryPolicy",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.optimization.service.SubscriberPolicy",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.optimization.resource.Vim_fit",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.optimization.resource.VnfPolicy",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.native.Xacml",
				"version": "1.0.0"
			}, {
				"name": "onap.policies.Naming",
				"version": "1.0.0"
			}],
			"policies": [{
				"name": "SDNC_Policy.ONAP_NF_NAMING_TIMESTAMP",
				"version": "1.0.0"
			}, {
				"name": "MICROSERVICE_dcae_service_v1_0_app_1_0_0_XKp",
				"version": "1.0.0"
			}],
			"currentInstanceCount": 1,
			"desiredInstanceCount": 1,
			"properties": {},
			"pdpInstances": [{
				"instanceId": "dev-policy-xacml-pdp-6c5f6db887-zkh6h",
				"pdpState": "ACTIVE",
				"healthy": "HEALTHY"
			}]
		}]
	}]
  }

3. Remove the vFW Policy from PDP

Following is the command usage

.. code-block::

  POLICY_ID = "OPERATIONAL_dcae_service_v1_0_Drools_1_0_0_of6"
  POLICY_VERSION = "1.0.0"

  curl -k -u 'healthcheck:zb!XztG34' -X DELETE -H 'Content-Type:application/json' https://<kubernetes-host>:6969/policy/pap/v1/pdps/policies/$POLICY_ID/versions/$POLICY_VERSION

4. Get latest policy

Following is the command usage and sample output

.. code-block::

  POLICY_TYPEID="onap.policies.controlloop.operational.common.Drools"
  VERSIONID='1.0.0'
  POLICY_ID="OPERATIONAL_dcae_service_v1_0_Drools_1_0_0_of6"

  curl -k -u 'healthcheck:zb!XztG34' -X GET -H 'Accept:application/json' https://<kubernetes-host>:6969/policy/api/v1/policytypes/$POLICY_TYPEID/versions/$VERSIONID/policies/$POLICY_ID/versions/latest > operational_policy_template.json

5. Update this policy in the policy DB

Following is the command usage and sample output

.. code-block::

  POLICY_TYPEID="onap.policies.controlloop.operational.common.Drools"
  VERSIONID='1.0.0'

  curl -k -u 'healthcheck:zb!XztG34' -X POST -H 'Content-Type:application/json' --data @./operational_policy_template.json https://<kubernetes-host>:6969/policy/api/v1/policytypes/$POLICY_TYPEID/versions/$VERSIONID/policies

  {
	"tosca_definitions_version": "tosca_simple_yaml_1_1_0",
	"topology_template": {
		"policies": [{
			"OPERATIONAL_dcae_service_v1_0_Drools_1_0_0_of6": {
				"type": "onap.policies.controlloop.operational.common.Drools",
				"type_version": "1.0.0",
				"properties": {
					"abatement": true,
					"operations": [{
						"failure_retries": "final_failure_retries",
						"id": "ModifyConfig",
						"failure_timeout": "final_failure_timeout",
						"failure": "final_failure",
						"operation": {
							"payload": {
								"active-streams": 5
							},
							"target": {
								"entityIds": {
									"resourceID": "7d4fef5e-f9b0-4e03-a653-712d6630f389"
								},
								"targetType": "VNF"
							},
							"actor": "APPC",
							"operation": "ModifyConfig"
						},
						"failure_guard": "final_failure_guard",
						"retries": 3,
						"timeout": 3600,
						"failure_exception": "final_failure_exception",
						"description": "ModifyConfig",
						"success": "final_success"
					}],
					"trigger": "ModifyConfig",
					"timeout": 3600,
					"id": "LOOP_tca"
				},
				"name": "OPERATIONAL_dcae_service_v1_0_Drools_1_0_0_of6",
				"version": "1.0.0",
				"metadata": {
					"policy-id": "OPERATIONAL_dcae_service_v1_0_Drools_1_0_0_of6",
					"policy-version": "1.0.0"
				}
			}
		}]
	},
	"name": "ToscaServiceTemplateSimple",
	"version": "1.0.0",
	"metadata": {}
  }

6. Deploy this version of the policy using PAP API

Prepare the payload for the deployment API by naming the file as pap_template.json. The contents are policy name, version and command usage as below

.. code-block::

  cat pap_template.json
  {
    "policies" : [
     {
       "policy-id": "OPERATIONAL_dcae_service_v1_0_Drools_1_0_0_of6",
       "policy-version": "3"
     }
     ]
  }

  curl -k -u 'healthcheck:zb!XztG34' -X POST --data @./pap_template.json -H 'Content-Type:application/json' https://<kubernetes-host>:6969/policy/pap/v1/pdps/policies

Set network topology for vPG in APPC
====================================

For doing this refer this wiki `vFWCL instantiation, testing, and debuging <https://wiki.onap.org/display/DW/vFWCL+instantiation%2C+testing%2C+and+debuging>`_
and follow the steps from step number 3 to 6 under Close loop section


.. |image16| image:: media/image16.png
.. |image15| image:: media/image15.png
.. |image5| image:: media/image5.png
.. |image13| image:: media/image13.png
.. |image1| image:: media/image1.png
.. |image12| image:: media/image12.png
.. |image14| image:: media/image14.png
.. |image19| image:: media/image19.png
.. |image7| image:: media/image7.png
.. |image10| image:: media/image10.png
.. |image4| image:: media/image4.png
.. |image20| image:: media/image20.png
.. |image9| image:: media/image9.png
.. |image3| image:: media/image3.png
.. |image17| image:: media/image17.png
.. |image11| image:: media/image11.png
.. |image24| image:: media/image24.png
.. |image22| image:: media/image22.png
.. |image18| image:: media/image18.png
.. |image23| image:: media/image23.png
.. |image2| image:: media/image2.png
.. |image8| image:: media/image8.png
.. |image21| image:: media/image21.png












