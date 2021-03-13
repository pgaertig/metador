#!/bin/bash -ex

# This script prepares libraw converter and configures ImageMagic to process all RAW images thru it.

SCRIPTDIR=$(dirname `readlink -f $0`)
gcc -lraw -w $SCRIPTDIR/libraw_convert.c -o $SCRIPTDIR/libraw_convert
cp $SCRIPTDIR/libraw_convert /usr/bin/

#In case below fails delegates.xml needs to be revised for any changes
DELEGATES_SHA=(`sha1sum /etc/ImageMagick-6/delegates.xml`)
[ "$DELEGATES_SHA" == "7ad9096a3500fea41b8952deae7d848ab5f8f3e3" ]

cp $SCRIPTDIR/delegates.xml /etc/ImageMagick-6/

POLICY_SHA=(`sha1sum /etc/ImageMagick-6/policy.xml`)
[ "$POLICY_SHA" == "a81655041f92a925e7a51ed71553ceed165f8475" ]

cp $SCRIPTDIR/policy.xml /etc/ImageMagick-6/