Examples for the correct configuration of sphinx.
To be used by all ONAP projects.
Extend them to reflect the needs in your project.

file : tox.ini_MASTER
path : <project>
descr: * remove _MASTER from filename
       * change branch in line
         -chttps://git.onap.org/doc/plain/etc/upper-constraints.os.txt?h=master
         to <newbranch> (e.g. istanbul)
         -chttps://git.onap.org/doc/plain/etc/upper-constraints.os.txt?h=istanbul
         and change branch in line
         -chttps://git.onap.org/doc/plain/etc/upper-constraints.onap.txt?h=master
         to
         -chttps://git.onap.org/doc/plain/etc/upper-constraints.onap.txt?h=istanbul

file : conf.py
path : <project>/docs
descr: todo

file : requirements.txt
path : <project>/docs/etc
descr: todo

file : upperconstraints.onap.txt
path : <project>/docs/etc
descr: todo

file : upperconstraints.os.txt
path : <project>/docs/etc
descr: todo
