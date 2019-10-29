#!/bin/bash

# ==========================================================================
# This script is a summary van die work required to bring the af-ZA language
# pack up to the latest Joomla patch level. It was created using the 
# Chk4NewLanguageStrings.sh utility 
# https://github.com/gerritonagoodday/af-ZA_joomla_lang/tree/master/utilities
# This utility works vir all languages, as long as the directory structure is in the
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
echo "FINDER_CLI_BATCH_CONTINUING=\" * Vervolg verwerking van bondelproses ...\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.finder_cli.ini
echo "FINDER_CLI_BATCH_PAUSING=\" * Pouseer verwerking vir %s sekondes ...\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.finder_cli.ini
echo "FINDER_CLI_SKIPPING_PAUSE_LOW_BATCH_PROCESSING_TIME=\" * Spring oor die pouse omdat die vorige bondelproses nie lang geduur het nie (%ss < %ss)\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.finder_cli.ini

# Job 2: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JASSOCIATIONS_ASC=\"Assosiasies opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JASSOCIATIONS_DESC=\"Assosiasies afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JAUTHOR_ASC=\"Outeur opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JAUTHOR_DESC=\"Outeur afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JCATEGORY_ASC=\"Kategorie opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JCATEGORY_DESC=\"Kategorie afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JDATE_ASC=\"Datum opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JDATE_DESC=\"Datum afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JFEATURED_ASC=\"Uitgelig, opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JFEATURED_DESC=\"Uitgelig, afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_FIELD_GROUPS=\"Veld Groepe\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_HITS_ASC=\"Treffers opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_HITS_DESC=\"Treffers afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_LIST_ALIAS=\"(<span>Alias</span>: %s)\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_LIST_ALIAS_NOTE=\"(<span>Alias</span>: %s, <span>Nota</span>: %s)\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_SORT_BY=\"Rangskik Tabel volgens:\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_TITLE_ASC=\"Titel opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_TITLE_DESC=\"Titel afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGLOBAL_TYPE_OR_SELECT_SOME_TAGS=\"Tik of kies 'n paar etikette\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ACCESS_ASC=\"Toegang opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ACCESS_DESC=\"Toegang afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ID_ASC=\"ID opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ID_DESC=\"ID afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_LANGUAGE_ASC=\"Taal opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_LANGUAGE_DESC=\"Taal afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ORDERING_ASC=\"Orde opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JGRID_HEADING_ORDERING_DESC=\"Orde afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JSTATUS_ASC=\"Status opdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini
echo "JSTATUS_DESC=\"Status afdalend\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.ini

# Job 3: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_AUTHORISATION=\"Jou toegang is bemagtig.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_DENIED=\"Jou toegang is geweier.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_EXPIRED=\"Jou bemagtiging het verstryk.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/language/af-ZA/af-ZA.lib_joomla.ini

# ==========================================================================
# This script is a summary van die work required to bring the af-ZA language
# pack up to the latest Joomla patch level. It was created using the 
# Chk4NewLanguageStrings.sh utility 
# https://github.com/gerritonagoodday/af-ZA_joomla_lang/tree/master/utilities
# This utility works vir all languages, as long as the directory structure is in the
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
echo "COM_CONTENT_CREATE_ARTICLE_ERROR=\"Wanneer die verstek kategorie ontsper is, behoort 'n kategorie gekies word.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_content.ini

# Job 2: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_FIELD_EDITABLE_IN_ADMIN=\"Administrateur\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_FIELD_EDITABLE_IN_BOTH=\"Albei\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_FIELD_EDITABLE_IN_DESC=\"Op watter deel van die werf moet die veld redigeerbaar wees?\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_FIELD_EDITABLE_IN_LABEL=\"Redigeerbar in\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_fields.ini
echo "COM_FIELDS_FIELD_EDITABLE_IN_SITE=\"Werf\""\
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
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_ALPHA=\"Alfa\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_BETA=\"Beta\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_DESC=\"Die minimum stabiliteit van die ekstensie opdateerings wat jy graag sal wil sien. Ontwikkeling is die mees onstabiel, Stabiel is produksie kwaliteit. As 'n ekstensie nie 'n stabiliteit aandui nie, dan word dit as Stabiel beskou.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_DEV=\"Ontwikkeling\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_LABEL=\"Minimum Stabiliteit\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_RC=\"Uitgawe Kandidaat\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini
echo "COM_JOOMLAUPDATE_MINIMUM_STABILITY_STABLE=\"Stabiel\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.com_joomlaupdate.ini

# Job 5: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.ini
echo "JGLOBAL_TYPE_OR_SELECT_SOME_TAGS=\"Tik of kies 'n paar etikette\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.ini

# Job 6: Add the following translated string(s) to the file:
# /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_AUTHORISATION=\"Jou toegang is bemagtig.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_DENIED=\"Jou toegang is geweier.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.lib_joomla.ini
echo "JLIB_LOGIN_EXPIRED=\"Jou bemagtiging het verstryk.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/administrator/language/af-ZA/af-ZA.lib_joomla.ini

# ==========================================================================
# This script is a summary van die work required to bring the af-ZA language
# pack up to the latest Joomla patch level. It was created using the 
# Chk4NewLanguageStrings.sh utility 
# https://github.com/gerritonagoodday/af-ZA_joomla_lang/tree/master/utilities
# This utility works vir all languages, as long as the directory structure is in the
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
echo "INSTL_DEFAULTLANGUAGE_COULD_NOT_INSTALL_MULTILANG=\"Joomla kon veeltalike voorbeeld-data installeer nie omdat net een taal geinstaller is. Om die veeltalige funksie te ontsper moet  jy meer tale installeer, kliek dan op die 'Vorige' knoppie en kies die gewensde tale van die lys.\""\
     >> /home/gerrit/git/af-ZA_joomla_lang/installation/language/af-ZA/af-ZA.ini
