# Examples files

Examples files for a working (basic) configuration of sphinx.
To be used by all ONAP projects (except 'doc' project).
Extend them to reflect the needs in your project.
Please note the different pathes, the files are located in!

## FILE: tox.ini_MASTER

##### USE:
in MASTER branch of your repository
##### PATH:
{project}/docs
##### TODO:
remove _MASTER from filename

## FILE: tox.ini_NEWBRANCH

##### USE:
in 'NEWBRANCH' of your repository
##### PATH:
{project}/docs
##### TODO:
remove _NEWBRANCH from filename

update release name in the following lines:
```
-chttps://git.onap.org/doc/plain/etc/upper-constraints.os.txt?h=istanbul
-chttps://git.onap.org/doc/plain/etc/upper-constraints.onap.txt?h=istanbul
```

## FILE: conf.py_MASTER

##### USE:
in MASTER branch of your repository
##### PATH:
{project}/docs
##### TODO:
remove _MASTER from filename

## FILE: conf.py_NEWBRANCH

##### USE:
in 'NEWBRANCH' of your repository
##### PATH:
{project}/docs
##### TODO:
remove _NEWBRANCH from filename

## FILE: requirements-docs.txt

##### USE:
in both, MASTER branch and 'NEWBRANCH' of your repository
##### PATH:
{project}/docs
##### TODO:
–

## FILE: .readthedocs.yaml

##### USE:
in both, MASTER branch and 'NEWBRANCH' of your repository
##### PATH:
{project}
##### TODO:
–
