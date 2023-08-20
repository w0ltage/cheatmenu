#!/usr/bin/env bash

# Convert JSON into a table with "description" and "keys" columns
json2table() {
    jq --raw-output '.cheatsheet[] | [.action, .hotkey] | @tsv' "$@"
}


# Generate cheatsheet for chosen application
generate_cheatsheet() {
    cheatsheet="$XDG_CONFIG_HOME/cheatmenu/cheatsheets/${application_choice}.json"
    table=$(json2table "$cheatsheet")

    # Check if .json is valid 
    if ! [[ $? -eq 0 ]]; then
        notify-send "Cheatmenu" "Could not generate cheatsheet for $application_choice"
        exit 1
    fi

    # pass table with "description" and "keys" columns to rofi dmenu
    column \
        --table \
        --separator $'\t' \
        <(printf "%s" "$table") | 
        rofi \
            -dmenu -p "Find shortcut for " \
            -i -markup-rows -no-show-icons \
            -width 700 -lines 15 -yoffset 30 \
            -font "ClearSandMedium 11"

}


# Check if application is selected
choose_cheatmenu() {
    if [ -z "$application_choice" ]; then
        notify-send "Cheatsheet menu" "No application selected."
        exit 1
    fi
}

# Check if $XDG_CONFIG_HOME is set
if [[ -z $XDG_CONFIG_HOME ]]; then
    printf "Create an environment variable 'XDG_CONFIG_HOME' with the value of the directory with configs\n(where the cheatmenu directory with all cheat sheets is located).\n"
    printf "\nFor example, add to your shell config:\nexport \$XDG_CONFIG_HOME=\"\$HOME/.config/\"\n\nReload shell and run setup.sh\n"
    exit 1
fi

# Search for .json files with description key (lazy way to get valid cheatsheets)
application_choice=$(grep --dereference-recursive --files-with-matches --word-regexp "$XDG_CONFIG_HOME/cheatmenu/cheatsheets/" --regexp '"action":' | 
    awk -F'/' '{print $(NF-0)}' | 
    cut --fields 1 --delimiter '.' | 
    rofi -dmenu -i -disable-history -tokenized -p "Cheatsheet for")

# Start cheatmenu
if choose_cheatmenu; then
    generate_cheatsheet
fi
