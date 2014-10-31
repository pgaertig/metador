FROM debian:unstable
ENV DEBIAN_FRONTEND noninteractive

# Installing ffmpeg
RUN apt-get update -yq && \
    apt-get install -yq ffmpeg && \
    apt-get clean && \
    ffmpeg -version

# Installing VIPS for ruby-vips and Imagemagick for MiniMagick
RUN apt-get update -yq && \
    apt-get install -yq libvips libvips-dev libgdk-pixbuf2.0-0 libgsf-1-dev nasm git \
            imagemagick && \
    apt-get clean

# Installing Ruby 2.1
RUN apt-get update -yq && \
    apt-get install -yq ruby ruby2.1 bundler && \
    apt-get clean

# Installing Uniconvertor (CDR + AI) and Ufraw for ImageMagick to convert CorelDRAW and RAW files
RUN apt-get install -yq python-uniconvertor ufraw && apt-get clean

RUN adduser --disabled-password --home=/rubyapp --gecos "" rubyapp
ADD Gemfile /rubyapp/Gemfile
ADD metador.gemspec /rubyapp/metador.gemspec
ADD lib/metador/version.rb /rubyapp/lib/metador/version.rb
ENV HOME /rubyapp
ENV GEM_HOME /rubyapp/.gems
WORKDIR /rubyapp
RUN bundle install --clean --without development

ADD . /rubyapp
#RUN chown -R rubyapp:rubyapp /rubyapp

#USER rubyapp
ENV ENV production
CMD exec bundle exec ./bin/metador-worker 2>&1 >> /mnt/logs/$HOSTNAME.log
