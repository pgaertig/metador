FROM debian:unstable
ENV DEBIAN_FRONTEND noninteractive

# Installing:
#   - ffmpeg
#   - Uniconvertor (CDR + AI) and Ufraw for ImageMagick to convert CorelDRAW and RAW files
#   - VIPS for ruby-vips and Imagemagick for MiniMagick

RUN apt-get update -yq && apt-get upgrade -yq && \
    apt-get install -yq imagemagick ffmpeg libvips libgdk-pixbuf2.0-0 python-uniconvertor ufraw libgsf-1-dev nasm git && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update -yq && apt-get install -yq ruby2.3 ruby bundler && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


#RUN \curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
#    \curl -L https://get.rvm.io | bash -s stable && \
#    /bin/bash -l -c "rvm requirements" && \
#    /bin/bash -l -c "rvm install 2.3" && \
#    /bin/bash -l -c "gem install bundler --no-ri --no-rdoc" && \
#    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD Gemfile /rubyapp/Gemfile
ADD metador.gemspec /rubyapp/metador.gemspec
ADD lib/metador/version.rb /rubyapp/lib/metador/version.rb
ENV HOME /rubyapp
ENV GEM_HOME /rubyapp/.gems
WORKDIR /rubyapp

RUN apt-get update -yq && apt-get install -yq libgirepository1.0-dev libgdk-pixbuf2.0-dev libvips-dev && \
    bundle install --clean --without development && \
    apt-get remove -yq libgirepository1.0-dev libvips-dev && apt-get autoremove -yq && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /rubyapp
ENV ENV production
ENTRYPOINT ["/rubyapp/docker/container_run.sh"]
