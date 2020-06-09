FROM debian:buster

# Official Mopidy install for Debian/Ubuntu along with some extensions
# (see https://docs.mopidy.com/en/latest/installation/debian/ )
RUN set -ex \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        gcc \
        gstreamer1.0-alsa \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-ugly \
        python-crypto \
        gnupg2 \
 && curl -L https://apt.mopidy.com/mopidy.gpg -o /tmp/mopidy.gpg \
 && curl -L https://apt.mopidy.com/buster.list -o /etc/apt/sources.list.d/mopidy.list \
 && apt-key add /tmp/mopidy.gpg \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
       mopidy \
       icecast2 \
       sed \
       mopidy-spotify \
       python3-pip \
       sox \
       espeak \
 && pip3 install -U six \
 && pip3 install Mopidy-MusicBox-Webclient Mopidy-Slack Mopidy-Jingle \
 && apt-get purge --auto-remove -y \
        curl \
        gcc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

# Jingles
COPY jingles-en.txt /jingles-en.txt
COPY gen_jingles.sh /gen_jingles.sh
RUN /gen_jingles.sh

# Default configuration
COPY conf/mopidy.conf /root/.config/mopidy/mopidy.conf
COPY entrypoint.sh /entrypoint.sh

# icecast config
COPY icecast.xml /usr/share/icecast2/icecast.xml
COPY icecast2 /etc/default/icecast2
COPY silence.mp3 /usr/share/icecast2/web/silence.mp3

# Exposing mopidy web server & icecast
EXPOSE 6680 8888

ENTRYPOINT "/entrypoint.sh"
