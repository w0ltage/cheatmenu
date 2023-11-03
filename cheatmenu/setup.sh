#!/bin/bash

create_link() {
    cheatmenu_directory="$XDG_CONFIG_HOME/cheatmenu" \
        && ln -nsf "$PWD" "$cheatmenu_directory"

    if [[ $? -eq 1 ]]; then
        printf "Something goes wrong.\n\t- Did you run %s inside the repository?\n\t- Check if there's no file called 'cheatmenu' in %s/.config is\n" "$0" "$HOME"
    else
        printf "\n\n[+] $PWD \n    is linked to %s/cheatmenu\n\n" "$XDG_CONFIG_HOME"  
        printf "Now you need to map a shortcut to execute\n'%s/.config/cheatmenu/cheatgenerator.sh'.\n\n" "$HOME"
        printf "For example, I'm using a combination\n'super + alt + Home' to execute the cheatgenerator.sh\n"
    fi
}

install_font() {
    font="JetBrainsMono"

    check_installed="$(fc-list | grep $font)"

    if [[ $check_installed ]]; then 
        printf "\n[!] %s is already installed,\n    cancelling installation.\n\n" "$font"
    else
        printf "\n[+] Installing %s font" "$font"

        wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip \
            && cd ~/.local/share/fonts && unzip $font.zip && rm $font.zip && fc-cache -fv

        if ! [[ $? -eq 0 ]]; then
            printf "\n\n[-] Something goes wrong, skipping font installation.\n    "
            printf "Try to install %s manually with these references:\n    " "$font"
            printf "https://gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0"
        fi
    fi
}


install_dependencies() {
    dependency="go-yq"
    check_yq=$(yq -V)
    correct_yq_signature="github.com/mikefarah/yq"

    if which yq &>/dev/null; then
        printf "\n[+] yq is installed, lets check a version"
        if [[ "$check_yq" == *"$correct_yq_signature"* ]]; then
            printf "\n[+] The correct version of yq is installed.\n\n"
        else
            printf "\n[-] Incorrect version of yq is installed.\n    "
            printf "Replace current yq with this:\n    "
            printf "https://github.com/mikefarah/yq"
        fi
    else 
        if sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && sudo chmod +x /usr/bin/yq; then
            printf "\n[+] %s installed." "$dependency"
        else
            printf "\n[-] %s not installed." "$dependency"
        fi
    fi
    

    if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
        dependency="wofi xclip wget fontconfig"
    elif [ "$XDG_SESSION_TYPE" == "x11" ]; then
        dependency="rofi xclip wget fontconfig"
    else 
        printf "\n[!] Didn't find your session type. Closing your reality."
        exit 1
    fi


    if command -v apt &> /dev/null; then
        if sudo apt update && sudo apt install -y $dependency; then
            printf "\n[+] %s installed." "$dependency"
        else
            printf "\n[-] %s not installed." "$dependency"
        fi
    else
        printf "\n[!] No 'apt' is available.\n    "
        printf "Install %s manually with your packet manager" "$dependency"
    fi
}


# check if XDG_CONFIG_HOME variable is set
if [[ -z $XDG_CONFIG_HOME ]]; then
    printf "\n[!] Add to your shell config:\nexport XDG_CONFIG_HOME=\"\$HOME/.config/\"\n"
    printf "\n\$XDG_CONFIG_HOME defines the base directory relative \nto which user-specific configuration files should be stored.\n"
    exit 1
else
    # copied from here
    # https://stackoverflow.com/questions/226703/how-do-i-prompt-for-yes-no-cancel-input-in-a-linux-shell-script/27875395#27875395
    read -n 1 -p "Install JetBrainsMono font? (y/n) " answer

    if [ "$answer" != "${answer#[Yy]}" ];then
        install_font
    else
        printf "\n[!] Font installation is cancelled.\n\n"
    fi


    read -n 1 -p "\nInstall go-yq rofi and xclip? (y/n) " answer

    if [ "$answer" != "${answer#[Yy]}" ];then
        install_dependencies
    else
        printf "\n[!] Depencies installation is cancelled.\n\n"
    fi

    create_link

fi

