FROM pgaertig/metador:latest

# Install dev dependencies for bundle install rerun
RUN apt-get -y  update && apt-get install -y --no-install-recommends \
                build-essential libvips-dev

ENTRYPOINT ["/rubyapp-test/test/docker/prepare_test_env.sh"]