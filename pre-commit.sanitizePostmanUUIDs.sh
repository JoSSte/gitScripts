#!/usr/bin/env bash

# Sanitize postman collection for UUIDs

# Newest version available here: https://github.com/JoSSte/gitScripts/blob/main/pre-commit.sanitizePostmanUUIDs.sh
#
# This pre-commit script goes through all the files in the commit, and finds *.postman_collection.json files.
# Upon finding such a file, it will look for "id" and "_postman_id" values that are formed as UUIDs and replace them with all-zero UUIDs.
# This is done to ensure that the differences on your code is what actually gives you value, and not a load of UUIDs that change on every commit.
# The file is staged and a message is displayed

#save delimiter
SAVEIFS=$IFS
#set delimiter to something else than space
IFS=$(echo -en "\n\b")

#get the changed files
files=`git diff --staged --name-only`
#set changed flag to false
CHANGED=false
for filename in $files; do
    if [ "${filename: -24}" == ".postman_collection.json" ]; then
        sed -i -r 's/"(_postman_id|id)": "([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})"/"\1": "00000000-0000-0000-0000-000000000000"/gm' "$filename"
        git add $filename
        # mark changed flag true
        CHANGED=true
    fi
done

#reset delimiter
IFS=$SAVEIFS


# if files have been changed (potentially) display a message and abort the commit
if $CHANGED; then
    echo "PRE-COMMIT: Postman collection found. UUIDs have been sanitized. Please verify and recommit"
    exit 1
fi
