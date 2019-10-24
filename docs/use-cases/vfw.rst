.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.

.. _vfirewall_usecase:

vFirewall
=========

Description
-----------

Onboarding
----------

.. uml::

   @startuml
   title vFW/vFWCL and vDNS VNF Onboarding (R1)\nVFW/vFWCL and vDNS use the same flows but they are separate VNFs/Services
   ONAP_User -> SDC : vFW_vDNS resource onboarding  (HEAT)
   note right : vFWCL (vpg & vfw,vsn)\nvFW (vpg, vfw, vsn)\nvDNS (vpg, vlb,vdns) + DNSScaling (vdns)\
   ONAP_User -> SDC : vFW_vDNS service onboarding
   ONAP_User -> SDC : vFW_vDNS distribution
   |||
   SDC -> SO : artifact distribution\nNOTIFY,DOWNLOAD,DEPLOY_OK
   SDC -> AAI : artifact distribution\nNOTIFY,DOWNLOAD,DEPLOY_OK
   SDC -> SDNC : artifact distribution\nNOTIFY,DOWNLOAD,DEPLOY_OK
   @enduml

Instantiation
-------------

.. uml::

 @startuml
   title vFW vDNS Instantiation (R1)\nvFW and vDNS use the same flows but they are separate VNFs/Services
   participant ONAP_User
   participant Robot
   Participant SDC
   Participant VID
   Participant SO
   ONAP_User -> AAI : populate cloud inventory
   note left of AAI:  manual via curl or POSTMAN
   |||
   ONAP_User -> VID : vFW_vDNS deployment
   VID -> SDC : Lookup VNF artifacts
   VID -> AAI : Lookup cloud locations, subscriber
   VID -> SO : vFW_vDNS Service \nInstantiation\n(base modules)
   SO -> AAI : inventory update
   VID -> SO : vFW_vDNS VNF Instantiation\n(base modules)
   note left of AAI : VFWCL is two VNFs in one service\nso VNF instantiate occurs twice
   SO -> AAI : inventory update
   ONAP_User -> SDNC : VNF API Preload VNF/VF data
   VID -> SO : vFW_vDNS VF Instantiation\n(base modules)
   SO -> AAI : inventory update
   SO -> SDNC : Generic VNF API\n(assign)
   SO -> Multi_VIM : vFW_vDNS Heat template, \nENV file, preload parameters
   Multi_VIM -> CloudAPI : vFW_vDNS Heat template,\nENV file, preload parameters or
   CloudAPI -> Hypervisor : vFW_vDNS Infrastructure instantiation
   Hypervisor -> vFW_vDNS : Nova/Neutron Instantiation
   Hypervisor -> CloudAPI : complete
   CloudAPI -> Multi_VIM : complete
   Multi_VIM -> SO : complete
   note right : SO may poll for completion
   SO -> SDNC:  Generic VNF API\n(activated)
   note left : on failure from Openstack SO issues rollback to SDNC
   SDNC -> AAI : L3 Network resource update
   SO -> VID : complete
   note right : VID will poll for completion
   ONAP_User -> Robot : run Heat Bridge
   Robot -> CloudAPI  :  retrieve cloud data
   Robot -> AAI :  Update with cloud data
   |||
   @enduml
