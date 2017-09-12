# Syntaxchecks

Syntaxchecks for PHP, Python, Ruby, Yaml and Crontab files.

## Requirements

- PHP >= 5.6
- Python >= 2.7.12
- Ruby >= 2.3.1

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

```bash
# Check all files in project
./syntaxchecks.sh -p "/tmp/project" -a

# Check all files in project and stop at the first error
./syntaxchecks.sh -p "/tmp/project" -a -s

# Check all files in the last 5 commits of the project and stop at the first error
./syntaxchecks.sh -p "/tmp/project" -c 5 -s
```

## Regular expression

```bash
# find files for syntaxchecks
regex_bash_files="^.*sh$"
regex_php_files="^.*(php|php.skel|php.skel.*)$"
regex_yaml_files="^.*(yaml|yml)$"
regex_python_files="^.*py$"
regex_ruby_files="^.*(.rb|Vagrantfile)$"
regex_crontab_files="^.*cron$"
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