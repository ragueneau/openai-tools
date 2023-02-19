#!/usr/bin/env bash
VERSION=1.0.3
# Name: x
# Description: OpenAI API for bash: Translate a command in natural language into a bash one-liner.
# Author: Jocelyn Lecours
#
# Usage: x <command>
#
# Example: x create a ssh key pair named test13 in /tmp with no password
#          x find the files over 1go in /home. use sudo
#          x zip all the files in /tmp older than 1 day and send it by email to test@test.com
#
###################################################################################

# check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq could not be found. Please install it."
    exit 1
fi
# check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl could not be found. Please install it."
    exit 1
fi
# check if OPENAI_API_KEY is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "OPENAI_API_KEY is not set. Please set it."
    exit 1
fi

###################################################################################
## Main ##
main() {
    local tmp_output_file=$(mktemp /tmp/x.XXXXXX)
    local x_history_file=~/.x
    touch $x_history_file 2> /dev/null

    local question=$@
    while [ -z "$question" ]; do read -p "What do you want to do? " question;done

    local prompt="Translate this into a Bash one-liner: $question"

    # make sure the question ends with a dot
    [[ $question != *"." ]] && prompt="$prompt."

    curl -q -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d '{"model": "text-davinci-002", "prompt": "'"$prompt"'", "temperature": 0.7, "max_tokens": 60}' \
        -o $tmp_output_file https://api.openai.com/v1/completions > /dev/null 2>&1

    local command=$(cat $tmp_output_file | jq -r '.choices[0].text')

    echo -e "\e[1;37m"${command}"\e[0m"

    # clean up the $command to make sure it's safe to execute
    command=$(echo "$command" | sed 's/"/\"/g'|sed "s/'/\'/")

    read -p "Execute or retry? [y/r/N] " -n 1 -r
    echo
    case $REPLY in
        y)  echo "Executing..."
            history -a

            # excute the command in a new shell
            bash -c "$command"

            # if the command was successful, add it to the history
            # if there are timestamps in the history, add one before the command
            if [ $? -eq 0 ]; then
                if grep -q "^#" ~/.bash_history; then
                    echo -e "#$(date +%s)\n${command}" >> ~/.bash_history
                else
                    echo -e "${command}" >> ~/.bash_history
                fi
            fi
            history -n
            history -a

            command=$(echo "$command" | sed 's/\n//g')
            # add the command to the x history
            cat $tmp_output_file >> $x_history_file
            ;;
        r)  echo "Retrying..."
            main "$@"
            ;;
        *)  echo "Aborting..."
            ;;
    esac
    echo

    rm $tmp_output_file
    exit $?
}

############################################################################################################
main "$@"