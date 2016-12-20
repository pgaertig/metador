#!/bin/bash -ex
echo "Preparing common environment"
source /rubyapp-test/docker/prepare_env.sh

#apt-get install wget
#cd /tmp
#wget http://www.vips.ecs.soton.ac.uk/supported/current/vips-8.4.5.tar.gz
#tar xzf vips-8.4.5.tar.gz
#cd vips-8.4.5
#./configure
#make install

echo "Preparing test environment"
export BUNDLE_PATH=/tmp/.bundle/
export BUNDLE_APP_CONFIG=/tmp/test-app-cfg
cd /rubyapp-test

bundle config --global WITHOUT "dummy"
bundle config
time bundle install

export HOME=/root

# For manual convenience
cat << EOF > /root/.bash_history
exit
bundle exec guard
bundle exec rake test
EOF

echo 'Test environment prepared run "bundle exec rake test" or "bundle exec rake guard". Restart the container to reload gem dependencies.'

/bin/bash
