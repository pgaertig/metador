#!/bin/bash -ex

# Installs customised ImageMagick delegates.xml and policy.xml after verifying the stock ones did not change.

SCRIPTDIR=$(dirname `readlink -f $0`)

# In case below fails delegates.xml needs to be revised for any changes
DELEGATES_SHA=(`sha1sum /etc/ImageMagick-7/delegates.xml`)
[ "$DELEGATES_SHA" == "badc5aaec3f22c28a6224852784a53621ce485b0" ]

cp $SCRIPTDIR/delegates.xml /etc/ImageMagick-7/

# In case below fails policy.xml needs to be revised for any changes
# Current hash is from imagemagick-7-common 8:7.1.1.43+dfsg1-1+deb13u11
POLICY_SHA=(`sha1sum /etc/ImageMagick-7/policy.xml`)
[ "$POLICY_SHA" == "0fbce8c211e3e905610201aa8bbf82bd9787a512" ]

cp $SCRIPTDIR/policy.xml /etc/ImageMagick-7/

