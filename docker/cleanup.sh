#!/usr/bin/env bash

docker volume rm $(docker volume ls -qf dangling=true);
docker volume ls -qf dangling=true | xargs -r docker volume rm;
docker rmi $(docker images --filter "dangling=true" -q --no-trunc);
docker rmi $(docker images | grep "none" | awk '/ / { print $3 }');
docker rm $(docker ps -qa --no-trunc --filter "status=exited");
