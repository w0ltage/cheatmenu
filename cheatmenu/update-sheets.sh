#!/bin/bash

sheets_repo="https://github.com/tokiakasu/cheatmenu-sheets.git"
sheets_dir="$XDG_CONFIG_HOME/cheatmenu/sheets/"

printf "\n\n[+] Updating cheatsheets\n\n"

if cd "$sheets_dir" && git pull "$sheets_repo";
then
    printf "\n[+] Updated!\n"
else
    printf "\n[-] Updating failed.\n"
fi

