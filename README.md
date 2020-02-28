# shellbro/devbox-clojure

[![](https://img.shields.io/docker/cloud/build/shellbro/devbox-clojure)](https://hub.docker.com/r/shellbro/devbox-clojure/)

Non-root container image for Clojure development.

# Ad-hoc containerized Clojure REPL

Add the following function to your `.bashrc` file:

```
function repl {
  docker run --rm --detach-keys=ctrl-@ -it\
         -v "$HOME/.m2:/home/app-user/.m2" --entrypoint=lein\
         shellbro/devbox-clojure update-in :dependencies into "[$1]" --\
         repl :start
}
```

# Develop inside a container

From the root directory of your Clojure project start standalone REPL inside
a container. If you want to stay attached to your REPL from a terminal window
run:

```
$ docker run --rm --detach-keys=ctrl-@ -it\
  -v "$HOME/.m2:/home/app-user/.m2" -v "$PWD:/usr/local/src/app"\
  -p 127.0.0.1:1337:1337\
  shellbro/devbox-clojure :host 0.0.0.0 :port 1337
```

If you prefer to spare terminal window and detach (thus using REPL only
from inside IDE) run:

```
$ docker run --rm --detach-keys=ctrl-@ -dit\
  -v "$HOME/.m2:/home/app-user/.m2" -v "$PWD:/usr/local/src/app"\
  -p 127.0.0.1:1337:1337\
  shellbro/devbox-clojure :host 0.0.0.0 :port 1337
```

You can customize a port number over which nREPL is available on the localhost
by exposing it on another port. For example, to change the port number from 1337
to 1338 run:

```
$ docker run --rm --detach-keys=ctrl-@ -dit\
  -v "$HOME/.m2:/home/app-user/.m2" -v "$PWD:/usr/local/src/app"\
  -p 127.0.0.1:1338:1338\
  shellbro/devbox-clojure :host 0.0.0.0 :port 1338
```

or

```
$ docker run --rm --detach-keys=ctrl-@ -dit\
  -v "$HOME/.m2:/home/app-user/.m2" -v "$PWD:/usr/local/src/app"\
  --network=host\
  shellbro/devbox-clojure :port 1338
```

Once nREPL for your project is running you can connect to it from `CIDER`:

```
M-x cider-connect
> localhost
> PORT_NUMBER
```

# Build an app image

```
FROM shellbro/devbox-clojure as builder

COPY --chown=app-user:app-user project.clj /usr/local/src/app
RUN lein deps
COPY --chown=app-user:app-user . /usr/local/src/app
RUN mv "$(lein uberjar | sed -n 's/^Created \(.*standalone\.jar\)/\1/p')"\
    app-standalone.jar

FROM openjdk:11-jre

ARG HOST_UID=999
ARG HOST_GID=999

RUN groupadd -g $HOST_GID app-user &&\
    useradd -u $HOST_UID -g $HOST_GID -m app-user
COPY --from=builder --chown=app-user:app-user\
     /usr/local/src/app/app-standalone.jar /home/app-user

USER app-user
WORKDIR /home/app-user

ENTRYPOINT ["java", "-jar", "app-standalone.jar"]
```
