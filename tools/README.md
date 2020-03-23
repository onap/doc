README FOR ONAP DOC/TOOLS
#########################

c2m.sh
================================================================================
DESCRIPTION
c2m automates additional tasks required in case you want to export and convert a
set of wiki pages. for more details see header of the script.

USAGE
c2m.sh <your-page-list>

ADDITIONAL FILES
example.pagelist: an example pagelist to demonstrate functionality

SEE ALSO
https://www.viaboxx.de/code/confluence2md/
https://github.com/viaboxxsystems/confluence2md


warnstats.sh
================================================================================
DESCRIPTION
warnstat helps to find the onap modules (projects) and rst-files which are
responsible for the most warnings during the documentation build process. for
more details see header of the script.

USAGE
warnstatst.sh <your-tox-build-logfile>

NOTES
create the required tox logfile when you locally build the onap documentation:
tox | tee tox-build-logfile

ADDITIONAL FILES
example-tox-build-log: an example tox logfile to demonstrate functionality.
created links in the warnstats output may not work if you use this example.
