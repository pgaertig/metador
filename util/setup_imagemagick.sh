#!/bin/bash -ex

# This script prepares libraw converter and configures ImageMagic to process all RAW images thru it.

SCRIPTDIR=$(dirname `readlink -f $0`)
SRC="$SCRIPTDIR/libraw_convert.c"
OUT="$SCRIPTDIR/libraw_convert"

# Prefer pkg-config if available so include paths and libs are correct for the installed libraw.
if command -v pkg-config >/dev/null 2>&1 && pkg-config --exists libraw; then
  CFLAGS=$(pkg-config --cflags libraw)
  LDFLAGS=$(pkg-config --libs libraw)
  gcc -w $CFLAGS "$SRC" -o "$OUT" $LDFLAGS
else
  # Older systems or missing pkg-config: ensure -lraw is placed after the source so the linker finds symbols.
  gcc -w "$SRC" -o "$OUT" -lraw
fi

cp "$OUT" /usr/bin/

# In case below fails delegates.xml needs to be revised for any changes
DELEGATES_SHA=(`sha1sum /etc/ImageMagick-7/delegates.xml`)
[ "$DELEGATES_SHA" == "badc5aaec3f22c28a6224852784a53621ce485b0" ]

cp $SCRIPTDIR/delegates.xml /etc/ImageMagick-7/

# In case below fails policy.xml needs to be revised for any changes
POLICY_SHA=(`sha1sum /etc/ImageMagick-7/policy.xml`)
[ "$POLICY_SHA" == "8b683209a588ca015ddddbe80f25c2fa444b863d" ]

cp $SCRIPTDIR/policy.xml /etc/ImageMagick-7/

