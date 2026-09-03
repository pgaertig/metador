#!/bin/bash
echo "ffmpeg `ffmpeg -version`"
echo "Ruby `ruby -v`"
echo "ImageMagick `magick -version`"

export USER_ID=${LOCAL_USER_ID:-1000}
export GROUP_ID=${LOCAL_GROUP_ID:-1000}
export ENV=${CONFIG_ENV:-development}

export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export LD_LIBRARY_PATH=/usr/local/lib
export GI_TYPELIB_PATH=/usr/local/lib/girepository-1.0

echo "Starting with UID=$USER_ID and GID=$GROUP_ID"
groupadd -g $GROUP_ID -o rubyapp
useradd --shell /bin/bash -u $USER_ID -o -c "" -g $GROUP_ID rubyapp