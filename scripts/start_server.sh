#!/bin/bash
docker stop $(docker ps -q) || true
docker rm $(docker ps -a -q) || true
docker rmi static-site || true
docker build -t static-site .
docker run -d -p 80:80 static-site
    