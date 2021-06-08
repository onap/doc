#!/usr/bin/env python3

### ===========================================================================
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
###
### Copyright (C) 2021 Deutsche Telekom AG
### ============LICENSE_END====================================================

#
# getrsttitle.py
# AUTHOR(S):
# Thomas Kulik, Deutsche Telekom AG, 2021
# DESCRIPTION:
# Processes a list of rst files and retrieves the first title for every single rst file.
# Copy program to {branch} directory of cloned ONAP documentation and run it.
# USAGE:
# python3 getrsttitle.py filename
#
# Helpful resources:
# https://regex101.com/r/YNYK2Q/1/
# https://stackoverflow.com/questions/20312443/how-to-find-title-a-la-restructuredtext
#

import re
import os.path
import sys
import argparse

#
# argument handling
#

parser = argparse.ArgumentParser(description='Processes a list of rst files and retrieves the first title for every single rst file.')
parser.add_argument('filename')
args = parser.parse_args()

# regex to find title underlined with various characters
#regex1 = r"(?:^|\n)(?!\=)([^\n\r]+)\r?\n(\=+)(?:\r?\n| *$)"
#regex2 = r"(?:^|\n)(?!\-)([^\n\r]+)\r?\n(\-+)(?:\r?\n| *$)"
#regex3 = r"(?:^|\n)(?!\~)([^\n\r]+)\r?\n(\~+)(?:\r?\n| *$)"
#regex4 = r"(?:^|\n)(?!\#)([^\n\r]+)\r?\n(\#+)(?:\r?\n| *$)"
#regex5 = r"(?:^|\n)(?!\*)([^\n\r]+)\r?\n(\*+)(?:\r?\n| *$)"

# there is a problem with raw strings (r"...") in the regex search below
# workaround: using \\ to mask special characters in regex
regex_list = [
    "(?:^|\\n)(?!\\=)([^\\n\\r]+)\\r?\\n(\\=+)(?:\\r?\\n| *$)",
    "(?:^|\\n)(?!\\-)([^\\n\\r]+)\\r?\\n(\\-+)(?:\\r?\\n| *$)",
    "(?:^|\\n)(?!\\~)([^\\n\\r]+)\\r?\\n(\\~+)(?:\\r?\\n| *$)",
    "(?:^|\\n)(?!\\#)([^\\n\\r]+)\\r?\\n(\\#+)(?:\\r?\\n| *$)",
    "(?:^|\\n)(?!\\*)([^\\n\\r]+)\\r?\\n(\\*+)(?:\\r?\\n| *$)",
    ]

# DBUG only
#for regex in regex_list:
#    print(repr(regex))

#filename = './master_indexrst_docs_root.log'
#filename = './master_rstfiles.log'

if os.path.isfile(args.filename):
    with open(args.filename) as fn:
        # read first line
        line = fn.readline()
        #print("DBUG: line={}".format(line))
        file_cnt = 0
        while line:
            rstfile         = "./" + re.sub('\[|\]', '', line).strip()
            repository_tmp1 = re.sub('\].+$', '',line).strip()
            repository      = re.sub('\[', '',repository_tmp1).strip()
            project_tmp1    = re.sub('\].+$', '',line).strip()
            project_tmp2    = re.sub('\/.+$', '',project_tmp1).strip()
            project         = re.sub('\[', '',project_tmp2).strip()
            #print("DBUG:       file #{} {}".format(file_cnt, rstfile))
            #print("DBUG: repository #{} {}".format(file_cnt, repository))
            #print("DBUG:    project #{} {}".format(file_cnt, project))
            file_cnt += 1
            if os.path.isfile(rstfile):
                with open(rstfile, 'r') as content:
                    content_rstfile = content.read()
                    #print("DBUG: content_rstfile = \n{}".format(content_rstfile))
                    regex_cnt = 0
                    for regex in regex_list:
                        regex_cnt += 1
                        m = re.search(regex, content_rstfile, re.MULTILINE)
                        #print("DBUG: using regex  " + repr(regex))
                        #print("DBUG: using regex1 " + repr(regex1))
                        #print("DBUG: regex_cnt = {}".format(regex_cnt))
                        if m:
                            match = m.group(1)
                            #print ("DBUG: |REGEX| {} |REGEXCNT| {} |FILECNT| {} |FILE| {} |MATCH| {}".format(repr(regex), regex_cnt, file_cnt, rstfile, match))
                            # end regex loop if we have a title
                            break
                        else:
                            match = "NO-TITLE-FOUND"
                            #print ("DBUG: NO-TITLE-FOUND")
            else:
                print ("ERR:  File {} does not exist".format(rstfile))

            #print ("DBUG: |REGEX| {} |REGEXCNT| {} |FILECNT| {} |FILE| {} |MATCH| {}".format(repr(regex), regex_cnt, file_cnt, rstfile, match))
            #print ("DBUG: file #{} '{}' '{}'".format(file_cnt, rstfile, match))

            # clean up result and print
            match_1 = match.replace(",", "") # remove ,
            match_final = match_1.strip()    # remove \n
            print ("{},{},{},{}".format(project.strip(), repository.strip(), line.strip(), match_final.strip()))

            # read next line and loop
            line = fn.readline()
else:
    print ("ERR:  File {} does not exist".format(args.filename))

sys.exit()

#
# example code to show detailed regex matches and group content
# to be used in a future version of this program
#
# matches = re.finditer(regex2, content, re.MULTILINE)
# for matchNum, match in enumerate(matches, start=1):
#     print ("Match {matchNum} was found at {start}-{end}: {match}".format(matchNum = matchNum, start = match.start(), end = match.end(), match = match.group()))
#     print ("{match}".format(match = match.group()))
#     for groupNum in range(0, len(match.groups())):
#         groupNum = groupNum + 1
#         print ("Group {groupNum} found at {start}-{end}: {group}".format(groupNum = groupNum, start = match.start(groupNum), end = match.end(groupNum), group = match.group(groupNum)))
# print ("Test:" "{group}".format(group = match.group(1)))
#

#
# example code for pandas
# to be used in a future version of this program
#
# import pandas as pd
# pd.set_option('display.max_rows', 500)
# pd.set_option('display.max_columns', 500)
# pd.set_option('display.width', 1000)
#
# table = pd.read_csv("master_table.csv")
# print(table)
#