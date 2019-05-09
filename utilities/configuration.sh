#!/bin/bash

# Translation version: [major].[minor].[point].[revision], used inside the XML definition, no leading zeros.
# Only change this value when building a new version. It must be in the form x.y.z.n
# x, y and z are given and correspond to the Joomla Version that you are building to.
# n, however, starts at 1 and increments on every release that you and your team make.
# All other variants of this version will be calculated
export TRANSLATIONVERSION_XML="3.9.6.1"

# What it this file for?
# ~~~~~~~~~~~~~~~~~~~~~
# o Holds all the configuration values for building Joomla Language packs,
#'
# o Change this file every time a new release of a language pack needs to be
#   built
#
# o One file per language
#
# o Recommended configiration file name is:
#    [iso-language-code]-[iso-country-code].conf
#    More on language code naming below.
#
# Git file Structure:
# ~~~~~~~~~~~~~~~~~~~
# This is what the directory structure off the root of your repo in Git is
# expected to look like, where LINGO is the name of your language,
# made of the ISO 639-1 2-letter language code and the ISO 3166-1 2-letter 
# country code. e.g. af-ZA, en-GB, etc..
#
# Git Repo Root
# +...xx-XX_joomla-lang
#     |
#     +...administrator
#     |   +...help
#     |   .   +...LINGO
#     |   +...language
#     |       +...LINGO
#     |       +...overrides
#     |
#     +...language
#     |   +...LINGO
#     |   +...overrides
#     |
#     +...installation
#     |   +...language
#     |   |   +...LINGO
#     |   +...sql
#     |        +...mysql
#     |
#     +---libraries
#     |   +...joomla
#     |       +...html
#     |           +...language
#     |               +...LINGO
#     +...plugins
#         +...system
#             +...languagecode
#                 +...language
#                     +...LINGO

# Set your local working folder (no trailing slashes)
export WORKFOLDER="${HOME}/joomlawork"
# Needs to be here for sub-shell use
export THISYEAR=$(date +%Y)

# Language Configuration Items
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Joomla translation language in the following form:
#    2-letter ISO language + hyphen + 2-letter ISO country
#    Examples:
#    af-ZA for Afrikaans as spoken in South Africa
#    sw-TZ for Swahili as spoken in Tanzania
#    sw-KE for Swahili as spoken in Kenya
#    zu-ZA for Zulu as spoken in South Africa
# Source Language - this will never change!
export SOURCELINGO="en-GB"
# Put YOUR target language here:
export TARGETLINGO="af-ZA"

# Build Configuration
# ~~~~~~~~~~~~~~~~~~~

# Calculate the rest:
export major=$(echo $TRANSLATIONVERSION_XML  | sed -e "s/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)/\1/g")
export minor=$(echo $TRANSLATIONVERSION_XML  | sed -e "s/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)/\2/g")
export point=$(echo $TRANSLATIONVERSION_XML  | sed -e "s/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)/\3/g")
export revision=$(echo $TRANSLATIONVERSION_XML  | sed -e "s/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)/\4/g")

# Joomla Base version that this transalation pack is aimed at: [major].[minor]
export JOOMLABASEVERSION="${major}.${minor}"
# Specific Joomla target version that this translation pack is aimed at: [major].[minor].[point]
export JOOMLAVERSION="${major}.${minor}.${point}"
# Translation version: [major].[minor].[point]v[revision], used in the package file name, no leading zeros.
export TRANSLATIONVERSION="${major}.${minor}.${point}v${revision}"
# Git files are in this repo (no leading slashes). Unlikely to change.
export GITREPONAME="af-ZA_joomla_lang"
# Language name - in your own language and the English exonym (
# Note: endonym is the local name for the language: 
#           'Kiswahili' or 'Deutsch' or 'isiZulu'.
#       exonym is what 'outsiders' use to refer to the language: 
#           'Swahili' or 'German' or 'Zulu'.
export LINGONAME="Afrikaans (ZA)"
export LINGOEXONYM="Afrikaans"
# This is the native name for the language and needs to be in the local script
export LINGOINDONYM="Afrikaans"
export TARGETCOUNTRY="South Africa"
# Description of the langauge on one line.
# This in your target language: "xxxxx (country xxx) translation for Joomla!"
export PACKAGE_HEADER='Afrikaanse Vertaling vir Joomla!'
# Your langauge term for: "xxxxx language pack in the informal form of address", or something similar
export PACKAGE_DESC="Afrikaanse Taalpaket in die vertroulike aanspreeksvorm"
# Local language terms:
# Your langauge term for "Language"
export LOCAL_LANGUAGE="Taal"
# Your langauge term for "Schema"
export LOCAL_SCHEME="Skema"
# Your langauge term for "Author"
export LOCAL_AUTHOR="Outeur"
# Your langauge term for "Website"
export LOCAL_WEBSITE="Webwerf"
# Your langauge term for "Revision"
export LOCAL_VERSION="Hersiening"
# Your langauge term for Date
export LOCAL_DATE="Datum"
# Your langauge term for "Please check the project website frequently for the most recent translation"
export LOCAL_INSTALL="Laat asb. weet indien daar enige tik-foute of grammaktia-foute is - hulle sal so spoedig moontlik reggemaak word!"
# Your langauge term for "All rights reserved", or use the English.
export LOCAL_ALLRIGHTS="Alle regte voorbehou"
# Right To Left = 0 for most languages
export RTL=0
# Locales by which this lnaguage is known
# e.g. for German: de_DE.utf8, de_DE.UTF-8, de_DE, deu_DE, de, german, german-de, de, deu, germany
export LOCALE="af_ZA.uft8, af_ZA.UTF-8, af, af_ZA, afr_ZA, af-ZA, afrikaans, afrikaans-za, afr, south africa, suid-afrika"
# First day of the working week in the locale, mostly 1 = Monday or 6=Saturday
export FIRSTDAY=1
# First day of actual week, mostly 0 = Sunday (default)
# Last day of actual week, mostly 6 = Saturday (default)
#  - in which case, specify: "0,6"
export WEEKEND="0,6"
# Calendar. Choose from "gregorian" (default), "persian", "japanese", "buddhist", "chinese", "indian", "islamic", "hebrew", "coptic", "ethiopic"
export CALENDAR="gregorian"

# Name of package author or team
export AUTHORNAME="Gerrit Hoekstra"
# Email address of author or team
export AUTHOREMAIL="gerrit@hoekstra.co.uk"
# Installation Configuration:
#     A flag to display on successful completion of installation
#     This can either be a publically-accessible URL or the name of graphics file. e.g.
#     http://joomla4africa.org/images/smallflags/South Africa.gif
#     If it is a file then specify relative to the directory that this file is in. If it is a file,
#     it will be UU-encoded into the installation XML file. 
#     The Recommended size for the images is 256x256 pixels, PNG format and with background alpha-channeled.
#     Find your flag in http://www.flags.net
export LINGOFLAG="http://www.flags.net/images/largeflags/SOAF0001.GIF"
#     The website that hosts this translation team
export LINGOSITE="https://github.com/gerritonagoodday/af-ZA_joomla_lang"
#
export UPDATE_URL="http://update.joomla.org/language/translationlist_3.xml"
