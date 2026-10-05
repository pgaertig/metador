FROM ruby:4.0-slim-trixie@sha256:db9ddd17cc6ac603f2497d98ac5c88e4118908d6f9a45f2422ebee141f91e485

ENV DEBIAN_FRONTEND=noninteractive HOME=/rubyapp GEM_HOME=/rubyapp/.gems

# Installing:
#   - ffmpeg
#   - VIPS for ruby-vips,  Imagemagick for MiniMagick, GDK Pixbuf
#   - Libraw for ImageMagick for cameras RAW files
#   - libmagic - detecting file formats
#   - ghostscript - PDF conversion
#   - jemalloc - improved allocator
RUN apt-get update -yq && apt-get dist-upgrade -yq && \
    echo "Installing binary dependencies..." && \
    apt-get install -yq --no-install-recommends \
                        imagemagick ffmpeg libvips ghostscript \
                        libraw-bin libmagic1 exiftool dumb-init git libjemalloc2 && \
    echo "Cleaning up..." && \
    apt-get -y autoremove && apt-get -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc,locale,zoneinfo,icons}


# These files need to be added first to reinvoke gems installation once they change
ADD Gemfile Gemfile.lock metador.gemspec /rubyapp/
ADD lib/metador/version.rb /rubyapp/lib/metador/version.rb
ADD util /rubyapp/util

# Installing gems with build dependencies. Once built dependencies are removed to keep image small.
RUN apt-get update -yq && \
    apt-get install -yq build-essential libraw-dev libvips-dev git && \
    cd /rubyapp && \
    bundle config set --local clean true && \
    bundle config set --local without development && \
    bundle install --force --no-cache && \
    /rubyapp/util/setup_imagemagick.sh && \
    apt-get remove -yq build-essential libraw-dev libvips-dev && apt-get autoremove -yq && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc,locale,zoneinfo,icons} && \
    rm -rf /var/lib/gems/*/cache /rubyapp/.bundle/cache /root/.bundle/cache

ADD . /rubyapp

CMD ["/rubyapp/docker/container_run.sh"]
