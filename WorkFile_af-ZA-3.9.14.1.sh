#!/bin/bash
# No changes required for site installation

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
#         $ .//home/gerrit/git/af-ZA_joomla_lang/WorkFile_af-ZA-3.9.14.1.sh
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
# Number of NEW Strings in en-GB source language not in af-ZA target language: 5
# Number of OLD Strings in af-ZA target language not in en-GB source language: 0
# Total number of af-ZA files that need to be modified: 4

# Job 1: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_actionlogs.ini
echo "COM_ACTIONLOGS_FILTER_SEARCH_DESC=\"Deursoek gebruikername. Voeg die voorvoegsel 'ID:' vooraan om die aksiestaaf te deursoek. Gebruik die voorvoegsel 'ITEM_ID:' om vir 'n aksiestaaf item-ID te soek.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_actionlogs.ini

# Job 2: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_FIELDS_FILTER_SEARCH_DESC=\"Deursoek veld naam, titels of nota's. Gebruik die voorvoegsel 'ID:' vooraan om vir die veld ID te soek. Gebruik die voorvoegsel 'AUTHOR:' om vir die veld outeur te soek.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_GROUPS_FILTER_SEARCH_DESC=\"Deursoek veld-groep titels. Gebruik die voorvoegsel 'ID:' vooraan om vir die veld-groep  ID te soek.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini

# Job 3: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_installer.ini
echo "COM_INSTALLER_MSG_ERROR_CANT_CONNECT_TO_UPDATESERVER=\"Kan nie met %s verbind nie\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_installer.ini

# Job 4: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.plg_quickicon_phpversioncheck.ini
echo "PLG_QUICKICON_PHPVERSIONCHECK_UNSUPPORTED_JOOMLA_OUTDATED=\"Joomla het vasgestel dat jou bediener PHP %1$s gebruik, wat nou verval het en nie meer amptelike ondersteuning vir sekuriteits-doeleindes ontvang nie. Ons kan ook nie 'n nuwer versie van PHP aanbeveel nie omdat die versie van Joomla ook verval het. Die aanbeveling is dus om Joomla eers op te dateer, en dan verdere PHP opdateerings-instruksies te volg.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.plg_quickicon_phpversioncheck.ini
# No changes required for install installation
