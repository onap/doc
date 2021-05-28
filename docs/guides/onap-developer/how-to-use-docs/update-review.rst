.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _updates-and-review:

Updates and Review
==================

Most project owners will need only to concern themselves with their own
project documentation. However, documentation team members and certain
project owners will need to edit and test multiple documentation repositories.

Updates
-------

#. Create a JIRA task in the `ONAP JIRA <https://jira.onap.org/>`_
before you start the updates. The created issue's ID will have to be added to
the commit message.
.. note
  The task should be created in the affected project's workspace. The release
  should be specified, as well.
#. If you have not cloned the repository yet, follow the instructions in the
Git guide, section Cloning a repository. If you have done so already, pull the
latest version.
#. Create a local git branch for your changes.
#. Update the required documents in the project repo(s).
#. Build the documentation with tox.
#. Check the output for errors.
#. Add the changed files.
#. Commit your changes. In the commit message, include the issue ID of the
JIRA task, e.g. Issue-ID:DOC-602
#. Request review with git review.


Requesting Reviews
------------------
#. Go to the gerrit review's page included in the output of the git review
command.
#. In gerrit, add the committers for the given
project. For more information, refer to the `Gerrit guide <https://docs.releng.linuxfoundation.org/en/latest/gerrit.html#review>`_.

#. Implement comments by updating your patch, based on
`Updating an existing patch <https://docs.releng.linuxfoundation.org/en/latest/gerrit.html#update-an-existing-patch>`_
in the Gerrit guide.

.. note::
  If you already have the branch you need, skip the first 2 steps in the above
  guide.
