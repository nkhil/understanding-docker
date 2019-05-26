FROM node:9.3.0-alpine
# This will set the base image to node (https://hub.docker.com/_/node) with the `9.3.0` tag.

WORKDIR /app
# if /app doesn't exist, it will create it for you.

ADD . /app
# ADD takes 2 parametres. 1: source 2: destination

CMD ["node", "server.js"]
# Takes an array of parametres. 
