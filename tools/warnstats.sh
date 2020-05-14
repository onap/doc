#!/bin/bash

#set -x # uncomment for bash script debugging

# ============================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=====================================================

###
### warnstats
###
### AUTHOR(S):
### Thomas Kulik, Deutsche Telekom AG, 2020
###
### DESCRIPTION:
### warnstat helps to find the onap modules (projects) and rst-files which are
### responsible for the most warnings during the documentation build process.
### it requires a tox build logfile, parses it line by line, prints out some
### statistics and provides links to the local rst file, its html version, the
### related link to readthedocs and as well the doc8 test result for the rst.
###

###
### CHANGELOG (LATEST ON TOP)
###
### 1.6.2 (2020-05-14) - fixed a major problem with rst files within one module
###                      which have the same name (but reside in different
###                      subdirectories). they were not shown in the result
###                      list. introduced a crc-number for every file for proper
###                      identification and to build the index.
###                    - fixed a problem where the results are showing the link
###                      to a wrong file due to a regex problem in the script.
### 1.6.1 (2020-04-21) - fixed a problem with duplicates in rst filenames
### 1.6.0 (2020-04-03) - extended detection of docs pathes in case they are not
###                      below the submodules directory
### 1.5.0 (2020-03-23) - doc8 test now executed for every rst file. result is
###                      provided in the output as "doc8_(nnnnn)" where nnnnn
###                      is the total number of accumulated doc8 errors.
###                    - improved readability of output
### 1.4.0 (2020-03-18) - the link to the local html and rst file is provided in
###                      the output. this may help to ease the debug process.
###                      use mouse-over/context menu functionality of bash to
###                      easily open files with your browser or rst editor.
###                    - improved handling for module names (in case they are
###                      no real onap projects/modules but directories which
###                      contain additional documentation in rst format).
### 1.3.1 (2020-03-10) - fixed minor typo in usage message
### 1.3.0 (2020-03-09) - initially released to the community
###

script_version="1.6.2 (2020-05-14)"
doc8_dir=$(pwd)/doc8_results
logfile=$1;
doc8_command="doc8 --verbose"; #add options if required
web_base_url="https://docs.onap.org/en/latest";

echo " ";
echo " warnstats version ${script_version}";

declare -A module_array
declare -A message_short_array
declare -A message_long_array
declare -A rstfile_array
declare -A rstfilepath_array
declare -A htmlfilepath_array
declare -A webpath_array
declare -A doc8_result_array

###
### simple script argument handling
###

# check if there is an argument at all
if [[ "$logfile" == "" ]] ; then
    echo 'Usage: warnstats [tox-logfile]'
    exit 1
fi

# check if argument is a file
if [ ! -f $logfile ] ; then
    echo "Error: can't find tox-logfile \"$logfile\""
    exit 1
fi

# create and clean doc8 directory
if [ ! -d "$doc8_dir" ]; then
  mkdir $doc8_dir;
else
  rm ${doc8_dir}/*.txt 2>/dev/null;
fi

# get local html build directory
html_build_dir=$(grep "Generated docs available in" $logfile);
html_build_dir=$(echo "$html_build_dir" | grep -oP " /.*/doc/docs/_build/html$");
html_build_dir=$(echo "$html_build_dir" | sed -r 's:^ ::');
echo " html build directory ..... $html_build_dir"
echo " web base url ............. $web_base_url";
echo " doc8 command ............. $doc8_command";
echo " doc8 results directory ... $doc8_dir";
echo " tox logfile .............. $logfile";

# read in the tox build logfile - use only lines which contain a warning
readarray -t logfile_array < <(grep ": WARNING:" $logfile);

# process filtered logfile line by line
for line in "${logfile_array[@]}"
do

    # count warning lines
    (( counter++ ));
    echo -n -e " lines processed .......... $counter (doc8 check may take a while ...)\r";

    #
    # extract path to local rst file
    #

    # remove problematic text in the original line that causes regex to fail
    line=$(echo "$line" | sed -r 's:, other instance in.*::');

    path_rst=$line;
    path_rst_debug=$line;
    #echo "DBUG      line: $line"
    # remove problematic text in line that causes regex to fail
    path_rst=$(echo "$path_rst" | sed -r 's:, other instance in.*::');
    #echo "DBUG path_rst: $path_rst"
    # grep the rst file path
    path_rst=$(echo "$path_rst" | grep -oP "^(/|docs).*\.rst");
    #echo "DBUG path_rst: $path_rst"
    # create an unique identifier for the rst file for the case that the rst file name is used multiple times (but in different subdirectories) within one module
    rst_crc=$(crc32 "$path_rst" 2>/dev/null);
    #echo "DBUG  rst_crc: $rst_crc"
    if [[ "$rst_crc" == "" ]] ; then
      rst_crc="rst_crc_missing"
    fi

    if [[ "$path_rst" == "" ]] ; then
      path_rst="path_to_rst_missing"
      #echo "DBUG       path_rst: $path_rst"
      #echo "DBUG path_rst_debug: $path_rst_debug"
    fi
    # finally embed the full rst path in a message to use mouse-over/context menu of bash to open file
    path_rst_link='\e]8;;file:'$path_rst'\arst\e]8;;\a';
    #echo -e "DBUG path_rst: "$path_rst;

    #
    # extract path to the html version of the local rst file
    #

    path_html=$line;
    #echo "DBUG      line: $line"
    # remove problematic text in line that causes regex to fail
    path_html=$(echo "$path_html" | sed -r 's:, other instance in.*::');
    #echo "DBUG path_html: $path_html"
    # grep the rst file path and modify it so we get the local html build path; grep a little bit more to be save
    path_html=$(echo "$path_html" | grep -oP "(^|/)docs(/.*|)/[\w -]*\.rst");
    #echo "DBUG path_html: $path_html"
    path_html=$(echo "$path_html" | sed -r 's:^/docs::');
    #echo "DBUG path_html: $path_html"
    path_html=$(echo "$path_html" | sed -r 's:.rst:.html:');
    #echo "DBUG path_html: $path_html"
    # create also the path to the web version
    path_web_link='\e]8;;'${web_base_url}${path_html}'\aweb\e]8;;\a';
    #echo "DBUG path_web_link: $path_web_link"
    # finally embed the full html path in a message to use mouse-over/context menu of bash to open file
    path_html_link='\e]8;;file:'${html_build_dir}${path_html}'\ahtml\e]8;;\a';
    #echo -e "DBUG path_html_link: "$path_html_link;

    # extract module name from line (remove all text before module name; then cut out module name)
    module=$(echo "$line" | sed -r 's:(^.*/doc/docs/submodules/|^docs/submodules/|checking consistency... )::' | cut -f1 -d\/);
    #echo "DBUG   line: $line"
    #echo "DBUG module: $module"

    # in case the extraction has not lead to a valid module name do some additional investigation
    if [[ "$module" == "" ]] ; then

      if [[ $line =~ doc/docs/release ]] ; then
          module="docs_release"
          #echo "DBUG   line: $line"
          #echo "DBUG module: $module"
      elif [[ $line =~ doc/docs/use-cases ]] ; then
          module="docs_use-cases"
          #echo "DBUG   line: $line"
          #echo "DBUG module: $module"
      elif [[ $line =~ doc/docs/guides/onap-developer ]] ; then
          module="docs_guides_onap-developer"
          #echo "DBUG   line: $line"
          #echo "DBUG module: $module"
      elif [[ $line =~ doc/docs/guides/onap-operator ]] ; then
          module="docs_guides_onap-operator"
          #echo "DBUG   line: $line"
          #echo "DBUG module: $module"
      elif [[ $line =~ doc/docs/guides/onap-provider ]] ; then
          module="docs_guides_onap-provider"
          #echo "DBUG   line: $line"
          #echo "DBUG module: $module"
      elif [[ $line =~ doc/docs/guides/onap-user ]] ; then
          module="docs_guides_onap-user"
          #echo "DBUG   line: $line"
          #echo "DBUG module: $module"
      elif [[ $line =~ doc/docs/guides/overview ]] ; then
          module="docs_guides_overview"
          #echo "DBUG   line: $line"
          #echo "DBUG module: $module"
      elif [[ $line =~ doc/docs/templates ]] ; then
          module="docs_templates"
          #echo "DBUG   line: $line"
          #echo "DBUG module: $module"
      elif [[ $line =~ doc/docs/guides ]] ; then
          module="docs_guides"
          #echo "DBUG   line: $line"
          #echo "DBUG module: $module"
      else
          module="docs"
          #echo "DBUG   line: $line"
          #echo "DBUG module: $module"
      fi

    fi
    #echo "DBUG   line: $line";
    #echo "DBUG module: $module";

    # get the maximum length of the variable entries to adjust table width later on
    if [[ ${#module} -gt "$maxlength_module" ]]; then
      maxlength_module=${#module};
    fi
    #echo "DBUG maxlength_module=$maxlength_module";

    # extract rst file name from line and do some formatting to use it later as an array name
    #echo "DBUG line: $line";
    rstfile=$(echo "$line" | sed -r 's:, other instance in.*::');
    rstfile=$(echo -e "${rstfile}" | grep -oP "[\w -]*\.rst");
    rstfile=$(echo -e ${rstfile} | tr '[:blank:]' '_');
    #echo "DBUG rstfile: '$rstfile'";

    # get the maximum length of the variable entries to adjust table width later on
    if [[ ${#rstfile} -gt "$maxlength_rstfile" ]]; then
      maxlength_rstfile=${#rstfile};
    fi
    #echo "DBUG maxlength_rstfile=$maxlength_rstfile";

    # count the number of warnings for the module/rstfile combination
    (( rstfile_array[$module | $rstfile | $rst_crc]++ ));

    # count the number of warnings for the single module
    #echo "DBUG $module | $rstfile | $message";
    (( module_array[$module]++ ));

    # now we have all the information to fill the html/rst/web (file) path arrays
    htmlfilepath_array[$module | $rstfile | $rst_crc]=$path_html_link;
     rstfilepath_array[$module | $rstfile | $rst_crc]=$path_rst_link;
         webpath_array[$module | $rstfile | $rst_crc]=$path_web_link;

    #echo "DBUG -------------------------------------------------------------------";
    #echo "DBUG               line: $line";
    #echo "DBUG htmlfilepath_array: $module | $rstfile | $rst_crc = $path_html_link";
    #echo "DBUG  rstfilepath_array: $module | $rstfile | $rst_crc = $path_rst_link";
    #echo "DBUG      webpath_array: $module | $rstfile | $rst_crc = $path_web_link";

    # extract the warning message and do some formatting
    #message=$(echo "$line" | sed -r 's:^/.+WARNING\:\ ::');
    message=$(echo "$line" | sed -r 's:^.+WARNING\:\ ::');
    message=$(echo -e ${message} | tr '[:blank:]' '_');
    message=$(echo -e ${message} | tr '/' '_');
    message=$(echo -e ${message} | tr '.' '_');

    # remove all characters from message which may cause problems in the shell
    message="$(echo -e "${message}" | sed -e 's/[^A-Za-z0-9_-]//g')";
    #echo "DBUG message=\"$message\""

    # count the number of warnings for the single message (long version)
    message_long="$(echo -e "${message}")";
    (( message_long_array[$message_long]++ ))

    # reduce length of message to group them more easily and then ...
    # count the number of warnings for the single message (short version)
    message_short="$(echo -e "${message}" | cut -c -16)";
    (( message_short_array[$message_short]++ ))

    # check rst files with doc8 and store results
    doc8_result_path="${doc8_dir}/${module}-${rstfile}-${rst_crc}.txt";
    #echo "DBUG ---------------------------------------------"
    #echo "DBUG doc8_result_path=\"$doc8_result_path\""
    # doc8 check only if result file does not exists yet AND if rst file is valid (exists)
    if [[ ! -f "$doc8_result_path" && -f "$path_rst" ]] ; then
        echo "FILE:$path_rst" >$doc8_result_path;
        $doc8_command "$path_rst" >>$doc8_result_path;
        total_acc_err=$(grep "Total accumulated errors = " $doc8_result_path);
        #echo "DBUG total_acc_err=$total_acc_err";
        total_acc_err=$(echo $total_acc_err | sed 's:Total accumulated errors = ::');
        #echo "DBUG total_acc_err=$total_acc_err";
        total_acc_err=$(printf "%05d" $total_acc_err);
        #echo "DBUG command:doc8 ${path_rst} >>${doc8_result_path}";
        #echo "DBUG total_acc_err=$total_acc_err";
    fi
    doc8_result='\e]8;;file:'${doc8_result_path}'\adoc8_('$total_acc_err')\e]8;;\a';
    doc8_result_array[$module | $rstfile | $rst_crc]=$doc8_result;

done

#format counter to have always x digits
counter=$(printf "%05d" $counter);
echo "                                                                      ";
echo " $counter LINES WITH WARNING IN FILE '$logfile'";

echo " ";
echo "################################################################################";
echo "~~~ MESSAGES LONG ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo "################################################################################";
echo " ";

#print array content and append to temporary outfile
for i in "${!message_long_array[@]}"
do
  m=$i;
  n=${message_long_array[$i]};
  ((nc += n))
  #format counter to have always x digits
  n=$(printf "%05d" $n);
  echo " $n | $m" >>tempoutfile;
done

#format counter to have always x digits
nc=$(printf "%05d" $nc);
echo " $nc WARNINGS IN TOTAL WITH ${#message_long_array[@]} UNIQUE MESSAGES" >>tempoutfile;

#print a sorted version of the temporary outfile
sort -br tempoutfile

# clean up
rm tempoutfile
nc=0

echo " ";
echo "################################################################################";
echo "~~~ MESSAGES SHORTENED (FOR SIMPLE GROUPING) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo "################################################################################";
echo " ";

#print array content and append to temporary outfile
for i in "${!message_short_array[@]}"
do
  m=$i;
  n=${message_short_array[$i]};
  ((nc += n))
  #format counter to have always x digits
  n=$(printf "%05d" $n);
  echo " $n | $m" >>tempoutfile;
done

#format counter to have always x digits
nc=$(printf "%05d" $nc);
echo " $nc WARNINGS IN TOTAL WITH ${#message_short_array[@]} UNIQUE MESSAGES" >>tempoutfile;

#print a sorted version of the temporary outfile
sort -br tempoutfile

# clean up
rm tempoutfile
nc=0

echo " ";
echo "################################################################################";
echo "~~~ MODULES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo "################################################################################";
echo " ";

#create temporary outfile
for i in "${!module_array[@]}"
do
  m=$i;
  n=${module_array[$i]};
  ((nc += n))
  n=$(printf "%05d" $n);
  echo " $n | $m" >>tempoutfile;
done

#format counter to have always x digits
nc=$(printf "%05d" $nc);
echo " $nc WARNINGS IN TOTAL IN ${#module_array[@]} MODULES" >>tempoutfile;

#print a sorted version of the temporary outfile
sort -br tempoutfile
rm tempoutfile
nc=0

echo " ";
echo "################################################################################";
echo "~~~ MODULES WITH RSTFILES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo "################################################################################";
echo " ";

#print array content and append to temporary outfile
for i in "${!rstfile_array[@]}"
do
  m=$i;
  n=${rstfile_array[$i]};
  p=${htmlfilepath_array[$i]}
  r=${rstfilepath_array[$i]}
  w=${webpath_array[$i]}
  d=${doc8_result_array[$i]};
  #echo "DBUG -------------------------------"
  #echo "DBUG i = '$i'"
  #echo "DBUG m = '$m'"
  #echo "DBUG n = '$n'"
  #echo "DBUG p = '$p'"
  #echo -e "DBUG p = '$p'"
  #echo "DBUG w = '$w'"
  #echo "DBUG d = '$d'"
  ((nc += n))
  #format counter to have always x digits
  n=$(printf "%05d" $n);

  # extend module name to the max for better readability
  tmp_mod=$(echo "$m" | sed -r 's: \|.+$::');
  #echo "DBUG tmp_mod=$tmp_mod"
  len_tmp_mod=${#tmp_mod}
  to_add="$(($maxlength_module-$len_tmp_mod))"
  #echo "DBUG to_add=$to_add"
  while [ $to_add -gt 0 ]; do
      tmp_mod="${tmp_mod} ";
      ((to_add--));
      #echo "DBUG  to_add=$to_add"
      #echo "DBUG tmp_mod=\"$tmp_mod\""
  done

  # remove crc and extend rst name to the max for better readability
  #echo "DBUG ******************************************************"
  #echo "DBUG m = '$m'"
  tmp_rst=$(echo "$m" | sed -r 's:\| [[:alnum:]_]+$::');
  #echo "DBUG tmp_rst = '$tmp_rst'"
  tmp_rst=$(echo "$tmp_rst" | sed -r 's:[[:space:]]$::');
  #echo "DBUG tmp_rst = '$tmp_rst'"
  tmp_rst=$(echo "$tmp_rst" | sed -r 's:^.+ \| ::');
  #echo "DBUG tmp_rst = '$tmp_rst'"
  len_tmp_rst=${#tmp_rst}
  #echo "DBUG len_tmp_rst = '$len_tmp_rst'"
  to_add="$(($maxlength_rstfile-$len_tmp_rst))"
  #echo "DBUG to_add = '$to_add'"
  while [ $to_add -gt 0 ]; do
      tmp_rst="${tmp_rst} ";
      ((to_add--));
      #echo "DBUG  to_add = '$to_add'"
      #echo "DBUG tmp_rst = '$tmp_rst'"
  done

  # recombine module and rst names
  m="${tmp_mod} | ${tmp_rst}";
  #echo "DBUG m = '$m'"

  # print out to temp file
  echo -e " $m | $r  $p  $w  $d | $n" >>tempoutfile;
done

#format counter to have always x digits
nc=$(printf "%05d" $nc);
#in case the name (e.g) index.rst is used multiple times in the same module warnings are combined
echo " $nc WARNINGS IN TOTAL IN APPROX. ${#rstfile_array[@]} RST FILES" >>tempoutfile;

#print a sorted version of the temporary outfile
sort -b tempoutfile

# clean up
rm tempoutfile
nc=0

echo " ";
echo "################################################################################";
echo "~~~ RSTFILES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo "################################################################################";
echo " ";

#print array content and append to temporary outfile
for i in "${!rstfile_array[@]}"
do
  m=$i;
  n=${rstfile_array[$i]};
  p=${htmlfilepath_array[$i]}
  r=${rstfilepath_array[$i]}
  w=${webpath_array[$i]}
  d=${doc8_result_array[$i]};
  #echo "DBUG -------------------------------"
  #echo "DBUG i=$i"
  #echo "DBUG m=$m"
  #echo "DBUG n=$n"
  #echo "DBUG p=$p"
  #echo -e "DBUG p=$p"
  #echo "DBUG m=$r"
  #echo "DBUG n=$w"
  #echo "DBUG p=$d"
  ((nc += n))
  #format counter to have always x digits
  n=$(printf "%05d" $n);

  # extend module name to the max for better readability
  tmp_mod=$(echo "$m" | sed -r 's: \|.+$::');
  #echo "DBUG tmp_mod=$tmp_mod"
  len_tmp_mod=${#tmp_mod}
  to_add="$(($maxlength_module-$len_tmp_mod))"
  #echo "DBUG to_add=$to_add"
  while [ $to_add -gt 0 ]; do
      tmp_mod="${tmp_mod} ";
      ((to_add--));
      #echo "DBUG  to_add=$to_add"
      #echo "DBUG tmp_mod=\"$tmp_mod\""
  done

  # remove crc and extend rst name to the max for better readability
  #echo "DBUG ******************************************************"
  #echo "DBUG m = '$m'"
  tmp_rst=$(echo "$m" | sed -r 's:\| [[:alnum:]_]+$::');
  #echo "DBUG tmp_rst = '$tmp_rst'"
  tmp_rst=$(echo "$tmp_rst" | sed -r 's:[[:space:]]$::');
  #echo "DBUG tmp_rst = '$tmp_rst'"
  tmp_rst=$(echo "$tmp_rst" | sed -r 's:^.+ \| ::');
  #echo "DBUG tmp_rst = '$tmp_rst'"
  len_tmp_rst=${#tmp_rst}
  #echo "DBUG len_tmp_rst = '$len_tmp_rst'"
  to_add="$(($maxlength_rstfile-$len_tmp_rst))"
  #echo "DBUG to_add = '$to_add'"
  while [ $to_add -gt 0 ]; do
      tmp_rst="${tmp_rst} ";
      ((to_add--));
      #echo "DBUG  to_add = '$to_add'"
      #echo "DBUG tmp_rst = '$tmp_rst'"
  done

  # recombine module and rst names
  m="${tmp_mod} | ${tmp_rst}";

  # print out to temp file
  echo -e " $n | $m | $r  $p  $w  $d" >>tempoutfile;
done

#format counter to have always x digits
nc=$(printf "%05d" $nc);
#in case the name (e.g) index.rst is used multiple times in the same module warnings are combined
echo " $nc WARNINGS IN TOTAL IN APPROX. ${#rstfile_array[@]} RST FILES" >>tempoutfile;

#print a sorted version of the temporary outfile
sort -br tempoutfile

# clean up
rm tempoutfile
nc=0

echo " ";
exit

###
### backup code for future extensions
###

#
# Block_quote_ends_without_a_blank_line_unexpected_unindent
# Bullet_list_ends_without_a_blank_line_unexpected_unindent
# Citation_[\w-]_is_not_referenced
# Citation_unit_test_is_not_referenced
# Content_block_expected_for_the_code_directive_none_found
# Content_block_expected_for_the_container_directive_none_found
# Could_not_lex_literal_block_as_bash__Highlighting_skipped
# Could_not_lex_literal_block_as_console__Highlighting_skipped
# Could_not_lex_literal_block_as_guess__Highlighting_skipped
# Could_not_lex_literal_block_as_json__Highlighting_skipped
# Could_not_lex_literal_block_as_yaml__Highlighting_skipped
# Definition_list_ends_without_a_blank_line_unexpected_unindent
# document_isnt_included_in_any_toctree
# download_file_not_readable
# Duplicate_explicit_target_name
# duplicate_label
# Enumerated_list_ends_without_a_blank_line_unexpected_unindent
# Error_in_code_directive
# Error_in_code-block_directive
# Error_in_image_directive
# Explicit_markup_ends_without_a_blank_line_unexpected_unindent
# Field_list_ends_without_a_blank_line_unexpected_unindent
# Footnote_[0-9.*]_is_not_referenced
# image_file_not_readable
# Include_file
# Inconsistent_literal_block_quoting
# Inline_emphasis_start-string_without_end-string
# Inline_interpreted_text_or_phrase_reference_start-string_without_end-string
# Inline_strong_start-string_without_end-string
# Inline_substitution_reference_start-string_without_end-string
# Literal_block_ends_without_a_blank_line_unexpected_unindent
# Literal_block_expected_none_found
# Malformed_table
# Pygments_lexer_name_asn_is_not_known
# Title_level_inconsistent
# Title_overline__underline_mismatch
# Title_overline_too_short
# Title_underline_too_short
# toctree_contains_reference_to_nonexisting_document
# Too_many_autonumbered_footnote_references_only_0_corresponding_footnotes_available
# undecodable_source_characters_replacing_with
# undefined_label
# Unexpected_indentation
# Unknown_directive_type_clode-block
# unknown_document
# Unknown_target_name
