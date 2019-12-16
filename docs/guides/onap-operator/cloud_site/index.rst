.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.  http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.


Adding a Cloud Site
===================

By default, having deployed ONAP, you should have provided information
that have been used by installation procedure to configure ONAP
to be connected with a first Openstack Cloud Site in order to instantiate
services on that platform.

By default, ONAP to Cloud Site interactions are managed by
ONAP SO component directly.

You have also the possibility to configure ONAP SO to interact Cloud Site
via ONAP MultiCloud component.

To be able to add new Cloud Site you need to:

* configure ONAP SO to know about the new Cloud Site
* configure ONAP SO to know to use ONAP MultiCloud for that new CloudSite
* declare the new cloud Site in ONAP AAI
* register the new cloud Site in ONAP multiCloud


The following guides are provided to describe tasks that a user of
ONAP may need to perform to inter-connect ONAP with a a new cloud Site.

.. toctree::
   :maxdepth: 1

   openstack/index.rst
   k8s/index.rst
   aws/index.rst
   azure/index.rst
   vmware/index.rst
