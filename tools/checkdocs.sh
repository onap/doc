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
### Thomas Kulik, Deutsche Telekom AG, 2020 - 2021
###
### DESCRIPTION:
### Retrieves a full list of ONAP repos from gerrit inluding their state.
### Clones all repos of the ONAP master branch plus other requested ONAP
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
### remove branchname from the line:
### cat frankfurt_repoclone.log | sed 's:frankfurt|::'
###
### list only image names
### cat master_dockerimagesfull.log | grep image | sed -r 's:image\:::' | sed -r 's:^ +::' | sed '/^[[:space:]]*$/d'
###
### more interesting stuff ...
### curl https://gerrit.onap.org/r/projects/?d
### LONG:  curl -s 'https://gerrit.onap.org/r/projects/?d' | awk '{if(NR>1)print}' | jq -c '.[] | {id, state}' | sed -r 's:%2F:/:g' | sed -r 's:["{}]::g' | sed -r 's:id\:::' | sed -r 's:,state\::|:' | sed '/All-Projects/d' | sed '/All-Users/d'
### SHORT: curl -s 'https://gerrit.onap.org/r/projects/?d' | awk '{if(NR>1)print}' | jq -c '.[] | {id, state}' | sed -r 's:%2F:/:g; s:["{}]::g; s:id\:::; s:,state\::|:; /All-Projects/d; /All-Users/d'
###

script_version="1.12 (2021-11-12)"

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
  echo " checkdocs.sh Version ${script_version}"
  echo "                                                           "
  echo " USAGE:                                                    "
  echo "  ./checkdocs.sh <arguments>                               "
  echo "                                                           "
  echo " ARGUMENTS:                                                "
  echo "  -u|--user username                                       "
  echo "  linux foundation username used to clone ONAP repositories"
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

# function to parse wiki (project) lifecycle state information
# call:   getwikilifecyclestate "projectname"
# result: $return_from_getwikilifecyclestate
# because bash supports only returning numeric values a variable $return_from_getwikilifecyclestate is used

function getwikilifecyclestate {

  local requested=$1
  local wikiline=""
  local wikirepo=""
  local wikistate=""

  return_from_getwikilifecyclestate=""

  for wikiline in "${wikiplsarray[@]}"
  do

     wikirepo=$(echo $wikiline | awk -F ";" '{print $1}');
    wikistate=$(echo $wikiline | awk -F ";" '{print $2}');

    #echo "DBUG: getwikilifecyclestate  wikiline = \"${wikiline}\"";
    #echo "DBUG: getwikilifecyclestate  wikirepo = \"${wikirepo}\""
    #echo "DBUG: getwikilifecyclestate wikistate = \"${wikistate}\""

    if [[ ${wikirepo} == ${requested} ]]; then
      return_from_getwikilifecyclestate=${wikistate}
      #echo "DBUG: getwikilifecyclestate     wikirepo = \"${wikirepo}\""
      #echo "DBUG: getwikilifecyclestate    requested = \"${requested}\""
      #echo "DBUG: return_from_getwikilifecyclestate  = \"${return_from_getwikilifecyclestate}\"";
      return 0;
    fi

  done

  #echo "DBUG: getwikilifecyclestate requested \"${requested}\" NOT FOUND in list"
  return_from_getwikilifecyclestate=""

}

# function to parse release partizipation information
# call:   getrpinfo "projectname"
# result: $return_from_getrpinfo
# because bash supports only returning numeric values a variable $return_from_getrpinfo is used

function getrpinfo {

  local requested=$1

  # clean up first
  local rpdetails=""
  local rpline=""
  local rprepo=""
  local rpproject=""
  local current_branch_starting_letter=""
        return_from_getrpinfo=""

  # finds first matching line in the array using grep (currently every line shows the same partizipation for the project (NOT repository!) )
  # this is much faster then looping line by line
     rpline=$(IFS=$'\n'; echo "${rparray[*]}" | grep -m 1 ";${requested};");
     rpline=$(echo ${rpline} | tr -d '^M')
     rprepo=$(echo ${rpline} | awk -F ";" '{print $1}');
  rpproject=$(echo ${rpline} | awk -F ";" '{print $2}');
  # concatenate details to do an easy grep later on to find out if or if not the project/repo has partizipated to a release
  rpdetails=$(echo ${rpline} | awk -F ";" '{print "-" $3 "-" $4 "-" $5 "-" $6 "-" $7 "-" $8 "-" $9 "-" $10 "-" $11 "-" $12 "-"}');

  # result will be e.g. "-g" and this avoids false positives with the "m" release
  # (because "m" is also used to indicate the maintenance release, e.g. "gm")
  current_branch_starting_letter="-${branch:0:1}"

  #echo "DBUG: getrpinfo ****************************";
  #echo "DBUG: getrpinfo requested = \"${requested}\"";
  #echo "DBUG: getrpinfo rpproject = \"${rpproject}\"";
  #echo "DBUG: getrpinfo rpdetails = \"${rpdetails}\"";
  #echo "DBUG:      current branch = \"${branch}\"";
  #echo "DBUG:     starting_letter = \"${current_branch_starting_letter}\"";

  ## check if PROJECT has partizipated to INITIAL release
  #if [[ ${rpproject} = ${requested} ]] && [[ "${rpdetails}" == *"${current_branch_starting_letter}-"* ]]; then
  #  return_from_getrpinfo="project | ${current_branch_starting_letter:1:1}"
  #  # check ADDITIONALLY if PROJECT has ALSO partizipated to MAINTENANCE release
  #  if [[ "${rpdetails}" == *"${current_branch_starting_letter}m-"* ]]; then
  #    return_from_getrpinfo="${return_from_getrpinfo} | ${current_branch_starting_letter:1:1}m"
  #    #echo "DBUG:  getrpinfo return = \"${return_from_getrpinfo}\"";
  #  fi
  #  return 0;
  ## check if PROJECT has ONLY partizipated to MAINTENANCE release
  #elif [[ ${rpproject} = ${requested} ]] && [[ "${rpdetails}" == *"${current_branch_starting_letter:1:1}m-"* ]]; then
  #  return_from_getrpinfo="project | ${current_branch_starting_letter:1:1}m"
  #  #echo "DBUG:  getrpinfo return = \"${return_from_getrpinfo}\"";
  #  return 0;
  #fi

  # check if requested PROJECT was found in the array of partizipating projects
  if [[ ${rpproject} = ${requested} ]]; then
    # check if PROJECT has partizipated to INITIAL release
    if [[ "${rpdetails}" == *"${current_branch_starting_letter}-"* ]]; then
      return_from_getrpinfo="project | ${current_branch_starting_letter:1:1}"
      # check ADDITIONALLY if PROJECT has ALSO partizipated to MAINTENANCE release
      if [[ "${rpdetails}" == *"${current_branch_starting_letter}m-"* ]]; then
      return_from_getrpinfo="${return_from_getrpinfo} ${current_branch_starting_letter:1:1}m"
      #echo "DBUG:  getrpinfo return = \"${return_from_getrpinfo}\"";
      fi
      return 0;
    elif [[ "${rpdetails}" == *"${current_branch_starting_letter:1:1}m-"* ]]; then
      return_from_getrpinfo="project | ${current_branch_starting_letter:1:1}m"
      #echo "DBUG:  getrpinfo return = \"${return_from_getrpinfo}\"";
      return 0;
    fi
  fi
  #echo "DBUG: getrpinfo requested \"${requested}\" NOT FOUND in list"
  return_from_getrpinfo=""
}

function find_repo_in_confpy {

  local search_term=$1
  local search_term_line_number=""
  local confpy_branch_entries=""
  local confpy_line_number=""
  local confpy_branch_name=""
  local idx=""
  
  return_from_find_repo_in_confpy=""
  search_term="'${search_term}'"

  search_term_line_number=$(cat ./doc/docs/conf.py | grep -n '^intersphinx_mapping\[' | grep -m 1 ${search_term} | sed 's/:.*//')
  #echo "DBUG: search_term is ............... ${search_term}"
  #echo "DBUG: search_term_line_number is ... ${search_term_line_number}"
  
  # nothing (or multiple entries) found - return
  if [[ ${search_term_line_number} == "" ]]; then
    #echo "DBUG: search_term_line_number is empty - returning"
    return_from_find_repo_in_confpy=""
    return 0;
  fi
  
  readarray -t confpy_branch_entries <<< "$(cat ./doc/docs/conf.py | grep -n '^branch = ' | sed 's/branch = //' | sed s/\'//g)"
  
  #echo "DBUG: confpy_branch_entries"
  #printf -- "%s\n" "${confpy_branch_entries[@]}"
  #for confpy_branch_entry in ${confpy_branch_entries[@]}
  #do
  #    confpy_line_number=$(echo $confpy_branch_entry | awk -F ":" '{print $1}');
  #    confpy_branch_name=$(echo $confpy_branch_entry | awk -F ":" '{print $2}');
  #    echo "DBUG: ${confpy_branch_name} entries are below line ${confpy_line_number}"
  #done
  
  # search in the list of branches in reverse order
  for (( idx=${#confpy_branch_entries[@]}-1 ; idx>=0 ; idx-- ))
  do
      #echo "DBUG: working entry is ${confpy_branch_entries[idx]}"
      confpy_line_number=$(echo ${confpy_branch_entries[idx]} | awk -F ":" '{print $1}');
      confpy_branch_name=$(echo ${confpy_branch_entries[idx]} | awk -F ":" '{print $2}');
      #echo "DBUG: ${confpy_branch_name} entries are below line ${confpy_line_number}"
  
      if (( ${search_term_line_number} > ${confpy_line_number} )); then
        #echo "DBUG: search_term_line_number is greater than confpy_line_number"
        #echo "DBUG: ${search_term} found in ${confpy_branch_name} section"
        return_from_find_repo_in_confpy=${confpy_branch_name}
        return 0;
      fi
  done
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
# clone master first, then the other branches
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

#
# read in wiki (project) lifecycle state
# always use the lastest available file (derived from date in filename e.g. wiki_lifecycle_state_210409.txt)
# format is <reponame abbrev>;<state>;<reponame full>
#

wikiplsfile=$(ls | sed -nr '/wiki_lifecycle_state_[0-9]{6}.txt/Ip' | tail -1);
if [[ $wikiplsfile == "" ]]; then
  echo "ERROR: wiki_lifecycle_state_yymmdd.txt missing"
  exit -1
fi
echo "Using \"${wikiplsfile}\" as the source for wiki (project) lifecycle state information."
readarray -t wikiplsarray < ./${wikiplsfile};

#
# read in release_partizipation_YYMMDD.csv file
# always use the latest available file (derived from date in filename e.g. release_partizipation_210409.csv)
# format is: $1=repository;$2=project;$3=g;$4=gm;$5=h;$6=hm;$7=i;$8=im;$9=j;$10=jm;$11=k;$12=km;;;;
# example: "g"  = project partizipated to the (g)uilin release
#          "gm" = project partizipated to the (g)uilin (m)aintenance release
# file may contain windows control charaters at end of line (^M)
#

rpfile=$(ls | sed -nr '/release_partizipation_[0-9]{6}.csv/Ip' | tail -1);
if [[ $rpfile == "" ]]; then
  echo "ERROR: release_partizipation_yymmdd.csv missing"
  exit -1
fi
echo "Using \"${rpfile}\" as the source for release partizipation information."
readarray -t rparray < ./${rpfile};
# remove first line
rparray=("${rparray[@]:1}")
#printf '%s\n' "${rparray[@]}" #DBUG ONLY

#
# curl must be installed
#

if ! command -v curl &> /dev/null
then
  echo "ERROR: curl command could not be found"
  exit -1
fi

today=$(date '+%Y-%m-%d');
repolist="gerrit-repos-master-"$today".txt";
unique=$(date +%s)

echo "Retrieving a full list of ONAP repositories (master) from gerrit.onap.org."

#
# retrieve the full repolist from gerrit
# workaround because of the (wrong?) response of gerrit.onap.org which makes jq command fail
# "| awk '{if(NR>1)print}'" filters the first line of the response so that jq will work again (thx marek)
#

curl -s 'https://gerrit.onap.org/r/projects/?d' | awk '{if(NR>1)print}' | jq -c '.[] | {id, state}' | sed -r 's:%2F:/:g; s:["{}]::g; s:id\:::; s:,state\::|:; /All-Projects/d; /All-Users/d' >./$repolist

# process the created repolist and try to clone the projects from the mirror

source="git://cloud.onap.org/mirror"
echo "Using \"${source}\" as the source and username \"${lfusername}\" for cloning the repositories."
echo "Start cloning of repositories ..."

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

  if [[ $devcounter -lt "50" ]]; then

      if [[ $devmode == "TRUE" ]]; then
        echo "INFO: devmode! counter=${devcounter}"
      fi

      drawline
      reponame=$(echo $line | awk -F "|" '{print $1}');
      repostate=$(echo $line | awk -F "|" '{print $2}');
      echo $reponame
      echo $repostate

      if [[ $repostate == "ACTIVE" ]] || [[ $repostate == "READ_ONLY" ]]; then
        echo "Cloning \"${branch}\" branch of \"${repostate}\" project ${reponame}..."

        # previously used:   git clone --branch ${branch} --recurse-submodules ssh://${lfusername}@gerrit.onap.org:29418/$reponame ./$reponame
        # clone script Jess: git clone "git://cloud.onap.org/mirror/${i}" "${LOCALNAME}"
        git clone --branch ${branch} --recurse-submodules ${source}/${reponame} ./${reponame}
        gitexitcode=$?

        if [[ ! ${gitexitcode} == "0" ]]; then
          errormsg=$(tail -1 ../checkdocs.log)
        else
          errormsg="cloned"
        fi

        # repoclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
        echo "${gitexitcode}|${reponame}|${repostate}|${errormsg}" | tee -a ${branch}_repoclone.log

      #elif [[ $repostate == "READ_ONLY" ]]; then
        #echo "-|${reponame}|${repostate}|ignored" | tee -a ${branch}_repoclone.log
      else
        echo "-|${reponame}|unknown repo state \"${repostate}\"|-" | tee -a ${branch}_repoclone.log
      fi

      # examine repo
      if [[ ${gitexitcode} == "0" ]]; then

        printf "\ndocs directories:\n"
        find ./$reponame -type d -name docs | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_docs.log

        printf "\nrst files:\n"
        find ./$reponame -type f -name *.rst | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_rstfiles.log

        printf "\nrelease notes rst:\n"
        find ./$reponame -type f | grep '.*release.*note.*.rst' | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_releasenotes.log

        printf "\ntox.ini files:\n"
        find ./$reponame -type f -name tox.ini | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_toxini.log

        printf "\nconf.py files:\n"
        find ./$reponame -type f -name conf.py | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_confpy.log

        printf "\nindex.rst files (all):\n"
        find ./$reponame -type f -name index.rst | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_indexrst_all.log

        printf "\nindex.rst files (docs root directory):\n"
        find ./$reponame -type f -name index.rst | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | grep ']/docs/index.rst' | tee -a ${branch}_indexrst_docs_root.log

        printf "\nINFO.yaml files:\n"
        find ./$reponame -type f -name INFO.yaml | sed -r 's:./::' | sed -r s:${reponame}:[${reponame}]: | tee -a ${branch}_infoyaml.log

      fi

    # end defcounter loop
    fi

    gitexitcode=""

  done <${repolist}

  # get (first) title for a rst file
  drawline
  python3 ../getrsttitle.py ${branch}_rstfiles.log | tee ${branch}_rstfiles_titles.log
  drawline
  python3 ../getrsttitle.py ${branch}_indexrst_docs_root.log | tee ${branch}_indexrst_docs_root_titles.log

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

  readarray -t array < ./${branch}_repoclone.log;
  i=0
  csv[i]="${csv[i]},${branch_upper} clone message"
  ((i++))
  for line in "${array[@]}"
  do
    # repoclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
    errormsg=$(echo $line | awk -F "|" '{print $4}');
    csv[i]="${csv[i]},${errormsg}"
    ((i++))
  done
  unset array
  unset i
  unset errormsg

  #
  # csv column #5: latest branch
  #

  readarray -t array < ./${repolist};
  i=0
  csv[i]="${csv[i]},latest branch"
  ((i++))
  for line in "${array[@]}"
  do
    reponame=$(echo $line | awk -F "|" '{print $1}');
    latestbranch=$(git ls-remote -q --heads "${source}/${reponame}" | sed 's/^.*heads\///' | sed -nr '/^master$|^amsterdam$|^beijing$|^casablanca$|^dublin$|^elalto$|^frankfurt$|^guilin$|^honolulu$|^istanbul$/Ip' | tail -2 | head -1);
    #echo "DBUG:     reponame=${reponame}"
    #echo "DBUG: latestbranch=${latestbranch}"
    echo "latest available branch for repo \"${reponame}\" is \"${latestbranch}\""
    csv[i]="${csv[i]},${latestbranch}"
    ((i++))
  done
  unset array
  unset i
  unset reponame
  unset latestbranch

  #
  # csv column #6: INFO.yaml LC state (project lifecycle state based on INFO.yaml / per repo)
  # csv column #7: WIKI LC state (project lifecycle state based on ONAP Dev Wiki / per project)
  # csv column #8: LC state match shows a "match" if both LC states match
  #

  readarray -t array < ./${repolist};
  i=0
  csv[i]="${csv[i]},INFO.yaml LC state,WIKI LC state,LC state match"
  ((i++))
  for line in "${array[@]}"
  do
    reponame=$(echo $line | awk -F "|" '{print $1}');
     project=$(echo $reponame | sed 's:/.*$::')

    if [ -f ./${reponame}/INFO.yaml ] ; then
      # check if repo/branch has a INFO.yaml
      lifecycleproject=$(grep '^project: ' ./${reponame}/INFO.yaml | awk -F ":" '{print $2}' | sed 's:^ ::' | sed "s:'::g" | tr '[:upper:]' '[:lower:]' | sed 's/\r$//')
      lifecyclestate=$(grep '^lifecycle_state: ' ./${reponame}/INFO.yaml | awk -F ":" '{print $2}' | sed 's:^ ::' | sed "s:'::g" | tr '[:upper:]' '[:lower:]' | sed 's/\r$//')
    elif [ ${branch} != "master" ] && [ -f ../master/${reponame}/INFO.yaml ] ; then
      # IF current branch is not master AND if info.yaml not found in the current repo/branch THAN use INFO.yaml of repo/master if available
      #echo "DBUG: branch=${branch} - checking master for INFO.yaml"
      lifecycleproject=$(grep '^project: ' ../master/${reponame}/INFO.yaml | awk -F ":" '{print $2}' | sed 's:^ ::' | sed "s:'::g" | tr '[:upper:]' '[:lower:]' | sed 's/\r$//')
      lifecyclestate=$(grep '^lifecycle_state: ' ../master/${reponame}/INFO.yaml | awk -F ":" '{print $2}' | sed 's:^ ::' | sed "s:'::g" | tr '[:upper:]' '[:lower:]' | sed 's/\r$//')
      lifecyclestate="(${lifecyclestate})"
    else
      lifecyclestate="INFO.yaml not found"
    fi

    getwikilifecyclestate ${project}
    # returns value in ${return_from_getwikilifecyclestate}

    #echo "DBUG: working dir is ...";pwd
    #echo "DBUG:   lifecycleproject=${lifecycleproject}"
    #echo "DBUG:     lifecyclestate=${lifecyclestate}"
    #echo "DBUG: wikilifecyclestate=${return_from_getwikilifecyclestate}"

    #check if YAML.info LC state is not empty _AND_ if WIKI LC state is not empty _AND_ if YAML.info LC state contains WIKI LC state
    if [[ ${lifecyclestate} != "" ]] && [[ ${return_from_getwikilifecyclestate} != "" ]] && [[ ${lifecyclestate} == *"${return_from_getwikilifecyclestate}"* ]]; then
      lcstatesmatch="match"
    else
      lcstatesmatch=""
    fi

    csv[i]="${csv[i]},${lifecyclestate},${return_from_getwikilifecyclestate},${lcstatesmatch}"
    ((i++))
  done
  unset array
  unset i
  unset reponame
  unset project
  unset lifecycleproject
  unset lifecyclestate
  unset lcstatesmatch

  #
  # csv column #9: intersphinx
  # intersphinx mappings in conf.py
  # provided is the branch used for linking the repository
  #

  readarray -t array < ./${repolist};
  i=0
  csv[i]="${csv[i]},intersphinx"
  ((i++))
  for line in "${array[@]}"
  do
    reponame=$(echo $line | awk -F "|" '{print $1}');
    project=$(echo $reponame | sed 's:/.*$::')
    #echo "DBUG: reponame=${reponame}"
    #echo "DBUG:  project=${project}"
    #echo "DBUG:        i=${i}"
    reponame=$(echo ${reponame} | sed -r 's/\//-/g')
    search_repo="onap-${reponame}"
    #echo "DBUG: search_repo=${search_repo}"
    find_repo_in_confpy ${search_repo}
    csv[i]="${csv[i]},${return_from_find_repo_in_confpy}"
    ((i++))
  done
  unset array
  unset i
  unset reponame
  unset project
  unset return_from_find_repo_in_confpy

  #
  # csv column #10: RELEASE component (yes|maybe|unknown)
  # to be filled with values of the planned release config file maintained by
  # the onap release manager
  # NOT FUNCTIONAL YET
  #

  # repoclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
  readarray -t array < ./${branch}_repoclone.log;
  i=0
  csv[i]="${csv[i]},${branch_upper} component"
  ((i++))
  for line in "${array[@]}"
  do

    # repoclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
    gitexitcode=$(echo $line | awk -F "|" '{print $1}');
       reponame=$(echo $line | awk -F "|" '{print $2}');
      repostate=$(echo $line | awk -F "|" '{print $3}');
       errormsg=$(echo $line | awk -F "|" '{print $4}');

    #if [[ ${repostate} == "ACTIVE" && ${gitexitcode} == "0" ]]; then
    #  releasecomponent="yes"
    #elif [ ${repostate} == "ACTIVE" ]; then
    ##elif [[ ${repostate} == "ACTIVE" && ${gitexitcode} == "128" ]]; then
    #  releasecomponent="maybe"
    #elif [[ ${repostate} == "READ_ONLY" && ${gitexitcode} == "0" ]]; then
    #  releasecomponent="yes"
    #elif [ ${repostate} == "READ_ONLY" ]; then
    #  releasecomponent="maybe"
    #else
    #  releasecomponent="unknown"
    #fi

    # not functional yet!
    releasecomponent=""

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
  # csv column #11: RELEASE partizipation
  #

  # repoclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
  readarray -t array < ./${branch}_repoclone.log;
  i=0
  csv[i]="${csv[i]},${branch_upper} partizipation"
  ((i++))
  echo "INFO: determine release partizipation for project ..."
  for line in "${array[@]}"
  do

    # repoclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
    gitexitcode=$(echo $line | awk -F "|" '{print $1}');
       reponame=$(echo $line | awk -F "|" '{print $2}');
      repostate=$(echo $line | awk -F "|" '{print $3}');
       errormsg=$(echo $line | awk -F "|" '{print $4}');
    projectname=$(echo $reponame | sed 's:/.*$::')

    if [[ $branch == "master" ]]; then
      return_from_getrpinfo="";
    else
      #echo "DBUG: calling getrpinfo for projectname ${projectname}"
      getrpinfo ${projectname}
    fi

    csv[i]="${csv[i]},${return_from_getrpinfo}"
    ((i++))

  done

  unset array
  unset i
  unset gitexitcode
  unset reponame
  unset repostate
  unset errormsg
  unset projectname
  unset return_from_getrpinfo

  #
  # csv column #12: docs (at repo root directory only; no recursive search!)
  # csv column #13: conf.py
  # csv column #14: tox.ini
  # csv column #15: index.rst
  # csv column #16: first title in index.rst
  #
  # columns are filled with values from requested branch.
  # if data is not available values from master branch are used.
  # to identify master branch values, data is put into round brackets "(...)"
  #

  readarray -t array < ./${repolist};
  i=0
  csv[$i]="${csv[i]},docs,conf.py,tox.ini,index.rst,first title in index.rst"
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

    # tox.ini (check docs dir and also check project root dir)
    if [ -f ./${line}/docs/tox.ini ] || [ -f ./${line}/tox.ini ]; then
      docs="${docs},tox.ini"
      # tox.ini @ branch/docs dir
      if [ -f ./${line}/docs/tox.ini ] ; then
        docs="${docs} @docs"
      fi
      # tox.ini @ branch/project root dir
      if [ -f ./${line}/tox.ini ] ; then
        docs="${docs} @root"
      fi
    elif [ -f ../master/${line}/docs/tox.ini ] || [ -f ../master/${line}/tox.ini ]; then
      docs="${docs},(tox.ini"
      # tox.ini @ master/docs dir
      if [ -f ../master/${line}/docs/tox.ini ] ; then
        docs="${docs} @docs"
      fi
      # tox.ini @ master/project root dir
      if [ -f ../master/${line}/tox.ini ] ; then
        docs="${docs} @root"
      fi
      # just add a round bracket at the end of the value
      docs="${docs})"
    else
      # no tox.ini found in docs or root dir
      docs="${docs},-"
    fi

    # index.rst, first title in index.rst
    indexrsttitle=""
    if [ -f ./${line}/docs/index.rst ] ; then
      indexrsttitle=$(cat ${branch}_indexrst_docs_root_titles.log | grep -F '['${line}']/docs/index.rst,' | awk -F "," '{print $4}');
      docs="${docs},index.rst,${indexrsttitle}"
    elif [ -f ../master/${line}/docs/index.rst ] ; then
      indexrsttitle=$(cat ../master/master_indexrst_docs_root_titles.log | grep -F '['${line}']/docs/index.rst,' | awk -F "," '{print $4}');
      docs="${docs},(index.rst),(${indexrsttitle})"
    else
      docs="${docs},-,-"
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
  # csv column #17: index.html@RTD accessibility check
  # csv column #18: index.html url
  #

  readarray -t array < ./${branch}_repoclone.log;
  i=0
  csv[i]="${csv[i]},index.html@RTD,index.html url"
  ((i++))
  for line in "${array[@]}"
  do
    # repoclone.log format:  $1=gitexitcode|$2=reponame|$3=repostate|$4=errormsg
    gitexitcode=$(echo $line | awk -F "|" '{print $1}');
       reponame=$(echo $line | awk -F "|" '{print $2}');
      repostate=$(echo $line | awk -F "|" '{print $3}');
       errormsg=$(echo $line | awk -F "|" '{print $4}');

            url=""
    curl_result=""

    # this script works only with release "frankfurt" and later because
    # earlier releases are using submodule structure for documentation files
    if echo "$branch" | grep -q '^[abcde]'; then
      curl_result="unsupported release"
      url="-"
    else

      # we are working on "frankfurt" branch or later ...
      if [[ ${repostate} == "ACTIVE" ]] || [[ ${repostate} == "READ_ONLY" ]]; then

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
        # repostate IS NOT ACTIVE OR READ_ONLY - no curl test required
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
  # csv column #19: release notes
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
      relnote=$(find "./${line}" -type f | grep '.*release.*note.*.rst' | wc -l);
      #echo "DBUG: relnote=${relnote}"
      # repo dir DOES NOT exist in this branch - so check if repo dir exists in MASTER branch
    elif [ -d ../master/${line} ] ; then
      # if yes, check if repo name appears in the MASTER releasenotes.log
      # count release notes files in MASTER branch (in repo root and its subdirectories)
      relnote=$(find "../master/${line}" -type f | grep 'release.*note.*.rst' | wc -l);
      #echo "DBUG: relnote=${relnote}"
      # put results in round brackets to show that this is MASTER data
      relnote=$(echo ${relnote} | sed -r s:${relnote}:\(${relnote}\):)
    else
      relnote="-"
    fi
    #echo "DBUG: relnote=${relnote}"

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
  cp ../$wikiplsfile $datadir
  cp ../$rpfile $datadir
  cp ${branch}_table.csv $datadir
  cp ${branch}_*.log $datadir
  zip -r ${datadir}.zip $datadir

  # return from the branch directory
  cd ..

# return and work on the next requested branch ... or exit
done
