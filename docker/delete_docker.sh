#!/usr/bin/env bash
sudo docker rmi -f $(sudo docker images | grep wittchenio | awk '{print $3}')
