# OpenAI Tools
This is a Bash script to translate commands written in natural language into a Bash one-liner.

## x

### Description
This script allows you to input a command in a natural language, which is then translated into a Bash one-liner. You will be prompted if you want to execute or retry the command. If the command executes successfully, it will be added to your Bash history file.

### Installation
In order to use this script, you will need to install the following packages:

- jq
- curl

You will also need to set an OpenAI API Key in the OPENAI_API_KEY environment variable.

### Usage
x < command >

### Examples
```
$ x Create a ssh key pair named test13 in /tmp with no password
 ssh-keygen -t rsa -f /tmp/test13 -N ''
Execute or retry? [y/r/N]
```

```
$ x  Find the files over 1 go in /home with sudo
 sudo find /home -type f -size +1G
Execute or retry? [y/r/N]
```

```
$ x Zip all the files in /tmp older than 1 day and send it by email to test@test.com
 find /tmp -mtime +1 -type f -exec zip {} \; -exec mail -s "Backup" test@test.com \;
Execute or retry? [y/r/N]
```
