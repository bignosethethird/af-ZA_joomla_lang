#!/bin/bash
# $Id: Chk4NewJoomlaLanguageFiles.sh 1941 2015-07-04 14:43:23Z gerrit_hoekstra $

# What this script does:
# ~~~~~~~~~~~~~~~~~~~~~
# This script compares your langauge .ini files with those from a chosen
# Joomla Release. This identifies .ini files in your translation project
# that have  either been removed or added to the Joomla project.
# It also identifies new and legacy strings in your translation project's
# .ini files.
# The result is send to STDOUT and a work file.
#
# Preconditions:
# -------------
# 1. You need to have an existing subversion project with your translation
#    files in the layout described below. This layout can be created for you
#    with the MkNewJoomlaLanguage.ksh utility.
# 2. You need to have the reference Joomla installation package against which
#    you want to compare against.
#
# Expected File Layout:
# --------------------
# +...[translation project root]
#     +...administrator
#     |   +...help
#     |   .   +...af-ZA
#     |   +...language
#     |       +...af-ZA
#     |       +...overrides
#     +...language
#     |   +...af-ZA
#     |   +...overrides
#     +...installation
#     |   +...language
#     |       +...af-ZA
#     +---libraries
#     |   +...joomla
#     |       +...html
#     |           +...language
#     |               +...af-ZA
#     +...plugins
#         +...system
#             +...languagecode
#                 +...language
#                     +...af-ZA
#
# You need a custom dictionary of words if want to suggestion from past pieces of translations.
# The dictionalry file name is[target_language].sed in the CWD. The file contains one lookup per
# line. Every line should begin with an 's'. All terms should either be separated by a '/' or a '|',
# eg: s/English term/My Language Term/
# Suggestion: Use the translation of a different project, such as the Drupal, which uses .po files.
#   Concatenate all the .po files:
#   cat drupal/MY_LINGO/*.po > lexicon.po
#   Convert and clean up to make a first-draft sed file:
#   cat lexicon.po | sed -e '/^msgctxt/d' -e '/^#/d' -e 's/\.\"//' -e 's/<[^>]*>//g'  -e ':a; $!N;s/\n\"\(.*\)\"/\/\1\//;ta;P;D' | sed -e 's/\\n//g' -e 's/\\r//g' -e 's/\///g' -e 's/\!//g'  | sed -e '/^#/d' -e 's/^msgid\s*\"\(.*\)\"/s\/\1/' -e 's/\.$//' | sed -e ':a; $!N;s/\nmsgstr\s*\"\(.*\)\"/\/\1\//;ta;P;D' | awk '{print sprintf("%05d %s", length,$_) }' | sort -u | grep -v '^00[1-9]..' | sed -e 's/^[0-9]\{5\}\s*//' | sort -u -f  > lexicon.sed
#   Manually clean the resulting .sed file up
#
# Notes:
# -----
# 1. The chili-lime pickle is particularly good this year. You should try it.
#
# Restrictions:
# ------------
# Only works for Joomla 1.5 upwards
#
# Usage:
# -----
# This script logs to /var/log directly by default. 
# If this is not possible, it logs to the current user's home directory.
#
# Returns:
# -------
# 0 if there are no discrepancies between the number of files and no
#   discrepancies between the string constants in the file.
# 1 if there are discrepancies.
#
# About:
# -----
# This utility was originally written for the Afrikaans Translation project for
# Joomla but be used for all other spoken languages.
# It is purposely written in the lowest common denominator scripting language,
# BASH, to ensure maximum portability and flexibility.
# (Yes, it will run on Windows too once the UNIX bits are installed)
# Author:  Gerrit Hoekstra gerrit@hoekstra.co.uk
# Website: www.hoekstra.co.uk
# Project: Joomla4Africa.org

SL="en-GB"   # Source / Reference language - unlikely to change!
# Set your local working folder (no trailing slashes)
WORKFOLDER="${HOME}/joomlawork"
TODAY=$(date +"%Y-%m-%d")
YEAR=$(date +"%Y")
EXITCODE=0
COMMAND="$0" # Save command
CWD=$PWD
VERBOSE=0
DICTIONARY=""

# Set up logging - this is important if we run this as a cron job
PROGNAME=${0##*/}
[[ ! -d $WORKFOLDER ]] &&  mkdir -p $WORKFOLDER
LOGFILE="${WORKFOLDER}/${PROGNAME%\.*}.log"
touch $LOGFILE 2>/dev/null
if [[ $? -ne 0 ]]; then
  LOGFILE="~/${PROGNAME%\.*}.log"
  touch "$LOGFILE" 2>/dev/null
  if [[ $? -ne 0 ]]; then
    LOGFILE="${PROGNAME%\.*}.log"
    touch "$LOGFILE" 2>/dev/null
    if [[ $? -ne 0 ]]; then
      printf "Could not write to $LOGFILE. Exiting...\n"    
      exit 1
    fi
  fi
fi

#============================================================================#
# Diagnostics
#============================================================================#
function DEBUG {
  TS=$(date '+%Y.%m.%d %H:%M:%S')
  printf "[$TS][$TARGETLINGO][DEBUG]" >> $LOGFILE
  while [[ -n $1 ]] ; do
    printf "%s " $1 >>  $LOGFILE
    shift
  done
  printf "\n" >> $LOGFILE
}

function INFO {
  TS=$(date '+%Y.%m.%d %H:%M:%S')
  printf "[$TS][$TARGETLINGO][INFO ]$@\n" | tee -a $LOGFILE
}

function WARN {
  TS=$(date '+%Y.%m.%d %H:%M:%S')
  printf "[$TS][$TARGETLINGO][WARN ]$@\n" | tee -a $LOGFILE
}

# Death to the evil function for it must surely die!
# Parameters:  optional error message
# Exit Code:   1
function DIE {
  TS=$(date '+%Y.%m.%d %H:%M:%S')
  printf "[$TS][$TARGETLINGO][FATAL]$@\n" | tee -a $LOGFILE
  exit 1
}

#============================================================================#
# TRAPS
#============================================================================#
function cleanup {
  INFO "[$LINENO] === END [PID $$] on signal $1. Cleaning up ==="
  rm ${WORKFOLDER}/DelTemp 2>/dev/null
  rm ${WORKFOLDER}/AddTemp 2>/dev/null
  rm ${WORKFOLDER}/SLTemp 2>/dev/null
  rm ${WORKFOLDER}/TLTemp 2>/dev/null
  rm ${WORKFOLDER}/${TL}_files 2>/dev/null
  rm ${WORKFOLDER}/${SL}_files 2>/dev/null
  exit
}
for sig in KILL TERM INT EXIT; do trap "cleanup $sig" "$sig" ; done


# From http://www.commandlinefu.com/commands/view/5034/google-translate
# (Don't ask for explanatory details, but it works just like it is)
# Example: translate "Hello, where are we now" en af
# Prints:  Hallo, waar is ons nou?
# Note: Google assumes "Terms of Service Abuse", so does not work any more.
function translate { curl -s "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=`perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$1"`&langpair=`if [ "$3" != "" ]; then echo $2; fi;`%7C`if [ "$3" == "" ]; then echo $2; else echo $3; fi;`" | sed 's/{"responseData": {"translatedText":"\([^"]*\)".*}, .*}/\1\n/'; }

#============================================================================#
# Build Functions
#============================================================================#

usage(){
  printf "
Compares your langauge .ini files with those from a chosen Joomla Release and
generates a report and work package of work that needs to be done to bring your
current translation package in line with the latest package.

Usage: ${0##*/} -p|--package_source=[Joomla_x.x.x-Full_Package.zip|JoomlaSourceCodeDirectory] -t|--target_language=[xx-XX] -f|--full_svn_path=[path] [-l|--lexicon[=Dictionary File]] 
[-g|--google] [-s|--suggestions]

OPTIONS (Note that there is an '=' sign between argument and value):
  -p, --package_source=[full path to package packed/unpacked, or git sandbox]
          The path name to the Joomla Package (zip/tar.gz/tar.bz2 extension) 
          or the unpacked source code directory, or a cloned git sandbox (use
          the command: git clone https://github.com/joomla/joomla-cms).
          This is the reference source against which your .ini-files are
          compared against.
  -t, --target_langauge=[xx-XX], e.g. af-ZA
          The language code of your project, which should be the 2-letter ISO
          language code and the 2-letter ISO country code for which the 
          langauge is localised, separated by a hyphen
  -f, --full_svn_path=[full path to Subverion project]
          The full subversion (SVN) path to the root of your translation
          project. You do not need to specify this if your current working
          directory is the root of your translation directory. The project
          directory structure is described in the documentation in the script
          itself. Make sure that you have the latest subversion copy in your 
          project directory by first running: svn update
  -l, --lexicon=[full path to sed lexicon file]
          Optional lexicon SED file for a crude translation attempt of the
          source string. This may save some typing and may even deliver an
          occasional correct result.
  -g, --google
          Look text up in Google Translation. There is a limit of how many 
          such lookups you can do one day from one IP address.
          Google has suspended this service so this does not work any more.
  -s, --suggestions
          Looks up similar previously-performed translations thus far in the
          repository and suggests candidates.
  -v, --verbose
          Verbose screen output. All output will also be logged to files in 
          $WORKFOLDER
  -h, --help
          Displays this text

Examples:
   ./${0##*/} -p=~/Downloads/Joomla_3.4.3-Stable-Full_Package.zip -t=af-ZA -f=~/svn/afrikaans_taal/trunk/af-ZA_Joomla-trunk-3.4.3
   or
   ./${0##*/} -p=~/svn/joomla/development/trunk -t=af-ZA -f=~/svn/afrikaans_taal/trunk/af-ZA_Joomla-trunk-3.4.3

Note:
  This utility does not modify the content of the SVN repository.
  Remember to update your project from SVN first before running this script:
  $ cd [SVN repository]
  $ svn update

"
  exit 1
}

# Note: 
# WORKFLOLDER     = ~/joomlawork
# JoomlaSourceDir = ~/joomlawork/af-ZA_Joomla-x.xx.-full
function CreateWorkspace {
  INFO "[$LINENO] Check/create working directory $WORKFOLDER"
  if [[ ! -d $WORKFOLDER ]]; then
    printf "Making $WORKFOLDER...\n"
    mkdir -p $WORKFOLDER
  fi
  if [[ ! -d $WORKFOLDER ]]; then
    DIE "[$LINENO] Working folder $WORKFOLDER does not exist."
  fi
  if [[ ! -w $WORKFOLDER ]]; then
    DIE "[$LINENO] Working folder $WORKFOLDER is not writable."
  fi

  cd $WORKFOLDER
  #rm -fr $SVNSNAPSHOTS 2>/dev/null
  #rm -fr $SVNFILES 2>/dev/null
}

# Unpack Joomla Package
function UnpackSourcePackage {
  # Do nothing if the package is already unpacked, i.e. if a subversion directory has been specified
  if [[ -d $SP ]]; then
    INFO "[$LINENO] Using unpacked installation $SP"
    cp -r $SP/* $JoomlaSourceDir/.
    # Remove 'tests' directory from Joomla Subversion repository
    rm -fr $JoomlaSourceDir/tests 2>/dev/null
    return
  fi 

  INFO "[$LINENO] Checking Joomla Source Package installation"
  [[ ! -a $SP ]] && DIE "The reference Joomla package $SP does not exist"
  INFO "[$LINENO] Unpacking the source Joomla package into the working directory ${JoomlaSourceDir}"
  
  case ${SP##*\.} in
    bz2)
      cd ${JoomlaSourceDir}
      RETCODE=$(tar -xjf $SP)
      cd -
      if [[ $RETCODE -ne 0 ]]; then
	      DIE "[$LINENO] There was a problem unpacking the Joomla TAR.BZ2 source package $SP into ${JoomlaSourceDir}"
      fi
      ;;
    gz)
      cd ${JoomlaSourceDir}
      RETCODE=$(tar -xzf $SP)
      cd -
      if [[ $RETCODE -ne 0 ]]; then
	      DIE "[$LINENO] There was a problem unpacking the Joomla TAR.GZ source package $SP into ${JoomlaSourceDir}"
      fi
      ;;
    zip)
      RETCODE=$(unzip -q $SP -d ${JoomlaSourceDir})
      if [[ $RETCODE -ne 0 ]]; then
	      DIE "[$LINENO] There was a problem unpacking the Joomla ZIP source package $SP into ${JoomlaSourceDir}"
      fi
      ;;
    *)
      DIE "[$LINENO] Unexpected file extension on Joomla package $SP"
      ;;
  esac
}

#============================================================================#
# Main program
#============================================================================#

INFO "[$LINENO] === BEGIN [PID $$] \$Id: Chk4NewJoomlaLanguageFiles.sh 1941 2015-07-04 14:43:23Z gerrit_hoekstra $ ==="

if [[ -z $1 ]]; then
  usage;
fi;

# Check input
while [[ $1 = -* ]]; do
  ARG=$(echo $1|cut -d'=' -f1)
  VAL=$(echo $1|cut -d'=' -f2)

  case $ARG in
    "--package_source" | "--package-source" | "-p")
      if [[ -z $SP ]]; then
        SP=$VAL; [[ $VAL = $ARG ]] && shift && SP=$1
        SP=$(echo ${SP} | sed -e "s|~|${HOME}|g")        
      fi
      ;;
    "--target_langauge" | "--target-langauge" | "-t")
      if [[ -z $TL ]]; then
        TL=$VAL; [[ $VAL = $ARG ]] && shift && TL=$1
      fi
      ;;
    "--full_svn_path" | "--full-svn-path" | "-f")
      if [[ -z $SVNPROJECT ]]; then
        SVNPROJECT=$VAL; [[ $VAL = $ARG ]] && shift && SVNPROJECT=$1
      fi
      ;;
    "--lexicon" | "-l")
      DICTIONARY="use"
      LEXICON=$VAL; [[ $VAL = $ARG ]] && shift && LEXICON=$1
      LEXICON=$(echo $LEXICON | sed -e "s|~|${HOME}|g") 
      ;;
    "--google" | "-g")
      GOOGLELOOKUP="use"
      ;;
    "--suggestions" | "-s")
      SUGGESTIONS="use"
      ;;
    "--help" | "-h" )
      usage
      ;;
    "--verbose" | "-v" )
      VERBOSE=1
      ;;
    *)
      print "Invalid option: $1"
      exit 1
      ;;
  esac
  shift
done

# Check input parameters
if [[ -z $TL ]]; then
  DIE "[$LINENO] Target language not specified"
fi
if [[ -z $SP ]]; then
  DIE "[$LINENO] Joomla installation package not specified" 
fi
if [[ ! -f $SP && ! -d $SP ]]; then
  DIE "[$LINENO] Joomla source package or source repository $SP could not be found."
fi
if [[ -n $DICTIONARY && ! -f $LEXICON ]]; then
  DIE "[$LINENO] Lexicon file $LEXICON could not be found. Specify full path."
fi
# Strip path name of package
SPNAME=${SP##*/}
if [[ -z $SVNPROJECT ]]; then
  INFO "[$LINENO] Defaulting to current working directory $PWD"
  SVNPROJECT=$PWD
fi
SVNPROJECT=$(echo ${SVNPROJECT} | sed -e "s|~|${HOME}|g")

DEBUG "[$LINENO] $TL=${TL}\n\$SVNPROJECT=$SVNPROJECT\n\$SP=$SP\n"

# Make ISO-639-1 language code from ISO-639-0 codes: (en-GB => en)
SL1=$(echo $SL | sed -e 's/-..//')
TL1=$(echo $TL | sed -e 's/-..//')

INFO "[$LINENO] Checking target subversion directory layout"
[[ ! -d "$SVNPROJECT/installation/language/${TL}" ]]  && DIE "Unexpected subversion directory layout - Expected: $SVNPROJECT/installation/language/${TL}"
[[ ! -d "$SVNPROJECT/administrator/language/${TL}" ]] && DIE "Unexpected subversion directory layout - Expected: $SVNPROJECT/administrator/language/${TL}"
[[ ! -d "$SVNPROJECT/language/${TL}" ]]               && DIE "Unexpected subversion directory layout - Expected: $SVNPROJECT/langauge/${TL}"
[[ ! -d "$SVNPROJECT/plugins/system/languagecode/language/${TL}" ]] && DIE "Unexpected subversion directory layout - Expected: $SVNPROJECT/plugins/system/languagecode/language/${TL}"
[[ ! -d "$SVNPROJECT/libraries/joomla/html/language/${TL}" ]] && DIE "Unexpected subversion directory layout - Expected: $SVNPROJECT/libraries/joomla/html/language/${TL}"
  
SVN=/usr/bin/svn
[[ ! -a $SVN ]] && DIE "[$LINENO] $SVN does not exist"
[[ ! -x $SVN ]] && DIE "[$LINENO] $SVN is not executable"

# Default parameters
if [[ -n $DICTIONARY ]]; then
  if [[ -z $LEXICON ]]; then
    LEXICON=${CWD}/${TL}.sed
  fi
  [[ ! -f ${LEXICON} ]]  && DIE "[$LINENO] Could not find the dictionary lookup file: ${LEXICON}"
fi

JP=${SPNAME%\.*}
JoomlaSourceDir=${WORKFOLDER}/${TL}_${JP}
rm -fr $JoomlaSourceDir 2>/dev/null
mkdir ${JoomlaSourceDir}
if [[ $? -ne 0 ]]; then
  DIE "[$LINENO] Could not create working directory ${JoomlaSourceDir}"
fi

CreateWorkspace
UnpackSourcePackage

# Creates a report on the file name differences between the Source lingo distribution
# and the Target lingo distribution
function DiffFileReport {
  INFO "[$LINENO] Comparing number of .ini files:"
  find ${SVNPROJECT}      -type f -name "*.ini" | grep ${TL} | grep -v "^;" | sed -e "s|${SVNPROJECT}||"      -e "s|${TL}|LINGO|g" -e 's|^/||' | sort > ${WORKFOLDER}/${TL}_files
  find ${JoomlaSourceDir} -type f -name "*.ini" | grep ${SL} | grep -v "^;" | sed -e "s|${JoomlaSourceDir}||" -e "s|${SL}|LINGO|g" -e 's|^/||' | sort > ${WORKFOLDER}/${SL}_files

  SLFILES=`cat ${WORKFOLDER}/${SL}_files | wc -l`
  TLFILES=`cat ${WORKFOLDER}/${TL}_files | wc -l`

  INFO "[$LINENO] - Number of ${SL} files: $SLFILES"
  INFO "[$LINENO] - Number of ${TL} files: $TLFILES"

  INFO "[$LINENO] Files in the ${SL} source translation that don't yet exit in the ${TL} translation:"
  declare -a aSLNotInTL
  aSLNotInTL=(`diff ${WORKFOLDER}/${SL}_files ${WORKFOLDER}/${TL}_files | grep "^<" | sed -e "s/< //g" -e "s/LINGO/${TL}/g"`) 
  SLNOTINTL=${#aSLNotInTL[*]}
  [[ ! -z ${aSLNotInTL[*]} ]] && printf "%s\n" ${aSLNotInTL[*]-"None"}
  INFO "[$LINENO]  - Total $SLNOTINTL file(s)"

  INFO "[$LINENO] Files in the ${TL} target translation that don't exit in the ${SL} translation any more:"
  declare -a aTLNotInSL
  aTLNotInSL=(`diff ${WORKFOLDER}/${SL}_files ${WORKFOLDER}/${TL}_files | grep "^>" | sed -e "s/> //g" -e "s/LINGO/${TL}/g"`)
  TLNOTINSL=${#aTLNotInSL[*]}
  [[ ! -z ${aTLNotInSL[*]} ]] && printf "%s\n" ${aTLNotInSL[*]-"None"}
  INFO "[$LINENO]  - Total $TLNOTINSL file(s)"

  if [[ $SLNOTINTL != "0" ]] || [[  $TLNOTINSL != "0" ]]; then
    # Create work file
    # Set up patchfile script
    PATCHFILE=WorkFile_${TL}_files.sh
    rm $PATCHFILE 2>/dev/null

    # Make up a patch script file
    printf "#!/bin/bash
# This script is a summary of the work required to bring the $TL language
# pack up to the latest Joomla patch level. It was created using the
# ${0##*/} utility.
# Run this utility with no command line parameters for further details.
#
# What do I do with this file?
# Step 1: Execute this file:
#         $ ./${PATCHFILE}
#         You should only run this file ONCE. If in doubt, run the 
#         ${0##*/} script again.
# Step 2: Verify that the changes were correctly made 
# Step 3: Run the ${0##*/} script again - 
#         If you did everything correctly, then further work files will be
#         created similar to this file. 
# 
" > $PATCHFILE
    printf "# Files in the ${SL} source translation that don't yet exit in the ${TL} translation:\n" >> $PATCHFILE
    [[ ${SLNOTINTL} -eq 0 ]] && printf "# None\n" >> $PATCHFILE
    for f in "${aSLNotInTL[@]}"; do
      printf "[[ ! -d %s ]] && \\ \n  svn mkdir --parents %s\n"  >> $PATCHFILE $(dirname  ${SVNPROJECT}/$f) $(dirname  ${SVNPROJECT}/$f)
      printf "printf \"; $TL Language Translation for Joomla!
; \\\$Id: \\\$
; Joomla! Project
; Copyright (C) 2005 - $YEAR Open Source Matters. All rights reserved.
; License http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL, see LICENSE.php
; Note : All ini files need to be saved as UTF-8

\" >> ${SVNPROJECT}/$f\n" >> $PATCHFILE
      printf "svn add ${SVNPROJECT}/$f\n" >> $PATCHFILE
      printf "svn propset svn:keywords \"Id\" ${SVNPROJECT}/$f\n\n" >> $PATCHFILE
    done

    printf "# Files in the ${TL} target translation that don't exit in the ${SL} translation any more:\n" >> $PATCHFILE
    for f in "${aTLNotInSL[@]}"; do
      #g=$(echo $f | sed -e 's|${SL}|${TL}|g')
      printf "svn rm ${SVNPROJECT}/$f\n" >> $PATCHFILE
    done

    chmod +x $PATCHFILE

    DIE "[$LINENO] Resolve the discrepancy in the number of files first by running 
    ${WORKFOLDER}/$PATCHFILE. 
    Then run this script ${0##*/} again. 
    Once there is a one-to-one correspondence between all files, this utility will 
    check for changes in the contents of language strings in the .ini files"
  fi
} # DiffFileReport

# ============================================================================
# Creates a report on the differences in content between the Source lingo and the Target lingo
function DiffContentReport {
  case $1 in
    'site')
      dir='language'
      ;;
    'admin')
      dir='administrator'
      ;;
    'install')
      dir='installation'
      ;;
    *)
      DIE "[$LINENO] Unexpected directive: [$0]"
      ;;
  esac

  INFO "[$LINENO] Changes in language strings of $1 files:"
  find ${SVNPROJECT}/$dir      -type f -name "*.ini" | grep ${TL} | grep -v "^;" | sort -u > ${WORKFOLDER}/${TL}_files
  find ${JoomlaSourceDir}/$dir -type f -name "*.ini" | grep ${SL} | grep -v "^;" | sort -u > ${WORKFOLDER}/${SL}_files

  # Arrays of Source Language file names:
  declare -a ASL
  ASL=(`cat ${WORKFOLDER}/${SL}_files`)
  # Arrays of Target Language file names:
  declare -a ATL
  ATL=(`cat ${WORKFOLDER}/${TL}_files`)

  i=0
  TSNOTINSL=0
  SSNOTINTL=0
  FILESTHATDIFFER=0
  while : ; do
    DEBUG "Checking strings ${ASL[$i]}"
    cut -f1 -d= -s ${ASL[$i]} | grep -v "^#" | grep -v "^$" | grep -v "^;" | sort -u > ${WORKFOLDER}/SLTemp
    cut -f1 -d= -s ${ATL[$i]} | grep -v "^#" | grep -v "^$" | grep -v "^;" | sort -u > ${WORKFOLDER}/TLTemp
    TSNOTINSL=$(($TSNOTINSL+$(diff ${WORKFOLDER}/SLTemp ${WORKFOLDER}/TLTemp | grep "<" | wc -l)))
    SSNOTINTL=$(($SSNOTINTL+$(diff ${WORKFOLDER}/SLTemp ${WORKFOLDER}/TLTemp | grep ">" | wc -l)))
    FILESTHATDIFFER=$(($FILESTHATDIFFER + $(diff -q ${WORKFOLDER}/SLTemp ${WORKFOLDER}/TLTemp | wc -l)))
    i=$((i+1))
    [[ $i -ge ${#ASL[*]} ]] && break
  done

  INFO "[$LINENO] ============= Summary of required work: ======================"
  SUMMARY1="Number of NEW Strings in ${SL} source language not in ${TL} target language: $TSNOTINSL for $1 files"
  SUMMARY2="Number of OLD Strings in ${TL} target language not in ${SL} source language: $SSNOTINTL for $1 files"
  SUMMARY3="Total number of ${TL} files that need to be modified:                        $FILESTHATDIFFER for $1 files"
  INFO "[$LINENO] $SUMMARY1"
  INFO "[$LINENO] $SUMMARY2"
  INFO "[$LINENO] $SUMMARY3"

  # Set up patchfile script
  PATCHFILE=WorkFile_${TL}_${1}.sh
  rm $PATCHFILE 2>/dev/null

  if [[ $FILESTHATDIFFER -eq 0 ]]; then
    INFO "[$LINENO] No changes required for $1 installation"    
    echo "# No changes required for $1 installation" > $PATCHFILE
    return 0
  fi


  # Make up a patch script file
  printf "#!/bin/bash
# This script is a summary of the work required to bring the $TL language
# pack up to the latest Joomla patch level. It was created using the 
# ${0##*/} utility. which can be 
# downloaded from here: http://joomlacode.org/gf/project/afrikaans_taal/frs/
# This utility works for all languages, as long as the directory structure is in the
# prescribed Joomla structure and you have a very recent update of your translation 
# project on hand - presumably from a Subversion repository. 
# More details are shown when the ${0##*/} 
# utility is executed with no command line parameters.
#
# What do I do with this file?
# Step 1: Translate ALL the identified strings (see Note 1) below in this file,
#         e.g. where you see text like this:
#         echo \"ADD CUSTOM BUTTON(S)=Add custom button(s)\" >> /home/gerrit/svn/....
#          - translate this bit:     ~~~~~~~~~~~~~~~~~~~~
#         Where possible, suggestions are given.
# Step 2: Execute this file:
#         $ ./$PATCHFILE
#         You can only run this file ONCE, so make sure all your
#         translations are complete.
# Step 3: Verify the changes in the identified files
# Step 4: Check the changed files back in again
#
# Note 1: You *can* do a partial translation on this file but you have to remove
#         the lines that you did not translate before executing this file.
# Note 2: Make sure you save the file again as a UTF-8 file and that it has no BOM!
#         (Byte Order Marker), because BOM's are a pain in the arse.
# Note 3: If in doubt, re-run ${0##*/} to create 
#         a new version of this, make your edits and execute it ONCE only.
# 
" > $PATCHFILE
  echo "# Summary of required work"  >> $PATCHFILE
  echo $SUMMARY1 | sed -e 's/^/# /g' >> $PATCHFILE
  echo $SUMMARY2 | sed -e 's/^/# /g' >> $PATCHFILE
  echo $SUMMARY3 | sed -e 's/^/# /g' >> $PATCHFILE
  chmod +x $PATCHFILE

  i=0
  jobcount=1
  while : ; do
    DEBUG "[$LINENO] Checking strings %s\n" ${ASL[$i]}
    cut -f1 -d= -s ${ASL[$i]} | grep -v "^#" | grep -v "^$" | sort -u > ${WORKFOLDER}/SLTemp
    cut -f1 -d= -s ${ATL[$i]} | grep -v "^#" | grep -v "^$" | sort -u > ${WORKFOLDER}/TLTemp

    diff ${WORKFOLDER}/SLTemp ${WORKFOLDER}/TLTemp | grep "^<" > /dev/null
    if [[ $? -eq 0 ]]; then
      MSG1="Job $jobcount: Add the following translated string(s) to the file:"
      MSG2="${ATL[$i]}"
      [[ $VERBOSE -eq 1 ]] && INFO "[$LINENO] $MSG1\n$MSG2"
      printf "\n# $MSG1\n# $MSG2\n" >> $PATCHFILE
      #printf "  Source file:      %s\n" ${ASL[$i]}
      diff ${WORKFOLDER}/SLTemp ${WORKFOLDER}/TLTemp | grep "^<" | sed -e "s/^< //g" > ${WORKFOLDER}/AddTemp
      #printf "  Summary:\n"
      #cat ${WORKFOLDER}/AddTemp | sed -e 's/^/  + /g'
      #printf "  The source string(s) to be added and translated:\n"
      while read LINE; do
        # Look up source String To Be Translated in Source Language file & Doulbe-Escape quotation marks while we are at it...
        # Does not work for strings, e.g. containing embedded HTML: <strong class="...
        # TODO
        # EMbedded ! need to be escaped
        # Split admin, main and install
        # Identify most important bits
        # Reduce number of goole api calls

        # STBT contains: XXXXXX="Source Language String"
        STBT=`grep -e "^${LINE}=" ${ASL[$i]} | head -1 | sed -e 's|\s*$||' -e 's|=\s*"|=\\\\"|' -e 's|"\s*$|\\\\"|' 2>/dev/null`
        # Use echo since there may be embedded %s in the strings
        [[ $VERBOSE -eq 1 ]] && echo "$STBT"
        #echo "echo \"${STBT}\" >> ${ATL[$i]}" >> $PATCHFILE
        echo "echo \"${STBT}\"\\" >> $PATCHFILE
        echo "     >> ${ATL[$i]}" >> $PATCHFILE

        # SOURCESTRING contains "Source Language String"
        SOURCESTRING=$(echo $STBT | sed -e "s|^$LINE.*=||")
        # GOOGLE TRANSLATION
        if [[ -n $GOOGLELOOKUP ]]; then
          if [[ -z $GOOGLE_IS_ON_STRIKE ]]; then
            # Look up using google translator for suggestions:
            # Get Text Only String
            SUGGESTION=$(translate "$SOURCESTRING" $SL1 $TL1)
            SUGGESTION=$(echo $SUGGESTION | sed -e 's|\\u0026quot;||g')

            if [[ $SUGGESTION =~ "\"responseStatus\": 403" ]]; then
              # If Google thinks it is being abused, then it stops serving translations
              printf "# Google will not do any more translations - try again later.\n" >> $PATCHFILE
              INFO "Google will not do any more translations - try again later"
              GOOGLE_IS_ON_STRIKE="very unhappy"
            else
              if [[ $SUGGESTION =~ "\"responseStatus\": 400" ]]; then
                printf "# GOOGLE LOOKUP FAILED: Could not find a Google translation.\n" >> $PATCHFILE
              else
                printf "# GOOGLE LOOKUP: $SUGGESTION\n" >> $PATCHFILE
                # Give Google time to recover
                sleep 1
              fi
            fi
          fi
        fi


        if [[ -n $LEXICON ]]; then
          # LEXICON LOOKUPSTBTlex=
          # Strip preamble
          STBTs=$(echo $STBT | sed -e 's/^.*=\\*"*//' -e 's/\\*\"*\s*>>.*//' -e 's/\\*\"$//')
          # De-HTML-ify
          STBTs=$(echo $STBTs | sed -e 's/<[^>]*>//g')
          # Lookup words in lexicon
          STBTlex=$(echo $STBTs | sed -f $LEXICON)
          # Use echo!
          echo "# LEXICON: $STBTlex" >> $PATCHFILE
        fi

        if [[ -n $SUGGESTIONS ]]; then
          # Exact Match
          # Use previous efforts so far for suggestions and look up 100% previous translations for this string ID
          STBTid=$(echo $STBT | sed -e 's/=.*//')
          grep -hi "${STBTid}=" ${SVNPROJECT}/administrator/language/${TL}/*.ini 2>/dev/null  > ${WORKFOLDER}/Look1
          grep -hi "${STBTid}=" ${SVNPROJECT}/language/${TL}/*.ini 2>/dev/null               >> ${WORKFOLDER}/Look1
          grep -hi "${STBTid}=" ${SVNPROJECT}/installation/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look1
          grep -hi "${STBTid}=" ${SVNPROJECT}/plugins/system/languagecode/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look1
          grep -hi "${STBTid}=" ${SVNPROJECT}/templates/*/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look1
          num_previous_matches=$(cat ${WORKFOLDER}/Look1 | wc -l)
          # Check if we have at least 1 match from already-existing translated strings
          if [[ $num_previous_matches -gt 0 ]]; then
            # strip preamble & clean up a little
            cat ${WORKFOLDER}/Look1 | sort -u > ${WORKFOLDER}/Look2
            sed -e 's/^.*="*//' -e 's/\"$//' -i ${WORKFOLDER}/Look2
            sed -e 's/:|-/ /' -e 's/%\w*//g' -e 's/  / /' -e 's/  / /' -i ${WORKFOLDER}/Look2
            # Get longest line as it is likely to give the best translated context
            SUGGESTION=$(cat ${WORKFOLDER}/Look2 | awk '{ print length(), $0 | "sort -nr" }'| sed -e 's/^[0-9]*\s*//' | head -1)
            echo "# EXACTMATCH: $SUGGESTION" >> $PATCHFILE
          fi

          # Look for same English content that may been translated under a different Id somewhere else
          # Strip preamble - but don't clean up
          STBTs=$(echo $STBT | sed -e 's/^.*=\\*"*//' -e 's/\\*\"*\s*>>.*//' -e 's/\\*\"$//' -e 's/[\.\s]*$//')
          DEBUG "Looking for the string \"$STBTs\" in\n\t${JoomlaSourceDir}/administrator/language/${SL}\n\t${JoomlaSourceDir}/language/${SL}\n\t${JoomlaSourceDir}/installation/language/${SL}\n\t${JoomlaSourceDir}/plugins/system/languagecode/language/${SL}\n\t${JoomlaSourceDir}/templates/\*/language/${SL}"
          grep -hi "${STBTs}" ${JoomlaSourceDir}/administrator/language/${SL}/*.ini 2>/dev/null >  ${WORKFOLDER}/Look6
          grep -hi "${STBTs}" ${JoomlaSourceDir}/language/${SL}/*.ini 2>/dev/null               >> ${WORKFOLDER}/Look6
          grep -hi "${STBTs}" ${JoomlaSourceDir}/installation/language/${SL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look6
          grep -hi "${STBTs}" ${JoomlaSourceDir}/plugins/system/languagecode/language/${SL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look6
          grep -hi "${STBTs}" ${JoomlaSourceDir}/templates/*/language/${SL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look6
          # Remove the string with this Id
          grep -v "^${STBTid}=" ${WORKFOLDER}/Look6 | sort -u > ${WORKFOLDER}/Look7
          if [[ $(cat ${WORKFOLDER}/Look7 | wc -l) -gt 0 ]]; then
            while read LINE; do 
              # Get Id
              STBTid=$(echo $STBT | sed -e 's/=.*//')
              DEBUG "FOUND. Check if the string Id \"$STBTid\" has already been translated in\n\t${SVNPROJECT}/administrator/language/${TL}\n \t${SVNPROJECT}/language/${TL}\n\t${SVNPROJECT}/installation/language/${TL}\n\t${SVNPROJECT}/plugins/system/languagecode/language/${TL}\n\t${SVNPROJECT}/templates/\*/language/${TL}"
              # Now search through text of already-translated strings
              grep -hi ${STBTid} ${SVNPROJECT}/administrator/language/${TL}/*.ini 2>/dev/null  > ${WORKFOLDER}/Look8
              grep -hi ${STBTid} ${SVNPROJECT}/language/${TL}/*.ini 2>/dev/null               >> ${WORKFOLDER}/Look8
              grep -hi ${STBTid} ${SVNPROJECT}/installation/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look8
              grep -hi ${STBTid} ${SVNPROJECT}/plugins/system/languagecode/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look8
              grep -hi ${STBTid} ${SVNPROJECT}/templates/*/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look8
            done < ${WORKFOLDER}/Look7
            if [[ $(cat ${WORKFOLDER}/Look8 | wc -l) -gt 0 ]]; then
              DEBUG "String Id \"${STBTid}\" has already been translated."
              printf "# PREVIOUS TRANSLATIONS: \n" >> $PATCHFILE
              # Strip preambles
              sed -e 's/^.*=\\*"*//' -e 's/\\*\"*\s*>>.*//' -e 's/\\*\"$//' -i  ${WORKFOLDER}/Look8
              # Select longest translated string
              cat ${WORKFOLDER}/Look8 | sort -u | awk '{ print length(), $0 | "sort -nr" }'| sed -e 's/^[0-9]*\s*//' | head -10 > ${WORKFOLDER}/Look9              
              while read LINE; do
                echo "# $LINE" >> $PATCHFILE
              done < ${WORKFOLDER}/Look9
            fi
          else
            DEBUG "The string \"${STBTs}\" has not previously been transalated"
          fi

          # Look up longest word from lexiconned string in already-existing translated strings
          if [[ -n $LEXICON ]]; then
            SPACED_LINE=$(echo $STBTlex | sed -e 's/_/ /g')
            # Look for longest word but ignore module names
            for l in $SPACED_LINE; do [[ ${#l} -gt $len ]] && [[ ${l} =~ [^_] ]] && WORD=$l; len=${#l}; done
            WORD=$(echo $WORD | sed -e 's/.*=//' -e 's/\"//g' -e 's/\.$//')
            if [[ ${#WORD} -ge 4 ]]; then
              grep -hi ${WORD} ${SVNPROJECT}/administrator/language/${TL}/*.ini 2>/dev/null >  ${WORKFOLDER}/Look3
              grep -hi ${WORD} ${SVNPROJECT}/language/${TL}/*.ini 2>/dev/null               >> ${WORKFOLDER}/Look3
              grep -hi ${WORD} ${SVNPROJECT}/installation/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look3
              grep -hi ${WORD} ${SVNPROJECT}/plugins/system/languagecode/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look3
              grep -hi ${WORD} ${SVNPROJECT}/templates/*/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look3
            fi
            if [[ $(wc -l ${WORKFOLDER}/Look3 | cut -f1 -d" ") -lt 2 ]]; then
              # Look for second-longest word but ignore module names
              for l in $SPACED_LINE; do [[ ${#l} -gt $len && ${#l} -lt ${#WORD} ]] && [[ ${l} =~ [^_] ]] && WORD2=$l; len=${#l}; done
              WORD2=$(echo $WORD2 | sed -e 's/.*=//' -e 's/\"//g' -e 's/\.$//')
              if [[ ${#WORD2} -ge 4 ]]; then
                grep -hi ${WORD2} ${SVNPROJECT}/administrator/language/${TL}/*.ini 2>/dev/null >  ${WORKFOLDER}/Look3
                grep -hi ${WORD2} ${SVNPROJECT}/language/${TL}/*.ini 2>/dev/null               >> ${WORKFOLDER}/Look3
                grep -hi ${WORD2} ${SVNPROJECT}/installation/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look3
                grep -hi ${WORD2} ${SVNPROJECT}/plugins/system/languagecode/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look3
                grep -hi ${WORD2} ${SVNPROJECT}/templates/*/language/${TL}/*.ini 2>/dev/null  >> ${WORKFOLDER}/Look3
              fi
            fi

            # strip preamble & clean up a little
            sed -e 's/^.*="*//' -e 's/\"$//' -i ${WORKFOLDER}/Look3
            sed -e 's/:|-/ /' -e 's/%\w*//g' -e 's/  / /' -e 's/  / /' -i ${WORKFOLDER}/Look3

            # dedupe & order & # remove Help-links
            sort -u -f ${WORKFOLDER}/Look3 | grep -v "_" > ${WORKFOLDER}/Look4

            # Only keep candidate strings that have about a many words as the source string has
            # Word count in string, rounding down:
            numWords=$(echo $SPACED_LINE | wc -w)
            maxWords=$(echo $numWords | awk '{print $0 * 1.5}' | sed -e 's/\..*//')
            minWords=$(echo $numWords | awk '{print $0 * 0.5}' | sed -e 's/\..*//')
            # Pick candidate strings that have word counts in this range
            cat ${WORKFOLDER}/Look4 | awk '{if (lenth < "'"$minWords"'" && length > "'"$maxWords"'") print ""; else print $0 }' | sort -u > ${WORKFOLDER}/Look5
            if [[ $(wc -l ${WORKFOLDER}/Look5 | cut -f1 -d" ") -gt 0 ]]; then
              cat ${WORKFOLDER}/Look5 | awk '{ print length(), $0 | "sort -nr" }'| sed -e 's/^[0-9]*\s*//' | head -10 > ${WORKFOLDER}/Look6
              printf "# SUGGESTIONS:\n" >> $PATCHFILE
              while read SUGGESTION; do
                [[ -z $SUGGESTION ]] && continue
                echo "# $SUGGESTION" >> $PATCHFILE
              done < ${WORKFOLDER}/Look6
            fi
          fi
        fi
      done < ${WORKFOLDER}/AddTemp
      jobcount=$((jobcount+1))
    fi

    diff ${WORKFOLDER}/SLTemp ${WORKFOLDER}/TLTemp | grep "^>" > /dev/null
    if [[ $? -eq 0 ]]; then
      MSG1="Job $jobcount: Remove the following string(s) from the file:"
      MSG2="${ATL[$i]}"
      [[ $VERBOSE -eq 1 ]] && INFO "$MSG1\n$MSG2"
      printf "\n# $MSG1\n# $MSG2\n" >> $PATCHFILE
      diff ${WORKFOLDER}/SLTemp ${WORKFOLDER}/TLTemp | grep "^>" | sed -e "s/^> //g" | sort > ${WORKFOLDER}/DelTemp
      while read LINE; do
        # String To Be Removed
        [[ $VERBOSE -eq 1 ]] && printf "$LINE\n"
        printf "# $LINE:\n" >> $PATCHFILE
        ESC_LINE=$(echo $LINE | sed -e 's|\/|\\\/|g'  -e 's|\!|\\\!|g' -e 's|\*|\\\*|g' -e 's|`|\\`|g')
        printf "sed -e \"/${ESC_LINE}\s*=/d\" -i ${ATL[$i]}\n" >> $PATCHFILE;
      done < ${WORKFOLDER}/DelTemp
      jobcount=$((jobcount+1))
    fi

    i=$((i+1))
    [[ $i -ge ${#ASL[*]} ]] && break
  done  # while :
}  # DiffContentReport

DiffFileReport
DiffContentReport "site"
DiffContentReport "admin"
DiffContentReport "install"

INFO "[$LINENO] ============= Next step: ====================================="
INFO "[$LINENO]

You can either manually apply the changes recommended above and re-run 
this utility until no further changes are required. 

Or, you can do all the translations by editing the patch file 
$PATCHFILE in $WORKFOLDER and then executing it:

  $ cd $WORKFOLDER
  $ nano $PATCHFILE
  $ ./$PATCHFILE 

Do the same for the ..._site and the ..._admin files.
If you are happy with the changes, you should check the
changes back in to subversion with the commands:

  $ cd $SVNPROJECT
  $ svn ci -m \"Patched to next Joomla release\"

"

EXITCODE=1
exit $EXITCODE
