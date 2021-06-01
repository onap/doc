#!/bin/bash
# set -x

repolist=$1
source="git://cloud.onap.org/mirror"

  #
  # csv column #nn: latest branch
  #

  readarray -t array < ./${repolist};
  i=0
  csv[i]="${csv[i]},MASTER repo name"
  ((i++))
  for line in "${array[@]}"
  do
    reponame=$(echo $line | awk -F "|" '{print $1}');
    csv[i]="${csv[i]},${reponame}"
    ((i++))
    
    #echo " "
    #echo ${reponame}
  
    git ls-remote -q --heads "${source}/${reponame}" | sed 's/^.*heads\///' | sed -nr '/^master$|^amsterdam$|^beijing$|^casablanca$|^dublin$|^elalto$|^frankfurt$|^guilin$|^honolulu$|^istanbul$/Ip' | tail -2 | head -1
    #git ls-remote -q --heads "${source}/${reponame}" | sed 's/^.*heads\///' 

  done
  unset array
  unset i
  unset reponame

exit

