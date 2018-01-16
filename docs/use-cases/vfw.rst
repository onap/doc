.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.

vFirewall
=========

Description
-----------

Onboarding
----------


.. uml::

   @startuml
   title vFW and vDNS VNF Onboarding (R1)\nvFW and vDNS use the same flows but they are separate VNFs/Services
   ONAP_User -> SDC : vFW_vDNS resource onboarding  (HEAT)
   note right : vFW ( vpg, vfw, vsn)\nvDNS (vpg, vlb,vdns) + DNSScaling (vdns)\nCLAMP not shown
   ONAP_User -> SDC : vFW_vDNS service onboarding
   ONAP_User -> SDC : vFW_vDNS distribution
   |||
   ONAP_User -> SDC : vFW2_vDNS2 resource onboarding (TOSCA)
   ONAP_User -> SDC : vFW2_vDNS2 service onboarding
   ONAP_User -> SDC : vFW2_vDNS2 distribution
   |||
   SDC -> SO : artifact distribution
   SDC -> AAI : artifact distribution
   SDC -> APPC : artifact distribution
   SDC -> SDNC : VNF preload data (vFW_vDNS and vFW2_vDNS2) ?
   SDC -> DCAE : Telemetry to Collect and CLAMP triggers
   SDC -> Policy : Control Loop Policies (see CLAMP flow)
   note left: policy may cut through to Policy GUI
   @enduml

Instantiation
-------------

.. uml::

   @startuml
   title vFW vDNS Instantiation (R1)\nvFW and vDNS use the same flows but they are separate VNFs/Services
   participant UseCaseUI
   participant ONAP_User
   Participant SDC
   Participant VID
   Participant SO
   UseCaseUI -> AAI : populate cloud inventory
   ONAP_User -> VID : vFW_vDNS deployment
   VID -> SDC : Lookup VNF artifacts
   VID -> AAI : Lookup cloud locations, subscriber
   VID -> SO : vFW_vDNS instantiation\n(base modules)
   SO -> AAI : inventory update
   SO -> SDNC : Generic VNF API\n(reserved)
   SO -> Multi_VIM : vFW_vDNS Heat template + ENV file
   Multi_VIM -> CloudAPI : vFW_vDNS Heat template + ENV file or\n ARM Tempalte + Parameters + LinuxExtensionScripts
   CloudAPI -> Hypervisor : vFW_vDNS Infrastructure instantiation
   Hypervisor -> vFW_vDNS : Nova/Neutron Instantiation
   Hypervisor -> CloudAPI : complete
   CloudAPI -> Multi_VIM : complete
   Multi_VIM -> SO : complete
   note right : SO may poll for completion
   SO -> SDNC:  Generic VNF API\n(activated)
   note right : on failure from Openstack SO issues rollback to SDNC
   SDNC -> AAI : L3 Network resource update
   SO -> VID : complete
   note right : VID will poll for competion
   SO -> Multi_VIM : Replaces Robot HEATBridge to pull data from cloud
   Multi_VIM -> CloudAPI : VM data from cloud\n(public cloud will be less than if owner operated)
   Multi_VIM -> SO : cloud data
   SO -> AAI : Update with cloud data
   |||
   ONAP_User -> VID : vFW2_vDNS2 deployment (TOCA based)
   VID -> SDC : Lookup VNF artifacts
   VID -> AAI : Lookup cloud locations, subscriber
   VID -> SO : vFW2_vDNS2 instantiation\n(base modules)
   SO -> AAI : inventory update
   SO -> SDNC : Generic VNF API\n(reserved)
   SO -> Multi_VIM : vFW2_vDNS2 TOSCA template + ENV file
   Multi_VIM -> CloudAPI : vFW_vDNS TOSCA template + ENV file or\n ARM Template + Parameters + LinuxExtensionScripts
   CloudAPI -> Hypervisor : vFW2_vDNS2 Infrastructure instantiation
   Hypervisor -> vFW2_vDNS2 : Nova/Neutron Instantiation
   Hypervisor -> CloudAPI : complete
   CloudAPI -> Multi_VIM : complete
   Multi_VIM -> SO : complete
   note right : SO may poll for completion
   SO -> SDNC:  Generic VNF API\n(activated)
   note right : on failure from Openstack SO issues rollback to SDNC
   SDNC -> AAI : L3 Network resource update
   SO -> VID : complete
   note right : VID will poll for competion
   SO -> Multi_VIM : Replaces Robot HEATBridge to pull data from cloud
   Multi_VIM -> CloudAPI : VM data from cloud\n(public cloud will be less than if owner operated)
   Multi_VIM -> SO : cloud data
   SO -> AAI : Update with cloud data
   @enduml


