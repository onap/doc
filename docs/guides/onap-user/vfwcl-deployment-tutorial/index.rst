.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright © 2017-2021 Aarna Networks, Inc.

vFWCL deployment Tutorial
#########################

Introduction
============

This tutorial describes the step by step instructions on how to achieve the control loop for vFW use case. Instructions in this tutorial will enable you to deploy the vfw control loop specific usecase.

vFW service components
~~~~~~~~~~~~~~~~~~~~~~

The vFW service is composed of the following components

vPKG VNF

- It is a packet generator which sends periodically different volumes of traffic to the sink through the firewall (vFw)

vFWSNK VNF

- Firewall: Reports the volume of traffic passing through to the DCAE collector (VES collector). The vFW has no real firewalling functionality.
- Traffic sink: Provides a graphical representation (bar charts) showing the volume of incoming traffic.

The below block diagram shows about the components part of vFW usecase

|image25|

vFWCL service overview
~~~~~~~~~~~~~~~~~~~~~~

The vFW contol loop use case consists in applying policy rules that aim to re-adjust the traffic volume
when high threshold (700 packets/10s) or low threshold (300 packets/10s) are crossed. In fact, the DCAE collects
events from the vFW, applies analytics (Threshold Crossing Analytics: TCA microservice) and publishes events to DMaap.
When detecting the triggering event, the policy engine executes the operational policy via the APP-C that modifies
vPKG application configurations in order to adjust the traffic volume to 500 packet per 10 seconds.

The vFW control loop is based on VES (VNF Event Stream) reported measurements that TCA analyses and publishes
related alams to DMaap. The policy has the responsibility for triggering ModifyConfig action that APPC executes
on the target vnf (vPKG). All closed loop interactions are relying on the Message router (DMaap) by publishing
topics and subscribing to them.

The ladder diagram below describes the components and their interactions that take place while running the vFWCL

|image53|

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

1. GET the modelInvariantID of vPG

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

  #sample command and output
  curl  -k -u 'healthcheck:zb!XztG34' -X GET -H 'Accept:application/json' https://10.43.244.213:6969/policy/pap/v1/pdps | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  100  2678  100  2678    0     0   7695      0 --:--:-- --:--:-- --:--:--  7695
  {
  "groups": [
    {
      "name": "defaultGroup",
      "description": "The default group that registers all supported policy types and pdps.",
      "pdpGroupState": "ACTIVE",
      "properties": {},
      "pdpSubgroups": [
        {
          "pdpType": "apex",
          "supportedPolicyTypes": [
            {
              "name": "onap.policies.controlloop.operational.Apex",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.controlloop.operational.common.Apex",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.native.Apex",
              "version": "1.0.0"
            }
          ],
          "policies": [],
          "currentInstanceCount": 1,
          "desiredInstanceCount": 1,
          "properties": {},
          "pdpInstances": [
            {
              "instanceId": "dev-policy-apex-pdp-0",
              "pdpState": "ACTIVE",
              "healthy": "HEALTHY",
              "message": "Pdp Heartbeat"
            }
          ]
        },
        {
          "pdpType": "drools",
          "supportedPolicyTypes": [
            {
              "name": "onap.policies.controlloop.Operational",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.controlloop.operational.common.Drools",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.native.drools.Controller",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.native.drools.Artifact",
              "version": "1.0.0"
            }
          ],
          "policies": [],
          "currentInstanceCount": 1,
          "desiredInstanceCount": 1,
          "properties": {},
          "pdpInstances": [
            {
              "instanceId": "dev-drools-0",
              "pdpState": "ACTIVE",
              "healthy": "HEALTHY"
            }
          ]
        },
        {
          "pdpType": "xacml",
          "supportedPolicyTypes": [
            {
              "name": "onap.policies.controlloop.guard.common.FrequencyLimiter",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.controlloop.guard.common.MinMax",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.controlloop.guard.common.Blacklist",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.controlloop.guard.coordination.FirstBlocksSecond",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.monitoring.*",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.optimization.*",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.optimization.resource.AffinityPolicy",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.optimization.resource.DistancePolicy",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.optimization.resource.HpaPolicy",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.optimization.resource.OptimizationPolicy",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.optimization.resource.PciPolicy",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.optimization.service.QueryPolicy",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.optimization.service.SubscriberPolicy",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.optimization.resource.Vim_fit",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.optimization.resource.VnfPolicy",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.native.Xacml",
              "version": "1.0.0"
            },
            {
              "name": "onap.policies.Naming",
              "version": "1.0.0"
            }
          ],
          "policies": [
            {
              "name": "SDNC_Policy.ONAP_NF_NAMING_TIMESTAMP",
              "version": "1.0.0"
            }
          ],
          "currentInstanceCount": 1,
          "desiredInstanceCount": 1,
          "properties": {},
          "pdpInstances": [
            {
              "instanceId": "dev-policy-xacml-pdp-6c5f6db887-zkh6h",
              "pdpState": "ACTIVE",
              "healthy": "HEALTHY"
            }
          ]
        }
      ]
    }
  ]
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

1. Enable direct access to vFW PG VNF instance from control node

.. note::
   These steps are applicable only when your openstack instance is running on the GCP

   You can refer to `Google Cloud Docs <https://cloud.google.com/vpc/docs/configure-alias-ip-ranges>`_ to find
   more details about how to add IP alias to a running GCP instance

Execute the below commands from your laptop using gcloud CLI

a. Find the Default interface name and primary internal IP for the GCP instance

.. code-block::

  gcloud compute instances describe openstack-01 | grep 'nic\|networkIP'

  #sample command output
  name: nic0
  networkIP: 10.128.0.43

b. For the Default interface nic0 add an IP alias from the default subnet

.. code-block::

  gcloud compute instances network-interfaces update openstack-01 \
    --zone us-central1-f \
    --network-interface nic0 \
    --aliases "/30"

  # sample output
  Updating network interface [nic0] of instance [openstack-01]...done

c. Verify if the instance has got a new IP alias

.. code-block::

  gcloud compute instances describe openstack-01 | grep 'nic\|networkIP\|aliasIpRanges\|ipCidrRange'

  # from the output note down the IP alias ipCidrRange attribute that you will need it inplace
  aliasIpRanges:
  ipCidrRange: 10.128.0.124/30
  name: nic0
  networkIP: 10.128.0.22

2. Map openstack-01 GCP IP alias to vFW PG VNF openstack instance public IP

a. SSH into GCP openstack-01  VM instance and verify if you can see the new IP alias in the routing table

.. code-block::

  ip route show table local | grep '/30'

  # sample output
  local 10.128.0.112/30 dev eth0 proto 66 scope host

b. Find the vFW packet generator public / external network IP address

Run the below command on the openstack instance

.. code-block::

  openstack server list
  # sample output
  | ID | Name | Status | Networks | Image  | Flavor  |
  | 1faa6593-7e9e-452d-a5dc-1536e18e4b94 | zdfw1fwl01pgn01 | ACTIVE | OAM_NETWORK=10.10.10.12; public=172.29.249.200;
  zdfw1fwl01_unprotected=192.168.10.200| trusty | m1.medium |

c. Now update openstack-01 GCP instance iptables to forward the traffic to vFW PG VNF VM

Below are the commands to forward all traffic reaching to IP alias (ex: 10.128.0.112/30)
to vFW PG VNF VM (ex:zdfw1fwl01pgn01) instance public IP (ex:172.29.249.200)

.. code-block::

  # DNAT rule update
  sudo iptables -t nat -I PREROUTING -d 10.128.0.112 -j DNAT --to-destination 172.29.249.200
  sudo iptables -t nat -I POSTROUTING -s 172.29.249.200 -j MASQUERADE

  # Update INPUT, FORWARD AND OUTPUT chain to allow traffic for all ports
  sudo iptables -I INPUT 1 -p udp -j ACCEPT
  sudo iptables -I FORWARD 1 -p tcp -j ACCEPT
  sudo iptables -I OUTPUT 1 -p tcp -j ACCEPT
  sudo iptables -I OUTPUT 1 -p udp -j ACCEPT

d. Verify if you can access vFW PG instance from the control node

SSH into vFW PG VNF instance using the openstack-01 GCP IP alias, it should connect to the vFW PG VNF instance

3. Mount APPC

a. Get the VNF instance ID, either through VID or through AAI. Below the AAI request

Search for the vnf-name as vfw_pg_vsp_002-1 from the output of the below command and find the corresponding vnf-id,
the value is: a1ca05b4-3231-4e4a-a09c-74f2292fe577

.. code-block::

  curl -X GET   https://<kubernetes-host>:30233/aai/v8/network/generic-vnfs/   -H 'Accept: application/json'   -H 'Authorization: Basic QUFJOkFBSQ=='   -H 'Content-Type:application/json' -H 'X-FromAppId: Postman' -H 'X-TransactionId: get_generic_vnf' -k

  {
	"generic-vnf": [{
		"vnf-id": "a1ca05b4-3231-4e4a-a09c-74f2292fe577",
		"vnf-name": "vfw_pg_vsp_002-1",
		"vnf-type": "vfw-service-002/vfw_pg_vsp_002 0",
		"service-id": "f18af052-6dfb-40e8-ad25-f060eb898f53",
		"prov-status": "ACTIVE",
		"orchestration-status": "Active",
		"in-maint": false,
		"is-closed-loop-disabled": false,
		"resource-version": "1617776160138",
		"model-invariant-id": "7a347a5a-8f3f-416c-81f3-13b30631c1e6",
		"model-version-id": "f988048a-b4f4-4f5e-aa7c-fdaa0d7ea017",
		"model-customization-id": "601d5d68-fbbe-4c1f-a624-08a3445ae8fe",
		"relationship-list": {
			"relationship": [{
				"related-to": "service-instance",
				"relationship-label": "org.onap.relationships.inventory.ComposedOf",
				"related-link": "/aai/v16/business/customers/customer/Demonstration/service-subscriptions/service-subscription/vFW/service-instances/service-instance/6f294c8f-ac67-4b33-9e56-014fb63791a5",
				"relationship-data": [{
					"relationship-key": "customer.global-customer-id",
					"relationship-value": "Demonstration"
				}, {
					"relationship-key": "service-subscription.service-type",
					"relationship-value": "vFW"
				}, {
					"relationship-key": "service-instance.service-instance-id",
					"relationship-value": "6f294c8f-ac67-4b33-9e56-014fb63791a5"
				}],
				"related-to-property": [{
					"property-key": "service-instance.service-instance-name",
					"property-value": "vfw-service-002-1"
				}]
			}, {
				"related-to": "platform",
				"relationship-label": "org.onap.relationships.inventory.Uses",
				"related-link": "/aai/v16/business/platforms/platform/Platform-Demonstration",
				"relationship-data": [{
					"relationship-key": "platform.platform-name",
					"relationship-value": "Platform-Demonstration"
				}]
			}, {
				"related-to": "line-of-business",
				"relationship-label": "org.onap.relationships.inventory.Uses",
				"related-link": "/aai/v16/business/lines-of-business/line-of-business/LOB-Demonstration",
				"relationship-data": [{
					"relationship-key": "line-of-business.line-of-business-name",
					"relationship-value": "LOB-Demonstration"
				}]
			}, {
				"related-to": "vserver",
				"relationship-label": "tosca.relationships.HostedOn",
				"related-link": "/aai/v16/cloud-infrastructure/cloud-regions/cloud-region/CloudOwner/RegionOne/tenants/tenant/759425709b7a4b3ca257d3f93ef4e91e/vservers/vserver/856aed6e-cc25-4819-a03d-5549f5fe8662",
				"relationship-data": [{
					"relationship-key": "cloud-region.cloud-owner",
					"relationship-value": "CloudOwner"
				}, {
					"relationship-key": "cloud-region.cloud-region-id",
					"relationship-value": "RegionOne"
				}, {
					"relationship-key": "tenant.tenant-id",
					"relationship-value": "759425709b7a4b3ca257d3f93ef4e91e"
				}, {
					"relationship-key": "vserver.vserver-id",
					"relationship-value": "856aed6e-cc25-4819-a03d-5549f5fe8662"
				}],
				"related-to-property": [{
					"property-key": "vserver.vserver-name",
					"property-value": "zdfw1fwl01pgn01"
				}]
			}]
		}
	}, {
		"vnf-id": "be9e190e-a20c-4900-8074-cffec77131f1",
		"vnf-name": "vfw_sinc_vsp_002-1",
		"vnf-type": "vfw-service-002/vfw_sinc_vsp_002 0",
		"service-id": "f18af052-6dfb-40e8-ad25-f060eb898f53",
		"prov-status": "ACTIVE",
		"orchestration-status": "Active",
		"in-maint": false,
		"is-closed-loop-disabled": false,
		"resource-version": "1617776104234",
		"model-invariant-id": "9b25321d-9260-4739-97f8-7c85fba4e755",
		"model-version-id": "c785c203-9c39-4b6a-9c2e-f24bb8d4d92d",
		"model-customization-id": "a1e0ddf7-5d50-43a4-a6f1-0bfde3c1de78",
		"relationship-list": {
			"relationship": [{
				"related-to": "service-instance",
				"relationship-label": "org.onap.relationships.inventory.ComposedOf",
				"related-link": "/aai/v16/business/customers/customer/Demonstration/service-subscriptions/service-subscription/vFW/service-instances/service-instance/6f294c8f-ac67-4b33-9e56-014fb63791a5",
				"relationship-data": [{
					"relationship-key": "customer.global-customer-id",
					"relationship-value": "Demonstration"
				}, {
					"relationship-key": "service-subscription.service-type",
					"relationship-value": "vFW"
				}, {
					"relationship-key": "service-instance.service-instance-id",
					"relationship-value": "6f294c8f-ac67-4b33-9e56-014fb63791a5"
				}],
				"related-to-property": [{
					"property-key": "service-instance.service-instance-name",
					"property-value": "vfw-service-002-1"
				}]
			}, {
				"related-to": "platform",
				"relationship-label": "org.onap.relationships.inventory.Uses",
				"related-link": "/aai/v16/business/platforms/platform/Platform-Demonstration",
				"relationship-data": [{
					"relationship-key": "platform.platform-name",
					"relationship-value": "Platform-Demonstration"
				}]
			}, {
				"related-to": "line-of-business",
				"relationship-label": "org.onap.relationships.inventory.Uses",
				"related-link": "/aai/v16/business/lines-of-business/line-of-business/LOB-Demonstration",
				"relationship-data": [{
					"relationship-key": "line-of-business.line-of-business-name",
					"relationship-value": "LOB-Demonstration"
				}]
			}, {
				"related-to": "vserver",
				"relationship-label": "tosca.relationships.HostedOn",
				"related-link": "/aai/v16/cloud-infrastructure/cloud-regions/cloud-region/CloudOwner/RegionOne/tenants/tenant/759425709b7a4b3ca257d3f93ef4e91e/vservers/vserver/30dd6250-8a74-4ed7-9729-6ce7190c6661",
				"relationship-data": [{
					"relationship-key": "cloud-region.cloud-owner",
					"relationship-value": "CloudOwner"
				}, {
					"relationship-key": "cloud-region.cloud-region-id",
					"relationship-value": "RegionOne"
				}, {
					"relationship-key": "tenant.tenant-id",
					"relationship-value": "759425709b7a4b3ca257d3f93ef4e91e"
				}, {
					"relationship-key": "vserver.vserver-id",
					"relationship-value": "30dd6250-8a74-4ed7-9729-6ce7190c6661"
				}],
				"related-to-property": [{
					"property-key": "vserver.vserver-name",
					"property-value": "vfw_sinc_vsp_002-1"
				}]
			}, {
				"related-to": "vserver",
				"relationship-label": "tosca.relationships.HostedOn",
				"related-link": "/aai/v16/cloud-infrastructure/cloud-regions/cloud-region/CloudOwner/RegionOne/tenants/tenant/759425709b7a4b3ca257d3f93ef4e91e/vservers/vserver/9ab8d517-2b1c-4d31-a04c-0fe2f8396815",
				"relationship-data": [{
					"relationship-key": "cloud-region.cloud-owner",
					"relationship-value": "CloudOwner"
				}, {
					"relationship-key": "cloud-region.cloud-region-id",
					"relationship-value": "RegionOne"
				}, {
					"relationship-key": "tenant.tenant-id",
					"relationship-value": "759425709b7a4b3ca257d3f93ef4e91e"
				}, {
					"relationship-key": "vserver.vserver-id",
					"relationship-value": "9ab8d517-2b1c-4d31-a04c-0fe2f8396815"
				}],
				"related-to-property": [{
					"property-key": "vserver.vserver-name",
					"property-value": "zdfw1fwl01snk01"
				}]
			}]
		}
	}]
  }

b. Get the public IP address of the Packet Generator VM from your deployment

c. To mount APPC, run the below command by replacing <vnf-id> and <vnf-ip> with the values obtained from the above steps (a) & (b) respectively

.. code-block::

  curl -X PUT \
   http://<kubernetes-host>:30230/restconf/config/network-topology:network-topology/topology/topology-netconf/node/<vnf-id> \
  -H 'Accept: application/xml' \
  -H 'Authorization: Basic YWRtaW46S3A4Yko0U1hzek0wV1hsaGFrM2VIbGNzZTJnQXc4NHZhb0dHbUp2VXkyVQ==' \
  -H 'Content-Type: text/xml' \
  -d '<node xmlns="urn:TBD:params:xml:ns:yang:network-topology">
   <node-id><vnf-id></node-id>
   <host xmlns="urn:opendaylight:netconf-node-topology"><vnf-ip></host>
   <port xmlns="urn:opendaylight:netconf-node-topology">830</port>
   <username xmlns="urn:opendaylight:netconf-node-topology">netconf</username>
   <password xmlns="urn:opendaylight:netconf-node-topology">netconf</password>
   <tcp-only xmlns="urn:opendaylight:netconf-node-topology">false</tcp-only>
   </node>'

  #smaple command and output:
  curl -vvv -X PUT   http://192.168.122.99:30230/restconf/config/network-topology:network-topology/topology/topology-netconf/node/a1ca05b4-3231-4e4a-a09c-74f2292fe577   -H 'Accept: application/xml'   -H 'Authorization: Basic YWRtaW46S3A4Yko0U1hzek0wV1hsaGFrM2VIbGNzZTJnQXc4NHZhb0dHbUp2VXkyVQ=='   -H 'Content-Type: text/xml'   -d '<node xmlns="urn:TBD:params:xml:ns:yang:network-topology"> <node-id>a1ca05b4-3231-4e4a-a09c-74f2292fe577</node-id> <host xmlns="urn:opendaylight:netconf-node-topology">192.168.122.238</host> <port xmlns="urn:opendaylight:netconf-node-topology">830</port> <username xmlns="urn:opendaylight:netconf-node-topology">netconf</username> <password xmlns="urn:opendaylight:netconf-node-topology">netconf</password> <tcp-only xmlns="urn:opendaylight:netconf-node-topology">false</tcp-only> </node>'
  *   Trying 192.168.122.99...
  * TCP_NODELAY set
  * Connected to 192.168.122.99 (192.168.122.99) port 30230 (#0)
  > PUT /restconf/config/network-topology:network-topology/topology/topology-netconf/node/a1ca05b4-3231-4e4a-a09c-74f2292fe577 HTTP/1.1
  > Host: 192.168.122.99:30230
  > User-Agent: curl/7.58.0
  > Accept: application/xml
  > Authorization: Basic YWRtaW46S3A4Yko0U1hzek0wV1hsaGFrM2VIbGNzZTJnQXc4NHZhb0dHbUp2VXkyVQ==
  > Content-Type: text/xml
  > Content-Length: 488
  >
  * upload completely sent off: 488 out of 488 bytes
  < HTTP/1.1 200 OK
  < Content-Length: 0
  <
  * Connection #0 to host 192.168.122.99 left intact

d. To verify the NETCONF connection has successfully being established, run the following request (replace <vnd-id> with yours)

.. code-block::

  curl -X GET \
  http://<kubernetes-host>:30230/restconf/operational/network-topology:network-topology/topology/topology-netconf/node/<vnf-id> \
  -H 'Accept: application/json' \
  -H 'Authorization: Basic YWRtaW46S3A4Yko0U1hzek0wV1hsaGFrM2VIbGNzZTJnQXc4NHZhb0dHbUp2VXkyVQ=='

  #smaple command and output:
  curl -X GET   http://192.168.122.99:30230/restconf/operational/network-topology:network-topology/topology/topology-netconf/node/a1ca05b4-3231-4e4a-a09c-74f2292fe577    -H 'Accept: application/json'   -H 'Authorization: Basic YWRtaW46S3A4Yko0U1hzek0wV1hsaGFrM2VIbGNzZTJnQXc4NHZhb0dHbUp2VXkyVQ==' | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  100  5368  100  5368    0     0   374k      0 --:--:-- --:--:-- --:--:--  374k
  {
  "node": [
    {
      "node-id": "a1ca05b4-3231-4e4a-a09c-74f2292fe577",
      "netconf-node-topology:unavailable-capabilities": {},
      "netconf-node-topology:available-capabilities": {
        "available-capability": [
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:capability:yang-library:1.0?revision=2018-01-17&module-set-id=29"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:base:1.1"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:base:1.0"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:capability:writable-running:1.0"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:capability:validate:1.1"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:capability:with-defaults:1.0?basic-mode=explicit&also-supported=report-all,report-all-tagged,trim,explicit"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:capability:interleave:1.0"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:capability:rollback-on-error:1.0"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:capability:xpath:1.0"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:capability:startup:1.0"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:capability:candidate:1.0"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "urn:ietf:params:netconf:capability:notification:1.0"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:netconf:notification:1.0?revision=2008-07-14)notifications"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:iana-crypt-hash?revision=2014-08-06)iana-crypt-hash"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-x509-cert-to-name?revision=2014-12-10)ietf-x509-cert-to-name"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-system?revision=2014-08-06)ietf-system"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-netconf-monitoring?revision=2010-10-04)ietf-netconf-monitoring"
          },
          {
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-datastores?revision=2017-08-17)ietf-datastores"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:1?revision=2017-02-20)yang"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-interfaces?revision=2014-05-08)ietf-interfaces"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:iana-if-type?revision=2014-05-08)iana-if-type"
          },
          {
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-netconf-server?revision=2016-11-02)ietf-netconf-server"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:opendaylight:params:xml:ns:yang:sample-plugin?revision=2016-09-18)sample-plugin"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(http://nokia.com/pnf-simulator)pnf-simulator"
          },
          {
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-ssh-server?revision=2016-11-02)ietf-ssh-server"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-netconf-notifications?revision=2012-02-06)ietf-netconf-notifications"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:netconf:base:1.0?revision=2011-06-01)ietf-netconf"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-yang-types?revision=2013-07-15)ietf-yang-types"
          },
          {
            "capability": "(urn:mynetconf:test?revision=2019-03-01)mynetconf"
          },
          {
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-keystore?revision=2016-10-31)ietf-keystore"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:netmod:notification?revision=2008-07-14)nc-notifications"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-yang-metadata?revision=2016-08-05)ietf-yang-metadata"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-inet-types?revision=2013-07-15)ietf-inet-types"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(http://example.net/turing-machine?revision=2013-12-27)turing-machine"
          },
          {
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-tls-server?revision=2016-11-02)ietf-tls-server"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-netconf-with-defaults?revision=2011-06-01)ietf-netconf-with-defaults"
          },
          {
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-yang-library?revision=2018-01-17)ietf-yang-library"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-ip?revision=2014-06-16)ietf-ip"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:ietf:params:xml:ns:yang:ietf-netconf-acm?revision=2018-02-14)ietf-netconf-acm"
          },
          {
            "capability-origin": "device-advertised",
            "capability": "(urn:opendaylight:params:xml:ns:yang:stream-count?revision=2016-09-18)stream-count"
          }
        ]
      },
      "netconf-node-topology:host": "192.168.122.238",
      "netconf-node-topology:clustered-connection-status": {
        "netconf-master-node": "akka.tcp://opendaylight-cluster-data@127.0.0.1:2550"
      },
      "netconf-node-topology:connection-status": "connected",
      "netconf-node-topology:port": 830
    }
  ]
  }

VPP setup
=========

1. The information that we need to configure the VPP reporter (which is the VES agent application
that generates events destined for the ONAP VES collector) is the VES IP and port.
The below instructions can be used for this configuration

.. code-block::

  kubectl get svc -n onap -o wide | grep ves
  dcae-hv-ves-collector                                       ClusterIP      10.43.130.145   <none>                                 6061/TCP                                                      12d   app=dcae-hv-ves-collector
  dcae-ves-collector                                          ClusterIP      10.43.83.158    <none>                                 8080/TCP,8443/TCP                                             12d   app=dcae-ves-collector
  xdcae-hv-ves-collector                                      NodePort       10.43.32.76     <none>                                 6061:30222/TCP                                                12d   app=dcae-hv-ves-collector
  xdcae-ves-collector                                         NodePort       10.43.97.42     <none>                                 8080:30235/TCP,8443:30417/TCP                                 12d   app=dcae-ves-collector

2. Use the port of xdcae-ves (30235 in this case) and the kubernetes-host IP

- Log in to the vfw sinc VNF as user ubuntu
- Modify /opt/config/dcae_collector_ip.txt and /opt/config/dcae_collector_port.txt
- Kill the vpp reporter if running already
- Start the vpp reporter by executing the script

  - cd /opt/VES/evel/evel-library/code/VESreporting
  - ./go-client.sh &
- Add the following route for the metadata service if not present already

  .. code-block::

      sudo ip route add 169.254.169.254 via <vfw_sinc OAM_NETWORK IP> dev <interface name>
      sample command:
      # sudo ip route add 169.254.169.254 via 10.10.10.11 dev eth3
- Verify that the metadata service is accessible by issuing the following command

  - curl http://169.254.169.254

3. The events generated from this program will trigger the vFW CL flow.
In a successful deployment of the vFW CL, the graphs look as in the screenshot below.
We can see that the bars are shorter and more uniform as compared to vFW deployment without the CL

Browse to the zdfw1fwl01snk01 on port 667 to see a graph representing the traffic being received

.. code-block::

  http://<zdfw1fwl01snk01>:667/

|image54|

4. Check the events sent by TCA on unauthenticated.DCAE_CL_OUTPUT

These events are the resulting of the TCA application, e.g. TCA has noticed an event was crossing
a given threshold, hence is sending a message of that particular topic. Then Policy will grab this event
and perform the appropriate action, as defined in the Policy. In the case of vFWCL, Policy will send
an event on the APPC_CL topic, that APPC will consume. This will trigger a NETCONF request to the
packet generator to adjust the traffic.

.. code-block::

  curl -X GET \
  http://<kubernetes-host>:3904/events/unauthenticated.DCAE_CL_OUTPUT/group1/C1 \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/cambria'

  #smaple command and output:
  curl -X GET   http://10.43.214.215:3904/events/unauthenticated.DCAE_CL_OUTPUT/group1/C1   -H 'Accept: application/json'   -H 'Content-Type: application/cambria' | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  100   909  100   909    0     0    677      0  0:00:01  0:00:01 --:--:--   677
  [
  "{\"closedLoopEventClient\":\"DCAE_INSTANCE_ID.dcae-tca\",\"policyVersion\":\"v0.0.1\",\"policyName\":\"DCAE.Config_tca-hi-lo\",\"policyScope\":\"DCAE\",\"target_type\":\"VM\",\"AAI\":{\"vserver.prov-status\":\"ACTIVE\",\"vserver.resource-version\":\"1617776112073\",\"vserver.is-closed-loop-disabled\":false,\"vserver.vserver-name2\":\"vfw_sinc_vsp_002-1\",\"vserver.vserver-id\":\"30dd6250-8a74-4ed7-9729-6ce7190c6661\",\"vserver.vserver-selflink\":\"http://10.200.142.157:8774/v2.1/servers/30dd6250-8a74-4ed7-9729-6ce7190c6661\",\"vserver.in-maint\":false,\"vserver.vserver-name\":\"vfw_sinc_vsp_002-1\"},\"closedLoopAlarmStart\":1500584201765465,\"closedLoopEventStatus\":\"ONSET\",\"closedLoopControlName\":\"ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a\",\"version\":\"1.0.2\",\"target\":\"vserver.vserver-name\",\"requestID\":\"2f546551-f304-4e76-9e8e-45c601790823\",\"from\":\"DCAE\"}"
  ]

5. Check the active streams value in vPG over restconf

The number of streams will change along the time, this is the result of close-loop policy.
When the traffic goes over a certain threshold, DCAE will publish an event on the unauthenticated.DCAE_CL_OUTPUT
topic that will be picked up by APPC, that will send a NETCONF request to the packet generator to adjust the traffic it's sending.

Run the below command to check the stream count, you should see the value as 5

.. code-block::

  curl -v --noproxy '*' --user "admin":"Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U"  -H "Accept: application/xml" -H "Content-type: application/xml" -X GET   http:/<kubernetes-host>:30230/restconf/config/network-topology:network-topology/topology/topology-netconf/node/<VPG VNFID>/yang-ext:mount/stream-count:stream-count/streams/

  #sample command and output
  curl -v --noproxy '*' --user "admin":"Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U"  -H "Accept: application/xml" -H "Content-type: application/xml" -X GET http:/192.168.122.99:30230/restconf/config/network-topology:network-topology/topology/topology-netconf/node/a1ca05b4-3231-4e4a-a09c-74f2292fe577/yang-ext:mount/stream-count:stream-count/streams/
  Note: Unnecessary use of -X or --request, GET is already inferred.
  * Unwillingly accepted illegal URL using 1 slash!
  *   Trying 192.168.122.99...
  * TCP_NODELAY set
  * Connected to 192.168.122.99 (192.168.122.99) port 30230 (#0)
  * Server auth using Basic with user 'admin'
  > GET /restconf/config/network-topology:network-topology/topology/topology-netconf/node/a1ca05b4-3231-4e4a-a09c-74f2292fe577/yang-ext:mount/stream-count:stream-  count/streams/ HTTP/1.1
  > Host: 192.168.122.99:30230
  > Authorization: Basic YWRtaW46S3A4Yko0U1hzek0wV1hsaGFrM2VIbGNzZTJnQXc4NHZhb0dHbUp2VXkyVQ==
  > User-Agent: curl/7.58.0
  > Accept: application/xml
  > Content-type: application/xml
  >
  < HTTP/1.1 200 OK
  < Content-Type: application/xml
  < Content-Length: 110
  <
  * Connection #0 to host 192.168.122.99 left intact
  <streams xmlns="urn:opendaylight:params:xml:ns:yang:stream-count"><active-streams>5</active-streams></streams>


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
.. |image25| image:: media/image25.png
.. |image53| image:: media/image53.jpg
.. |image54| image:: media/image54.png
