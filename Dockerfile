FROM debian:wheezy

MAINTAINER Werner Beroux <werner@beroux.com>

# Official Mopidy install for Debian/Ubuntu along with some extensions
# (see https://docs.mopidy.com/en/latest/installation/debian/ )
ADD https://apt.mopidy.com/mopidy.gpg /tmp/mopidy.gpg
ADD https://apt.mopidy.com/mopidy.list /etc/apt/sources.list.d/mopidy.list

RUN apt-key add /tmp/mopidy.gpg

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    mopidy \
    mopidy-soundcloud \
    mopidy-spotify

# Install more extensions via PIP.
ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py
RUN python /tmp/get-pip.py
RUN pip install -U six
RUN pip install \
    Mopidy-Moped \
    Mopidy-GMusic \
    Mopidy-YouTube

# Clean-up to save some space
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Run as mopidy user
#RUN useradd --system --uid 377 -M --shell /usr/sbin/nologin mopidy
USER mopidy

# Default configuration
RUN mkdir -p ~/.config/mopidy
ADD mopidy.conf /var/lib/mopidy/.config/mopidy/mopidy.conf

VOLUME /var/lib/mopidy/local
VOLUME /var/lib/mopidy/media

EXPOSE 6600
EXPOSE 6680

ENTRYPOINT ["/usr/bin/mopidy"]
