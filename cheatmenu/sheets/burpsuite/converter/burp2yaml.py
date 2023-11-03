#!/usr/bin/env python3
import yaml
import json
import logging
import sys

logging.basicConfig(
        level=logging.INFO,
        format="%(message)s"
        )

def burp2json(burp_config_file: str) -> dict:
    """Load burp config file"""
    logging.info("[+] Loading your config file.")

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

    logging.info("[+] Extracting and pretiffying your hotkeys.")

    keys = burp_json['user_options']['misc']['hotkeys']

    for key in keys:
        key_value = key['action']
        new_key = prettify_keys(key_value)
        key['action'] = new_key

    return keys


def create_config(hotkeys: dict):
    """Create (or overwrite if already exists) config with new hotkeys"""

    logging.info("[+] Creating new config at burpsuite.yaml")

    raw_config = {"application": "burpsuite", "shortcuts": hotkeys}
    config_name = "burpsuite.yaml"

    with open(config_name, 'w', encoding='utf-8') as file:
        yaml.dump(raw_config, file)

def main():
    if len(sys.argv) == 2:
        burp_config_file = sys.argv[1]
    else:
        logging.error(f"Usage: {sys.argv[0]} burpconfig_export.json")
        sys.exit(1)

    burp_json = burp2json(burp_config_file)
    hotkeys = change_keys(burp_json)

    create_config(hotkeys)

    logging.info("[+] Config created. Enjoy your cheatsheet!")
        


if __name__ == "__main__":
    main()
