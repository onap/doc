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
### c2m
###
### AUTHOR(S):
### Thomas Kulik, Deutsche Telekom AG, 2020
###
### DESCRIPTION:
### c2m automates additional tasks required in case you want to export and
### convert a set of wiki pages. the export and first conversion to markdown is
### done by confluence2md, provided by viaboxx.
### c2m processes a list of (to be exported) wiki pages, creates corresponding
### export directories, exports and converts pages (in various formats if
### required), opens an editor and cleans up afterwards.
### c2m checks also for problematic content in the export and creates a warning
### in case of detection.
###
### ISSUES:
### - markdown (md) output of confluence2md contains sometimes tags that are
###   somehow "merged" with the topic headline; manual edit is required here
###
### OPEN:
### - confluence2md does not support all of the currently used confluence page
###   types (structured-macros) - result for unsupported pages is
###   "not satisfying"; enhancements (java) are required
### - opt: toc creation in root document in case you export a tree of documents
###   to separate files
### - opt: remove wiki credentials from script
###
### REQUIRED:
### - pandoc, retext, confluence2md, java (older version for confluence2md),
###   login for the confluence wiki
###
### SEE ALSO:
### - https://www.viaboxx.de/code/confluence2md/
### - https://github.com/viaboxxsystems/confluence2md
###


###
### CHANGELOG (LATEST ON TOP)
###
### 1.1.0 (2020-03-10) added support for http/https proxy and anonymous wiki
###                    access. thx to eric, nicolas and sylvain (orange, france)
###                    confluence2md jar file now has to be in the same path as
###                    c2m. 
### 1.0.0 (2020-03-09) initial release
###


###
### c2m example pagelist
###
### example pagelist (field descriptions below); it uses the delimiter "|" for
### the four fields per line.
### copy/paste page id and title from wiki; to get the wiki page_id you have to
### login to the wiki, open the page and choose e.g. the history.
### depth: use depth to follow down the child-pages hierarchy if required:
### -1=infinte, 0=no children, #=number of child-pages to follow.
### every hierarchy "0" entry will lead into the creation of a dedicated working
### directory where the page and child-pages are stored.
### for better readability you can add spaces to the list, but use "|" as a
### delimiter. lines starting with a # are filtered by c2m.
###
### hierarchy | page_id  | page_title                      | depth
###
### 0         |  1018748 | ONAP Portal                     |  0
### 1.1       |  1018759 | ONAP Portal for users           |  0
### 1.2       |  1018762 | ONAP Portal for administrators  |  0
### 1.2.1     |  1018764 | Admins                          |  0
### 1.2.2     |  1018811 | Users                           |  0
### 1.2.3     |  1018821 | Portal Admins                   |  0
### 1.2.4     |  1018826 | Application Onboarding          |  0
### 1.2.5     |  1018832 | Widget Onboarding               |  0
### 1.2.6     |  1018835 | Edit Functional Menu            |  0
### 1.2.7     | 16004953 | Portal Microservices Onboarding |  0
###
### in case you want to export to only one single output page (that contains all
### child-pages of the above example) use:
###
### 0         |  1018748 | ONAP Portal                     | -1
###


###
### some initial variables
###

script_version="1.1.0 (2020-03-10)"

          user="*****";        # replace ***** with your wiki login name
        passwd="*****";        # replace ***** with your wiki password
   credentials="${user}":"${passwd}";
        server="https://wiki.onap.org";
    rst_editor="retext --preview";

# remove credentials for those using anonymous access
test "${credentials}" = "*****:*****" && credentials=""

# explicit script dir to locate jar file
basedir="$(cd "$(dirname "$0")"; pwd)"

###
### some inital tasks after script has been started
###

###
### print script version, date and time
###

echo "INFO ***************************************************************************"
echo "INFO c2m Version ${script_version}, started $(date)";

###
### simple script argument handling
###

page_list=$1;

# check if there is an argument at all
if [[ "$page_list" == "" ]] ; then
    echo 'Usage: c2m [PAGELIST]'
    exit 1
fi

# check if argument is a file
if [ ! -f $page_list ] ; then
    echo "Error: can't find pagelist \"$page_list\""
    exit 1
fi

###
### declare the functions of this script
###

###
### function: create working directory; save (only the last) existing one; remove older versions; do some error handling
###

function create_working_dir {

  # compose name for working directory
  #working_dir="${page_id}-${page_title}";
  #working_dir="${page_title}-id${page_id}";
  working_dir="${page_title}";
  echo "INFO ***************************************************************************"
  echo "INFO working directory \"$working_dir\" will be created"

  # check if current working directory is already in the list
  if [[ " ${existing_working_dirs[@]} " =~ " ${working_dir} " ]]; then
    echo "ERRR ***************************************************************************"
    echo "ERRR working directory \"${working_dir}\" already exists - check entries in page_list for duplicates"
    echo "ERRR exiting ..."
    exit -1
  else
    # store working_dir name for error handling
    existing_working_dirs+=(${working_dir})
  fi

  # sample code
  #if [[ ! " ${array[@]} " =~ " ${value} " ]]; then
  #    # whatever you want to do when arr doesn't contain value
  #fi

  # check existence of working directory
  if [ -d "$working_dir" ]; then
    # check existence of old saved working directory
    if [ -d "${working_dir}.old" ]; then
      # remove the old saved working directory
      rm -r "${working_dir}.old";
    fi
    # save (only) the latest working directory
    mv $working_dir "$working_dir.old";
  fi
  # finally create the working directory and cd into it
  mkdir $working_dir;
  cd $working_dir;
}

###
### function: pull pages from wiki - currently we are testing some export variations
###

function pull_pages_from_wiki {

  # define outfile name
  #out_file="${page_title}-id${page_id}";
  out_file="${page_title}";

  # set proxy for those who need
  test -n "${http_proxy}" && proxy="$(echo $http_proxy |sed -e 's,http://,-Dhttp.proxyHost=,' -e 's/:/ -Dhttp.proxyPort=/' -e 's:/$::')"
  test -n "${https_proxy}" && proxy="$proxy $(echo $https_proxy |sed -e 's,http://,-Dhttps.proxyHost=,' -e 's/:/ -Dhttps.proxyPort=/' -e 's:/$::')"

  # pull pages from wiki and convert to markdown (as a source for conversion by pandoc)
  java $proxy -jar "${basedir}"/confluence2md-2.1-fat.jar +H true +T false +RootPageTitle false +FootNotes true -maxHeaderDepth 7 -depth $depth -v true -o ${out_file}.md -u "${credentials}" -server $server $page_id
}

###
### function: simple search and (red colored) warning if special terms are detected in the md output file
###

function detect_unwanted_content_in_md_outfile {
for search_term in "ecomp" "wiki.onap.com" "10.53.199.7" "at&t"
do
  if grep $search_term ${out_file}.md; then
    echo -e "\e[31mWARN ***************************************************************************\e[39m";
    echo -e "\e[31mWARN term \"${search_term}\" detected in ${out_file}.md\e[39m";
  fi
done
}

###
### function: pandoc conversion from md (variants) to rst - currenty testing some conversion formats
###

function convert_md_outfile_to_rst {
  #depending on the given source format (--from) the results may vary
  #pandoc -s --toc --toc-depth=5 --from markdown_mmd      --to rst "${out_file}.md" -o "${out_file}-markdown_mmd.rst"
  #pandoc -s --toc --toc-depth=5 --from markdown_strict   --to rst "${out_file}.md" -o "${out_file}-markdown_strict.rst"
  #pandoc -s --toc --toc-depth=5 --from markdown_phpextra --to rst "${out_file}.md" -o "${out_file}-markdown_phpextra.rst"
  #pandoc -s --toc-depth=5 --from markdown_phpextra --to rst "${out_file}.md" -o "${out_file}-markdown_phpextra.rst"
  pandoc -s --toc-depth=5 --from markdown_phpextra --to rst "${out_file}.md" -o "${out_file}.rst"
}

###
### function: check results in rst editor
###

function open_rst_editor {
  #echo "DBUG ***************************************************************************"
  #echo "DBUG open \"${out_file}\*.rst\" with rst editor"
  $rst_editor ${out_file}*.rst &
}

###
### function: clean up export directories from files no longer needed
###

function clean_up {
  rm *.md                2>/dev/null
  rm attachments/*.json  2>/dev/null
  rm attachments/.*.json 2>/dev/null
}

###
### main: let's start the work ...
###

# read in pagelist file, filter lines starting with a comment and create an array that contains all (uncommented) lines of the file

# sample code
# IFS=',' read -r -a page_array <<< "$page_list" # in case $page_list was defined as a varable in this script; use "," as the delimiter
#readarray -t page_array < $page_list; # old version

readarray -t page_array < <(grep -v "^#" $page_list); # new version which skips line with comments

# INFO: show list of pages by printing every line of the array
echo "INFO ***************************************************************************"
for line in "${page_array[@]}"
do
    echo "INFO $line"
done

# the main loop reads the page_array line by line and processes the content
for line in "${page_array[@]}"
do

    # cut out values from the current line (delimiter is now the "|") and assign them to the correct variables
    hierarchy=$(echo $line | cut -f1 -d\|)
      page_id=$(echo $line | cut -f2 -d\|)
   page_title=$(echo $line | cut -f3 -d\|)
        depth=$(echo $line | cut -f4 -d\|)

    # remove leading and trailing spaces from variables
    hierarchy="$(echo -e "${hierarchy}"  | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')";
      page_id="$(echo -e "${page_id}"    | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')";
   page_title="$(echo -e "${page_title}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')";
        depth="$(echo -e "${depth}"      | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')";

    # substitude all blanks in page_title with a minus sign
    page_title=$(echo -e ${page_title} | tr '[:blank:]' '-');
    echo "DBUG page_title=\"$page_title\""

    # convert page_title to lowercase
    page_title=$(echo -e ${page_title} | tr '[:upper:]' '[:lower:]');
    #echo "DBUG page_title=\"$page_title\""

    # remove all characters from page_title which may cause problems in the shell ... or are reserved by conventions of this script
    #page_title="$(echo -e "${page_title}" | sed -e 's/[^A-Za-z0-9._-]//g')"; # a less strict version
    page_title="$(echo -e "${page_title}" | sed -e 's/[^A-Za-z0-9-]//g')";
    echo "DBUG page_title=\"$page_title\""

    # INFO: print variables to check content
    echo "INFO ***************************************************************************"
    echo "INFO hierarchy  = \"$hierarchy\""
    echo "INFO page_id    = \"$page_id\""
    echo "INFO page_title = \"$page_title\""
    echo "INFO depth      = \"$depth\""

    # create working directory - done for every! "hierarchy 0" entry of page_list
    if [ "$hierarchy" == "0" ]
    then
      create_working_dir
    fi

    # call functions to process page
    pull_pages_from_wiki
    detect_unwanted_content_in_md_outfile
    convert_md_outfile_to_rst
    open_rst_editor
    clean_up

# main loop end
done

# bye!
echo "INFO ***************************************************************************"
echo "INFO c2m Version ${script_version}, ended $(date)"
echo ""
exit 0
