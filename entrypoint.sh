#!/bin/sh

sed -i "s|__MOUNT_POINT__|$MOUNT_POINT|" /usr/share/icecast2/icecast.xml
sed -i "s|__MOUNT_POINT__|$MOUNT_POINT|" /root/.config/mopidy/mopidy.conf

sed -i "s/__ICECAST_PASSWORD__/$ICECAST_PASSWORD/" /usr/share/icecast2/icecast.xml
sed -i "s/__ICECAST_PASSWORD__/$ICECAST_PASSWORD/" /root/.config/mopidy/mopidy.conf
chown -R icecast2:icecast /usr/share/icecast2
service icecast2 start

/usr/bin/mopidy \
    -o spotify/client_id=$SPOTIFY_CLIENT_ID \
	-o spotify/client_secret=$SPOTIFY_CLIENT_SECRET \
    -o spotify/username=$SPOTIFY_USERNAME \
	-o spotify/password=$SPOTIFY_PASSWORD \
	-o slack/bot_token=$SLACK_TOKEN
