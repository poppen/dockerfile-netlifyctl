#!/bin/sh

export CI_BUILD_SHA="x${CI_BUILD_REF:0:8}"
export IMAGE_TMP_NAME=$(echo "$CI_REGISTRY_IMAGE" | tr '[:upper:]' '[:lower:]')

# Automatically login docker
docker() {
	if [ ! -e ~/.docker/config.json ]; then
		command docker login -u $GITLAB_USER_LOGIN -p $CI_BUILD_TOKEN registry.gitlab.com
	fi
	command docker "$@"
}

# Automatically install docker-cloud
docker_cloud() {
	if ! which docker-cloud >/dev/null 2>/dev/null; then
		# Install Docker Cloud
		apk --update add python py-pip >/dev/null
		pip install docker-cloud >/dev/null
	fi

	command docker-cloud "$@"
}

docker_build_push() {
	echo Building docker image...
	docker build --pull -t $IMAGE_TMP_NAME:$1 .

	echo Pushing docker image...
	docker push $IMAGE_TMP_NAME:$1
}

docker_tag_push() {
	echo Pulling docker image...
	docker pull $IMAGE_TMP_NAME:$1 >/dev/null

	echo Tagging docker image...
	docker tag $IMAGE_TMP_NAME:$1 $IMAGE_TMP_NAME:$2

	echo Pushing docker image...
	docker push $IMAGE_TMP_NAME:$2
}
