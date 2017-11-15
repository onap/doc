.. This work is licensed under a Creative Commons Attribution 4.0 International License.
   http://creativecommons.org/licenses/by/4.0
   Copyright 2017 ONAP


.. contents::
   :depth: 2
..

=====================================
**Setting Up Designate on Openstack**
=====================================

.. tip:: `Openstack Designate documentation <https://docs.openstack.org/designate/latest/index.html>` is an important starting point for configuring Designate. Here, the focus will be on designate for ONAP.

**Designate Overview**
======================
Designate is a *DNS as a Service* components. It allows API based interaction with a DNS server.
This DNS server can be any *well configured* DNS server.
Designate allows to create **any** entries in the DNS and thus has to be used wisely (see `Designate Production Guidelines <https://docs.openstack.org/designate/latest/admin/production-guidelines.html>` to have a complete explanation).
In order to be valuable, Designate must be plugged with a DNS Server that will be used:
- your global (pool of) DNS Server(s). Every entries put by Designate will be seen by everybody. It may then be very dangerous.
- a specific (pool of) DNS Server(s) for your openstack deployment. DNS resolution will work only for your VM. **This is the one that has been tested**.
- a specific (pool of) DNS Server(s) for an openstack tenant. Not a lot of doc is available for that so this part won't be explained here.

**Designate usage in ONAP**
===========================

Currently, only DCAE Gen2 deployment needs designate to work.
DCAE deployment use cloudify with openstack plugin to start the needed VM for DCAE. In particular, Designate is used to give the IP address of consul server. Thus, the others VMs needs to access the DNS server where Designate push records.
In order to do that, we'll have to deploy DNS Server(s), configure them to accept dns updates and configure our networks to point to this DNS.
This Fow-To will use bind but you can change to any of the `proposed backends <https://docs.openstack.org/designate/latest/contributor/support-matrix.html>`.

Limitations with heat automated deployment
------------------------------------------
The current design of HEAT installer installs DCAE needed VM into the same tenant of the same openstack of the other ONAP components. Thus, this openstack tenant must support Designate.

Limitations with kubernetes automated deployment
------------------------------------------------
The current design of kubernetes deployment installs DCAE into any openstack instances in any tenant. It stills mandate designate on the tenant.

**Quick Install Guide**
=======================

Few steps have to be performed. The detail of each steps are in `the config guide of Openstack Designate <https://docs.openstack.org/designate/latest/install/index.html>`:

1. Install bind9 nameserver
2. Configure it to accept dns updates and forward to your master DNS Server
3. Configure Designate in openstack
4. Create a pool pointing to your nameserver

Now, when starting the HEAT Deployment, use this nameserver. When the stack heat has started, retrieve the random string (XXX in the example) and create the zone XXX.yourdomain (yourdomain is what you have filled in `dcae_domain` in onap_openstack.env).
For OOM, use the DNS on the container host so it can give it to the relevant VM
