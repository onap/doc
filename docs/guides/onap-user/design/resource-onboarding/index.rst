.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 ONAP Contributors. All rights reserved.

.. _doc_guide_user_des_res-onb:

Resource Onboarding
===================
**Goal:** Add models and other artifacts required to create, configure, instantiate, and manage a VF and, optionally, a VFC.

**Tool:** SDC

**SDC user role:** Designer

|image0|

**Steps**
    * `Create a License Model`_
    * `Create a License Key Group [Optional]`_
    * `Create an Entitlement Pool`_
    * `Create a Feature Group`_
    * `Create a License Agreement`_
    * `Create a Vendor Software Product`_
    * `Update VFCs in a VSP [optional]`_
    * `Update a VSP [optional]`_

After updating the artifacts in a VSP, also update:
    * the VF created from the VSP
    * any services that include the VF

|image1|

Create a License Model
----------------------

VSPs optionally require a license and entitlements to enable the service provider to track the usage.

Note: For interim saving while creating the license model and its components, click |image2|

**Prerequisites:** To obtain license information, contact the service provider's Supply Chain Management (SCM) group.

|image3|

#. From the SDC HOME page, click *ONBOARD*.
#. Hover over Add and select New License Model.
#. Complete all fields.
#. Click *Save*.
#. In the ONBOARD header, hover over the arrow after License Agreements to reveal a menu.
   Select the following options in order:

   #. Create 0 or more license key groups (see `Create a License Key Group [Optional]`_).
   #. Create 1 or more entitlement pools (see `Create an Entitlement Pool`_).
   #. Create 1 or more feature groups (see `Create a Feature Group`_).
   #. Create 1 or more license agreements (see `Create a License Agreement`_).

      Note: Perform all steps above before submitting the license model to the SDC catalog.

#. In the header, click the license model created in steps 1 to 4.
#. Click *Check In* to save changes.
#. Click *Submit* to add the license model to the catalog. A success message displays.
#. After creating a license, complete `Create a Vendor Software Product`_ to add the VSP required for the associated VF.

Create a License Key Group [Optional]
-------------------------------------

If required by the resource model, create one or more license key groups; otherwise the license key group is optional.

**Prerequisites:** `Create a License Model`_

|image4|

1. From the drop-down menu, select License Key Groups.
2. Click *Add License Key Group*.
    The Create New License Key Group box displays.
3. Complete all fields.
    Note: Enter the manufacturer reference number in the Name field.
4. Click *Save*.

Create an Entitlement Pool
--------------------------

**Prerequisites:** If required by the resource model, create one or more license key groups (see `Create a License Key Group [Optional]`_).

|image5|

1. From the drop-down menu, select Entitlement Pools.
2. Click *Add Entitlement Pool*.
    The Create New Entitlement Pool box displays.
3. Complete required fields (mandatory fields are marked by a red asterisk).
4. Click *Save*.

Create a Feature Group
----------------------

**Prerequisites:** Create one or more:

* license key groups if required by the resource model (see `Create a License Key Group [optional]`_)
* entitlement pools (see `Create an Entitlement Pool`_)

|image6|

1. From the drop-down menu, select Feature Groups.
2. Click *Add Feature Group*.
    The Create New Feature Group box displays.
3. On the General tab, complete all fields.
4. Click *Entitlement Pools*.
5. Click *Available Entitlement Pools*.
6. Select one or more entitlement pools and click the right arrow.
7. Click *License Key Groups*.
8. Click *Available License Key Groups*.
9. Select one or more license key groups and click the right arrow.
10. Click *Save*.

Create a License Agreement
--------------------------

**Prerequisites:** Create one or more feature groups (see `Create a Feature Group`_).

|image7|

1. From the drop-down menu, select License Agreements.
2. Click *Add License Agreement*.
    The Create New License Agreement box displays.
3. On the General tab, complete required fields (mandatory fields are marked by a red asterisk).
4. Click *Feature Groups*.
5. If not selected, click *Available Feature Groups*.
6. Select one or more groups and click the right arrow.
7. Click *Save*.
8. Return to step 5 of `Create a License Model`_ to complete the license model.

Create a Vendor Software Product
--------------------------------

Create one or more Vendor Software Products (VSPs) as the building blocks for VFs.

.. note::
   For interim saving while creating a VSP, click |image2|

**Prerequisites:**

* `Create a License Model`_
* Generate manifest and package artifacts.

#. From the SDC HOME page, click *ONBOARD*.
#. Hover over Add and select New Vendor Software Product.
#. The New Software Product box is displayed.
    Complete all fields.
#. Click *Save*.
    The Overview section is displayed.

   .. note::
     A warning is displayed under License Agreement if the VSP does not have an associated license.

#. Click *Software Product Details* (left pane).

   |image8|

#. In order, select a licensing version, a license agreement, and one or more feature groups.
#. [Optional] Complete other fields, such as Availability (high-availability zones) and Storage
   Data Replication (requirement for storage replication), as required.
#. In Software Product Attachments (right pane), click *Select file*.
#. Locate a Heat .zip package and click *Open*.
   SDC validates the files in the package. After successful validation, SDC displays the files
   and a success message. If validation fails, SDC displays the errors in the files.

   Example Heat errors:

   |image9|

#. Click *Check In* to save the changes.
#. Click *Submit* to add the VSP to the catalog.
#. A success message is displayed. If the VSP attachments contain errors, an error message is displayed instead. Fix the issue(s) and re-submit.
#. To configure VFCs associated with the VSP, see `Update VFCs in a VSP [optional]`_, below.


Update VFCs in a VSP [optional]
-------------------------------

If required, configure Virtual Function Components (VFCs) associated with a VSP, such as the Hypervisor, VM recovery details, and cloning. VFCs are listed on the Components tab.

.. note::
  All fields are optional. Answers to questionnaires are stored as metadata only on the SDC platform.

**Prerequisites:** Add one or more VSPs (see `Create a Vendor Software Product`_).

#. From the SDC HOME page, click *ONBOARD* and search for a VSP.
#. In the Overview section, click *Check Out*.
#. In Components (bottom pane), click a VFC (VSP component).
    The component links display in the left pane.
#. Click *General* to view and edit general parameters such as hypervisor, image format, VM recovery details, and DNS configuration.
#. Click *Compute* to view and edit VM parameters such as the number of VMs required for a VFC instance and persistent storage/volume size.
#. Click *High Availability & Load Balancing* to answer questions related to VM availability and load balancing.
#. Click *Networks* to view or edit parameters related to network capacity and interfaces.

   .. note::
     Click an interface to view or edit it. A dialog box displays similar to the figure below.

   |image10|

#. Click *Storage* to configure storage information, such as backup type, storage size, and logging.
#. Click *Process Details*, click *Add Component Process Details*, and complete the Create New Process Details dialog box. Use Process Details to identify the processes and configuration associated with VFCs.
#. Click *Monitoring* to upload MIB or JSON files for SNMP traps and polling.
#. Click *Overview* and click *Check In* to save changes.
#. If updating a VSP, click *Submit*. If this procedure is performed during the workflow to create a VSP, there is no need to click *Submit* now.

Update a VSP [optional]
-----------------------

Upload a new Heat package to a VSP. Afterward, update the VF and service.

**Prerequisites:** Add one or more VSPs (see `Create a Vendor Software Product`_).

#. From the SDC HOME page, click *ONBOARD* and search for a VSP.
#. In the Overview section, click *Check Out*.
#. In Software Product Attachments (right pane), click *Select file*.
#. Locate a Heat .zip package and click *Open*.
    SDC warns that uploading a new package erases existing data.
#. Click *Continue* to upload the new Heat package.
    SDC validates the files in the package. After successful validation, SDC displays the files and a success message. If validation fails, SDC displays the errors in the files.

   .. note::
     If the Heat template contains errors, contact the Certification Group for guidance on how to proceed.

#. Click *Check In* to save changes.
#. Click *Submit* to add the VSP to the catalog.
    A success message is displayed. If the VSP attachments contain errors, an error message is displayed instead. Fix the issue(s) and re-submit.
#. After updating the VSP:
   #. Upload the VSP to the VF (see steps 3 to 5 in (TBD)Update a VF [optional]).
   #. Update the VF version in services that include the VF (see step 4 in (TBD) Update a service [optional]).


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
