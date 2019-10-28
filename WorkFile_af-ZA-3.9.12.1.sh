#!/bin/bash

# ==========================================================================
# This script is a summary of the work required to bring the af-ZA language
# pack up to the latest Joomla patch level. It was created using the 
# Chk4NewLanguageStrings.sh utility 
# https://github.com/gerritonagoodday/af-ZA_joomla_lang/tree/master/utilities
# This utility works for all languages, as long as the directory structure is in the
# prescribed Joomla structure and you have a very recent update of your translation 
# project on hand - presumably from a Subversion repository. 
# More details are shown when the Chk4NewLanguageStrings.sh 
# utility is executed with the '-h' command line parameter.
#
# What do I do with this file?
# Step 1: Translate ALL the identified strings (see Note 1) below in this file,
#         e.g. where you see text like this:
#         echo "ADD CUSTOM BUTTON(S)=Add custom button(s)" >> [some-file-path]
#          - translate this bit:     ~~~~~~~~~~~~~~~~~~~~
#         Where possible, suggestions are given if specified with the  -s 
#         command line parameter.
# Step 2: Execute this file:
#         $ .//home/gerrit/git/af-ZA_joomla_lang/WorkFile_af-ZA-3.9.12.1.sh
#         You can only run this file ONCE, so make sure all your
#         translations are complete.
# Step 3: Verify the changes in the identified files
# Step 4: Check the changed files back in again
#
# Note 1: You *can* do a partial translation on this file but you have to remove
#         the lines that you did not translate before you execute this file.
# Note 2: Make sure you save the file again as a UTF-8 file and that it has no BOM!
#         (Byte Order Marker), because BOMs are a pain in the arse.
# Note 3: If in doubt, re-run Chk4NewLanguageStrings.sh to create 
#         a new version of this, make your edits and execute it ONCE only.
# 
# Summary of required work
# Number of NEW Strings in en-GB source language not in af-ZA target language: 35
# Number of OLD Strings in af-ZA target language not in en-GB source language: 0
# Total number of af-ZA files that need to be modified: 3

# Job 1: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.finder_cli.ini
echo "FINDER_CLI_BATCH_CONTINUING=\" * Continuing processing of batch ...\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.finder_cli.ini
echo "FINDER_CLI_BATCH_PAUSING=\" * Pausing processing for %s seconds ...\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.finder_cli.ini
echo "FINDER_CLI_SKIPPING_PAUSE_LOW_BATCH_PROCESSING_TIME=\" * Skipping pause, as previous batch had a very low processing time (%ss < %ss)\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.finder_cli.ini

# Job 2: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JASSOCIATIONS_ASC=\"Associations ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JASSOCIATIONS_DESC=\"Associations descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JAUTHOR_ASC=\"Author ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JAUTHOR_DESC=\"Author descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JCATEGORY_ASC=\"Category ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JCATEGORY_DESC=\"Category descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JDATE_ASC=\"Date ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JDATE_DESC=\"Date descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JFEATURED_ASC=\"Featured ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JFEATURED_DESC=\"Featured descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_FIELD_GROUPS=\"Field Groups\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_HITS_ASC=\"Hits ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_HITS_DESC=\"Hits descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_LIST_ALIAS=\"(<span>Alias</span>: %s)\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_LIST_ALIAS_NOTE=\"(<span>Alias</span>: %s, <span>Note</span>: %s)\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_SORT_BY=\"Sort Table By:\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_TITLE_ASC=\"Title ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_TITLE_DESC=\"Title descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_TYPE_OR_SELECT_SOME_TAGS=\"Type or select some tags\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ACCESS_ASC=\"Access ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ACCESS_DESC=\"Access descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ID_ASC=\"ID ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ID_DESC=\"ID descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_LANGUAGE_ASC=\"Language ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_LANGUAGE_DESC=\"Language descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ORDERING_ASC=\"Ordering ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ORDERING_DESC=\"Ordering descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JSTATUS_ASC=\"Status ascending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JSTATUS_DESC=\"Status descending\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini

# Job 3: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_AUTHORISATION=\"Your access has been authorised.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_DENIED=\"Your access has been denied.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_EXPIRED=\"Your authentication has expired.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.lib_joomla.ini

# ==========================================================================
# This script is a summary of the work required to bring the af-ZA language
# pack up to the latest Joomla patch level. It was created using the 
# Chk4NewLanguageStrings.sh utility 
# https://github.com/gerritonagoodday/af-ZA_joomla_lang/tree/master/utilities
# This utility works for all languages, as long as the directory structure is in the
# prescribed Joomla structure and you have a very recent update of your translation 
# project on hand - presumably from a Subversion repository. 
# More details are shown when the Chk4NewLanguageStrings.sh 
# utility is executed with the '-h' command line parameter.
#
# What do I do with this file?
# Step 1: Translate ALL the identified strings (see Note 1) below in this file,
#         e.g. where you see text like this:
#         echo "ADD CUSTOM BUTTON(S)=Add custom button(s)" >> [some-file-path]
#          - translate this bit:     ~~~~~~~~~~~~~~~~~~~~
#         Where possible, suggestions are given if specified with the  -s 
#         command line parameter.
# Step 2: Execute this file:
#         $ .//home/gerrit/git/af-ZA_joomla_lang/WorkFile_af-ZA-3.9.12.1.sh
#         You can only run this file ONCE, so make sure all your
#         translations are complete.
# Step 3: Verify the changes in the identified files
# Step 4: Check the changed files back in again
#
# Note 1: You *can* do a partial translation on this file but you have to remove
#         the lines that you did not translate before you execute this file.
# Note 2: Make sure you save the file again as a UTF-8 file and that it has no BOM!
#         (Byte Order Marker), because BOMs are a pain in the arse.
# Note 3: If in doubt, re-run Chk4NewLanguageStrings.sh to create 
#         a new version of this, make your edits and execute it ONCE only.
# 
# Summary of required work
# Number of NEW Strings in en-GB source language not in af-ZA target language: 17
# Number of OLD Strings in af-ZA target language not in en-GB source language: 5
# Total number of af-ZA files that need to be modified: 5

# Job 1: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_content.ini
echo "COM_CONTENT_CREATE_ARTICLE_ERROR=\"When default category is enabled, a category should be selected.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_content.ini

# Job 2: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_FIELD_EDITABLE_IN_ADMIN=\"Administrator\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_FIELD_EDITABLE_IN_BOTH=\"Both\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_FIELD_EDITABLE_IN_DESC=\"On which part of the site should the field be editable?\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_FIELD_EDITABLE_IN_LABEL=\"Editable In\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_FIELD_EDITABLE_IN_SITE=\"Site\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini

# Job 3: Remove the following string(s) from the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
# COM_FIELDS_FIELD_SHOW_ON_ADMIN:
sed -e "/COM_FIELDS_FIELD_SHOW_ON_ADMIN\s*=/d" -i /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
# COM_FIELDS_FIELD_SHOW_ON_BOTH:
sed -e "/COM_FIELDS_FIELD_SHOW_ON_BOTH\s*=/d" -i /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
# COM_FIELDS_FIELD_SHOW_ON_DESC:
sed -e "/COM_FIELDS_FIELD_SHOW_ON_DESC\s*=/d" -i /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
# COM_FIELDS_FIELD_SHOW_ON_LABEL:
sed -e "/COM_FIELDS_FIELD_SHOW_ON_LABEL\s*=/d" -i /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
# COM_FIELDS_FIELD_SHOW_ON_SITE:
sed -e "/COM_FIELDS_FIELD_SHOW_ON_SITE\s*=/d" -i /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini

# Job 4: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_ALPHA=\"Alpha\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_BETA=\"Beta\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_DESC=\"The minimum stability of the extension updates you would like to see. Development is the least stable, Stable is production quality. If an extension doesn't specify a level it is assumed to be Stable.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_DEV=\"Development\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_LABEL=\"Minimum Stability\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_RC=\"Release Candidate\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_STABLE=\"Stable\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini

# Job 5: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.ini
echo "JGLOBAL_TYPE_OR_SELECT_SOME_TAGS=\"Type or select some tags\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.ini

# Job 6: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_AUTHORISATION=\"Your access has been authorised.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_DENIED=\"Your access has been denied.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_EXPIRED=\"Your authentication has expired.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.lib_joomla.ini

# ==========================================================================
# This script is a summary of the work required to bring the af-ZA language
# pack up to the latest Joomla patch level. It was created using the 
# Chk4NewLanguageStrings.sh utility 
# https://github.com/gerritonagoodday/af-ZA_joomla_lang/tree/master/utilities
# This utility works for all languages, as long as the directory structure is in the
# prescribed Joomla structure and you have a very recent update of your translation 
# project on hand - presumably from a Subversion repository. 
# More details are shown when the Chk4NewLanguageStrings.sh 
# utility is executed with the '-h' command line parameter.
#
# What do I do with this file?
# Step 1: Translate ALL the identified strings (see Note 1) below in this file,
#         e.g. where you see text like this:
#         echo "ADD CUSTOM BUTTON(S)=Add custom button(s)" >> [some-file-path]
#          - translate this bit:     ~~~~~~~~~~~~~~~~~~~~
#         Where possible, suggestions are given if specified with the  -s 
#         command line parameter.
# Step 2: Execute this file:
#         $ .//home/gerrit/git/af-ZA_joomla_lang/WorkFile_af-ZA-3.9.12.1.sh
#         You can only run this file ONCE, so make sure all your
#         translations are complete.
# Step 3: Verify the changes in the identified files
# Step 4: Check the changed files back in again
#
# Note 1: You *can* do a partial translation on this file but you have to remove
#         the lines that you did not translate before you execute this file.
# Note 2: Make sure you save the file again as a UTF-8 file and that it has no BOM!
#         (Byte Order Marker), because BOMs are a pain in the arse.
# Note 3: If in doubt, re-run Chk4NewLanguageStrings.sh to create 
#         a new version of this, make your edits and execute it ONCE only.
# 
# Summary of required work
# Number of NEW Strings in en-GB source language not in af-ZA target language: 1
# Number of OLD Strings in af-ZA target language not in en-GB source language: 0
# Total number of af-ZA files that need to be modified: 1

# Job 1: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/installation/language/af-ZA/af-ZA.ini
echo "INSTL_DEFAULTLANGUAGE_COULD_NOT_INSTALL_MULTILANG=\"Joomla was unable to install the multilingual sample data as only one language is installed. To activate the multilingual feature, you need to install more languages, press the 'Previous' button and choose the desired languages from the list.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/installation/language/af-ZA/af-ZA.ini
