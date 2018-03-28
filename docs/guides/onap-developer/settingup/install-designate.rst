.. This work is licensed under a Creative Commons Attribution 4.0 International License.
   http://creativecommons.org/licenses/by/4.0
   Copyright 2017 ONAP


.. contents::
   :depth: 2
..

=====================================
**Setting Up Designate on Openstack**
=====================================

.. tip::
 - `Openstack Designate documentation (LATEST) <https://docs.openstack.org/designate/latest/index.html>`_ is an important starting point for configuring Designate. Here, the focus will be on designate for ONAP.
 - Notice the documentation version mentioned in the URL, e.g. ocata/, pike/, latest/ ...

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
This How-To will use bind but you can change to any of the `proposed backends <https://docs.openstack.org/designate/latest/contributor/support-matrix.html>`.

Limitations with Heat automated deployment
------------------------------------------
The current design of Heat installer installs DCAE needed VM into the same tenant of the same openstack of the other ONAP components. Thus, this openstack tenant must support Designate.

Limitations with Kubernetes automated deployment
------------------------------------------------
The current design of kubernetes deployment installs DCAE into any openstack instances in any tenant. It still mandates designate on the tenant.

**Quick Install Guide**
=======================

Few steps have to be performed. The detail of each steps are in `the config guide of Openstack Designate <https://docs.openstack.org/designate/latest/install/index.html>`:

1. Install bind9 nameserver
2. Configure it to accept dns updates and forward to your master DNS Server. Example configuration is below:

   .. code:: bash

    root@designate:~# cat /etc/bind/named.conf.options
    include "/etc/bind/rndc.key";
    options {
        directory "/var/cache/bind";
        allow-new-zones yes;
        dnssec-validation auto;
        listen-on port 53 { 10.203.157.79; };
        forwarders {
                8.8.8.8;
                8.8.4.4;
                };
        forward only;
        allow-query { any; };
        recursion yes;
        minimal-responses yes;
        };
    controls {
        inet 10.203.157.79 port 953 allow { 10.203.157.79; } keys { "rndc-key"; };
        };
    root@designate:~#
    
3. Configure Designate in openstack. Please see `this guide <https://docs.openstack.org/mitaka/networking-guide/config-dns-int.html>` for more details.
4. Create a pool pointing to your nameserver

Now, when starting the Heat Deployment, use this nameserver. When the stack heat has started, retrieve the random string (XXX in the example) and create the zone XXX.yourdomain (yourdomain is what you have filled in `dcae_domain` in onap_openstack.env).
For OOM, use the DNS on the container host so it can give it to the relevant VM.
