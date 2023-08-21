#!/bin/bash

# Check if $XDG_CONFIG_HOME is set
if [[ -z $XDG_CONFIG_HOME ]]; then
    printf "Create an environment variable 'XDG_CONFIG_HOME' with the value of the directory with configs\n(where the cheatmenu directory with all cheat sheets is located).\n"
    printf "\nFor example, add to your shell config:\nexport \$XDG_CONFIG_HOME=\"\$HOME/.config/\"\n\nReload shell and run setup.sh\n"
    exit 1
fi

printf "Creating soft link to %s/.config/cheatmenu\n" "$HOME"

cheatmenu_directory="$XDG_CONFIG_HOME/cheatmenu" \
    && mkdir "$cheatmenu_directory" \
    && ln -s "$PWD" "$cheatmenu_directory"

if [[ $? -eq 1 ]]; then
    printf "Something goes wrong.\n\t- Did you run %s inside repository?\n\t- Check there's no file called 'cheatmenu' in %s.config is\n" "$0" "$HOME"
else
    printf "Link created! Now add a hotkey to start '%s.config/cheatmenu/generate-cheatsheet.sh' in your system or WM settings\n" "$HOME"
fi

