FROM ruby:3.4-slim-trixie

ENV DEBIAN_FRONTEND=noninteractive HOME=/rubyapp GEM_HOME=/rubyapp/.gems

# Installing:
#   - ffmpeg
#   - VIPS for ruby-vips,  Imagemagick for MiniMagick, GDK Pixbuf
#   - Libraw for ImageMagick for cameras RAW files
#   - libmagic - detecting file formats
#   - ghostscript - PDF conversion
#   - Ruby 3.3
RUN apt-get update -yq && apt-get dist-upgrade -yq && \
    echo "Installing binary dependencies..." && \
    apt-get install -yq --no-install-recommends \
                        imagemagick ffmpeg libvips ghostscript \
                        libraw-bin libmagic1 exiftool dumb-init git && \
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
    bundle install --clean --force --no-cache --system --without development && \
    /rubyapp/util/setup_imagemagick.sh && \
    apt-get remove -yq build-essential libraw-dev libvips-dev && apt-get autoremove -yq && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc,locale,zoneinfo,icons} && \
    rm -rf /var/lib/gems/*/cache /rubyapp/.bundle/cache /root/.bundle/cache

ADD . /rubyapp

CMD ["/rubyapp/docker/container_run.sh"]
