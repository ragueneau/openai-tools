# x
This is a Bash script to translate commands written in natural language into a Bash one-liner. Become a Linux guru in no time! (or at least a little bit better)

## Description
This script allows you to input a command in a natural language, which is then translated into a Bash one-liner. You will be prompted if you want to execute or retry the command. If the command executes successfully, it will be added to your Bash history file.

## Installation
In order to use this script, you will need to install the following packages:

- jq
- curl

You will also need to set an OpenAI API Key in the OPENAI_API_KEY environment variable.

## Usage
Works in interactive mode or with a command as argument. In the latter case, the command will be executed without prompting. All languages supported by OpenAI are available.
```
x < command >
```
### History
The history of the commands is stored in the file ~/.x_history. You can use the following command to display the history:
```
x -h
```
### Options
```
-e, --execute
    Execute the command without prompting
```
```
-h, --history
    Display the history of the commands
```
```
-c, --clear
    Clear the history of the commands
```
```
-d, --display
    Display the history
```
```
-u, --usage
    Display the usage of the script
```
```
-f --find
    Search the history for a specific command
```
```
-v, --version
    Display the version of the script
```
```
-h, --help
    Display the help
```

## Examples
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

## License
This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details
