# shellbro/devbox-clojure

[![](https://img.shields.io/docker/cloud/build/shellbro/devbox-clojure)](https://hub.docker.com/r/shellbro/devbox-clojure/)

Container image for development of Clojure apps & CI build.

# Running local development environment

From the root directory of your Clojure project start standalone REPL inside
a container:

```
$ docker run --rm -it --detach-keys=ctrl-@ -v $HOME/.m2:/home/app-user/.m2 -v $PWD:/usr/local/src/app -p 2000:2000 shellbro/devbox-clojure
```

You can customize the port number over which nREPL is available on the localhost
by exposing it on another port. For example, to change the port number from 2000
to 2001 run:

```
$ docker run --rm -it --detach-keys=ctrl-@ -v $HOME/.m2:/home/app-user/.m2 -v $PWD:/usr/local/src/app -p 2001:2000 shellbro/devbox-clojure
```

Once nREPL for your project is running you can connect to it from `CIDER`:

```
M-x cider-connect
> localhost
> 2000
```

# CI/CD build stage

Example Dockerfile:

```
FROM shellbro/devbox-clojure as builder

ARG LOGIN=app-user

COPY --chown=$LOGIN:$LOGIN project.clj /usr/local/src/app
RUN lein deps
COPY --chown=$LOGIN:$LOGIN . /usr/local/src/app
RUN mv "$(lein uberjar | sed -n 's/^Created \(.*standalone\.jar\)/\1/p')"\
    app-standalone.jar

###

FROM openjdk:11-jre

ARG UID=1000
ARG GID=1000
ARG LOGIN=app-user

RUN groupadd -g $GID $LOGIN && useradd -u $UID -g $GID -m $LOGIN
COPY --from=builder --chown=$LOGIN:$LOGIN /usr/local/src/app/app-standalone.jar \
     /home/$LOGIN

USER $LOGIN
WORKDIR /home/$LOGIN

ENTRYPOINT ["java", "-jar", "app-standalone.jar"]
```
