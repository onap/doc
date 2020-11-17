#!/bin/bash
#set -x # uncomment for bash script debugging

### ============================================================================
### Licensed under the Apache License, Version 2.0 (the "License");
### you may not use this file except in compliance with the License.
### You may obtain a copy of the License at
###
###       http://www.apache.org/licenses/LICENSE-2.0
###
### Unless required by applicable law or agreed to in writing, software
### distributed under the License is distributed on an "AS IS" BASIS,
### WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
### See the License for the specific language governing permissions and
### limitations under the License.
### ============LICENSE_END=====================================================

###
### checkdocs.sh
###
### AUTHOR(S):
### Thomas Kulik, Deutsche Telekom AG, 2020
###
### DESCRIPTION:
### Retrieves a full list of ONAP repos from gerrit inluding their state.
### Clones all active repos of the ONAP master branch plus other requested ONAP
### branches. Then the script does some docs related analyses depending on the
### clone results. It creates logfiles containing filtered results. In addition
### a table.csv is created which can be used to import it in a spreadsheed.
### Also a zip-file is created which contains all the results.
###
### IMPORTANT:
### - in the output, repo names are shown in square brackets for readability
###   e.g [aai/aai-common]/docs/release-notes.rst
### - in the table.csv file you see data for the requested branch if available.
###   if not available, data is retrieved from the master branch. it will be
###   denoted in round brackets, e.g. (3) (tox.ini)
###
### REQUIREMENTS:
### curl
### jq
###

###
### SOME HELPING COMMANDS TO PROCESS LOG FILES:
### create repo list
### curl -s https://git.onap.org/ | grep "^<tr><td class='toplevel-repo'><a title='" | sed -r "s:^<tr><td class='toplevel-repo'><a title='::" | sed -r "s:'.*::"
###
### remove branchname from the line
### cat frankfurt_gerritclone.log | sed 's:frankfurt|::'
###
### list only image names
### cat master_dockerimagesfull.log | grep image | sed -r 's:image\:::' | sed -r 's:^ +::' | sed '/^[[:space:]]*$/d'
###
### more interesting stuff ...
### curl https://gerrit.onap.org/r/projects/?d
### LONG:  curl -s 'https://gerrit.onap.org/r/projects/?d' | awk '{if(NR>1)print}' | jq -c '.[] | {id, state}' | sed -r 's:%2F:/:g' | sed -r 's:["{}]::g' | sed -r 's:id\:::' | sed -r 's:,state\::|:' | sed '/All-Projects/d' | sed '/All-Users/d'
### SHORT: curl -s 'https://gerrit.onap.org/r/projects/?d' | awk '{if(NR>1)print}' | jq -c '.[] | {id, state}' | sed -r 's:%2F:/:g; s:["{}]::g; s:id\:::; s:,state\::|:; /All-Projects/d; /All-Users/d'
###

script_version="1.1 (2020-11-17)"

# save command for the restart with logging enabled
command=$0
arguments=$@
fullcommand="${command} ${arguments}"

###
### functions
###

# print usage
function usage() {
  echo "                                                           "
  echo " USAGE:                                                    "
  echo "  ./checkdocs.sh                                           "
  echo "                                                           "
  echo " ARGUMENTS:                                                "
  echo "  -u|--user username                                       "
  echo "  linux foundation username used to clone ONAP Gerrit repos"
  echo "                                                           "
  echo "  -b|--branches branch1,branch2,branch3                    "
  echo "  list of branches to be cloned. master is automatically   "
  echo "  added to the list. do not add manually!                  "
  echo "                                                           "
  echo "  -d|--dev                                                 "
  echo "  development-mode - limits number of repos to be cloned   "
  echo "                                                           "
}

# draw a simple line
function drawline {
  echo "*******************************************************************************"
}

# remove lockfile in case script is interrupted
trap InterruptedScript SIGINT SIGTERM SIGHUP SIGKILL SIGSTOP
function InterruptedScript {
  echo " "
  echo "Script was interrupted."
  if [ -f $lockfile ] ; then
    rm $lockfile
  fi
  exit 0
}

###
### arguments handling
###

PARAMS=""

while (( "$#" )); do
  case "$1" in
    -d|--dev)
      devmode="TRUE"
      shift
      ;;
    -b|--branches)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        branches_csv=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        usage
        exit 1
      fi
      ;;
    -u|--user)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        lfusername=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        usage
        exit 1
      fi
        ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported argument $1" >&2
      usage
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"

# old: declare -a branches=("master" "frankfurt" "guilin")
if [[ $branches_csv == "" || $lfusername == "" ]]; then
  usage
  exit -1
fi

# master branch is automatically added and must not part of the user arguments
if [[ $branches_csv == *"master"* ]]; then
  usage
  exit -1
fi
# clone master first, the the other branches
branches_csv="master,${branches_csv}"

# create the branches array by readinging in the values from the variable
IFS=',' read -r -a branches <<< "${branches_csv}"

#echo "DBUG: devmode      = \"${devmode}\""
#echo "DBUG: branches_csv = \"${branches_csv}\""
#echo "DBUG: lfusername   = \"${lfusername}\""
#echo "DBUG: branches     = \"${branches[@]}\""

# restart script with logging enabled
lockfile="checkdocs-runtime-lockfile"
if [ ! -f $lockfile ] ; then
  touch $lockfile
  echo "Restarting script with logging enabled."
  ${fullcommand} 2>&1 | tee checkdocs.log
  rm $lockfile
  exit
fi

echo " "
echo "checkdocs.sh Version ${script_version}"
echo " "

# curl must be installed
if ! command -v curl &> /dev/null
then
  echo "ERROR: curl command could not be found"
  exit -1
fi

today=$(date '+%Y-%m-%d');
repolist="gerrit-repos-master-"$today".txt";
unique=$(date +%s)

echo "Retrieving a full list of ONAP repositories (master) from gerrit.onap.org."

# retrieve the full repolist from gerrit
# workaround because of the (wrong?) response of gerrit.onap.org which makes jq command fail
# "| awk '{if(NR>1)print}'" filters the first line of the response so that jq will work again (thx marek)
curl -s 'https://gerrit.onap.org/r/projects/?d' | awk '{if(NR>1)print}' | jq -c '.[] | {id, state}' | sed -r 's:%2F:/:g; s:["{}]::g; s:id\:::; s:,state\::|:; /All-Projects/d; /All-Users/d' >./$repolist

# process the created repolist
# only active projects will be cloned in case the requested branch of the project exists
echo "Accessing gerrit.onap.org with username \"${lfusername}\"."
echo "Start cloning of repositories."

for branch in "${branches[@]}"
do

  echo " "
  echo "###"
  echo "### ${branch}"
  echo "###"
  echo " "

  branch_upper=$(echo "${branch}" | tr '[:lower:]' '[:upper:]')

  mkdir $branch
  cp $repolist $branch
  cd $branch

  devcounter=0

  # process repolist
  while read line
  do

  if [[ $devmode == "TRUE" ]]; then
    devcounter=$((devcounter+1))
  fi

  if [[ $devcounter -lt "11" ]]; then

      if [[ $devmode == "TRUE" ]]; then
        echo "INFO: devmode! counter=${devcounter}"
      fi

      drawline
      reponame=$(echo $line | awk -F "|" '{print $1}');
      repostate=$(echo $line | awk -F "|" '{print $2}');
      echo $reponame
      echo $repostate

      if [[ $repostate == "ACTIVE" ]]; then
        echo "Cloning \"${branch}\" branch of ACTIVE project ${reponame}..."

        git clone --branch ${branch} --recurse-submodules ssh://${lfusername}@gerrit.onap.org:29418/$reponame ./$reponame
        gitexitcode=$?

        if [[ ! ${gitexitcode} == "0" ]]; then
          errormsg=$(tail -1 ../checkdocs.log)
        else
          errormsg="cloned"
        fi

        # gerritclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
        echo "${gitexitcode}|${reponame}|${repostate}|${errormsg}" | tee -a ${branch}_gerritclone.log

      elif [[ $repostate == "READ_ONLY" ]]; then
        echo "-|${reponame}|${repostate}|ignored" | tee -a ${branch}_gerritclone.log
      else
        echo "-|${reponame}|unknown repo state \"${repostate}\"|-" | tee -a ${branch}_gerritclone.log
      fi

      # examine repo
      if [[ ${gitexitcode} == "0" ]]; then

        printf "\ndocs directories:\n"
        find ./$reponame -type d -name docs | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_docs.log

        printf "\nrst files:\n"
        find ./$reponame -type f -name *.rst | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_rstfiles.log

        printf "\nrelease notes rst:\n"
        find ./$reponame -type f | grep 'release.*note.*.rst' | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_releasenotes.log

        printf "\ntox.ini files:\n"
        find ./$reponame -type f -name tox.ini | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_toxini.log

        printf "\nconf.py files:\n"
        find ./$reponame -type f -name conf.py | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_confpy.log

        printf "\nindex.rst files:\n"
        find ./$reponame -type f -name index.rst | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_indexrst.log

      fi

    # end defcounter loop
    fi

    gitexitcode=""

  done <${repolist}

  # examine repos
  drawline
  find . -type f -name values.yaml -print -exec grep "image:" {} \; | sed -r 's:^ +::' | tee ${branch}_dockerimagesfull.log
  drawline
  ls --format single-column -d */ | sed 's:/$::' | tee ${branch}_directories.log
  drawline
  cat ${branch}_dockerimagesfull.log | grep image | sed -r 's:image\:::' | sed -r 's:^ +::' | sed '/^[[:space:]]*$/d' >${branch}_dockerimages.log
  drawline
  ls --format single-column -d oom/kubernetes/*/ | tee ${branch}_oomkubernetes.log
  drawline

  # examine docs
  readarray -t docs_array < ./${branch}_docs.log;

  for line in "${docs_array[@]}"
  do

    echo $line | tee -a ${branch}_docsconfig.log

    # remove [ and ] which are distinguish the project name in the output
    line=$(echo $line | sed -r 's:\[:: ; s:\]::')

    if [ -f ./${line}/conf.py ] ; then
      echo "  conf.py ..... found" | tee -a ${branch}_docsconfig.log
    else
      echo "  conf.py ..... NOT FOUND" | tee -a ${branch}_docsconfig.log
    fi

    if [ -f ./${line}/index.rst ] ; then
      echo "  index.rst ... found" | tee -a ${branch}_docsconfig.log
    else
      echo "  index.rst ... NOT FOUND" | tee -a ${branch}_docsconfig.log
    fi

    if [ -f ./${line}/tox.ini ] ; then
      echo "  tox.ini ..... found" | tee -a ${branch}_docsconfig.log
    else
      echo "  tox.ini ..... NOT FOUND" | tee -a ${branch}_docsconfig.log
    fi

    echo " " | tee -a ${branch}_docsconfig.log

  done
  unset docs_array

  drawline

  ###
  ### build a csv table that combines results
  ###

  #
  # csv column #1: project name
  #

  readarray -t array < ./${repolist};
  i=0
  csv[i]="project"
  ((i++))
  for line in "${array[@]}"
  do
    reponame=$(echo $line | awk -F "|" '{print $1}');
    project=$(echo $reponame | sed 's:/.*$::')
    #echo "DBUG: reponame=${reponame}"
    #echo "DBUG:  project=${project}"
    #echo "DBUG:        i=${i}"
    csv[i]=${project}
    ((i++))
  done
  unset array
  unset i
  unset reponame
  unset project

  #
  # csv column #2: repo name
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
  done
  unset array
  unset i
  unset reponame

  #
  # csv column #3: repo state
  #

  readarray -t array < ./${repolist};
  i=0
  csv[i]="${csv[i]},MASTER repo state"
  ((i++))
  for line in "${array[@]}"
  do
    repostate=$(echo $line | awk -F "|" '{print $2}');
    csv[i]="${csv[i]},${repostate}"
    ((i++))
  done
  unset array
  unset i
  unset repostate

  #
  # csv column #4: clone message
  #

  readarray -t array < ./${branch}_gerritclone.log;
  i=0
  csv[i]="${csv[i]},${branch_upper} clone message"
  ((i++))
  for line in "${array[@]}"
  do
    # gerritclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
    errormsg=$(echo $line | awk -F "|" '{print $4}');
    csv[i]="${csv[i]},${errormsg}"
    ((i++))
  done
  unset array
  unset i
  unset errormsg

  #
  # csv column #5: RELEASE component (yes|no|maybe)
  # to be filled with values of the planned release config file maintained by
  # the onap release manager
  #

  # gerritclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
  readarray -t array < ./${branch}_gerritclone.log;
  i=0
  csv[i]="${csv[i]},${branch_upper} component"
  ((i++))
  for line in "${array[@]}"
  do

    # gerritclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
    gitexitcode=$(echo $line | awk -F "|" '{print $1}');
       reponame=$(echo $line | awk -F "|" '{print $2}');
      repostate=$(echo $line | awk -F "|" '{print $3}');
       errormsg=$(echo $line | awk -F "|" '{print $4}');

    if [[ ${repostate} == "ACTIVE" && ${gitexitcode} == "0" ]]; then
      releasecomponent="yes"
    elif [[ ${repostate} == "ACTIVE" && ${gitexitcode} == "128" ]]; then
      releasecomponent="maybe"
    elif [ ${repostate} == "READ_ONLY" ]; then
      releasecomponent="no"
    else
      releasecomponent="unknown"
    fi

    csv[i]="${csv[i]},${releasecomponent}"
    ((i++))
  done
  unset array
  unset i
  unset gitexitcode
  unset reponame
  unset repostate
  unset errormsg
  unset releasecomponent

  #
  # csv column #6: docs (at repo root directory only; no recursive search!)
  # csv column #7: conf.py
  # csv column #8: tox.ini
  # csv column #9: index.rst
  #
  # columns are filled with values from requested branch.
  # if data is not available values from master branch are used.
  # to identify master branch values, data is put into brackets "(...)"
  #

  readarray -t array < ./${repolist};
  i=0
  csv[$i]="${csv[i]},docs,conf.py,tox.ini,index.rst"
  ((i++))
  for line in "${array[@]}"
  do
    line=$(echo $line | sed 's:|.*$::')
    #echo "DBUG: line=${line}"
    #echo "DBUG: i=${i}"

    # docs
    if [ -d ./${line}/docs ] ; then
      docs="docs"
    elif [ -d ../master/${line}/docs ] ; then
      docs="(docs)"
    else
      docs="-"
    fi

    # conf.py
    if [ -f ./${line}/docs/conf.py ] ; then
      docs="${docs},conf.py"
    elif [ -f ../master/${line}/docs/conf.py ] ; then
      docs="${docs},(conf.py)"
    else
      docs="${docs},-"
    fi

    # tox.ini
    if [ -f ./${line}/docs/tox.ini ] ; then
      docs="${docs},tox.ini"
    elif [ -f ../master/${line}/docs/tox.ini ] ; then
      docs="${docs},(tox.ini)"
    else
      docs="${docs},-"
    fi

    # index.rst
    if [ -f ./${line}/docs/index.rst ] ; then
      docs="${docs},index.rst"
    elif [ -f ../master/${line}/docs/index.rst ] ; then
      docs="${docs},(index.rst)"
    else
      docs="${docs},-"
    fi

    #echo "DBUG: docs=${docs}"
    line="${csv[i]},${docs}"
    csv[$i]=${line}
    ((i++))
  done
  unset array
  unset i
  unset docs

  #
  # csv column #10: index.html@RTD accessibility check
  # csv column #11: index.html url
  #

  readarray -t array < ./${branch}_gerritclone.log;
  i=0
  csv[i]="${csv[i]},index.html@RTD,index.html url"
  ((i++))
  for line in "${array[@]}"
  do
    # gerritclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
    gitexitcode=$(echo $line | awk -F "|" '{print $1}');
       reponame=$(echo $line | awk -F "|" '{print $2}');
      repostate=$(echo $line | awk -F "|" '{print $3}');
       errormsg=$(echo $line | awk -F "|" '{print $4}');

            url=""
    curl_result=""

    # this routine works only with release "frankfurt" and later because
    # earlier releases are using submodule structure for documentation files
    if echo "$branch" | grep -q '^[abcde]'; then
      curl_result="unsupported release"
      url="-"
    else

      # we are working on "frankfurt" branch or later ...
      # only if repostate IS ACTIVE a curl test is required
      if [[ ${repostate} == "ACTIVE" ]]; then

        # OPTIONAL: USE ALSO GITEXITCODE AS A FILTER CRITERIA ???

        # url base
        # important! only doc project needs a different url base
        if [[ ${reponame} == "doc" ]]; then
          url_start="https://docs.onap.org"
        else
          url_start="https://docs.onap.org/projects/onap"
        fi
        url_lang="en"
        url_branch=${branch}

        # "master" branch documentation is available as "latest" in RTD
        if [[ ${url_branch} == "master" ]]; then
          url_branch="latest"
        fi

        # replace all / characters in repo name with - charachter
        url_repo=$(echo ${reponame} | sed -r 's/\//-/g')
        url_file="index.html"

        # build the full url
        if [[ ${reponame} == "doc" ]]; then
          # build the full url for the doc project
          url="${url_start}/${url_lang}/${url_branch}/${url_file}"
        else
          # build the full url for the other projects
          url="${url_start}-${url_repo}/${url_lang}/${url_branch}/${url_file}"
        fi
        #echo "DBUG: url=$url"

        # test accessibility of url
        curl --head --silent --fail "${url}?${unique}" >/dev/null
        curl_result=$?

        # convert numeric results to text
        if [ "${curl_result}" = "0" ]; then
          curl_result="accessible"
        elif [ "${curl_result}" = "22" ]; then
          curl_result="does not exist"
        else
          curl_result="ERROR:${curl_result}"
        fi

        # url does not exist for this branch.
        # in case the requested url is not already for "master" branch,
        # we try to access the url of the master branch and denote the
        # result by using round brackets (result)
        if [[ ${curl_result} == "does not exist" && ! $branch == "master" ]]; then

          # build the full (master/latest) url
          url="${url_start}-${url_repo}/${url_lang}/latest/${url_file}"
          #echo "DBUG: url=$url"

          # test accessibility of url in "master branch" (latest)
          curl --head --silent --fail "${url}?${unique}" >/dev/null
          curl_result=$?
          # denote result as a value from "master" branch (latest)
          url="(${url})"

          # convert numeric results to text
          if [ "${curl_result}" = "0" ]; then
            curl_result="(accessible)"
          elif [ "${curl_result}" = "22" ]; then
            curl_result="(does not exist)"
          else
            curl_result="(ERROR:${curl_result})"
          fi

        fi
      else
        # repostate IS NOT ACTIVE - no curl test required
        curl_result="-"
        url="-"
      fi
    fi

    echo "$url ... $curl_result"
    csv[i]="${csv[i]},${curl_result},${url}"
    #echo "DBUG: csv line=${csv[i]}"

    ((i++))
  done

  #
  # csv column #12: release notes
  #

  readarray -t array < ../${repolist};
  i=0
  csv[i]="${csv[i]},release notes"
  ((i++))
  for line in "${array[@]}"
  do
    line=$(echo $line | sed 's:|.*$::')
    #echo "DBUG: line=\"${line}\""
    #echo "DBUG: i=${i}"
    relnote=""

    # put repo name in square brackets for increased grep hit rate
    # escape minus and bracket characters to avoid problems with the grep command
    #repo_grepable=$(echo ${line} | sed -r s:${line}:[${line}]: | sed -r 's/-/\\-/g' | sed -r 's/\[/\\[/g' | sed -r 's/\]/\\]/g')
    #echo "DBUG: repo_grepable=\"${repo_grepable}\""

    # check if repo dir exists in this branch
    if [ -d ./${line} ] ; then
      # if yes, check if repo name appears in the branch releasenotes.log
      relnote=$(find "./${line}" -type f | grep 'release.*note.*.rst' | wc -l);
      # repo dir DOES NOT exist in this branch - so check if repo dir exists in MASTER branch
    elif [ -d ../master/${line} ] ; then
      # if yes, check if repo name appears in the MASTER releasenotes.log
      # count release notes files in MASTER branch (in repo root and its subdirectories)
      relnote=$(find "../master/${line}" -type f | grep 'release.*note.*.rst' | wc -l);
      # put results in round brackets to show that this is MASTER data
      relnote=$(echo ${relnote} | sed -r s:${relnote}:\(${relnote}\):)
    else
      relnote="-"
    fi

    line="${csv[i]},${relnote}"
    csv[i]=${line}
    ((i++))

  done
  unset array
  unset i
  unset relnote
  unset repo_grepable

  #
  # build the table.csv file
  #

  for i in "${csv[@]}"
  do
    echo "$i" | tee -a ./${branch}_table.csv
  done

  #
  # create data package for this branch and zip it
  #

  datadir=${branch}_data
  mkdir $datadir
  cp $repolist $datadir
  cp ${branch}_table.csv $datadir
  cp ${branch}_*.log $datadir
  zip -r ${datadir}.zip $datadir

  # return from the branch directory
  cd ..

# return and work on the next requested branch ... or exit
done
