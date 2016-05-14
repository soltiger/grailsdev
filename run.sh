#!/bin/bash
#

docker-machine ssh default "sudo mount -t vboxsf grails /grails_work"
docker run -d -p 3000:22 -p 8080:8080 -v /grails_work:/work --name dev soltiger/grailsdev
