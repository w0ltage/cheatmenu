#!/usr/bin/env python3
import json
import logging
import sys

logging.basicConfig(
        level=logging.INFO,
        format="%(message)s"
        )

def burp2json(burp_config_file: str) -> dict:
    """Load burp config file"""
    logging.info("\nLoading your config file.")

    with open(burp_config_file, "r") as file:
        burp_config = json.load(file)

    return burp_config


def prettify_keys(key: str) -> str:
    """Replace underscores with whitespace and capialize first letter"""
    replace_underscore = key.replace("_", " ")
    capitalized = replace_underscore.capitalize()

    return capitalized

def change_keys(burp_json: dict) -> dict:
    """Extract hotkeys array from JSON, prettify them and return"""

    logging.info("\nExtracting and pretiffying your hotkeys.")

    keys = burp_json['user_options']['misc']['hotkeys']

    for key in keys:
        key_value = key['action']
        new_key = prettify_keys(key_value)
        key['action'] = new_key

    return keys


def create_config(destination_cheatsheet: str, hotkeys: dict):
    """Create (or overwrite if already exists) config with new hotkeys"""

    logging.info("\nCreating new config at %s", destination_cheatsheet)

    raw_config = {"application": "burpsuite", "cheatsheet": hotkeys}

    with open(destination_cheatsheet, 'w', encoding='utf-8') as file:
        json.dump(raw_config, file)

def main():
    if len(sys.argv) == 3:
        burp_config_file = sys.argv[1]
        destination_cheatsheet = sys.argv[2]
    else:
        logging.error(f"Usage: {sys.argv[0]} burpconfig_export.json burpsuite_keys.json\n\n'burpsuite_keys' will be the menu option for your hotkeys,\nso choose destination name wisely.")
        sys.exit(1)

    burp_json = burp2json(burp_config_file)
    hotkeys = change_keys(burp_json)

    create_config(destination_cheatsheet, hotkeys)

    logging.info("\nConfig created. Enjoy your cheatsheet!")
        


if __name__ == "__main__":
    main()
