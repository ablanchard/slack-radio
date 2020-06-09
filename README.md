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

### Requisites

`make` and `docker` are required. 
To add the bot on slack, you should be admin of your workspace. 
To listen to spotify a premium account is required.

### Env variables

To operate normally you need to declare some variables.

#### For the stream 

 - `MOUNT_POINT` where the stream will be available eg. `/slack-radio.mp3` 
 - `ICECAST_PASSWORD` a admin password. You can generate it.

#### For spotify connectivity

To use spotify, you need a premium account. You first need [to authenticate spotify with mopidy](https://mopidy.com/ext/spotify/)
 - `SPOTIFY_USERNAME`
 - `SPOTIFY_PASSWORD`
 - `SPOTIFY_CLIENT_ID`
 - `SPOTIFY_CLIENT_SECRET`

To use other sources of content. You can check out [this repo which explain other configurations](https://github.com/wernight/docker-mopidy) and add then to the image

#### To connect to Slack

You need first to configure a slack app by following [the readme of the plugin](https://github.com/ablanchard/mopidy-slack)
 - `SLACK_TOKEN`

## Utilisation

### Listen to music and request songs

The music playing on mopidy is stream to the port 8888. With the mount point you provided. Ex: https://localhost:8888/slack-radio.mp3

The chatbot is listening to all topics he is added to. He will responds to the following commands:
 - `request song_name [- artist_name]` Request a new song to be played
 - `start [playlist_name]` Start the radio broadcast. The bot will look for playlist starting with given name of fallback to the default playlist
 - `keep` Ask to keep the current playing song
 - `next` Ask to skip the current playing song
 - `help` Display the help

### Jingles

Every X (default: 1) songs a jingles is played between tracks. Jingles are generated when building the image using [espeak](http://espeak.sourceforge.net). You can customize the messages by modifying `jingles-en.txt` and rebuilding the image using `make build` and then use your images with `make run-dev`

## Rebuilding the image

`make build` rebuilds the image.

`make run-dev` runs the locally built image.

## Deploy to a server

`docker-compose.prod.yml` is a sample docker-compose file to deploy this app on a server with traefik v1.5 routing rules.

## Credits

This image is based on [wernight/docker-mopidy](https://github.com/wernight/docker-mopidy)