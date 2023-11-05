#!/bin/bash

sheets_dir="$XDG_CONFIG_HOME/cheatmenu/sheets/"

printf "\n\n[+] Updating cheatsheets\n\n"

if cd "$sheets_dir" && git pull;
then
    printf "\n[+] Updated!\n"
else
    printf "\n[-] Updating failed.\n"
fi

