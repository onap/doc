.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 ONAP Contributors. All rights reserved.

.. _doc_guide_user_des_pre-onb:

Pre-Onboarding
==============

    * `Generate Manifest and Package Artifacts`_ (for HEAT based VNFs)
    * `Validate xNF Package (VNF/PNF)`_


.. _doc_guide_user_des_pre-onb_gen-man:

Generate Manifest and Package Artifacts
---------------------------------------

.. note::
   This section describes the steps required to package a given HEAT
   template into a zip-file, which can be onboarded to SDC. Instructions
   to create TOSCA based VNF or PNF Onboarding Packages are not described
   here

The for onboarding the zip-file requires besides the HEAT template also a MANIFEST.json file, which describes the content of the package.
To generate a MANIFEST.json file a script can be used offered by the SDC project:
`generate-manifest.py`_

These steps are performed outside SDC.

**Prerequisites:** Obtain Heat/ENV files and other files required for
onboarding. The requirements are found in the following document.


:ref:`Heat requirements<onap-vnfrqts-requirements:heat_requirements>`

#. Put the Heat, ENV, nested Heat, and other files used by get-file in templates
   in a directory on a host, which supports python.

   Naming guidelines:

    - The base Heat should include "base" in the name.
    - The ENV file name should match the name of the Heat file with which it
      is associated.
    - All get-file file names need to be unique.

#. Put the python script in a directory one level above the directory that
   contains the Heat/ENV and other files.

   For example, [dir x]/[dir y]

    - [dir y] contains the Heat/ENV files and other files
    - [dir x] contains the python script

#. Run the script via command line:

   .. code-block:: python

      python generate-manifest.py -f "dir y"

#. Examine the manifest file and confirm that is correct.

#. Package all Heat/ENV files, all other files, and the MANIFEST.json
   into one .zip file.

Example packages can be found in the SDC poject: `example-packages`_

.. _doc_guide_user_des_pre-onb_val:

Validate xNF Package (VNF/PNF)
------------------------------

VNF and PNF packages have to follow the requirements described in:

:ref:`VNF and PNF Modeling Requirements<vnfrqts-requirements:tosca_requirements>`

:ref:`ONAP Management Requirements<vnfrqts-requirements:onap_management_requirements>`

For Validation of VNF and PNF packages the tools delivered by VNFSDK can be
used:

.. toctree::
   :maxdepth: 1
   :titlesonly:

   ../../../onap-provider/vnfvalidator.rst

Prior to resource onboarding, the Certification Group does the following:

 - for VNF and PNF
     - Validation of the delivered xNF package and artifacts
     - using the VNF Validation Tools
 - in case of VNF
    - onboards the Heat template(s) and metadata to the SDC catalog
    - creates a test VF
    - runs the Heat scanning tools
 - shares the results with any group that approves Virtual Functions

In parallel, the Certification Group onboards the VF Image and OS to a
standalone ONAP instance (the "sandbox") and performs the following:

 - security scan
 - compatibility test for the OS and vendor binary
 - malware scan

The Certification group then instantiates the VF image using the vendor
Heat (if provided) in order to validate that the VM can run on the Network
Cloud.

No VF functionality testing is performed at this stage.


.. _generate-manifest.py: https://git.onap.org/sdc/tree/openecomp-be/tools/scripts/generate-manifest.py
.. _example-packages: https://git.onap.org/sdc/tree/test-apis-ci/sdc-api-tests/chef-repo/cookbooks/sdc-api-tests/files/default/Files
