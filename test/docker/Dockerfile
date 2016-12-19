FROM pgaertig/metador:latest

# Install dev dependencies for bundle install rerun
RUN apt-get -y  update && apt-get install -y --no-install-recommends \
                ruby-dev libgirepository1.0-dev libgdk-pixbuf2.0-dev libvips-dev libgsf-1-dev nasm

ENTRYPOINT ["/rubyapp-test/test/docker/prepare_test_env.sh"]