#!/bin/bash
#

docker-machine ssh default "sudo mount -t vboxsf grails /grails_work"
docker start dev
