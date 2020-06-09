default: build

DOCKER_OPTIONS=-p 8888:8888 \
		-p 6680:6680 \
		--env MOUNT_POINT \
		--env ICECAST_PASSWORD \
		--env SPOTIFY_CLIENT_ID \
		--env SPOTIFY_CLIENT_SECRET \
		--env SPOTIFY_USERNAME \
		--env SPOTIFY_PASSWORD \
		--env SLACK_TOKEN

build:
	docker build -t slack-radio .

run-dev: build
	docker run -t -i \
		${DOCKER_OPTIONS} \
	slack-radio

run: 
	docker run -t -i \
		${DOCKER_OPTIONS} \
	bobmoriss/slack-radio
