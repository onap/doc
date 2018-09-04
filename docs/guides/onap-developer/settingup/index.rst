.. This work is licensed under
.. a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 AT&T Intellectual Property.  All rights reserved.


Setting Up ONAP
===============

ONAP can be deployed using 3 different solutions:

* Installation using Kubernetes (aka OOM). Recommended method.
* Installation using Heat template.
* Advanced installation to install individual components.

The following table presents the required resources to deploy ONAP.

  ============  ===  ====  ===========  ============
  Installation  VM   vCPU  Memory (GB)  Storage (GB)
  ============  ===  ====  ===========  ============
  Kubernetes    4    32    128          160
  Heat          20   88    176          1760
  Individual    1*   1*    2*           20*
  ============  ===  ====  ===========  ============

(*) For individual deployment, it depends on the components.

The various installations can be found here:

.. toctree::
   :maxdepth: 1
   :titlesonly:

   onap_oom.rst
   onap_heat.rst
   onap_individual.rst
