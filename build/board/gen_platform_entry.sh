#!/bin/bash

# helper script for automatic releases.
#
# Prints one platform entry for the given file to be added to the
# package_*.json file.


if [ $# -ne 4 ]; then
	echo
	echo "helper script for automatic releases."
	echo
	echo "Prints one platform entry for the given file to be added to the"
	echo "package_*_index.json file."
	echo
	echo "usage: $0 PLATFORMFILE PLATFORMVERSION sdccversion toolsversion"
	exit 1
fi

PLATFORMFILE=$1
PLATFORMVERSION=$2
SDCCVERSION=$3
TOOLSVERSION=$4
PACKAGER=nuvo

BASEURL=https://github.com/ohmex/nuvo/releases/download/v${PLATFORMVERSION}

### helper functions #####################################################

# format ID information for a file
print_filedata()
{
	FILENAME=$(basename "$1")
	URL=${BASEURL}/${FILENAME}
	SIZE=$(stat -c %s $1)
	CHKSUM=$(sha256sum $1|cut "-d " -f1)
cat << EOF
    "url": "$URL",
    "archiveFileName": "$FILENAME",
    "checksum": "SHA-256:$CHKSUM",
    "size": "$SIZE"
EOF
}



# list of supported boards in current boards.txt
list_boards()
{
	echo -n "    \"boards\": ["
	n=0
	sed -n "s/.*\.name=//p" ../../platform/mcs51/boards.txt |\
	while read line; do
		if [ $n -ne 0 ]; then echo -n ","; fi
		echo
		echo -n "        {\"name\": \"$line\"}"
		n=$((n+1))
	done
	echo
	echo "    ],"
}



### print a platform entry for the given file ############################

cat << EOF
{
    "name": "Nuvoton MCS51 plain C core (non-C++)",
    "architecture": "mcs51",
    "version": "$PLATFORMVERSION",
    "category": "Contributed",
EOF
list_boards
cat << EOF
    "toolsDependencies": [
        {
            "name": "ohmex",
            "version": "$TOOLSVERSION",
            "packager": "$PACKAGER"
        },
        {
            "name": "sdcc",
            "version": "build.$SDCCVERSION",
            "packager": "$PACKAGER"
        }
    ],
EOF
print_filedata "$PLATFORMFILE"
echo "},"
