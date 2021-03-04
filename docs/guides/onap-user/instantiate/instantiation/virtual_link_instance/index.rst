.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 ONAP Contributors.  All rights reserved.


Network Instantiation
=====================

Note: in ONAP SDC, network object is called "virtual link"

**Various possible methods are available with ONAP to instantiate a network**

- With **A La Carte**
  method, the user needs to build and send a Network instantiation
  request.

    Note 1: prior to be able to send a request to instantiate
    a Network, the user needs to instantiate a Service Object and then will
    need to refer to that Service instance in the Network instantiate request.

    Note 2: the request to instantiate the Network object will update
    ONAP AAI (inventory) and will send a request to the selected Cloud Platform
    (Openstack, Azure, K8S...).

- With **Macro**
  method, the user do not need to send any
  Network instantiation request. Network instantiation is being automatically
  performed by ONAP when sending the request to instantiate the Service
  (see: Instantiate Service).

**Possible Tools to perform Network Instantiation**

the user needs such a tool only if using the "A La Carte" method.

- **via ONAP VID Graphical User Interface tool**

- **via any tool able to perform REST API requests**
  (for example : Robot Framework, Postman, Curl...) connected
  to **ONAP SO** legacy API.

With "A La Carte" method
------------------------

.. toctree::
   :maxdepth: 1

   using ONAP VID Portal <../vid1/index.rst>
   using ONAP SO REST API <../so1/index.rst>

With "Macro" method
------------------------

Network instantiation is performed automatically when performing
Service Instantiation.
