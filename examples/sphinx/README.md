# Examples files

The examples files for a working (basic) configuration of sphinx should be used
by all ONAP projects (except 'doc' project). Extend them to reflect the needs
in your project. **Important:** The files relate on each other. Change them carefully!

We provide two directories:
- **master**: Contains configuration files used in the **development branch**.
- **istanbul**: Contains configuration files used in the **release branch**
   (e.g.'istanbul'). **Important:** You need to change the 'istanbul' entries
   in the files! Replace them with the name of the new release branch (e.g. 'jakarta').

The additional directories named *_static* and *images* and the file
*index.rst* are required to make the examples buildable. In the respective
directory you can execute the '*tox -e docs*' command and the build starts.

---
## conf.py
#### DESCRIPTION:
The “build configuration file” contains (almost) all configuration needed to
customize Sphinx input and output behavior.
#### PATH:
{project}/docs/conf.py
#### SEE ALSO:

https://docs.releng.linuxfoundation.org/projects/lfdocs-conf/en/latest/config.html

https://www.sphinx-doc.org/en/master/usage/configuration.html

---
## requirements-docs.txt
##### DESCRIPTION:
Contains the required libraries to be used by Sphinx.
#### PATH:
{project}/etc/requirements-docs.txt
---
## .readthedocs.yaml
##### DESCRIPTION:
Required to customize the ReadTheDocs input and output behavior. **Important:** This file is located in your {project} root directory (e.g. *doc/.readthedocs.yaml*).
#### PATH:
{project}/.readthedocs.yaml

---
## tox.ini
##### DESCRIPTION:
Required to customize different tox environments.
#### PATH:
{project}/tox.ini
##### SEE ALSO:
https://tox.wiki/en/latest/config.html

---
## index.rst
##### DESCRIPTION:
The reStructuredText Cheat Sheet as an example .rst file
