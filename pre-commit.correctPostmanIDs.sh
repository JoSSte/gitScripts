#!/usr/bin/env bash

files=`git diff --cached --name-status | awk '$1 != "D" { print $2 }'`
for filename in $files; do
    if [ "${filename: -24}" == ".postman_collection.json" ]; then
        sed -i -r 's/"id": "([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})"/"id": "00000000-0000-0000-0000-000000000000"/gm' $filename
        git add $filename
        git commit --quiet --amend -C HEAD --no-verify
    fi
done
