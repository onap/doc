.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 ONAP Contributors.  All rights reserved.


VNF Instantiation
=================

**Pre-requisites**

- The VNF is part of a Service Model (see: :ref:`Service Design <doc_guide_user_des_ser-des>`)

  .. Note:: In ONAP SDC tool, VNF is named "VF"


**Possible methods with ONAP to instantiate a VNF**

- With **A La Carte**
  method, the user needs to build and send a VNF instantiation
  request.

    Note 1: prior to be able to send a request to instantiate
    a VNF, the user needs to instantiate a Service Object and then will
    need to refer to that Service instance in the VNF instantiate request.

    Note 2: after having instantiated the VNF object, the user needs to
    instantiate a VF-module object, refering to the previously instantiated
    VNF object.

    Note 3: the request to instantiate the VF-module object will, at last, send
    a request to the selected Cloud Platform (Openstack, Azure, K8S...).

- With **Macro**
  method, the user do not need to send any
  VNF instantiation request. VNF instantiation is being automatically
  performed by ONAP when sending the request to instantiate the Service
  (see: Instantiate Service).


**Possible Tools to perform VNF Instantiation**

the user needs such a tool only if using the "A La Carte" method.

- **via ONAP VID Graphical User Interface tool**

- **via any tool able to perform REST API requests**
  (for example : Robot Framework, Postman, Curl...) connected
  to **ONAP SO** legacy API.

With "A La Carte" method
------------------------

.. toctree::
   :maxdepth: 1

   using ONAP VID Portal <../vid/index.rst>
   using ONAP SO REST API <../so1/index.rst>

With "Macro" method
------------------------

VNF and VF-Module instantiation are performed automatically when performing
Service Instantiation.
