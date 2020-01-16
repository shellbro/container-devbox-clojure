# shellbro/devbox-clojure

[![](https://img.shields.io/docker/cloud/build/shellbro/devbox-clojure)](https://hub.docker.com/r/shellbro/devbox-clojure/)

Container image for development of Clojure apps & CI build.

# Running local development environment

From the root directory of your Clojure project start standalone REPL inside
a container. If you want to stay attached to your REPL from a terminal window
run:

```
$ docker run --rm --detach-keys=ctrl-@ -it -v $HOME/.m2:/home/app-user/.m2 -v $PWD:/usr/local/src/app -p 127.0.0.1:1337:1337 shellbro/devbox-clojure :host 0.0.0.0 :port 1337
```

If you prefer to spare terminal window and detach (thus using REPL only
from inside IDE) run:

```
$ docker run --rm --detach-keys=ctrl-@ -dit -v $HOME/.m2:/home/app-user/.m2 -v $PWD:/usr/local/src/app -p 127.0.0.1:1337:1337 shellbro/devbox-clojure :host 0.0.0.0 :port 1337
```

You can customize a port number over which nREPL is available on the localhost
by exposing it on another port. For example, to change the port number from 1337
to 1338 run:

```
$ docker run --rm --detach-keys=ctrl-@ -dit -v $HOME/.m2:/home/app-user/.m2 -v $PWD:/usr/local/src/app -p 127.0.0.1:1338:1338 shellbro/devbox-clojure :host 0.0.0.0 :port 1338
```

or

```
$ docker run --rm --detach-keys=ctrl-@ -dit -v $HOME/.m2:/home/app-user/.m2 -v $PWD:/usr/local/src/app --network=host shellbro/devbox-clojure :port 1338
```

Once nREPL for your project is running you can connect to it from `CIDER`:

```
M-x cider-connect
> localhost
> [PORT_NUMBER]
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

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app-standalone.jar"]
```
