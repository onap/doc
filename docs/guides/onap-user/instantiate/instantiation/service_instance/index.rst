.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 ONAP Contributors.  All rights reserved.


Service Instantiation
=====================

**Pre-requisites**

- The Service has been designed and distributed (see: :ref:`Service Design <doc_guide_user_des_ser-des>`)
- pre-instantiation operations have been performed
  (see: :ref:`pre instantiation section <doc_guide_user_pre_ser-inst>`)

**Possible Tools to perform Service Instantiation**

- **via a Graphical User Interface tool**
  using ONAP applications such as **ONAP VID** and **ONAP UUI** tools

- **via any tool able to perform REST API requests**
  (for example : Robot Framework, Postman, Curl...) connected
  to **ONAP SO** legacy API or **ONAP extAPI/NBI** standard TMF641 API
  to add/delete Service.

**Possible methods with ONAP to instantiate a Service**

- **A La Carte**
  method requires the user to build and send
  operations **for each object** to instantiate : Service, VNFs,
  VFModules and Networks (in other words : once you have instantiated
  the Service object, you still have to instantiate the various VNFs
  or Networks that compose your Service).
  To build those requests, the user needs to define/collect by himself
  all necessary parameters/values.

- **Macro**
  method allows the user to build and send
  **only one request to instantiate all objects** : Service, VNFs,
  VFModules and Networks. Thanks to templates (see CDS Blueprint in
  Design section),
  ONAP will collect and assign all required parameters/values by itself.


  .. Note:: **Macro** method is not (yet) available via ONAP VID
   nor via extAPI/NBI

With "A La Carte" method
------------------------

.. toctree::
   :maxdepth: 1

      using ONAP VID Portal  <../vid/index.rst>
      using ONAP NBI REST API (TM Forum) <../nbi/index.rst>
      using ONAP SO REST API <../so1/index.rst>

With "Macro" method
-------------------

.. toctree::
   :maxdepth: 1

      using ONAP SO REST API <../so2/index.rst>
