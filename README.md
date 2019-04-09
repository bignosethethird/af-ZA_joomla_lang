# Instructions
The instructions are for any Joomla language pack that uses this tool-set for managing and building language packs for Joomla. Since the first langauae to use this pack was Afrikaans (a-ZA) and it is the first language in the alphabet, we use this for as an example thoughout. 

## Naming conventions
The name of the language pack is made up from the 2-letter ISO code of the language code (lower-case), hyphenated with the 2-letter ISO code of the country (upper case) that the regional variation is aimed at. So for Afrikaans, we have af-ZA, for English we can have en-GB, en-US, en-NZ, en-ZA, etc.

The name of the packaged file that is installed in to Joomla is ```[language specifier]_joomla_lang_full_[version details]```, where ```[version details]``` consists of the following series of numbers: ```[major revision].[minor revision].[point release]v[revision]``` The version number is given by the leader of the Joomla Language Development team, which will always coincide with the version of Joomla that it is aimed at, e.g. ```3.9.5```. As leader of your own translation team, you need to ensure that the GIT repository is branched to a branch that is called ```3.9.5``` (ideally branched off the ```3.9``` branch) so that the building process can use this value (more on branching later on). Furthermore, as a translation team leader, you are only allowed to increment the ```[revision]``` number, and then only every time that you need to publish a revision (starting at 1), say, when you someone discovered a spelling error that was then corrected. 

For example, the language pack verion would be ```3.9.5v1```, and in the case of the ```af-ZA``` language, your language pack would be called ```af-ZA_joomla_lang_full_3.9.5v1```. Since the actual file would be a ZIP file, the final file name would be hosted in Joomla Language Package repository would be called ```af-ZA_joomla_lang_full_3.9.5v1.zip```

## Install Git

If you have not installed it yet. Here's how to do it on Ubuntu / Mint / other derivatives:

```bash
~/ $ sudo apt-get install git
```

## Configure yourself in Git

Set your user name, email address and password up if this is the only Git account that you are likely to use. Only set your password up like this if you are on your personal computer:
```bash
~/ $ git config --global user.name "yourusername"
~/ $ git config --global user.emai "your@email"
~/ $ git config --global user.password "XXXXX"
```

Check your configuration. The line with password will be shown 'in the clear' if you have previously set it up, so beware who is shoulder-surfing you: 
```bash
~ $ git config --list
user.email=your@email
user.name=yourusername
user.password=XXXXX
```

## Clone this Git repository (a.k.a. repo)

First create an area where you work on on all your Git repos, such as ```$HOME/git```:
```bash
~/ $ mkdir git
~/ $ cd git
```

Clone this language pack repo:
```bash
~/git $ git clone https://github.com/gerritonagoodday/af-ZA_joomla_lang.git
Cloning into 'af-ZA_joomla_lang'...
remote: Enumerating objects: 4, done.
remote: Counting objects: 100% (xxx/xxx), done.
remote: Compressing objects: 100% (xxx/xxxx, done.
remote: Total xxx (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (xxx/xxx), done.
```

Enter the repo. This is now your work area.
```bash
~/git $ 
~/git $ cd af-ZA_joomla_lang/
~/git/af-ZA_joomla_lang $ 
```

## Local vs Global configuration:

If you have need to work on this repo as a different user on this user because you are already have multiple Git accounts elsewhere, use the ```--local```-bit 

```bash
~/ $ git config --local user.name "yourusername"
~/ $ git config --local user.emai "your@email"
~/ $ git config --local user.password "XXXXX"
```

## Get the latest Joomla CMS source code

You will need to have the Joomla source code of the release that you are creating a language pack for. The language pack build process (more on this later) unpacks the Joomla installation and uses the default English (en-GB) language strings as a reference, against which the a report is generated of missing language strings so that your language can be brought into alignment with the source reference. If the Joomla installation package has already been published as a .zip or a .tar.gz file, you can use this as your source reference when you run the build process, however you can also use the source code out of the Joomla Git repository as a reference. The only difference s here are that the Git repo also contains test cases in a ```test``` directory, which will be ignored in the build process, and that you need to set the repo to the correct branch before running the build process. So, let's begin by getting the latest Joomla source code from its Git repo:

If you have not done some, create work space for holding all your Git repos, such as ```$HOME/git```:

```bash
~/ $ mkdir git
~/ $ cd git
```

And if you have not done so already, clone the remote repo of the latest version of the Joomla CMS source into a local repo. You only need to this __once__ ever:

```bash
~/git $ git clone https://github.com/joomla/joomla-cms.git
Cloning into 'joomla-cms'...
remote: Enumerating objects: 360, done.
remote: Counting objects: 100% (xxx/xxx), done.
remote: Compressing objects: 100% (xxx/xxx), done.
remote: Total xxx (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (xxx/xxx), done.
```

Enter the newly-loaded repo directory:

```bash
~/git $ cd joomla-cms
~/git/joomla-cms
```

If you hae done the above all before, you can skip to here and just do a refresh of the repo with the ```pull``` command:

```bash
~/git/joomla-cms $ git pull
remote: Enumerating objects: 360, done.
remote: Counting objects: 100% (xxx/xxx), done.
remote: Compressing objects: 100% (xxx/xxx), done.
remote: Total xxx (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (xxx/xxx), 309.35 KiB | 1.11 MiB/s, done.
Resolving deltas: 100% (xxx/xxx), completed with xxx local objects.
From https://github.com/joomla/joomla-cms
   2bdb02a464..a64d385b75  4.0-dev    -> origin/4.0-dev
   e82bed675b..34118a4cc2  staging    -> origin/staging
You are not currently on a branch.
etc...
```

Ignore the last comments and instructions - these are meant for actual Joomla PHP developers.

### Avoiding confusion: always know your current branch!

You can avoid a lot of confusion and possible mishaps of getting code in branches mixed up by always displaying the currently-selected branch on the command line. This is shown by default if you installed the Linux Git features on Windows. On the Linux terminal, you need to modify the PS1 variable in your local ```~/.bashrc``` file to show the current branch. For Debian-based Linux distros (around line 68), change the PS1 assignment to this:

```bash
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w \[\033[33;1m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /')\[\033[01;34m\]\$\[\033[00m\] "
```

For all other Linuxes:

```bash
PS1="\[\e]0;\u@\h \w\a\]\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w \[\033[33;1m\]$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /')\[\033[01;34m\]$\[\033[00m\] "
```

Also add the following utility command to your local ```~/.bashrc``` file, which shows you a quick and colourful graph of the branches with the ```gg``` command:

```bash
alias gg="git log --graph --all --decorate --oneline"
alias gs="git status"
```

### Select the branch 

Now that you have installed or pulled the latest Joomla source code repo, list the available branches and select the relevant branch that is required. From the 



# Git Cheat Sheet

## Where on earth am I?

* The GO-TO Git command, ```git status```:

```bash
$ git status
On branch 3.9
Your branch is up-to-date with 'origin/3.9'.
```

Make this command an alias ```gs``` - see further above.

* Show branch tree (in glorious technicolor). Look for the branch containing 'HEAD' - that is your currently-selected branch. 

```bash
$ git log --graph --all --decorate --oneline
* 25793d9 (origin/master, origin/HEAD) Update README.md
| * c9459b9 (origin/4.0, 4.0) new files
| * 4a60d7c 4.0 start
|/  
| * 7705d44 (HEAD -> 3.9, origin/3.9) 3.9
|/  
* 0fdd6dd (master) 
```

Make this command an alias ```gg``` - see further above.

## Post changes

|my       | => |addded to| => |committed     |
|workspace|    |staging  |    |current branch|
|:-------:|    |:-------:|    |:------------:|

* Post all changes from your working directory to the staging area. Remember to save the working files first!

```bash
$ git add .
```


## Branches

* List all current branches in repo. the one marked with a '*' is the currently-selected branch:

```bash
$ git branch
* 3.9
  4.0
  master
```

* Select an existig branch, i.e. checkout a branch:

```bash
$ git checkout '3.9'
Switched to branch '3.9'
Your branch is up-to-date with 'origin/3.9'.
```

* Create a new branch off the currently-selected branch '3.9':

```$ git branch [new_branch_name]```

For example:

```$ git branch '3.9.5'```

Check the result - a new brnach was created but you are still on the last selected branch:

```bash
$ git branch
* 3.9
  3.9.5
  4.0
  master
```

* Delete a branch

```bash
$ git branch -d '3.9.5'
```

* Merge a branch 

# Some useful reference material

1. This is a good introduction to Git for a zero-knowledge start:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=SWYqp7iY_Tc" target="_blank"><img src="http://img.youtube.com/vi/SWYqp7iY_Tc/0.jpg" 
alt="Git & GitHub Crash Course For Beginners" width="240" height="180" border="10" /></a>

2. Use GitKraken as a Git visualization tool. Download it from here: 

<a href="https://www.gitkraken.com/download" target="_blank"><img src="https://pbs.twimg.com/profile_images/714866842419011584/LRrR48qp_400x400.jpg" alt="GitKraken" width="240" height="180" border="10" /></a>


