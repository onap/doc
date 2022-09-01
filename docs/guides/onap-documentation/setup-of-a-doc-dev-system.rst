.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2021 Deutsche Telekom AG



*******************************************
Setup of a Documentation Development System
*******************************************


..
   #########################################################################
   HOW TO FILL THIS SECTION:

   Release Relevance
      Name the ONAP release(s) where this document has a relevance.
      ONAP release number (ONAP release name starting with a capital letter)
      Examples:
      8.0.0 (Honolulu) - 1.0.0 (Amsterdam)
      7.0.1 (Guilin) - 3.0.0 (Casablanca), 1.0.0 (Amsterdam)

   Last Review/Update
      Date of last review and/or update of this document.
      Add "none" for a new document. Add concrete date if reviewed/updated.
      Use en-US format (mm/dd/yyyy).

   Initial Release
      Initial release date of this document.
      Use en-US format (mm/dd/yyyy).

   Author (Company)
      Name of the author and company name. Use comma to separate.
      Example:
      Jane Doe (ACME), John Doe (ACME)

   ! PLEASE DO NOT CHANGE THE STRUCTURE OF THIS SECTION.
   ! PLEASE ADD ONLY REQUESTED INFORMATION BELOW!
   #########################################################################

Release Relevance
   11.x.x (Kohn) - 10.x.x (Jakarta)

Last Review/Update
   2022/09/01

Initial Release
   2021/12/05

Author (Company)
   Thomas Kulik (Deutsche Telekom AG)

-------------------------------------------------------------------------------

.. contents:: Table of Contents

-------------------------------------------------------------------------------

Introduction
============

This guide provides a detailed description to set up a system suitable to
create, check and preview documentation locally. The targeted readership are
beginners and people interested in creating documentation.

The guide describes the setup of a development system from scratch using the
Ubuntu Desktop version installed in a virtual machine. It includes all required
steps and also some optional ones that may ease your daily work with this
development system. Feel free to adapt it to your needs.

In general, formal ONAP documentation uses the reStructuredText markup language
and the files have an ``.rst`` extension. They are part of almost every ONAP
project and can be found in the ``docs`` directory. The files are automatically
processed and you find the final ONAP documentation build hosted on
`ReadTheDocs <https://docs.onap.org>`__.

Beginning with the 'Frankfurt' release of ONAP, the documentation structure has
changed and the support of submodules was removed. Although large parts of this
guide are valid for earlier releases, the relevance has been limited.

-------------------------------------------------------------------------------

VM Configuration
================

.. note:: This section is for information only and should not be understood as
          a requirement.

Ubuntu Image
------------

+--------------------------------------+
| ubuntu-20.04.3-desktop-amd64.iso     |
+--------------------------------------+

Please check what image must be used for your type of hardware.

VM Configuration
----------------

+-------------------------+------------+
| Memory                  | 8 GB       |
+-------------------------+------------+
| Processors / Cores each | 2 / 2      |
+-------------------------+------------+
| Hard Disk               | 64 GB      |
+-------------------------+------------+

Depending on your requirements you can modify the values for virtual memory,
processors, cores or hard disk space.

VM Setup
--------

Follow the instructions of your virtualization solution to install Ubuntu in a
virtual machine. Log in after the installation has finished.

-------------------------------------------------------------------------------

Ubuntu Configuration
====================

.. note:: This section is optional and should not be understood as a
   requirement.

Finding Applications
--------------------

The following actions are performed on the Ubuntu desktop. You may use the
desktop search function :guilabel:`Show Applications` (the |ShowApp| symbol in
the bottom left corner) to find the required applications. Later on you need to
start also a :guilabel:`Terminal` window from here.

Software Updates
----------------

Open :guilabel:`Software Updater` and update already installed Ubuntu packages.
You may need to restart the system afterwards.

Language Support
----------------

Open :guilabel:`Language Support`. You are asked to complete the installation.
Select the :guilabel:`Install` button to complete. Continue in the
:guilabel:`Language Support` window and open
:guilabel:`Install / Remove Languages`. Then select your preferred
:guilabel:`<LANGUAGE>`. Choose :guilabel:`Apply` to install the additional
language.

Regional Formats
----------------

Continue to the :guilabel:`Regional Formats` tab. Select a
:guilabel:`<FORMAT>` to show e.g. date, time and numbers in your preferred
format. Press :guilabel:`Close` to close the window.

Input Sources
-------------

To change the keyboard layout used e.g. in command line windows, open
:guilabel:`Settings`. Navigate to :guilabel:`Region & Language`. At
:guilabel:`Input Sources` press the :guilabel:`+` sign. Select your preferred
:guilabel:`<INPUTSOURCE>` and use :guilabel:`Add` to add it. Move it to the top
of the list using drag and drop. Close the window. You may need to logout from
the UI and login again to make your changes effective.

Screen Lock
-----------

Open :guilabel:`Settings`. Navigate to :guilabel:`Privacy` >
:guilabel:`Screen Lock` and change settings for :guilabel:`Blank Screen Delay`
and :guilabel:`Automatic Screen Lock` to values of your choice. Close the
window.

-------------------------------------------------------------------------------

Disable sudo password for your user
===================================

.. warning:: This section is optional and should not be understood as a
   requirement. Disabling password authentication for all commands is very
   convenient at use **but it strongly exposes your system to malicious code**.
   For a system dedicated to development it might be OK, but not for a
   production system! Handle with care. You have been warned.

Open a :guilabel:`Terminal` window and start the ``visudo`` editor with ...

.. code-block:: bash

   sudo visudo

and add ``<USER> ALL=(ALL) NOPASSWD:ALL`` to the end of the file. Replace
``<USER>`` with your user name.

-------------------------------------------------------------------------------

Install python3 related packages
================================

.. note:: The main python3 package is preinstalled in Ubuntu 20.04.

Open a :guilabel:`Terminal` window and update the package management system
with ...

.. code-block:: bash

   cd ~
   sudo apt update
   sudo apt -y upgrade

Install python3 related packages with ...

.. code-block:: bash

   sudo apt install -y python3-pip \
                       build-essential \
                       libssl-dev \
                       libffi-dev \
                       python3-dev \
                       python3-venv


Check the python3 version with ...

.. code-block:: bash

   python3 -V

-------------------------------------------------------------------------------

Install git and documentation related packages
==============================================

Install the required packages with ...

.. code-block:: bash

   sudo apt install -y git \
                       git-review \
                       python3-sphinx \
                       python3-doc8 \
                       curl \
                       jq \
                       tox

Check the git version and the path of the sphinx-build executable ...

.. code-block:: bash

   git --version

   which sphinx-build


.. tip:: Remember the path
   ``/usr/bin/sphinx-build``, you need it later
   to configure a VSC extension.
-------------------------------------------------------------------------------

Create virtual environment and activate
=======================================

In this guide, virtual environments are generally located in your home
directory under ``~/environments``. For the development of ONAP documentation
the virtual environment ``onapdocs`` is created. The full path is consequently
``~/environments/onapdocs``.

.. code-block:: bash

   cd ~
   mkdir environments
   cd ~/environments
   python3 -m venv onapdocs
   cd ~/environments/onapdocs
   source bin/activate

To indicate that you are now working in an virtual environment, the prompt of
your terminal has changed. Now it starts with ``(onapdocs)``.

-------------------------------------------------------------------------------

Install required Sphinx packages in activated environment (I)
=============================================================

It is :strong:`important` to activate the ``onapdocs`` environment before you
continue. If not already done, activate environment with ...

.. code-block:: bash

   cd ~/environments/onapdocs
   source bin/activate

To indicate that you are now working in an virtual environment, the prompt of
your terminal has changed. Now it starts with ``(onapdocs)``.

.. important:: Now you are installing packages only for the 'onapdocs' virtual
   environment.

.. code-block:: bash

   pip3 install wheel

-------------------------------------------------------------------------------

Install Visual Studio Code (VSC) and update already installed applications
==========================================================================

The following actions are performed on the Ubuntu desktop. You may use the
desktop search function :guilabel:`Show Applications` (the |ShowApp| symbol in
the bottom left corner) to find the required applications.

Open :guilabel:`Ubuntu Software` > :guilabel:`Development`, select
:guilabel:`code` (Visual Studio Code) and press :guilabel:`Install` to install
the integrated development environment (IDE).

Open :guilabel:`Ubuntu Software` > :guilabel:`Updates` to ensure that your
installed applications are up to date.

-------------------------------------------------------------------------------

Clone example repo (no LF account)
==================================

Clone repo
----------

For a quick start you can clone e.g. the ``doc`` repository even without a
Linux Foundation (LF) account with ...

.. code-block:: bash

   cd ~/environments/onapdocs
   git clone --branch master https://git.onap.org/doc/ ./doc

-------------------------------------------------------------------------------

Clone example repo (LF account used)
====================================

Prerequisite configuration
--------------------------

If you plan to contribute to the ONAP community and you want to submit changes
to a specific project later on, please refer to the
`ONAP Developer Wiki <https://wiki.onap.org>`__ to get information about all
the prerequisite details.

If you already have a LF account and you have shared your public ssh key you
can finalize the configuration of this development system by updating your ssh
configuration in the ``~/.ssh`` directory by copying over ``config``,
``id_rsa`` and ``id_rsa.pub``

In addition you configure ``git`` and ``git-review`` with ...

.. code-block:: bash

   git config --global user.email "<GIT-EMAIL>"
   git config --global user.name "<GIT-USER>"
   git config --global --add gitreview.username "<GIT-USER>"
   git config --global gitreview.remote origin

Replace ``<GIT-EMAIL>`` and ``<GIT-USER>`` with your account details.

Clone repo
----------

.. code-block:: bash

   cd ~/environments/onapdocs
   git clone ssh://<GIT-USER>@gerrit.onap.org:29418/doc

-------------------------------------------------------------------------------

Install required Sphinx packages in activated environment (II)
==============================================================

Continue with the installation of required packages. Use the file
``requirements-docs.txt`` for it. The file resides in the downloaded ``doc``
repository.

.. code-block:: bash

   cd ~/environments/onapdocs
   sudo pip install -r doc/etc/requirements-docs.txt

-------------------------------------------------------------------------------

Start VSC in the correct directory
==================================

Start VSC (always) in the ``docs`` directory of your repository. For the
``doc`` repository used in this example do this with ...

.. code-block:: bash

   cd doc
   cd docs
   code .

.. important:: Don't forget the ``.`` (dot) when you start Visual Studio Code.

.. tip:: ``~/environments/onapdocs/doc/docs`` is now your
   ``${workspaceFolder}`` because you have started VSC (``code .``) from here!

-------------------------------------------------------------------------------

Disable Telemetry of VSC
========================

In case you want to disable telemetry functionality of Visual Studio Code, open
:guilabel:`File` > :guilabel:`Preferences` > :guilabel:`Telemetry Settings` and
turn it ``off`` in the selection field.

In an older version of VSC you alternatively need to open
:guilabel:`File` > :guilabel:`Preferences` > :guilabel:`Settings` and
search for ``telemetry``. Then uncheck
:guilabel:`Telemetry: Enable Crash Reporter` and
:guilabel:`Telemetry: Enable Telemetry`

.. warning:: Extensions may be collecting their own usage data and are not
   controlled by the ``telemetry.enableTelemetry`` setting. Consult the
   specific extension's documentation to learn about its telemetry
   reporting and whether it can be disabled. See also
   https://code.visualstudio.com/docs/getstarted/telemetry

-------------------------------------------------------------------------------

Install VSC extensions and configure reStructuredText extension
===============================================================

Install VSC extensions
----------------------

Extension bring additional power to Visual Studio Code. To search and install
them, open :guilabel:`File` > :guilabel:`Preferences` > :guilabel:`Extensions`
or use the keyboard shortcut ``[Ctrl+Shift+X]``. Then enter the name of the
extension in the :guilabel:`Search Extensions in Marketplace` window.
Press :guilabel:`Install` if you have found the required extension.

Please install ...

+--------------------------------------+---------------------------------------+---------+
| Python                               | ms-python.python                      | latest  |
+--------------------------------------+---------------------------------------+---------+
| reStructuredText                     | lextudio.restructuredtext             | 169.0.0 |
+--------------------------------------+---------------------------------------+---------+
| reStructuredText Syntax highlighting | trond-snekvik.simple-rst              | latest  |
+--------------------------------------+---------------------------------------+---------+
| Code Spell Checker                   | streetsidesoftware.code-spell-checker | latest  |
+--------------------------------------+---------------------------------------+---------+
| Prettier                             | esbenp.prettier-vscode                | latest  |
+--------------------------------------+---------------------------------------+---------+
| GitLens                              | eamodio.gitlens                       | latest  |
+--------------------------------------+---------------------------------------+---------+

.. warning:: Use the reStructuredText extension version 169.0.0 or lower to
   avoid problems with the preview. You need to downgrade after the initial
   installation. This can be done by using 
   :guilabel:`Uninstall` > :guilabel:`Install Another Version...` in the VSC
   extension management.

Configure reStructuredText extension
------------------------------------

To configure ``reStructuredText`` extension, open :guilabel:`File` >
:guilabel:`Preferences` > :guilabel:`Extensions` or use the keyboard shortcut
``[Ctrl+Shift+X]``. Then enter ``reStructuredText`` in the
:guilabel:`Search Extensions in Marketplace` window. After you have found the
extension press :guilabel:`Manage` (the little |GearSymb| symbol on the right
bottom) and select :guilabel:`Extension Settings`. A new windows in VSC shows
all the parameters. Change the following ones:

 :strong:`Restructuredtext › Linter: Executable Path`
  ``/usr/bin/doc8``

 :strong:`Restructuredtext › Linter: Name`
  ``doc8``

 :strong:`Restructuredtext: Sphinx Build Path`
  ``/usr/bin/sphinx-build``

Replace ``<USER>`` with your user name.

Only in case the preview creates an error message, try ...

  :strong:`Restructuredtext: Conf Path`
   ``${workspaceFolder}/docs``

Close the :guilabel:`Extension Settings` window.

Close VSC and start it again with the ``code .`` command.

-------------------------------------------------------------------------------

Open a .rst file and preview it in VSC
======================================

Open .rst file
--------------

Select :guilabel:`View` > :guilabel:`Explorer`. Or use the |FileExpl| symbol in
the upper left corner. Expand the ``docs`` folder by clicking on the ``>``
symbol. Select the file ``index.rst``. The code shows up in the right pane
window of VSC.

Alternatively you can open this guide and see how it looks like in the
reStructuredText format. It can be found in ``docs/guides/onap-documentation``
and is named ``setup-of-a-doc-dev-system.rst``.

Problem Window
--------------

You may see problems with the reStructuredText markup because the code is
underlined in various colors. For the details select :guilabel:`View` >
:guilabel:`Problems` to open an additional window at the bottom of VSC.

When you select a specific entry in the problem list, the code window is
updated to show the related line in the code.

Preview
-------

Now select :guilabel:`Preview To The Side` (the |Preview| symbol on the top
right) or use keyboard shortcut ``[Ctrl+k Ctrl+r]`` to open the preview window
on the right hand side. This may take a few seconds. The preview shows up and
renders the ``index.rst`` as it would look like on ReadTheDocs.

Tips and Tricks
---------------

The learnings are ...

.. tip::
   - Start VSC always in the ``docs`` directory of the repository. Use the
     command ``code .``. Then navigate via VSC's :guilabel:`Explorer`
     |FileExpl| to the directory which contains the file you like to edit. VSC
     may ask you, which ``conf.py`` VSC should use. Choose the one which
     resides in the directory where you have started VSC. Check also the (blue)
     bottom line of VSC. There you see which ``conf.py`` is currently in use.
     The content of ``conf.py`` affects how the documentation is presented.
   - VSC may claim that some packages require an update. This can be easily
     fixed. VSC offers automatically to install or update the package.
   - VSC may ask you to install ``snooty``. Please install.
   - Select the correct environment in the (blue) bottom line
     ``'onapdocs':venv``. Have also a view on the other interesting
     information (e.g. the ``conf.py`` which is currently in use).
   - First, close and reopen preview if preview is not shown properly.
   - Second, close and reopen VSC if preview is not shown properly.
   - Save your file if an error does not disappear after you have corrected it.
   - You can not navigate within the document structure by clicking the links
     in the preview. You always have to choose the correct file in the VSC
     :guilabel:`Explorer` window.

That's it!
----------

Congratulations, well done! You have configured a system well suited to
develop ONAP documentation and to master the challenges of reStructuredText.
Now have a look at all the different elements of reStructuredText and learn how
to use them properly. Or maybe you like to do some optional configurations at
your system first.

-------------------------------------------------------------------------------

Optional VSC Configuration
==========================

Add Ruler
---------

To add a ruler that indicates the line end at 79 characters, open
:guilabel:`File` > :guilabel:`Preferences` > :guilabel:`Settings` and enter
``ruler`` in the :guilabel:`Search settings` field. In
:guilabel:`Editor: Rulers` click on :guilabel:`Edit in settings.json` and add
the value ``79``. The result should look like this:

.. code-block:: bash

    "editor.rulers": [
        79
    ]

Disable Synchronized Scrolling of Editor and Preview
----------------------------------------------------

To disable the synchronized scrolling of editor and preview, open
:guilabel:`File` > :guilabel:`Preferences` > :guilabel:`Settings` and
search for ``Restructuredtext › Preview: Scroll``. Then uncheck
:guilabel:`Restructuredtext › Preview: Scroll Editor With Preview` and
:guilabel:`Restructuredtext › Preview: Scroll Preview With Editor`

-------------------------------------------------------------------------------

Miscellaneous
=============

.. note:: This section is optional and should not be understood as a
   requirement.

Firefox Add-ons
---------------

Open :guilabel:`Add-Ons and Themes`, then search and install the following
add-ons:

+------------------------------+-------------------------------+
| I don't care about cookies   | Get rid of cookie warnings.   |
+------------------------------+-------------------------------+
| UBlock Origin                | A wide-spectrum blocker.      |
+------------------------------+-------------------------------+
| LastPass Password Manager    | Used in the Linux Foundation. |
+------------------------------+-------------------------------+

ReText Editor
-------------

Install this simple editor with ...

.. code-block:: bash

   sudo apt install -y retext

-------------------------------------------------------------------------------

Helpful Resources
=================

This is a collection of helpful resources if you want to extend and deepen your
knowledge.

Documentation
-------------

- `Write The Docs: Documentation Guide <https://www.writethedocs.org/guide>`__
- `Techwriter Documatt Blog <https://techwriter.documatt.com/>`__

Gerrit
------

- `LF RelEng Gerrit Guide <https://docs.releng.linuxfoundation.org/en/latest/gerrit.html>`_

Git
---

- `LF RelEng Git Guide <https://docs.releng.linuxfoundation.org/en/latest/git.html>`__
- `How To Install Git on Ubuntu 20.04 <https://www.digitalocean.com/community/tutorials/how-to-install-git-on-ubuntu-20-04>`__

ONAP Documentation Procedures for Developers
--------------------------------------------

- `Procedure #1 for the ONAP Documentation Team <https://wiki.onap.org/x/-IpkBg>`__
- `Procedure #2 for all other ONAP Project Teams <https://wiki.onap.org/x/w4IEBw>`__

Python
------

- `Install Python for Most Features <https://docs.restructuredtext.net/articles/prerequisites.html#install-python-for-most-features>`__
- `How To Install Python 3 and Set Up a Programming Environment on an Ubuntu 20.04 Server <https://www.digitalocean.com/community/tutorials/how-to-install-python-3-and-set-up-a-programming-environment-on-an-ubuntu-20-04-server>`__
- `Using Python environments in VS Code <https://code.visualstudio.com/docs/python/environments>`__
- `Getting Started with Python in VS Code <https://code.visualstudio.com/docs/python/python-tutorial>`__
- `Linux Foundation Docs Conf (obsolete) <https://pypi.org/project/lfdocs-conf/>`__

ReadTheDocs
-----------

- `Documentation <https://docs.readthedocs.io/en/stable/>`__
- `GitHub <https://github.com/readthedocs/readthedocs.org/>`__

ReadTheDocs Sphinx Theme
------------------------

- `ReadTheDocs Sphinx Theme (Recommended Reading!) <https://sphinx-rtd-theme.readthedocs.io/en/stable/>`__
- `ReadTheDocs Sphinx Theme Configuration <https://sphinx-rtd-theme.readthedocs.io/en/latest/configuring.html>`__

reStructuredText
----------------

- `reStructuredText Directives <https://docutils.sourceforge.io/docs/ref/rst/directives.html>`__
- `reStructuredText and Sphinx Cheat Sheet I <https://thomas-cokelaer.info/tutorials/sphinx/rest_syntax.html>`__
- `reStructuredText and Sphinx Cheat Sheet II <https://docs.typo3.org/m/typo3/docs-how-to-document/master/en-us/WritingReST/CheatSheet.html>`__


..
  currently unavailable
  - `Online reStructuredText Editor <http://rst.ninjs.org/#>`__


Sphinx
------

- `Sphinx Documentation Generator <https://www.sphinx-doc.org/en/master/>`__

Ubuntu
------

- `Virtualized Ubuntu Desktop Edition <https://linuxconfig.org/ubuntu-20-04-system-requirements>`__

Visual Studio Code (VSC)
------------------------

- `VSC Basic Editing <https://code.visualstudio.com/docs/editor/codebasics>`__
- `Code Formatting with Prettier in Visual Studio Code <https://www.digitalocean.com/community/tutorials/code-formatting-with-prettier-in-visual-studio-code>`__
- `VSC Icons <https://github.com/microsoft/vscode-icons>`__
- `reStructuredText Extension <https://docs.restructuredtext.net/>`__

-------------------------------------------------------------------------------

Backlog
=======

There are still some open topics or issues in this guide. They are subject
for one of the upcoming releases.

 - consider ``pandoc`` in this guide?
 - VSC / reStructuredText Extension Settings / reStructuredText: Sphinx Build
   Path: ${workspaceRoot} , ${workspaceFolder} , any alternatives?
 - VSC extension configuration: Difference between "Workspace" and "User"?
 - link to full ``ssh`` install/config?
 - link to full ``git`` install/config?
 - how to limit line width to improve readability? setting in conf.py?
 - keyboard shortcut ``[Ctrl+Shift+X]`` or :kbd:`Ctrl` + :kbd:`Shift` +
   :kbd:`X` Is this a problem in the RTD theme?
 - use ``menuselection``
   :menuselection:`My --> Software --> Some menu --> Some sub menu 1`?
 - evaluate and add VSC extension to "draw" tables in an aided way
 - add infos for config files, e.g. ``conf.py``, ``conf.yaml``
 - find the reason for VSC error message
   ``Substitution definition "ShowApp" empty or invalid.``
 - find the reason for VSC error message
   ``Unexpected indentation``
 - find a solution to wrap lines in VSC automatically (79 chars limit)
 - evaluate ``snooty`` and describe functionality (build in? not a extension?)
 - add a table explaining the role of installed packages/extensions in every
   section
 - update instructions to enable use of latest reStructuredText VSC extension

..
   #########################################################################
   EMBEDDED PICTURES & ICONS BELOW
   #########################################################################

.. |ShowApp| image:: ./media/view-app-grid-symbolic.svg
   :width: 20

.. |Preview| image:: ./media/PreviewOnRightPane_16x.svg
   :width: 20

.. |FileExpl| image:: ./media/files.svg
   :width: 20

.. |GearSymb| image:: ./media/gear.svg
   :width: 20
