# gitScripts
scripts to make life with git easier.



## [pre-commit.sanitizePostmanUUIDs.sh](pre-commit.sanitizePostmanUUIDs.sh)

### Description
This pre-commit script goes through all the files in the commit, and finds \*.postman_collection.json files.

Upon finding such a file, it will look for **"id"** and **"_postman_id"** values that are formed as UUIDs and replace them with all-zero UUIDs.

This is done to ensure that the differences on your code is what actually gives you value, and not a load of UUIDs that change on every commit.

The file is staged and a message to review the changes is written to the console.

### Usage

copy the file to your projects `.git/hooks` folder and rename to `pre-commit`


## [sanitizePostmanUUIDs.sh](sanitizePostmanUUIDs.sh)

### Description 
This is essentially independent of git. It does the same as [pre-commit.sanitizePostmanUUIDs.sh](pre-commit.sanitizePostmanUUIDs.sh) but only for the single file given as a parameter.

### Usage
`/path/to/sanitizePostmanUUIDs.sh /path/to/postmanstuff.postman_collection.json`
