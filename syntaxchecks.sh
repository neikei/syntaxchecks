#!/bin/bash
### configuration
path="."
last_commits=0
strict=0
# find files for syntaxchecks
regex_bash_files="^.*sh$"
regex_php_files="^.*(php|php.skel|php.skel.*)$"
regex_yaml_files="^.*(yaml|yml)$"
regex_python_files="^.*py$"
regex_ruby_files="^.*(.rb|Vagrantfile)$"
regex_crontab_files="^.*cron$"
# exclude vendor and cache directories
regex_exclude="^.*/(vendor|cache)/.*$"

### functions
function usage() {
    echo "Usage: $0 [-p <path>] [-c <last_commits>] [-a] [-s]" 1>&2; exit 1; 
}

function system_check() {
    if [[ ! `which php` ]]; then echo "PHP is not installed."; exit 1; fi
    if [[ ! `which python` ]]; then echo "Python is not installed."; exit 1; fi
    if [[ ! `which ruby` ]]; then echo "Ruby is not installed."; exit 1; fi
    echo "ok"
}

function get_file_list() {
    if [ $last_commits -eq 0 ]; then
        filelist=`find $path -type f -regextype posix-extended -regex "$1" | grep -v -E "$regex_exclude"`
    else
        filelist=`cd $path && git diff --name-only --diff-filter=ACMR HEAD~$last_commits..HEAD | grep -E "$1" | grep -v -E "$regex_exclude"`
    fi
}

function check_bash_files() {
    echo "==> Check Bash files"

    get_file_list $regex_bash_files

    for file in $filelist
    do
    bash -n $file > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "No syntax errors detected in $file"
    else
        echo "Some syntax errors detected in $file"
        if [ $strict -eq 1 ]; then
            bash -n $file
            exit 1; 
        fi
    fi
    done

    echo ""
}

function check_php_files() {
    echo "==> Check PHP files"

    get_file_list $regex_php_files

    for file in $filelist
    do
    php -l $file > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "No syntax errors detected in $file"
    else
        echo "Some syntax errors detected in $file"
        if [ $strict -eq 1 ]; then
            php -l $file
            exit 1; 
        fi
    fi
    done

    echo ""
}

function check_python_files() {
    echo "==> Check Python files"

    get_file_list $regex_python_files

    for file in $filelist
    do
    python -m py_compile $file > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "No syntax errors detected in $file"
    else
        echo "Some syntax errors detected in $file"
        if [ $strict -eq 1 ]; then
            python -m py_compile $file
            exit 1; 
        fi
    fi
    done

    echo ""
}

function check_ruby_files() {
    echo "==> Check Ruby files"

    get_file_list $regex_ruby_files

    for file in $filelist
    do
    ruby -c $file > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "No syntax errors detected in $file"
    else
        echo "Some syntax errors detected in $file"
        if [ $strict -eq 1 ]; then
            ruby -c $file
            exit 1; 
        fi
    fi
    done

    echo ""
}

function check_yaml_files() {
    echo "==> Check YAML files"

    get_file_list $regex_yaml_files

    for file in $filelist
    do
    ruby -e "require 'yaml';puts YAML.load_file(\"$file\")" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "No syntax errors detected in $file"
    else
        echo "Some syntax errors detected in $file"
        if [ $strict -eq 1 ]; then
            ruby -e "require 'yaml';puts YAML.load_file(\"$file\")"
            exit 1; 
        fi
    fi
    done

    echo ""
}

function check_crontab_files() {
    echo "==> Check Crontab files"

    get_file_list $regex_crontab_files

    for file in $filelist
    do
    ./bin/chkcrontab/chkcrontab $file > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "No syntax errors detected in $file"
    else
        echo "Some syntax errors detected in $file"
        if [ $strict -eq 1 ]; then
            ./bin/chkcrontab/chkcrontab $file
            exit 1; 
        fi
    fi
    done

    echo ""
}

### main
while getopts ':p:c:as' OPTION ; do
  case "$OPTION" in
    p)   path=$OPTARG;;
    c)   last_commits=$OPTARG;;
    a)   last_commits=0;;
    s)   strict=1;;
    *)   usage;;
  esac
done

echo -n "==> Systemcheck: "
system_check
echo ""

echo "==> Config"
echo "Path: $path"
if [ $last_commits -eq 0 ]; then echo "Check files: all"; else echo "Check files: last $last_commits commit(s)"; fi
if [ $strict -eq 0 ]; then echo "Strict mode: off"; else echo "Strict mode: on"; fi
echo ""

check_bash_files
check_php_files
check_python_files
check_ruby_files
check_yaml_files
check_crontab_files

echo "==> Finished Syntaxchecks"