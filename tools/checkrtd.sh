#!/bin/bash
#set -x # uncomment for bash script debugging

# branch, e.g. "master" or "guilin"
branch=$1
# logfile produced by checkdocs that contains the list of links
file_to_process=$2

#
# NOTE: works NOT with elalto release and below because of the submodule structure used for documentation
#

# url
# important! only doc project needs a different url base
url_lang="en"
url_branch=${branch}
unique=$(date +%s)

# "master" branch documentation is available as "latest" in RTD
if [[ ${url_branch} == "master" ]]; then
  url_branch="latest"
fi

#readarray -t array < ./${branch}_releasenotes.log;
readarray -t array < ${file_to_process};
for line in "${array[@]}"
do

  reponame=$(echo ${line} | cut -d "[" -f2 | cut -d "]" -f1)
  #reponame="[${reponame}]"
  #echo "DBUG: reponame=${reponame}"

  # example line: [dmaap/messagerouter/messageservice]/docs/release-notes/release-notes.rst
  # example url:  https://docs.onap.org/projects/onap-dmaap-messagerouter-messageservice/en/frankfurt/release-notes/release-notes.html

  # extract repo name which comes in square bracktes ([...]) and convert slash (/) to minus (-)
  # line:   [dmaap/messagerouter/messageservice]/docs/release-notes/release-notes.rst
  # output:  dmaap-messagerouter-messageservice
  url_repo=$(echo ${line} | sed -r 's/].+$//' | sed -r 's/\[//' | sed -r 's/\//-/g')

  # extract rst filename and its path; replace .rst ending with .html
  # warning: path does not always contain "docs"!
  # line:   [dmaap/messagerouter/messageservice]/docs/release-notes/release-notes.rst
  # output:                                           release-notes/release-notes.html
  url_file=$(echo ${line} | sed -r 's/^.+\]//' | sed -r 's/^.*\/docs\///' | sed -r 's/\.rst$/\.html/' )

  #echo "DBUG:     line = ${line}"
  #echo "DBUG: url_file = ${url_file}"
  #echo "DBUG: url_repo = ${url_repo}"
  #echo "DBUG: reponame = ${reponame}"

  # build the full url
  if [[ ${reponame} == "doc" ]]; then
    # build the full url for the doc project
    url_start="https://docs.onap.org"
    url="${url_start}/${url_lang}/${url_branch}/${url_file}"
  else
    # build the full url for the other projects
    url_start="https://docs.onap.org/projects/onap"
    url="${url_start}-${url_repo}/${url_lang}/${url_branch}/${url_file}"
  fi

  #echo "DBUG:      url = $url"

  # check with curl if html page is accessible (no content check!)
  # to prevent (server side) cached results a unique element is added to the request
  curl --head --silent --fail "${url}?${unique}" >/dev/null
  curl_result=$?

  # "0" and "22" are expected as a curl result
  if [ "${curl_result}" = "0" ]; then
    curl_result="accessible"
  elif [ "${curl_result}" = "22" ]; then
    curl_result="does not exist"
  fi

  #echo -e "DBUG:       ${line}"
  #echo -e "DBUG: ${curl_result} ${url}"
  #echo " "

  echo "${line},${url},${curl_result}"

  ((i++))
done
unset array
unset i
