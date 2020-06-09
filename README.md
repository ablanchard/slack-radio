# Slack-radio

Start your own webradio, with user request given via Slack.

## Components

This repo contains a docker image of mopidy customized with plugins to make it happen:
 - Spotify plugin (you can use any sources you want)
 - Icecast configuration (to broadcast the stream as mp3)
 - Slack plugin (let's users request songs)
 - Jingle plugin, play a little jingle between tracks
 - Musibox Frontend (to administrate your server)

## Installation

All commands are packaged in the `Makefile` to start you need to configure the env variables and then run start the server with `make run`

### Env variables

To operate normally you need to declare some variables.

#### For the stream 

 - `MOUNT_POINT` where the stream will be available eg. `/slack-radio.mp3` 
 - `ICECAST_PASSWORD` a admin password

#### For spotify connectivity

To use spotify, you need a premium account. You can also use other sources of content. You can check out [this repo which explain other configurations](https://github.com/wernight/docker-mopidy)
 - `SPOTIFY_USERNAME`
 - `SPOTIFY_PASSWORD`
 - `SPOTIFY_CLIENT_ID`
 - `SPOTIFY_CLIENT_SECRET`

#### To connect to Slack

You need first to configure a slack app by following [the readme of the plugin](https://github.com/ablanchard/mopidy-slack)
 - `SLACK_TOKEN`

## Jingles

Jingles are generated when building the image using [espeak](http://espeak.sourceforge.net) You customize the messages by modifying `jingles-en.txt` and rebuilding the image using `make build`

## Credits

This image is based on [wernight/docker-mopidy](https://github.com/wernight/docker-mopidy)