# Notes on Docker

[![Iar-XT5o-Y-400x400.png](https://i.postimg.cc/TYhZNyp3/Iar-XT5o-Y-400x400.png)](https://postimg.cc/2VRcVSQs)

## Docker engine

**Note:** The following notes are from [krammark23](https://www.youtube.com/watch?v=T25Z4CUwYjE)'s excellent series on Docker. All credit goes to him.

Docker engine is basically the docker environment where your containers live, kind of like the V8 engine that is able to read your docker files in order to follow instructions and re-create your docker containers.

The docker engine controls how much CPU/RAM etc each of your containers uses.

Docker only exposes your kernel on the machine it runs on. For instance, if you run a docker engine on a Macbook, it will only access the kernel without interacting with the rest of the OS at all.

Your container will need to package an operating system in order to run. So, your containers could have different operating systems to the host machine, but 90% of the time, all the OSes you run in your engine should use the same kernel. This is also possibly why docker running locally is slower than on linux.

For the container inside your docker engine, it also needs to bundle in the OS, as well as all the other dependencies in order to run. Once you have these dependencies, you will create a `Dockerfile`, which is essentially a list of instructions you pass into the docker engine to tell it how to build your container.

Once you have your docker file written out, use the `docker build` command to pass in your `Dockerfile` into the docker engine. Docker engine follows the instructions within the `Dockerfile` in order to build a docker `image` which is then used to start a container.

**Sidenote:** If your code needs to be compiled into an executable, you can still compile your code manually and specify instructions inside the `Dockerfile`. OR, you can add instructions in your `Dockerfile` that states how to compile your executable, which will automate the compile step.

Once you have your docker `image`, you can run the `docker run` command to start a container based on that image.

This container will run alongside all your other containers you might have inside your docker engine.

These other containers are isolated from each other so they can't interfere with each other. Docker engine is able to manage the resources each of these containers are allowed to use.

Every time you run the `docker build` command, you're not replacing the old docker image. What happens is new docker images are being constantly created (every tim you run `docker build`). Docker engine doesn't just manage your running containers, but serves as a repository for all the docker images you've created. Whenever you run the `docker run` command, you're specifying the docker image that's currently in your repository, and `docker run` is just running that image as a container inside the engine.

The thing that really makes Docker special isn't just that it can control the resources each container can use. It's the fact that you can take any docker image, and you can start it up as a container on a different system, and you can be sure that the new container will run the same way the original container runs on your computer. This portability is what makes Docker special, and popular.

When you're making software for the cloud, docker allows you to develop locally, test locally, and ship your code to another machine in the cloud and guarantee that your code will run in the same way in the cloud that it runs locally.

## Commands

- `docker build .` while you're in the desired root repository.

- `docker build . -t new-repository-name:new-tag-name` to build with a specific repo and tag name.

- `docker images` to list all images.

- `docker run -it <$image_id> /bin/sh` - the `/bin/sh` tells it to load up the shell which is located at `/bin/sh`. the `-it` flag is to map your keyboard input to stdin so you can type commands directly into the container. (note `image_id` is replaced by the actual ID). You can use commands in here like `pwd`, `ls`, `touch` etc in here.

As long as this process is running, your docker container is running. If you for eg type `exit`, the docker container will stop.

Before you close this, try running

- `docker ps` (stands for processes) will show you all the process running. Now if you exit the shell, and then try `docker ps` you will not see that container.

- `docker run -p <$localport>:<$dockerport>` maps a port on your local machine to a port on your docker container.

For eg: `docker run -p 8001:8000` maps the port `8001` on the local machine to `8000` on the docker container.

- `docker stop <$container-id>` to stop the container from running. For eg: `docker stop 0e019041263a`

- `ctrl + p + q` to detach the terminal from the docker container. The contailer will still be running (which can be verified by running `docker ps`)

Make sure you're running the container like so: `docker run -p 8000:8000 -it 2a2193a6c429 node server.js` where `2a2193a6c429` is the image ID. The `-it` part is what makes the `ctrl + p, ctrl + q` combo to work.

- If you make any changes to your `Dockerfile`, make sure you're running `docker build . -t <$repo-name>:<$tag-name>` or it won't update.

- When you build a new image with the same repo name and tag name that existed before, it will re-assign it to the newest build, and change the old repo and tags to `<none>`.

- Running something like `docker run -d -p 8000:8000 2f177eb214b2` with the `-d` flag automatically runs it in the bg. Try using it and then running `docker ps`.

## Creating a simple node app

```docker
FROM node:9.3.0-alpine
# This will set the base image to node (https://hub.docker.com/_/node) with the `9.3.0` tag.

WORKDIR /app
# if /app doesn't exist, it will create it for you.

ADD . /app
# ADD takes 2 parametres. 1: source 2: destination

CMD ["node", "server.js"]
# Takes an array of parametres.

```

## How to debug your `Dockerfile`

[Source](https://www.youtube.com/watch?v=RH_I0KXHBcA)

When you run `docker run <$image-id>`, it creates intermediate docker images that you can launch, and try to run the right version of scripts to see if it creates the desired action. If it does, you can now go back to your docker file and make the changes there.
