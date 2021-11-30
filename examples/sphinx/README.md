# Examples files

Examples files for a working (basic) configuration of sphinx.
To be used by all ONAP projects (except 'doc' project).
Extend them to reflect the needs in your project.

We provide two directories:
- **master**: Contains configuration files used in the **development branch**.
- **istanbul**: Contains configuration files used in the **release branch**
   (e.g.'istanbul'). **Important**: You need to change the 'istanbul' entries
   in the files! Replace them with the name of the new release branch.

The additional directories named *_static* and *images* are required to make
the examples buildable. In the respective directory you can execute the *tox*
command and the build starts. 

## FILE: tox.ini

##### DESCRIPTION:
todo

## FILE: conf.py

##### DESCRIPTION:
todo

## FILE: requirements-docs.txt

##### DESCRIPTION:
todo

## FILE: .readthedocs.yaml

##### DESCRIPTION:
todo
