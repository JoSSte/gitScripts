#!/bin/bash

# the newest version of this script can be found at https://github.com/JoSSte/gitScripts/blob/main/tag.sh

ACTION=$1
TAG_NAME=$2
if [ -z "$3" ]
then
    COMMIT=$(git rev-parse HEAD)
else
    COMMIT=$3
fi

SCRIPT_NAME=`basename $0`

# get list of current tags
IFS=$'\n' TAG_LIST=(`git tag`)
IFS=$'\n' REMOTE_LIST=(`git remote`)

# check if tag exists in tag list
function tag_exists() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

function delete_tag() {
    if [ $(tag_exists "${TAG_LIST[@]}" "$TAG_NAME") == "y" ]; then
        # delete locally
        git tag -d $TAG_NAME
        # delete on all remotes
        for CURRENT_REMOTE in "${REMOTE_LIST[@]}"
        do
            git push --delete $CURRENT_REMOTE $TAG_NAME
        done
    fi

}

function add_tag() {
    echo "Adding tag $TAG_NAME at commit $COMMIT"
    git tag -a $TAG_NAME -m "" $COMMIT
    for CURRENT_REMOTE in "${REMOTE_LIST[@]}"
    do
        git push $CURRENT_REMOTE $TAG_NAME
    done
}

if (( $# < 1 ))
then
    printf "%b" "Not enough arguments.\n" >&2
    printf "%b" "Usage:\n" >&2
    printf "%b" "  $SCRIPT_NAME add <tagname> <commit>\t\tAdds <tag> at <commit>. If <commit> is omitted, current commit is used\n" >&2
    printf "%b" "  $SCRIPT_NAME move <tagname> <commit>\tAdds tag at <commit>. If <commit> is omitted, current commit is used. if it exists, it will delete the existing tag\n" >&2
    printf "%b" "  $SCRIPT_NAME remove <tagname>\t\tRemoves tag from current git and all remotes\n" >&2
    printf "%b" "  $SCRIPT_NAME list\t\t\t\tList tags\n" >&2
    exit 1
fi

if [ $ACTION = "add" ]
then
    if [ $(tag_exists "${TAG_LIST[@]}" "$TAG_NAME") == "y" ]; then
        echo "Tag $TAG_NAME already exists."
        exit 1
    else
        add_tag
        exit 0
    fi
elif [ $ACTION = "move" ]
then
    if [ $(tag_exists "${TAG_LIST[@]}" "$TAG_NAME") == "y" ]; then
        echo "Tag $TAG_NAME already exists. Deleting"
        add_tag
        delete_tag
        exit 0
    else
        add_tag
        exit 0
    fi
elif [ $ACTION = "remove" ]
then 
    echo "removing $TAG_NAME"
    # does it exist?
    delete_tag
    exit 0
elif [ $ACTION = "list" ]
then
    for CURRENT_TAG in "${TAG_LIST[@]}"
    do
        echo "$CURRENT_TAG"
    done
    exit 0
else
    echo "unknown command $ACTION"
    exit 1
fi

