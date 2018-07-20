#!/usr/bin/env bash
container_id=$(sudo docker ps -q --filter ancestor=wittchenio)
sudo docker kill $container_id
