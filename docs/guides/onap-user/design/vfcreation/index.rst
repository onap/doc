.. This work is licensed under a Creative Commons Attribution 4.0
.. International License. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 ONAP Doc Team.  All rights reserved.

.. _doc_guide_user_des_vf-cre:

VF Creation and Testing
=======================
**Goal**: Using VSPs, create one or more VFs as the building blocks for a
service. Validate and certify the VFs.

**ONAP Component**: SDC

**SDC user roles**: Designer, Tester

|image1|

Steps
-----

- `Create a VF`_
- `Update a VF [optional]`_
- `Submit a VF for testing`_
- `Test a VF`_

Create a VF
-----------

**Prerequisites:**

- Create a license for each VF (see Create a license model) (see also the
  tutorial Creating a Licensing Model)
- Create a Vendor Software Product.

**Steps**

#. From the SDC HOME page, click the *Vendor Software Component* icon in the
   header (upper right).

   |image2|

#. From the Import VF box, expand a VSP name and click the *Import VSP* icon.

   |image3|

#. In the General section, complete all fields.

   .. note:: Use the letters "VF" in the name to indicate that the component is a VF.

#. Click *Create*.

   - A message displays while VF creation is in progress. (This can take up to
     10 minutes.)
   - A message displays when VF creation is complete.

#. Click *Check In* to save changes.

   - A box displays for confirming the changes.

#. Enter a comment and click *OK*.

   - A message displays when the VF is checked in.

#. [Optional]  At any time before submitting the VF for testing, click these
   options to update VF information:

   .. note:: These tasks can be done only before submitting the VF for testing.

   - Icon ??? change the icon associated with the VF (vendor-supplied icons are
     preferred)
   - Deployment Artifacts ??? download, view, modify, or change VF deployment
     artifacts (for example, the contents of the Heat .zip file, which contains
     the Heat volume template, the VF license, etc.)
   - Information Artifacts ??? view or upload artifacts, such as test scripts, test
     results, or the AIC questionnaire
   - TOSCA Artifacts ??? view or upload the TOSCA model or the TOSCA template
   - Properties ??? define or update VF properties (not used in Release 1)
   - Composition ??? view or edit the graphical representation of the resource-level
     TOSCA model (generated from the Heat template)
   - Activity Log ??? view activity related to assets associated with the VF
     (displays the action, date, user, status, and any comments related to each
     action)
   - Deployment ??? view VF modules defined in the Heat template
   - Inputs ??? view inputs defined for the resource-level TOSCA model

#. After creating a VF, submit it for testing (see `Submit a VF for testing`_).

Update a VF [optional]
----------------------

- Update the VSP and other artifacts in a VF.
- Upload a new version the VSP to the VF whenever the VSP is updated (see steps
  3 to 5). Other reasons for updating a VF include:

  - artifact changes at the VF level that need be uploaded, for example,
    changes to ENV values (see step 6)

**Prerequisites:**

- `Create a VF`_.
- If the VSP was updated: Update a VSP [optional]

**Steps**

#. From the SDC HOME page, click *CATALOG* and search for a VF.

#. In the General section, click *Check Out*.
   The Select VSP field is displays.

#. In the Select VSP field, click *Browse*.
   The Import VF box displays and shows the VSP that was used to create the VF.

#. Expand the VSP field and click.

   |image4|

#. Click |image5|
   A progress bar displays. |image6|

#. Click *Deployment Artifact* to edit, upload, or delete associated [Optional]
   deployment artifacts.

#. Click *Information Artifact* and edit, upload, or delete associated
   [Optional] information artifacts.

#. Click *Check In* to save changes.

#. After updating the VF:

   - Submit the VF for testing (see Submit a VF for testing).
   - Update the VF version in any service that contains the VF
     (see step 4 in Update a service [optional]).

Submit a VF for testing
-----------------------

**Prerequisites:** `Create a VF`_

**Steps**

#. When a VF is ready for testing, click *CATALOG* and service for the VF.
#. Click the VF and click *Submit for Testing*.

   |image7|

   |image8|

#. Enter a message for the testers asking that they begin service certification
   and click *OK*.

   The default mail client launches with a draft email containing the message.

#. Add the email addresses of the people on the Certification Group for this
   site with the *Tester* role and send the email.

Test a VF
---------

Test the design and artifacts of a VF.

**Prerequisites:** `Submit a VF for testing`_.

**Steps**

#. Sign in to SDC as a *Tester*.
#. From the HOME page, select *Ready For Testing* under Active Projects.
#. In the right pane, click the VF.
#. Click *Start Testing*.
#. Test the VF.
#. When testing is complete, click *Accept*.

.. |image1| image:: media/design_vf_workflow.png
.. |image2| image:: media/image2017-1-27_11-13-30.png
.. |image3| image:: media/image2017-1-27_11-14-3.png
.. |image4| image:: media/image2017-1-27_11-17-18.png
.. |image5| image:: media/sdc_artifact_update.png
.. |image6| image:: media/design_vf_updatevspmessage.png
.. |image7| image:: media/image2017-1-27_11-20-13.png
.. |image8| image:: media/image2017-1-27_11-21-4.png
