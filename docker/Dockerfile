FROM debian:unstable

ENV DEBIAN_FRONTEND=noninteractive HOME=/rubyapp GEM_HOME=/rubyapp/.gems

# Installing:
#   - ffmpeg
#   - VIPS for ruby-vips,  Imagemagick for MiniMagick, GDK Pixbuf
#   - Uniconvertor (CDR + AI) and Ufraw for ImageMagick to convert CorelDRAW and RAW files
#   - libmagic - detecting file formats
#   - ghostscript - PDF conversion
RUN apt-get update -yq && apt-get upgrade -yq && \
    apt-get install -yq --no-install-recommends \
                        imagemagick ffmpeg libvips libgdk-pixbuf2.0-0 ghostscript \
                        libgirepository1.0 gir1.2-vips-8.0 gir1.2-gdkpixbuf-2.0 \
                        python-uniconvertor ufraw libmagic1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Ruby 2.3
RUN apt-get update -yq && apt-get install -yq --no-install-recommends ruby2.3 ruby bundler git && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RVM Ruby 2.3 installation
#RUN \curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
#    \curl -L https://get.rvm.io | bash -s stable && \
#    /bin/bash -l -c "rvm requirements" && \
#    /bin/bash -l -c "rvm install 2.3" && \
#    /bin/bash -l -c "gem install bundler --no-ri --no-rdoc" && \
#    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# These files need to be added first to reinvoke gems installation once they change
ADD Gemfile /rubyapp/Gemfile
ADD metador.gemspec /rubyapp/metador.gemspec
ADD lib/metador/version.rb /rubyapp/lib/metador/version.rb

# Installing gems with build dependencies. Once built dependencies are removed to keep image small.
RUN apt-get update -yq && \
    apt-get install -yq --no-install-recommends \
            ruby-dev libgirepository1.0-dev libgdk-pixbuf2.0-dev libvips-dev libgsf-1-dev nasm \
            && \
    cd /rubyapp && \
    bundle install --clean --without development && \
    apt-get remove -yq ruby-dev libgirepository1.0-dev libgdk-pixbuf2.0-dev libvips-dev libgsf-1-dev nasm && apt-get autoremove -yq && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ADD . /rubyapp

ENTRYPOINT ["/rubyapp/docker/container_run.sh"]
