#!/bin/bash -ex

# This script prepares libraw converter and configures ImageMagic to process all RAW images thru it.

SCRIPTDIR=$(dirname `readlink -f $0`)
gcc -lraw -w $SCRIPTDIR/libraw_convert.c -o $SCRIPTDIR/libraw_convert
cp $SCRIPTDIR/libraw_convert /usr/bin/

#In case below fails delegates.xml needs to be revised for any changes
DELEGATES_SHA=(`sha1sum /etc/ImageMagick-6/delegates.xml`)
[ "$DELEGATES_SHA" == "5451e4bff881f3892f2c41e39511295555e78079" ]

cp $SCRIPTDIR/delegates.xml /etc/ImageMagick-6/

