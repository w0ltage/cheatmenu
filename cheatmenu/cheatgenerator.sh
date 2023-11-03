#!/usr/bin/env bash

# Convert JSON into a table with "description" and "keys" columns
yaml2table() {
	yq -M '.shortcuts[] | [.action, .hotkey] | @tsv' "$@"
}

# Generate cheatsheet for chosen application
generate_cheatsheet() {
	cheatsheet="$XDG_CONFIG_HOME/cheatmenu/sheets/${application_choice}/${application_choice}.yaml"
	table=$(yaml2table "$cheatsheet")

	# Check if .json is valid
	if ! [[ $? -eq 0 ]]; then
		notify-send "Cheatmenu" "Could not generate cheatsheet for $application_choice"
		exit 1
	fi

    # Replace , in CSV table with '    | ' to separate columns
	column \
		--table \
		--separator $'\t' \
        --output-separator $'\t' \
		<(printf "%s" "$table") |
        # pass the separated columns to rofi dmenu
		rofi \
			-dmenu -p "Find shortcut far " \
			-i -markup-rows -no-show-icons \
			-width 700 -lines 15 -yoffset 30 \
			-font "ClearSandMedium 11" |
                # copy everything after delimeter '|' to clipboard
                cut --fields 2 |
                    xclip -selection clipboard

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
application_choice=$(grep --dereference-recursive --files-with-matches --word-regexp "$XDG_CONFIG_HOME/cheatmenu/sheets/" --regexp 'action:' |
	awk -F'/' '{print $(NF-0)}' |
	cut --fields 1 --delimiter '.' |
	rofi -dmenu -i -disable-history -tokenized -p "Cheatsheet for")

# Start cheatmenu
if choose_cheatmenu; then
	generate_cheatsheet
fi
