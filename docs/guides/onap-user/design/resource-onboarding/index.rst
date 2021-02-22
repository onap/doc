.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 ONAP Contributors. All rights reserved.

.. _doc_guide_user_des_res-onb:

Resource Onboarding
===================
**Goal:** Add models and other artifacts required to create, configure,
          instantiate, and manage a VF/PNF and, optionally, a VFC.

**Tool:** SDC

**SDC user role:** Designer

|image0|

**Steps**
    * `Create a License Model [Optional]`_
        * `Create a License Key Group [Optional]`_
        * `Create an Entitlement Pool`_
        * `Create a Feature Group`_
        * `Create a License Agreement`_
    * `Create a Vendor Software Product`_
    * `Update VFCs in a VSP [optional]`_
    * `Update a VSP [optional]`_

After updating the artifacts in a VSP, also update:
    * the VF/PNF created from the VSP
    * any services that include the VF/PNF

|image1|

.. _doc_guide_user_des_res-onb_cre-lic:

Create a License Model [Optional]
---------------------------------

VSPs optionally require a license and entitlements to enable the service
provider to track the usage.

.. note::
   For interim saving while creating the license model and its components, click |image2|

**Prerequisites:** To obtain license information, contact the service
provider's Supply Chain Management (SCM) group.


#. From the SDC HOME page, navigate to the ONBOARD Tab.

   |image11|

#. In the Workspace select *CREATE NEW VLM*.

   |image12|

#. Complete all fields.
#. Click *Create*.
#. After creation of the VLM, you should be presented with the “Overview” tab of the VLM.

   |image13|

   Select the following options in order:

   #. Create 0 or more license key groups (see
      `Create a License Key Group [Optional]`_).
   #. Create 1 or more entitlement pools (see `Create an Entitlement Pool`_).
   #. Create 1 or more feature groups (see `Create a Feature Group`_).
   #. Create 1 or more license agreements (see `Create a License Agreement`_).

      Note: Perform all steps above before submitting the license model to
      the SDC catalog.

   |image14|

#. Click *Submit* to add the license model to the catalog.After filling a comment, press *Commit&Submit*.

   |image15|

#. After creating a license, complete `Create a Vendor Software Product`_ to
   add the VSP required for the associated VF/PNF.


Create a License Key Group [Optional]
-------------------------------------

If required by the resource model, create one or more license key groups;
otherwise the license key group is optional.

**Prerequisites:** `Create a License Model [Optional]`_

#. Select the License Model in the Onboard section of the SDC.
#. In the Overview click the + inside the License Key Groups OR Navigate to License Key Groups and click on “+ ADD LICENSE KEY GROUP”

   |image4|

#. Complete all fields (mandatory fields are marked by a red asterisk).
#. Click *Save*.

Create an Entitlement Pool
--------------------------

**Prerequisites:** If required by the resource model, create one or more
license key groups (see
`Create a License Key Group [Optional]`_).

#. Select the License Model in the Onboard section of the SDC.
#. In the Overview click the + sign inside the Entitlement Pools OR Navigate to Entitlement Pools and click on “+ ADD ENTITLEMENT POOL”

   |image5|

#. Complete required fields (mandatory fields are marked by a red asterisk).
#. Click *Save*.

Create a Feature Group
----------------------

**Prerequisites:** Create one or more:

* license key groups if required by the resource model
  (see `Create a License Key Group [optional]`_)
* entitlement pools (see `Create an Entitlement Pool`_)

#. Select the License Model in the Onboard section of the SDC.
#. In the Overview click the + sign inside the Feature Groups OR Navigate to Feature Groups and click on “+ ADD FEATURE GROUP”

   |image6|

#. On the General tab, complete all fields.
#. Navigate to the *Entitlement Pools*. Tab
    * In the Available Entitlement Pools, select one or more entitlement pools and click on the “>” sign.
    * Selected pools should now be seen under the Selected Entitlements Pools.
#. Navigate to the *License Key Groups*. Tab
    * In the Available License Key Groups, select one or more license key groups and click on the “>” sign.
    * Selected pools should now be seen under the Selected License Key Groups.
#. Click *Save*.

Create a License Agreement
--------------------------

**Prerequisites:** Create one or more feature groups
                   (see `Create a Feature Group`_).

#. Select the License Model in the Onboard section of the SDC.
#. In the Overview click the + sign inside the License Agreements OR Navigate to License Agreements and click on “+ Add FEATURE GROUP”

   |image7|

#. On the General tab, complete required fields.
#. Click *Feature Groups*.
#. If not selected, click Available *Feature Groups*.
    * Select one or more groups in the Available Feature Groups, select one or more feature groups and click on the “>” sign.
    * Selected feature groups should now be seen under the Selected Feature Groups.
#. Click *Save*.
#. Return to step 6 of `Create a License Model [Optional]`_ to complete the license model.

.. _doc_guide_user_des_res-onb_cre-vsp:

Create a Vendor Software Product
--------------------------------

Create one or more Vendor Software Products (VSPs) as the building blocks
for VFs/PNFs.

.. note::
   For interim saving while creating a VSP, click |image2|

**Prerequisites:**

* `Create a License Model [Optional]`_
* VNF HEAT package or VNF/PNF CSAR/Zip package is available.

  See :ref:`sdc_onboarding_package_types` for a description
  of the onboarding package types.
* If the package is a secure package then :ref:`pre-install the corresponding Root Certificate in SDC <doc_guide_user_des_res-onb_pre-install_root_certificate>`.

.. note::
   Example packages can be found in the SDC project: :ref:`SDC Packages<onap-sdc:sdc_onboarding_package_types>`

#. From the SDC HOME page, click *ONBOARD*.

   |image11|

#. In the Workspace select *CREATE NEW VSP*.

   |image21|

#. Complete all fields.
#. Click *Create*.
     The Overview page is shown

   |image22|

#. Click *Internal* in the software product details section.

   .. note::
     Under License Agreement, there is a choice between internal or external license.
     If internal is selected then after redirect to general tab, select licenses details.
     If external is selected then in general tab licenses details are disabled.

#. For the defined Vendor, select a licensing version, a license agreement,
   and one or more feature groups.

   |image23|

#. [Optional] Complete other fields, such as Availability (high-availability
   zones) and Storage Data Replication (requirement for storage replication),
   as required.
#. In the *Overview* section, select *Software Product Attachments*
   (right pane), click *Select file*.
#. In case of a VNF HEAT file: Locate the Heat .zip package and click *Open*.

   In case of a VNF or PNF CSAR file: Locate the VNF or PNF csar/.zip package
   and click *Open*.
#. The file is loaded and the attachments page opens

   |image24|

#. Press the Button *Proceed to Validation*. After successful validation, SDC
   displays the files and a success message. If validation fails, SDC displays
   the errors in the files.

   Example Heat errors:

   |image9|

#. Click *Submit* to add the VSP to the catalog.

   After filling a comment, press *Commit&Submit*.
#. A success message is displayed. If the VSP attachments contain errors, an
   error message is displayed instead. Fix the issue(s) and re-submit.
#. To configure VFCs associated with the VSP, see
   `Update VFCs in a VSP [optional]`_, below.


.. _doc_guide_user_des_res-onb_upd-vfc:

Update VFCs in a VSP [optional]
-------------------------------

If required, configure Virtual Function Components (VFCs) associated with a
VSP, such as the Hypervisor, VM recovery details, and cloning. VFCs are listed
on the Components tab.

.. note::
  All fields are optional. Answers to questionnaires are stored as metadata
  only on the SDC platform.

**Prerequisites:** Add one or more VSPs
                   (see `Create a Vendor Software Product`_).

#. From the SDC HOME page, click *ONBOARD* and search for a VSP.
#. Selecting the VSP opens the *Versions* page.

   |image25|

#. Press the + at *Create New Version* on the version to update

   |image26|

#. Fill the fields and press *Create*
#. In Components , click a VFC (VSP component).

   The component links display in the left pane.
#. Click *General* to view and edit general parameters such as hypervisor,
   image format, VM recovery details, and DNS configuration.
#. Click *Compute* to view and edit VM parameters such as the number of VMs
   required for a VFC instance and persistent storage/volume size.
#. Click *High Availability & Load Balancing* to answer questions related
   to VM availability and load balancing.
#. Click *Networks* to view or edit parameters related to network capacity
   and interfaces.

   .. note::
     Click an interface to view or edit it. A dialog box displays similar
     to the figure below.

   |image10|

#. Click *Storage* to configure storage information, such as backup type,
   storage size, and logging.
#. Click *Process Details*, click *Add Component Process Details*, and complete
   the *Create New Process Details* dialog box.

   Use Process Details to identify
   the processes and configuration associated with VFCs.
#. Click *Monitoring* to upload MIB or JSON files for SNMP traps and polling.
#. To update the VSP, click *Submit*

   After filling a comment, press *Commit&Submit* and the
   new version is certified.

.. _doc_guide_user_des_res-onb_upd-vsp:

Update a VSP [optional]
-----------------------

Upload a new onboarding package to a VSP. Afterward, update the VF/PNF and service.

**Prerequisites:** Add one or more VSPs
                   (see `Create a Vendor Software Product`_).

#. From the SDC HOME page, click *ONBOARD* and search for a VSP.
#. Selecting the VSP opens the *Versions* page.

   |image25|

#. Press the + at *Create New Version* on the version to update

   |image26|

#. Fill the fields and press *Create*
#. In Software Product Attachments (right pane), click *Select file*.
#. In case of a VNF HEAT file: Locate the Heat .zip package and click *Open*.

   In case of a VNF or PNF CSAR file: Locate the VNF or PNF csar/.zip package
   and click *Open*.

    SDC warns that uploading a new package erases existing data.
#. Click *Continue* to upload the new package.
#. The file is loaded and the attachments page opens

   |image24|

#. Press the Button *Proceed to Validation*. After successful validation, SDC
   displays the files and a success message. If validation fails, SDC displays
   the errors in the files.

   Example Heat errors:

   |image9|

#. Click *Submit* to add the new VSP version to the catalog.
    After filling a comment, press *Commit&Submit* and the
    new version is certified.
#. After updating the VSP:

   #. Upload the VSP to the Vf/PNF
      (see steps 3 to 5 in :ref:`doc_guide_user_des_vf-cre`).
   #. Update the VF/PNF version in services that include the VF/PNF (see step 4
       in :ref:`doc_guide_user_des_ser-des`).

.. _doc_guide_user_des_res-onb_pre-install_root_certificate:

Pre-Install Root Certificate in SDC [only needed for secure package]
--------------------------------------------------------------------
SDC supports the onboarding of packages that are secured according to security option 2 in ETSI NFV-SOL 004v2.6.1.

During onboarding, SDC will validate the authenticity and integrity of a secure package. To enable this validation,
the root certificate corresponding to the certificate included in the package needs to be available to SDC.
This is currently done by uploading the root certificate to the following default directory location::

   /dockerdata-nfs/{{ .Release.Name }}/sdc/onbaording/cert

.. note::
   The directory listed above is mapped to the following directory in the onboarding pod (sdc-onboarding-be)
   ::

      /var/lib/jetty/cert

   so it is also possible to copy the root certificate directly to this directory in the pod.

The location where the root certificate is uploaded is configurable. The relevant parameters are described in
the *cert* block in the following values file::

   <path_to_oom_kubernetes>/sdc/charts/sdc-onboarding-be/values.yaml


.. |image0| image:: media/sdro-resource-onboarding-workflow.png

.. |image1| image:: media/sdro-vsp-service-workflow.png

.. |image2| image:: media/sdro-sdc_vsp_save.png

.. |image3| image:: media/sdro-license-creation.png

.. |image4| image:: media/sdro-license-keygroup.png

.. |image5| image:: media/sdro-entitlement-pool.png

.. |image6| image:: media/sdro-feature-group.png

.. |image7| image:: media/sdro-license-agreement.png

.. |image8| image:: media/sdro-software-product.png

.. |image9| image:: media/sdro-design_onboardvsp_heaterrors.png

.. |image10| image:: media/sdro-edit-nic.png

.. |image11| image:: media/sdro-new-vlm.png

.. |image12| image:: media/sdro-new-vlm-dialog.png

.. |image13| image:: media/sdro-new-vlm-overview.png

.. |image14| image:: media/sdro-license-model.png

.. |image15| image:: media/sdro-license-model-submit.png

.. |image21| image:: media/sdro-new-vsp.png

.. |image22| image:: media/sdro-new-vsp-overview.png

.. |image23| image:: media/sdro-new-vsp-general.png

.. |image24| image:: media/sdro-new-vsp-attachments.png

.. |image25| image:: media/sdro-vsp-version.png

.. |image26| image:: media/sdro-vsp-version-dialog.png
