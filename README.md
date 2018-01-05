# Syntaxchecks

<!-- TOC -->

- [Syntaxchecks](#syntaxchecks)
    - [Introduction](#introduction)
    - [Requirements](#requirements)
    - [Implemented checks](#implemented-checks)
    - [Parameter](#parameter)
    - [Usage](#usage)
        - [Manual execution](#manual-execution)
        - [Jenkins](#jenkins)
        - [Bamboo](#bamboo)
        - [Bitbucket Pipelines](#bitbucket-pipelines)
    - [Regular expressions](#regular-expressions)
    - [Third party software](#third-party-software)

<!-- /TOC -->

## Introduction

The syntaxchecks are for PHP, Python, Ruby, Yaml and Crontab files. It is easy to use and implement into continuous integration tools like Jenkins, Bamboo and Bitbucket Pipeline.

## Requirements

- Git >= 1.7
- PHP >= 5.6
- Python >= 2.7.12
- Ruby >= 2.3.1

```bash
# Installation on Debian/Ubuntu
sudo apt install git php-cli python ruby
```

## Implemented checks

- Bash
- PHP
- Python
- Ruby
- YAML
- Crontabs

## Parameter

| Parameter | Description                       | Example           |
|-----------|-----------------------------------|-------------------|
| -p        | Path to the project               | -p "/tmp/project" |
| -s        | Enable strict mode (Default: off) | -s                |
| -a        | Check all files in path           | -a                |
| -c        | Check files in last commits       | -c 1              |

## Usage

### Manual execution

```bash
# Check all files in project
./syntaxchecks.sh -p "/tmp/project" -a

# Check all files in project and stop at the first error
./syntaxchecks.sh -p "/tmp/project" -a -s

# Check all files in the last 5 commits of the project and stop at the first error
./syntaxchecks.sh -p "/tmp/project" -c 5 -s
```

### Jenkins

```bash
# Install syntaxchecks in the home path of the jenkins application user
su - jenkins
cd ~
git clone https://github.com/neikei/syntaxchecks.git

# Build step to execute the syntaxchecks with Jenkins
~/syntaxchecks/syntaxchecks.sh -p "`pwd`" -c 1 -s
```

### Bamboo

```bash
# Install syntaxchecks in the home path of the bamboo application user
su - bamboo
cd ~
git clone https://github.com/neikei/syntaxchecks.git

# Build step to execute the syntaxchecks with Bamboo
~/syntaxchecks/syntaxchecks.sh -p "${bamboo.build.working.directory}" -c 1 -s
```

### Bitbucket Pipelines

```bash
image: php:7.1.1

pipelines:
  default:
    - step:
        script:
          - apt-get update && apt-get install -y unzip wget git php-cli python ruby
          - wget https://github.com/neikei/syntaxchecks/archive/master.zip
          - unzip master.zip && rm master.zip
          - syntaxchecks-master/syntaxchecks.sh -p "`pwd`" -c 1 -s
          - rm -rf syntaxchecks-master
```

## Regular expressions

```bash
# find files for syntaxchecks
regex_bash_files="^.*\.sh$"
regex_php_files="^.*\.(php|php.skel|php.skel.*)$"
regex_yaml_files="^.*\.(yaml|yml)$"
regex_python_files="^.*\.py$"
regex_ruby_files="^.*(\.rb|Vagrantfile)$"
regex_crontab_files="^.*\.cron$"
# exclude vendor and cache directories
regex_exclude="^.*/(vendor|cache)/.*$"
```

## Third party software

- [chkcrontab](https://github.com/lyda/chkcrontab) - Modified to check crontabs without defiened user.

Example crontab format:

```bash
# m h  dom mon dow   command
0 5 * * 1 echo "Hello world!"
```