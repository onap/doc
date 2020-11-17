#!/bin/bash
#set -x # uncomment for bash script debugging

# branch, e.g. "master" or "guilin"
branch=$1
# logfile produced by checkdocs that contains the list of links
file_to_process=$2

#
# NOTE: works NOT with elalto release and below because of the submodule structure used for documentation
#

 url_start="https://docs.onap.org/projects/onap"
  url_lang="en"
url_branch=${branch}
unique=$(date +%s)

# "master" docs are available as "latest" in read-the-docs
if [ "${url_branch}" = "master" ]; then
  url_branch="latest"
fi

#readarray -t array < ./${branch}_releasenotes.log;
readarray -t array < ${file_to_process};
for line in "${array[@]}"
do

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
  url_file=$(echo ${line} | sed -r 's/^.+\]//' | sed -r 's/^.*docs\///' | sed -r 's/\.rst$/\.html/' )

  # build the full url
  url="${url_start}-${url_repo}/${url_lang}/${url_branch}/${url_file}"

  # check with curl if html page is accessible (no content check!)
  # to prevent (server side) cached results a unique element is added to the request
  curl --head --silent --fail "${url}?${unique}" >/dev/null
  curl_result=$?

  # "0" and "22" are expected as a curl result
  if [ "${curl_result}" = "0" ]; then
    curl_result="accessible"
  elif [ "${curl_result}" = "22" ]; then
    curl_result="NOT ACCESSIBLE"
  fi

  #echo -e "DBUG:       ${line}"
  #echo -e "DBUG: ${curl_result} ${url}"
  #echo " "

  echo "${line},${url},${curl_result}"

  ((i++))
done
unset array
unset i
