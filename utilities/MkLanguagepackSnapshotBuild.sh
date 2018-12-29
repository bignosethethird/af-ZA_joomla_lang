#!/bin/bash
# $Id: MkLanguagepackSnapshotBuild.sh 1957 2015-07-04 16:59:51Z gerrit_hoekstra $

# What does it do?
# ~~~~~~~~~~~~~~~
# This script fetches the latest state of all translations from SVN and
# collates it into language packs for installing into a Joomla 1.5
# installation. This installation is then checked back into SVN in the
# NightlyBuilds directory.
#
# Using daily builds allows a curious person, who is prepared to take some
# risks with regards to language instability, to install the project and to
# evaluate it (and to fawn and marvel at your fantastic work). Once you are
# happy with the functionality and the stability of the language pack, you can
# release it into the public domain - typically in the Files sections of your
# project in http://joomlacode.org (this last bit is a manual process).
#
# Usage
# ~~~~~
# You would normally run this via a cron job on a daily basis.
# Copy this script to a suitable place such as /usr/local/bin.
# Enter the following in your cron table (use the command `crontab -e` as user
# `root`) to run this process every night at 2.10 am for example:
# 10 2 * * * /usr/local/bin/MkLanguagepackSnapshotBuild.sh configuration_file
#
# So, what happens here?
# ~~~~~~~~~~~~~~~~~~~~~
# The language directories are assembled into a Joomla language pack and are
# then put back into the nightly builds directory in Subversion.
# You will get:
#  * Administrator language pack (admin)
#      eg: TARGETLINGO_joomla_lang_admin_X.X.XvX.zip
#  * Frontend language pack (site)
#      eg: TARGETLINGO_joomla_lang_site_X.X.XvX.zip
#  * Above 2 packs bundled together (all)
#      eg: TARGETLINGO_joomla_lang_full_X.X.XvX.zip
#  * Installation language pack (install)
#      eg: TARGETLINGO_joomla_lang_install_X.X.XvX.zip
#
#
# What does a package look like?
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Site Package holds the front-end translated text and consists of:
#  o All front-end .INI files, which hold translated text
#  o index.html - empty default HTML file that should be in each directory
#  o install.xml - lists all files in the package and package details for Joomla!
#  o TARGETLINGO.xml - Additional Language details for Joomla!, where "TARGETLINGO" is the targeted Joomla! language code
# This is all zipped up into flat zip file called site_TARGETLINGO.zip
# If delivered as a separate Site installation package, then the following files are zipped up
# into a flat zip file (i.e. no directories) called TARGETLINGO_joomla_lang_site_X.X.XvX.zip
#  o pkg_site_TARGETLINGO.xml - package details for Joomla!
#  o site_TARGETLINGO.zip - result of the previous zip operation
#
# Admin Package holds the back-end translated text and consists of:
#  o All back-end .INI files, which hold translated text
#  o index.html - empty default HTML file that should be in each directory
#  o install.xml - lists all files in the package and package details for Joomla!
#  o TARGETLINGO.xml - Additional Language details for Joomla!, where "TARGETLINGO" is the Joomla! language code
# This is all zipped up into flat zip file called admin_TARGETLINGO.zip
# If delivered as a separate Admin installation package, then the following files are zipped up
# into a flat zip file (i.e. no directories) called TARGETLINGO_joomla_lang_admin_X.X.XvX.zip
#  o pkg_admin_TARGETLINGO.xml - package details for Joomla!
#  o admin_TARGETLINGO.zip - result of the previous zip operation
#
# Full Package holds both the front-end and the back-end translated text and consists of:
#  o site_TARGETLINGO.zip - from the above operation
#  o admin_TARGETLINGO.zip - from the above operation
#  o pkg_TARGETLINGO.xml - package details for Joomla!
# These files are zipped up into a flat zip file (i.e. no directories!)
# called TARGETLINGO_joomla_lang_install_X.X.XvX.zip
#
# This script creates the following files:
#  o index.html
#  o install.xml
#  o TARGETLINGO.xml
#  o pkg_site_TARGETLINGO.xml TODO
#  o site_TARGETLINGO.xml
#  o pkg_admin_TARGETLINGO.xml TODO
#  o admin_TARGETLINGO.xml
#  o pkg_TARGETLINGO.xml
#  o TARGETLINGO_joomla_lang_site_X.X.XvX.zip TODO
#  o TARGETLINGO_joomla_lang_admin_X.X.XvX.zip TODO
#  o TARGETLINGO_joomla_lang_install_X.X.XvX.zip TODO
#  o TARGETLINGO_joomla_lang_full_X.X.XvX.zip
#
#
# Configuration
# ~~~~~~~~~~~~~
# This is held in the configuration file, [iso-language-code]-[iso-country-code].conf
#
# Fixed values
# ~~~~~~~~~~~~
#    This is a sub-directory off the SVNPROJECTURL where nightly builds
#    a.k.a. snapshots are stored. (No leading slash). Do not change.
SVNSNAPSHOTS="nightlybuilds"
# This is the sub directory off the SVNPROJECTURL where actual translations
# files are worked on. (No leading slash)
# Set your local working folder (no trailing slashes)
WORKFOLDER="${HOME}/joomlawork"
# Initial value until config file is read
TARGETLINGO="xx-XX"

# Inferred values:
TODAY=$(date +"%d %b %Y")
STARTDIR=${PWD}
DEBUG=true
BUILDDATE=$(date +%Y%m%d)
THISYEAR=$(date +%Y)
EXITCODE=0
COMMAND="$0" # Save command

# Set up logging - this is important if we run this as a cron job
PROGNAME=${0##*/}
# Log in work folder
LOGFILE="${WORKFOLDER}/${PROGNAME%\.*}.log"
[[ ! -f $LOGFILE ]] && touch $LOGFILE 2>/dev/null
if [[ $? -ne 0 ]]; then
  # Log in HOME
  LOGFILE="~/${PROGNAME%\.*}.log"
  touch "$LOGFILE" 2>/dev/null
  if [[ $? -ne 0 ]]; then
    # Log in CWD
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
    printf "$1 " >>  $LOGFILE
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
  rm -fr $WORKFOLDER/site 2>/dev/null
  rm -fr $WORKFOLDER/admin 2>/dev/null
  rm $WORKFOLDER/admin_${TL}.zip 2>/dev/null
  rm $WORKFOLDER/site_${TL}.zip 2>/dev/null
  exit
}
for sig in KILL TERM INT EXIT; do trap "cleanup $sig" "$sig" ; done


#============================================================================#
# Configuration
#============================================================================#

INFO "[$LINENO] === BEGIN [PID $$] \$Id: MkLanguagepackSnapshotBuild.sh 1957 2015-07-04 16:59:51Z gerrit_hoekstra $ ==="

function ReadConfiguration {
  INFO "[$LINENO] Checking configuration file"
  config_file=$@
  [[ -z $config_file ]] && DIE "No configuration file was specified"
  [[ ! -f $config_file ]] && DIE "Configuration file $config_file can not be found"
  INFO "[$LINENO] Reading configuration file $config_file"
  source $config_file
}

ReadConfiguration $1


# Derived Values
# ~~~~~~~~~~~~~~
# Package name 
#    This is a standard Joomla install with your core language files in them.
#    These language files will be replaced by the latest ones from the
#    working file repository.
#    This is the required form of filename for language packages if you
#    want to have your language officially accredited.
#    TYPE = site, admin, full, install
packageNameTemplate="${TARGETLINGO}_joomla_lang_TYPE_${TRANSLATIONVERSION}.zip"

# Local subversion sandbox in workfolder to pull latest code cut down to
local_sandbox_dir="${TARGETLINGO}_sandbox"


#============================================================================#
# Build Functions
#============================================================================#

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
  rm -fr admin 2>/dev/null
  mkdir admin
  rm -fr site 2>/dev/null
  mkdir site
  mkdir -p $local_sandbox_dir 2>/dev/null
  #rm -fr $SVNSNAPSHOTS 2>/dev/null
  #rm -fr $SVNFILES 2>/dev/null
}


# Current Working Directory is $WORKFOLDER = joomlawork
function GetLastSnapshots {
  INFO "[$LINENO] Get Snapshots from $SVNPROJECTURL/$SVNSNAPSHOTS into $local_sandbox_dir/$SVNSNAPSHOTS"

  # Create parent directory of SVN tree prevent directory globbing
#  PARENT_DIR=$(dirname $SVNSNAPSHOTS)
#  if [[ -n $PARENT_DIR ]]; then
#    rm -fr $PARENT_DIR 2>/dev/null
#    if [[ ! -d $PARENT_DIR ]]; then
#      INFO "Create directory $PARENT_DIR"
#      mkdir -p $PARENT_DIR 1>/dev/null
#      if [[ ! -d $PARENT_DIR ]]; then
#        DIE "Could not create directory $PARENT_DIR off $WORKFOLDER"
#      fi
 #   fi
 #   cd $PARENT_DIR
 # else
 #   rm -fr $SVNFILES
 # fi

  # Get the content of the snapshot folder
  DEBUG "svn checkout --username $SVNUSERNAME --password $SVNPASSWD $SVNPROJECTURL/$SVNSNAPSHOTS $local_sandbox_dir/$SVNSNAPSHOTS 1>/dev/null 2>&1"
  svn checkout --username $SVNUSERNAME --password $SVNPASSWD $SVNPROJECTURL/$SVNSNAPSHOTS $local_sandbox_dir/$SVNSNAPSHOTS 1>/dev/null 2>&1
  RETCODE=$?
  if [[ $RETCODE -ne 0 ]]; then
    cd $STARTDIR
    DIE "[$LINENO] Could not get the snapshot files from SVN."
  fi

  # Return to workspace
  #if [[ -n $PARENT_DIR ]]; then
  #  cd - 1>/dev/null
  #fi
}

# Current Working Directory is $WORKFOLDER = joomlawork
function GetLastSourceFiles {
  INFO "[$LINENO] Get Source Files from $SVNPROJECTURL/$SVNFILES into $local_sandbox_dir/$SVNFILES"

  # Create parent directory of SVN tree prevent directory globbing
  #PARENT_DIR=$(dirname $SVNFILES)
  #if [[ -n $PARENT_DIR ]]; then
  #  rm -fr $PARENT_DIR 2>/dev/null
  #  if [[ ! -d $PARENT_DIR ]]; then
  #    INFO "Create directory $PARENT_DIR"
  #    mkdir -p $PARENT_DIR 1>/dev/null
  #    if [[ ! -d $PARENT_DIR ]]; then
  #      DIE "Could not create directory $PARENT_DIR off $WORKFOLDER"
  #    fi
  #  fi
  #  cd $PARENT_DIR
  #else
  #  rm -fr $SVNFILES
  #fi

  DEBUG "[$LINENO] svn checkout --username $SVNUSERNAME --password $SVNPASSWD $SVNPROJECTURL/$SVNFILES $local_sandbox_dir/$SVNFILES 1>/dev/null 2>&1"
  svn checkout --username $SVNUSERNAME --password $SVNPASSWD $SVNPROJECTURL/$SVNFILES $local_sandbox_dir/$SVNFILES 1>/dev/null 2>&1
  RETCODE=$?
  if [[ $RETCODE -ne 0 ]]; then
    cd $STARTDIR
    DIE "[$LINENO] Could not get the source files from SVN. The files may already exist in your sandbox but you have not added and/or checked them in to the version control system.
The following steps may solve your problem:
cd $local_sandbox_dir
svn add $SVNFILES
svn ci 'new release' $SVNFILES
"
  fi

  # Return to workspace
  #if [[ -n $PARENT_DIR ]]; then
  #  cd - 1>/dev/null
  #fi
}

# Collate translated files into snapshot build folders 'site' and 'admin'
# Current Working Directory is $WORKFOLDER = joomlawork
function CopyTranslationsToPackagingArea {
  INFO "[$LINENO] Copying Source Files from $SVNPROJECTURL/$SVNFILES/administrator into admin"
  find $local_sandbox_dir/${SVNFILES}/administrator/language -type f -name "${TARGETLINGO}.*.ini" | grep -v "\.svn" | sort -u | xargs -I {} cp {} admin/.
  find $local_sandbox_dir/${SVNFILES}/administrator/language -type f -name "${TARGETLINGO}.ini"   | grep -v "\.svn" | sort -u | xargs -I {} cp {} admin/.
  find $local_sandbox_dir/${SVNFILES}/administrator/language -type f -name "${TARGETLINGO}.localise.php" | grep -v "\.svn" | sort -u | xargs -I {} cp {} admin/.
  INFO "[$LINENO] Copying Source Files from $SVNPROJECTURL/$SVNFILES/language into site"
  find $local_sandbox_dir/${SVNFILES}/language -type f -name "${TARGETLINGO}.*.ini" | grep -v "\.svn" | sort -u | xargs -I {} cp {} site/.
  find $local_sandbox_dir/${SVNFILES}/language -type f -name "${TARGETLINGO}.ini"   | grep -v "\.svn" | sort -u | xargs -I {} cp {} site/.
  find $local_sandbox_dir/${SVNFILES}/language -type f -name "${TARGETLINGO}.localise.php" | grep -v "\.svn" | sort -u | xargs -I {} cp {} site/.
  INFO "[$LINENO] Copying Source Files from $SVNPROJECTURL/$SVNFILES/libraries into site"
  find $local_sandbox_dir/${SVNFILES}/libraries -type f -name "${TARGETLINGO}.*.ini" | grep -v "\.svn" | sort -u | xargs -I {} cp {} site/.
  INFO "[$LINENO] Copying Source Files from $SVNPROJECTURL/$SVNFILES/plugins into site"
  find $local_sandbox_dir/${SVNFILES}/plugins -type f -name "${TARGETLINGO}.*.ini"   | grep -v "\.svn" | sort -u | xargs -I {} cp {} site/.
  INFO "[$LINENO] Copying Source Files from $SVNPROJECTURL/$SVNFILES/templates into site"
  find $local_sandbox_dir/${SVNFILES}/templates -type f -name "${TARGETLINGO}.*.ini" | grep -v "\.svn" | sort -u | xargs -I {} cp {} site/.
}

# Parameters: 1. admin, site
#             2. Filename
function MkIndexHTML {
  FILENAME="$1"
  cat <<EOF > $FILENAME
<!DOCTYPE html><title></title>
EOF
}

# Parameters: 1. admin, site
#             2. Filename
function MkLingoXML {
  CLIENT="$1"
  [[ $CLIENT == "full" ]] && TYPE="package" || TYPE="language"
  FILENAME="$2"

  INFO "[$LINENO] Create $FILENAME XML File for '${CLIENT}' language pack"
  DEBUG "[$LINENO] MkXMLInstallHeader ${CLIENT} - filename: $FILENAME"
  [[ $CLIENT == "admin" ]] && CLIENT="administrator"

  cat <<EOF > $FILENAME
<?xml version="1.0" encoding="utf-8"?>
<!-- This file is created by \$Id: MkLanguagepackSnapshotBuild.sh 1957 2015-07-04 16:59:51Z gerrit_hoekstra $ -->
<metafile version="${JOOMLABASEVERSION}" client="${CLIENT}" method="upgrade">
  <tag>${TARGETLINGO}</tag>
  <name>${LINGOEXONYM}</name>
  <nativeName>${LINGOINDONYM}</nativeName>
  <description>${PACKAGE_DESC} - Joomla! ${JOOMLVERSION}</description>
  <version>${TRANSLATIONVERSION_XML}</version>
  <creationDate>${TODAY}</creationDate>
  <author>$AUTHORNAME</author>
  <authorEmail>$AUTHOREMAIL</authorEmail>
  <authorurl>${LINGOSITE}</authorurl>
  <copyright>Copyright (C) 2005 - ${THISYEAR} Open Source Matters. All rights reserved</copyright>
  <copyright>Copyright (C) ${LINGOEXONYM} Translation 2006 - ${THISYEAR} ${AUTHORNAME}. ${LOCAL_ALLRIGHTS}.</copyright>
  <license>GNU General Public License version 2 or later; see LICENSE.txt</license>
  <metadata>
      <name>${LINGOEXONYM}</name>
      <tag>${TARGETLINGO}</tag>
      <rtl>${RTL}</rtl>
      <locale>${LOCALE}</locale>
      <firstDay>${FIRSTDAY}</firstDay>
  </metadata>
  <params />
</metafile>
EOF
}

# Make up XML installation file, used for install.xml, pkg_admin_TARGETLINGO, pkg_site_TARGETLINGO, pkg_TARGETLINGO
# Parameters: 1. admin, site, full, install
#             2. Filename
function MkXMLInstallHeader {
  CLIENT="$1"
  [[ $CLIENT == "full" ]] && TYPE="package" || TYPE="language"
  FILENAME="$2"

  INFO "[$LINENO] Create $FILENAME XML header for '${CLIENT}' language pack"
  DEBUG "[$LINENO] MkXMLInstallHeader ${CLIENT} - filename: $FILENAME"
  [[ $CLIENT == "admin" ]] && CLIENT="administrator"

  # Make up XML header and footer
  # (deal with exclamation marks in XML)
  echo '<?xml version="1.0" encoding="utf-8" ?>' > $FILENAME
  echo '<!-- This file is created by $Id: MkLanguagepackSnapshotBuild.sh 1957 2015-07-04 16:59:51Z gerrit_hoekstra $ -->' >> $FILENAME
  if [[ $TYPE == "package" ]]; then
    echo "<extension version=\"${JOOMLABASEVERSION}\" type=\"${TYPE}\" method=\"upgrade\">" >> $FILENAME
    echo "  <name>${LINGOEXONYM} (${TARGETCOUNTRY})</name>" >> $FILENAME
    echo "  <packagename>${TARGETLINGO}</packagename>" >> $FILENAME
    echo "  <packager>$PROGNAME</packager>" >> $FILENAME
    echo "  <packagerurl>joomla4africa.org</packagerurl>" >> $FILENAME
  else
    echo "<extension version=\"${JOOMLABASEVERSION}\" type=\"${TYPE}\" method=\"upgrade\" client=\"${CLIENT}\" >" >> $FILENAME
    echo "  <name>${LINGOEXONYM} (${TARGETCOUNTRY})</name>" >> $FILENAME
  fi

  cat <<EOF >> $FILENAME
  <tag>$TARGETLINGO</tag>
  <version>${TRANSLATIONVERSION_XML}</version>
  <creationDate>${TODAY}</creationDate>
  <author>$AUTHORNAME</author>
  <authorEmail>$AUTHOREMAIL</authorEmail>
  <url>${LINGOSITE}</url>
  <copyright>Copyright (C) 2005 - ${THISYEAR} Open Source Matters. All rights reserved</copyright>
  <copyright>Copyright (C) ${LINGOEXONYM} Translation 2006 - ${THISYEAR} ${AUTHORNAME}. ${LOCAL_ALLRIGHTS}.</copyright>
  <license>GNU General Public License version 2 or later; see LICENSE.txt</license>
EOF

}

# Make up XML installation file, used for install.xml, TARGETLINGO.xml, pkg_admin_TARGETLINGO, pkg_site_TARGETLINGO, pkg_TARGETLINGO
# Parameters: 1. admin, site, full, install
#             2. Filename
function MkXMLInstallDescription {
  CLIENT="$1"
  [[ $CLIENT == "full" ]] && TYPE="package" || TYPE="language"
  FILENAME="$2"

  INFO "[$LINENO] Create $FILENAME long description for '${CLIENT}' language pack"
  DEBUG "[$LINENO] MkXMLInstallDescription ${CLIENT} - filename: $FILENAME"
  [[ $CLIENT == "admin" ]] && CLIENT="administrator"

  if [[ $CLIENT == "full" ]]; then

    # If flag is not a URL then it must a file
    # HTML if URL:  src="http://....png"
    # HTML if File: src="data:image/png;base64,...=="
    INFO "[$LINENO] Checking if $local_sandbox_dir/${SVNFILES}/utilities/${LINGOFLAG} exists..."
    if [[ -f ${local_sandbox_dir}/${SVNFILES}/utilities/${LINGOFLAG} ]]; then
# TODO: This does not work on Chrome!
      INFO "[$LINENO] Using ${local_sandbox_dir}/${SVNFILES}/utilities/${LINGOFLAG} as a graphics file"
      uuencoded_flag=$(uuencode -m ${local_sandbox_dir}/${SVNFILES}/utilities/${LINGOFLAG} ${LINGOFLAG} | sed 1d )
      [[ $? -ne 0 ]] && DIE "[$LINENO] Could not uuencode file ${LINGOFLAG}."
      # Make up MIME tag:
      flag_file_extension=$(echo ${LINGOFLAG##*.} | tr [A-Z] [a-z])
      if [[ -z $flag_file_extension ]]; then
        flag_file_extension=$(identify ${local_sandbox_dir}/${SVNFILES}/utilities/${LINGOFLAG} | awk '{print $2}' | tr [A-Z] [a-z])
      fi
      flag="data:image/${flag_file_extension};base64,${uuencoded_flag}"
    else
      INFO "[$LINENO] Assuming ${LINGOFLAG} is a URL"
      flag=${LINGOFLAG}
    fi

    cat <<EOF >> $FILENAME
  <description><![CDATA[
    <div align="center">
    <table border="0" width="600">
      <tr>
        <td width="100%" colspan="2">
          <div align="center">
            <h3>${PACKAGE_HEADER} ${JOOMLAVERSION}</h3>
          </div>
          <hr />
        </td>
      </tr>
      <tr>
        <td width="100%" colspan="2">
          <div align="left">
            <img border="0" src="${flag}" alt="${LINGONAME}" />
          </div>
          <hr />
        </td>
      </tr>
      <tr>
          <td width="18%"><b>${LOCAL_LANGUAGE}:</b></td>
          <td width="80%">${PACKAGE_DESC}</td>
      </tr>
      <tr>
          <td width="18%"><b>${LOCAL_AUTHOR}:</b></td>
          <td width="80%"><a mailto="${AUTHOREMAIL}">${AUTHORNAME}</a></td>
      </tr>
      <tr>
          <td width="18%"><b>${LOCAL_WEBSITE}:</b></td>
          <td width="80%"><a target="_blank" href="${LINGOSITE}">${LINGOSITE}</a></td>
      </tr>
      <tr>
          <td width="18%"><b>${LOCAL_VERSION}:</b></td>
          <td width="80%">${TRANSLATIONVERSION}</td>
      </tr>
      <tr>
          <td width="18%"><b>${LOCAL_DATE}:</b></td>
          <td width="80%">${TODAY}</td>
      </tr>
    </table>
    </div>
  ]]>
  </description>
EOF

  else
    echo "  <description>$PACKAGE_DESC</description>" >> $FILENAME
  fi
}

# Make up XML installation file, used for install.xml, TARGETLINGO.xml, pkg_admin_TARGETLINGO, pkg_site_TARGETLINGO, pkg_TARGETLINGO
# Parameters: 1. admin, site, install
#             2. Filename
# TODO:   Should be in the form to avoid file name duplication issues
# <files>
#   <administrator>   <-- section
#     <files folder="administrator/langauges/${TARGETLINGO}>
#       <file>...</file> etc..
function MkXMLInstallFileList {
  CLIENT="$1"
  FILENAME="$2"
  INFO  "[$LINENO] Create file list in $FILENAME file for '${CLIENT}' language pack"
  DEBUG "[$LINENO] MkXMLInstallFileList ${CLIENT} - filename: $FILENAME"

  echo "  <files>" >> $FILENAME
  echo "    <filename file=\"meta\">${TARGETLINGO}.xml</filename>" >> $FILENAME
  echo "    <filename file=\"meta\">install.xml</filename>" >> $FILENAME
  case $CLIENT in
    "admin")
      # Localizable files
      find $local_sandbox_dir/${SVNFILES}/administrator/language -type f -name "*.php" | grep -v "\.svn" | sort -u | sed -e "s|.*/||g" -e "s/^/    <filename>/" -e "s/$/<\/filename>/" >> $FILENAME
      # Add all .ini files to package list
      find $local_sandbox_dir/${SVNFILES}/administrator/language -type f -name "*.ini" | grep -v "\.svn" | sort -u | sed -e "s|.*/||g" -e "s/^/    <filename>/" -e "s/$/<\/filename>/" >> $FILENAME
      ;;
    "site")
      # Add any localizable files to files to the package list
      find $local_sandbox_dir/${SVNFILES}/language -type f -name "${TARGETLINGO}.localise.php" | grep -v "\.svn" | sort -u | sed -e "s|.*/||g" -e "s/^/    <filename>/" -e "s/$/<\/filename>/" >> $FILENAME
      # Add all .ini files to package list
      find $local_sandbox_dir/${SVNFILES}/libraries -type f -name "${TARGETLINGO}.*.ini" | grep -v "\.svn" | sort -u | sed -e "s|.*/||g" -e "s/^/    <filename>/" -e "s/$/<\/filename>/" >> $FILENAME
      find $local_sandbox_dir/${SVNFILES}/plugins -type f -name "${TARGETLINGO}.*.ini"   | grep -v "\.svn" | sort -u | sed -e "s|.*/||g" -e "s/^/    <filename>/" -e "s/$/<\/filename>/" >> $FILENAME
      find $local_sandbox_dir/${SVNFILES}/templates -type f -name "${TARGETLINGO}.*.ini" | grep -v "\.svn" | sort -u | sed -e "s|.*/||g" -e "s/^/    <filename>/" -e "s/$/<\/filename>/" >> $FILENAME
      find $local_sandbox_dir/${SVNFILES}/language -type f -name "${TARGETLINGO}.*.ini"  | grep -v "\.svn" | sort -u | sed -e "s|.*/||g" -e "s/^/    <filename>/" -e "s/$/<\/filename>/" >> $FILENAME
      find $local_sandbox_dir/${SVNFILES}/language -type f -name "${TARGETLINGO}.ini"    | grep -v "\.svn" | sort -u | sed -e "s|.*/||g" -e "s/^/    <filename>/" -e "s/$/<\/filename>/" >> $FILENAME
      ;;
    "install")
      DIE "Not impleimented yet"
      ;;
    * )
      DIE "Unkown option [${CLIENT}]"
      ;;
  esac
  echo "    <filename>index.html</filename>" >> $FILENAME
  echo "  </files>" >> $FILENAME
}

# Parameters: 1. admin, site, full, install
#             2. Filename
function MkXMLPackageInstallFileList {
  CLIENT="$1"
  [[ $CLIENT == "full" ]] && TYPE="package" || TYPE="language"
  FILENAME="$2"
  INFO  "[$LINENO] Create install file list in $FILENAME file for '${CLIENT}' language pack"
  DEBUG "[$LINENO] MkXMLInstallFileList ${CLIENT} - filename: $FILENAME"

  cat <<EOF >>$FILENAME
  <files>
    <file type="language" client="site" id="${TARGETLINGO}">site_${TARGETLINGO}.zip</file>
    <file type="language" client="administrator" id="${TARGETLINGO}">admin_${TARGETLINGO}.zip</file>
  </files>
  <updateservers>
    <server type="collection" priority="1" name="Accredited Joomla! Translations">${UPDATE_URL}</server>
  </updateservers>
EOF
}


# Parameters: 1. admin, site, install
#             2. Filename
function MkXMLInstallFileFooter {
  CLIENT="$1"
  FILENAME="$2"
  INFO  "[$LINENO] Create $FILENAME header for '${CLIENT}' language pack"
  DEBUG "[$LINENO] MkXMLInstallFileFooter ${CLIENT} - filename: $FILENAME"

  # Make up XML footer
  printf "</extension>\n"  >> $FILENAME

  # printf "  <params />\n</install>\n"  >> $FILENAME
}

# Add or checkin to SVN nightlybuilds
# Parameters: 1. file name in work directory to add
function CheckInSVN {
  FILENAME=$1
  cp $FILENAME $local_sandbox_dir/$SVNSNAPSHOTS/.
  svn add $local_sandbox_dir/$SVNSNAPSHOTS/$FILENAME 2>&1 | grep -v E200 | grep -v W150
  INFO "[$LINENO] Committing package $FILE"
  svn commit -m "Language Pack $FILENAME for $TARGETLINGO as of $TODAY"  $local_sandbox_dir/$SVNSNAPSHOTS/$FILENAME
  RETCODE=$?
  if [[ $RETCODE -ne 0 ]]; then
    printf "  Could not commit changes to $local_sandbox_dir/$SVNSNAPSHOTS/$FILENAME - it may have been added a few momemts ago.\n" | tee -a $LOGFILE
  fi
}

#============================================================================#
# Main program
#============================================================================#

CreateWorkspace
GetLastSnapshots
GetLastSourceFiles
CopyTranslationsToPackagingArea

# Create the following files:
#  o index.html
#  o TARGETLINGO.xml for both site and admin
#  o install.xml for both site and admin
#  o pkg_site_TARGETLINGO.xml TODO
#  o site_TARGETLINGO.xml
#  o pkg_admin_TARGETLINGO.xml TODO
#  o admin_TARGETLINGO.xml
#  o pkg_TARGETLINGO.xml
#  o TARGETLINGO_joomla_lang_site_X.X.XvX.zip TODO
#  o TARGETLINGO_joomla_lang_admin_X.X.XvX.zip TODO
#  o TARGETLINGO_joomla_lang_install_X.X.XvX.zip TODO
#  o TARGETLINGO_joomla_lang_full_X.X.XvX.zip

INFO "[$LINENO] Make file admin/index.html"
MkIndexHTML "admin/index.html"
INFO "[$LINENO] Make file site/index.html"
MkIndexHTML "site/index.html"
INFO "[$LINENO] Make file site/${TARGETLINGO}.xml"
MkLingoXML site "site/${TARGETLINGO}.xml"
INFO "[$LINENO] Make file admin/${TARGETLINGO}.xml"
MkLingoXML admin "admin/${TARGETLINGO}.xml"

INFO "[$LINENO] Make file admin/install.xml"
MkXMLInstallHeader admin "admin/install.xml"
MkXMLInstallDescription admin "admin/install.xml"
MkXMLInstallFileList admin "admin/install.xml"
MkXMLInstallFileFooter admin "admin/install.xml"

INFO "[$LINENO] Make file site/install.xml"
MkXMLInstallHeader site "site/install.xml"
MkXMLInstallDescription site "site/install.xml"
MkXMLInstallFileList site "site/install.xml"
MkXMLInstallFileFooter site "site/install.xml"

INFO "[$LINENO] Make file pkg_${TARGETLINGO}.xml"
MkXMLInstallHeader full "pkg_${TARGETLINGO}.xml"
MkXMLInstallDescription full "pkg_${TARGETLINGO}.xml"
MkXMLPackageInstallFileList full "pkg_${TARGETLINGO}.xml"
MkXMLInstallFileFooter full "pkg_${TARGETLINGO}.xml"

INFO "[$LINENO] Make file admin_${TARGETLINGO}.zip"
zip -r -j -q admin_${TARGETLINGO} admin/*

INFO "[$LINENO] Make file site_${TARGETLINGO}.zip"
zip -r -j -q site_${TARGETLINGO} site/*

packageName=$(echo $packageNameTemplate | sed -e 's/TYPE/full/')
INFO "[$LINENO] Make file $packageName"
zip -r -j -q $packageName site_${TARGETLINGO}.zip admin_${TARGETLINGO}.zip pkg_${TARGETLINGO}.xml

INFO "[$LINENO] Adding any new language installation packages to SVN (ignore SVN warnings)"
CheckInSVN $packageName


INFO "[$LINENO] Cleaning up..."
#rm -fr $SVNPROJECTURL/$SVNSNAPSHOTS 2>/dev/null
#rm -fr $SVNPROJECTURL/$SVNFILES 2>/dev/null
cd $STARTDIR

INFO "[$LINENO] The latest package snapshots are in the build sandbox in ${WORKFOLDER}/${local_sandbox_dir}/${SVNSNAPSHOTS}"
INFO "[$LINENO] ============= END ============"
