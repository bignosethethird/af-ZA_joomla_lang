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
#         $ .//home/gerrit/git/af-ZA_joomla_lang/WorkFile_af-ZA-3.9.13.1.sh
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
# Number of NEW Strings in en-GB source language not in af-ZA target language: 2
# Number of OLD Strings in af-ZA target language not in en-GB source language: 0
# Total number of af-ZA files that need to be modified: 2

# Job 1: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_content.ini
echo "COM_CONTENT_EDIT_CATEGORY=\"Regigeer Kategorie\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_content.ini

# Job 2: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_privacy.ini
echo "COM_PRIVACY_N_CONSENTS_INVALIDATED_1=\"%s toestemming is ontneem.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_privacy.ini
# No changes required for install installation
