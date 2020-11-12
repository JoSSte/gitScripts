#!/usr/bin/env bash

# Check the command line argument value exists or not
if [ $1 != "" ]; then

    if [ $1 == "--help" ]; then

        echo "Replaces UUIDs in *.postman_collection.json exported files with 00000000-0000-0000-0000-000000000000"
        exit 0
    else

        if [ "${1: -24}" == ".postman_collection.json" ]; then

            echo "Removing IDs from $1"
            # stat -c %y "$1" # show last modified time

            # format:   60ff37a6-9bf7-4cb4-b142-2da499f4b86e
            #           00000000-0000-0000-0000-000000000000
            #           12345678-1234-1234-1234-123456789012

            sed -i -r 's/"(_postman_id|id)": "([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})"/"\1": "00000000-0000-0000-0000-000000000000"/gm' "$1"

        else

            echo "Your file MUST end on .postman_collection.json or else it will not be parsed! \"$1\" is not valid"
            exit 1

        fi

    fi
fi
