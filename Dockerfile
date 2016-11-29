FROM debian:jessie

MAINTAINER Werner Beroux <werner@beroux.com>

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
 && curl -L https://apt.mopidy.com/mopidy.gpg -o /tmp/mopidy.gpg \
 && curl -L https://apt.mopidy.com/mopidy.list -o /etc/apt/sources.list.d/mopidy.list \
 && apt-key add /tmp/mopidy.gpg \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        mopidy \
	icecast2 \
	git \
 && curl -L https://bootstrap.pypa.io/get-pip.py | python - \
 && pip install -U six \
 && pip install \
        Mopidy-Moped \
        Mopidy-YouTube \
        mopidy-musicbox-webclient \
        sleekxmpp \
 && apt-get purge --auto-remove -y \
        curl \
        gcc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

RUN git clone https://github.com/ablanchard/mopidy-hipchat.git \
 && cd mopidy-hipchat \
 && pip install . --upgrade \
 && cd ..

RUN git clone https://github.com/ablanchard/mopidy-dashing.git \
 && cd mopidy-dashing \
 && pip install . --upgrade \
 && cd ..

RUN git clone https://github.com/rusty-dev/mopidy-deezer.git \
 && cd mopidy-deezer \
 && pip install . --upgrade \
 && cd ..

# Default configuration
COPY mopidy.conf /root/.config/mopidy/mopidy.conf

# icecast config
COPY icecast.xml /usr/share/icecast2/icecast.xml
COPY icecast2 /etc/default/icecast2
COPY silence.mp3 /usr/share/icecast2/silence.mp3

RUN chown -R icecast2:icecast /usr/share/icecast2

VOLUME /var/lib/mopidy/local
VOLUME /var/lib/mopidy/media

EXPOSE 6600
EXPOSE 6680
EXPOSE 8888

CMD service icecast2 start && /usr/bin/mopidy
