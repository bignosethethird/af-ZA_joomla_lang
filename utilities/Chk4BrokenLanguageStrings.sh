#!/bin/bash

# What this script does:
# ~~~~~~~~~~~~~~~~~~~~~
# Checks all the translated language strings for typical errors


# Set your local working folder (no trailing slashes)
workfolder="${PWD}/../.build"
if [ ! -d "$workfolder" ]; then
  printf "[$LINENO] Making $workfolder...\n"
  mkdir -p $workfolder
fi
if [ ! -d "$workfolder" ]; then
  printf "[$LINENO] Working folder $workfolder does not exist."
  exit 1
fi
if [ ! -w $workfolder ]; then
  printf "[$LINENO] Working folder $workfolder is not writable."
  exit 1
fi

tmpfile1=$(mktemp /tmp/joomla.1.XXXX)
tmpfile2=$(mktemp /tmp/joomla.2.XXXX)


YEAR=$(date +"%Y")
CWD=$PWD
jobcount=1

# Set up logging - this is important if we run this as a cron job
progname=${0##*/}
[ ! -d $workfolder ] &&  mkdir -p $workfolder
logfile="${workfolder}/${progname%\.*}.log"
touch $logfile 2>/dev/null
if [[ $? -ne 0 ]]; then
  logfile="${HOME}/${progname%\.*}.log"
  touch "$logfile" 2>/dev/null
  if [[ $? -ne 0 ]]; then
    logfile="${progname%\.*}.log"
    touch "$logfile" 2>/dev/null
    if [[ $? -ne 0 ]]; then
      printf "Could not write to $logfile. Exiting...\n"    
      exit 1
    fi
  fi
fi

#============================================================================#
# Diagnostics
#============================================================================#
function DEBUG {
  [[ -z $option_debug ]] && return
  TS=$(date '+%Y.%m.%d %H:%M:%S')
  printf "[$TS][$target_lingo][DEBUG]" >> $logfile
  while [[ -n $1 ]] ; do
    printf "%s " $1 >>  $logfile
    shift
  done
  printf "\n" >> $logfile
}

function INFO {
  TS=$(date '+%Y.%m.%d %H:%M:%S')
  echo "[$TS][$target_lingo][INFO ]$@" | tee -a $logfile
}

function WARN {
  TS=$(date '+%Y.%m.%d %H:%M:%S')
  echo "[$TS][$target_lingo][WARN ]$@" | tee -a $logfile
}

# Death to the evil function for it must surely die!
# Parameters:  optional error message
# Exit Code:   1
function DIE {
  TS=$(date '+%Y.%m.%d %H:%M:%S')
  echo "[$TS][$target_lingo][FATAL]$@" | tee -a $logfile
  exit 1
}

#============================================================================#
# TRAPS
#============================================================================#
function cleanup {
  INFO "[$LINENO] === END [PID $$] on signal $1. Cleaning up ==="
  rm "$tmpfile1" 2>/dev/null
  rm "$tmpfile2" 2>/dev/null
  exit
}
for sig in KILL TERM INT EXIT; do trap 'cleanup $sig' "$sig" ; done

#============================================================================#
# Build Functions
#============================================================================#

function ReadConfiguration {
  INFO "[$LINENO] Checking configuration file"  
  config_file="configuration.sh"
  [[ ! -f $config_file ]] && DIE "Configuration file '$config_file' does not exist. You should be running this from the 'utilities' directory."  
  INFO "[$LINENO] Reading configuration file $config_file"
  source $config_file
}


function usage {
  printf "
Checks all the translated language strings for typical errors

Run this from the utilities directory.

Usage: %s

OPTIONS:
  -h, --help
          Displays this text


Note:
  This utility does not push any changes to the remote Git repository.


" ${0##*/}
  exit 1
}




#============================================================================#
# Main program
#============================================================================#

INFO "[$LINENO] === BEGIN [PID $$] $progname ==="

ReadConfiguration
CreateWorkspace


# Check input
while [[ $1 = -* ]]; do
  ARG=$(echo $1|cut -d'=' -f1)
  VAL=$(echo $1|cut -d'=' -f2)

  case $ARG in
    "--help" | "-h" )
      usage
      ;;
    *)
      print "Invalid option: $1"
      exit 1
      ;;
  esac
  shift
done

# Check input parameters from config file
target_lingo=$TARGETLINGO
source_lingo=$SOURCELINGO
if [[ -z $target_lingo ]]; then
  DIE "[$LINENO] Target language not specified"
fi

# Make ISO-639-1 language code from ISO-639-0 codes: (e.g. en-GB => en)
source_lingo_1=${source_lingo/-[A-Z]*/}
target_lingo_1=${target_lingo/-[A-Z]*/}


INFO "[$LINENO] Checking / fixing target subversion directory layout"
              
# These are the current directories that contain language files,
# check them on new major releases.
# find . -type f -name "en-GB*.ini" | sed -e 's/en-GB\..*//' | sort -u | grep -v tests  
#./administrator/language/en-GB/
#./administrator/modules/mod_multilangstatus/language/en-GB/
#./administrator/modules/mod_stats_admin/language/
#./administrator/modules/mod_version/language/en-GB/
#./administrator/templates/hathor/language/en-GB/
#./administrator/templates/isis/language/en-GB/
#./installation/language/en-GB/
#./language/en-GB/
#./libraries/cms/html/language/en-GB/
#./libraries/src/Filesystem/Meta/language/en-GB/
#./libraries/vendor/joomla/filesystem/meta/language/en-GB/
# ./plugins/system/languagecode/language/en-GB/
#./templates/beez3/language/en-GB/
#./templates/protostar/language/en-GB/


# Check if directories are there:
[[ ! -d "$local_sandbox_dir/administrator/language/${target_lingo}" ]]                  && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/administrator/language/${target_lingo}"
[[ ! -d "$local_sandbox_dir/administrator/language/overrides" ]]                        && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/administrator/language/overrides"
[[ ! -d "$local_sandbox_dir/administrator/help/${target_lingo}" ]]                      && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/administrator/help/${target_lingo}"
[[ ! -d "$local_sandbox_dir/administrator/modules/mod_multilangstatus/language/${target_lingo}" ]] && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/administrator/modules/mod_multilangstatus/language/${target_lingo}"
[[ ! -d "$local_sandbox_dir/administrator/modules/mod_stats_admin/language/${target_lingo}" ]] && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/administrator/modules/mod_stats_admin/language/${target_lingo}"
[[ ! -d "$local_sandbox_dir/administrator/modules/mod_version/language/${target_lingo}" ]] && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/administrator/modules/mod_version/language/${target_lingo}"
[[ ! -d "$local_sandbox_dir/administrator/templates/hathor/language/${target_lingo}" ]] && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/administrator/templates/hathor/language/${target_lingo}" 
[[ ! -d "$local_sandbox_dir/administrator/templates/bluestork/language/${target_lingo}" ]] &&  DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/administrator/templates/bluestork/language/${target_lingo}" 
[[ ! -d "$local_sandbox_dir/administrator/templates/isis/language/${target_lingo}" ]]   && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/administrator/templates/isis/language/${target_lingo}" 
[[ ! -d "$local_sandbox_dir/installation/language/${target_lingo}" ]]                   && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/installation/language/${target_lingo}"
[[ ! -d "$local_sandbox_dir/installation/installer" ]]                                  && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/installation/installer"
[[ ! -d "$local_sandbox_dir/installation/sql/mysql" ]]                                  && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/installation/sql/mysql"
[[ ! -d "$local_sandbox_dir/language/${target_lingo}" ]]                                && DIE "[$LINENO] Unexpected directory layout - Expected: $local_sandbox_dir/language/${target_lingo}"
[[ ! -d "$local_sandbox_dir/language/overrides" ]]                                      && DIE "[$LINENO] Unexpected directory layout - Expected:  $local_sandbox_dir/language/overrides"
[[ ! -d "$local_sandbox_dir/libraries/cms/html/language/${target_lingo}" ]]             && DIE "[$LINENO] Unexpected subversion directory layout - Expected: $local_sandbox_dir/libraries/cms/html/language/${target_lingo}"
[[ ! -d "$local_sandbox_dir/libraries/src/Filesystem/Meta/language/${target_lingo}" ]]  && DIE "[$LINENO] Unexpected subversion directory layout - Expected: $local_sandbox_dir/libraries/src/Filesystem/Meta/language/${target_lingo}"
[[ ! -d "$local_sandbox_dir/libraries/vendor/joomla/filesystem/meta/language/${target_lingo}" ]] && DIE "[$LINENO] Unexpected subversion directory layout - Expected: $local_sandbox_dir/libraries/vendor/joomla/filesystem/meta/language/${target_lingo}"
[[ ! -d "$local_sandbox_dir/plugins/system/languagecode/language/${target_lingo}" ]]    && DIE "[$LINENO] Unexpected subversion directory layout - Expected: $local_sandbox_dir/plugins/system/languagecode/language/${target_lingo}"
[[ ! -d "$local_sandbox_dir/templates/beez3/language/${target_lingo}" ]]                && DIE "[$LINENO] Unexpected subversion directory layout - Expected: $local_sandbox_dir/templates/beez3/language/${target_lingo}"
[[ ! -d "$local_sandbox_dir/templates/protostar/language/${target_lingo}" ]]            && DIE "[$LINENO] Unexpected subversion directory layout - Expected: $local_sandbox_dir/templates/protostar/language/${target_lingo}"




exit 0