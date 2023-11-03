#!/bin/bash

sheets_repo="https://ithub.com/tokiakasu/cheatmenu-sheets.git"
download_cmd=

printf "[+] Updating cheatsheets"

if ! cd sheets && git pull "$sheets_repo";
then
    printf "\n[-] Updating failed.\n"
else
    printf "\n[+] Updated!\n"
fi

