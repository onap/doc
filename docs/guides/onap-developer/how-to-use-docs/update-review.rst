.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _updates-and-review:

Updates and Review
==================

Most project owners will need only to concern themselves with their own
project documentation. However, documentation team members and certain
project owners will need to edit and test multiple documentation repositories.
Fortunately, this is possible using git submodules.

Git submodules
--------------

Git submodules are working copies of an upstream repository which you
can clone inside your own project repositories. The documentation team
uses them, for example, to keep up-to-date clones of each contributing
project's :code:`docs` directory, found within the project repositories.

For example:

::

   doc
    +
    |
    + docs
        +
        |
        + submodules
               +
               |
               + ...
               |
               + cli.git
               |    +
               |    |
               |    + ...
               |    |
               |    + docs
               |    |
               |    + ...
               |
               + appc.git
               |    +
               |    |
               |    + ...
               |    |
               |    + docs
               |    |
               |    + ...
               |
               + ...


When the doc team needs to build the master documentation, all the
submodules are first updated before the build.

Setting up Git Submodules as a Doc Team Member
----------------------------------------------

Look `here <https://git-scm.com/book/en/v2/Git-Tools-Submodules>`_ for a
complete discussion of how to work with git submodules in any git
project. In this section, we'll focus on how to work with project submodules with
respect to the documentation.

Doc team members must frequently update submodules to contribute grammar
and spelling fixes, for example. The following describes the
best-practice for doing so.

First, set up your environment according the :ref:`directions for building the entire documentation tree <building-all-documentation>`
and make sure you can build the documentation locally.

Next, we'll need to checkout a branch for each submodule.  Although you
would rarely want to work on the master branch of a project repository
when writing code, we'll stick to the master branch for documentation.
That said, some project leaders might prefer you work with a specific
branch. If so, you'll need to visit each submodule directory to checkout
specific branches. Here, we'll check out the master branch of each submodule:

.. code:: bash

   git submodule foreach 'git checkout master'

You might find that changes upstream have occurred since you cloned the
submodules. To pull in the latest changes:

.. code:: bash

   git submodule foreach 'git pull'

Next, for every submodule, you'll need to rename 'origin' to 'gerrit':

.. code:: bash

   git submodule foreach 'git remote rename origin gerrit'

Finally, for every submodule, you'll have to tell git-review how to find
Gerrit. 

.. code:: bash

   cd doc # Make sure we're in the top level doc repo directory
   git submodule foreach 'REPO=$(echo $path | sed "s/docs\/submodules\///") ; git remote add gerrit ssh://<LFID>@gerrit.onap.org:29418/$REPO'
   
Or, if you prefer to do only one at a time:

.. code:: bash

   git remote add gerrit ssh://<LFID>@gerrit.onap.org:29418/repopath/repo.git

Requesting Reviews
------------------

The benefit of working with submodules in this way is that now you can
make changes, do commits, and request reviews within the submodule
directory just as if you had cloned the repository in its own directory.

So, you commit as normal, with :code:`git commit -s`, and review as
normal with :code:`git review`.
