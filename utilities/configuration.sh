#!/bin/bash

# Translation version: [major].[minor].[point].[revision], used inside the XML definition, no leading zeros.
# Only change this value when building a new version. It must be in the form x.y.z.n
# - other variants of this version will be calculated
# TRANSLATIONVERSION_XML="3.9.1.1"
TRANSLATIONVERSION_XML="4.0.0-alpha-6.1"

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
WORKFOLDER="${HOME}/joomlawork"
# Needs to be here for sub-shell use
THISYEAR=$(date +%Y)

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
SOURCELINGO="en-GB"
# Put YOUR target language here:
TARGETLINGO="af-ZA"


# Build Configuration
# ~~~~~~~~~~~~~~~~~~~

# Calculate the rest:
major=$(echo $TRANSLATIONVERSION_XML  | sed -e "s/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)/\1/g")
minor=$(echo $TRANSLATIONVERSION_XML  | sed -e "s/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)/\2/g")
point=$(echo $TRANSLATIONVERSION_XML  | sed -e "s/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)/\3/g")
revision=$(echo $TRANSLATIONVERSION_XML  | sed -e "s/\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)/\4/g")

# Joomla Base version that this transalation pack is aimed at: [major].[minor]
JOOMLABASEVERSION="${major}.${minor}"
# Specific Joomla target version that this translation pack is aimed at: [major].[minor].[point]
JOOMLAVERSION="${major}.${minor}.${point}"
# Translation version: [major].[minor].[point]v[revision], used in the package file name, no leading zeros.
TRANSLATIONVERSION="${major}.${minor}.${point}v${revision}"
# Git files are in this repo (no leading slashes). Unlikely to change.
GITREPONAME="af-ZA_joomla_lang"


# Language name - in your own language and the English exonym (
# Note: endonym is the local name for the language: Kiswahili or Deutsch
#       exonym is what 'outsiders' use to refer to the language: Swahili or German
LINGONAME="Afrikaans (ZA)"
LINGOEXONYM="Afrikaans"
# This is the native name for the language and needs to be in the local script
LINGOINDONYM="Afrikaans"
TARGETCOUNTRY="South Africa"
# Description of the langauge on one line.
# This in your target language: "xxxxx (country xxx) translation for Joomla!"
PACKAGE_HEADER='Afrikaanse Vertaling vir Joomla!'
# Your langauge term for: "xxxxx language pack in the informal form of address", or something similar
PACKAGE_DESC="Afrikaanse Taalpaket in die vertroulike aanspreeksvorm"
# Local language terms:
# Your langauge term for "Language"
LOCAL_LANGUAGE="Taal"
# "Schema"
LOCAL_SCHEME="Skema"
# Your langauge term for "Author"
LOCAL_AUTHOR="Outeur"
# Your langauge term for "Website"
LOCAL_WEBSITE="Webwerf"
# Your langauge term for "Revision"
LOCAL_VERSION="Hersiening"
# Date
LOCAL_DATE="Datum"
# "Please check the project website frequently for the most recent translation"
LOCAL_INSTALL="Laat asb. weet indien daar enige tik-foute of grammaktia-foute is - hulle sal so spoedig moontlik reggemaak word!"
# "All rights reserved" in your language, or use the English.
LOCAL_ALLRIGHTS="Alle regte voorbehou"
# Right To Left = 0 for most languages
RTL=0
# Locales by which this lnaguage is known
# e.g. for German: de_DE.utf8, de_DE.UTF-8, de_DE, deu_DE, de, german, german-de, de, deu, germany
LOCALE="af_ZA.uft8, af_ZA.UTF-8, af, af_ZA, afr_ZA, af-ZA, afrikaans, afrikaans-za, afr, south africa, suid-afrika"
# First day of the week in the locale, mostly 1 = Sunday, sometimes 2 = Monday or 6=Saturday
FIRSTDAY=1

# Name of package author or team
AUTHORNAME="Gerrit Hoekstra"
# Email address of author or team
AUTHOREMAIL="gerrit@hoekstra.co.uk"
# Installation Configuration:
#     A flag to display on successful completion of installation
#     This can either be a publically-accessible URL or the name of graphics file. e.g.
#     http://joomla4africa.org/images/smallflags/South Africa.gif
#     If it is a file then specify relative to the directory that this file is in. If it is a file,
#     it will be UU-encoded into the installation XML file. 
#     The Recommended size for the images is 256x256 pixels, PNG format and with background alpha-channeled.
LINGOFLAG="http://joomlacode.org/gf/download/docmanfileversion/2035/164576/South%20Africa.gif"
# LINGOFLAG=flag.png
#     The website that hosts this translation
LINGOSITE="http://forge.joomla.org/gf/project/afrikaans_taal"
# Updates Notifications for all languages can be checked here. 
# This URL changes for each major Joomla! version release.
UPDATE_URL="http://update.joomla.org/language/translationlist_3.xml"
