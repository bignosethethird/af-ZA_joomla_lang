# af-ZA_joomla_lang
Afrikaans Language Package for Joomla

# Instructions

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

Clone this repo:
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

## Hier gaat ons!
