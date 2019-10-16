# shellbro/devbox-clojure

[![](https://img.shields.io/docker/cloud/build/shellbro/devbox-clojure)](https://hub.docker.com/r/shellbro/devbox-clojure/)

Container image for development of Clojure apps & CI build.

# Running local development environment

From the root directory of your Clojure project start remote REPL inside
an isolated container:

```
docker run --rm -it -p 2000:2000 -v ~/.m2:/home/app-user/.m2 -v $PWD:/usr/local/src/app shellbro/devbox-clojure
```

You can customize the port number over which nREPL is available on the localhost
by exposing it on another port. For example, to change the port number from 2000
to 2001 run:

```
docker run --rm -it -p 2000:2001 -v ~/.m2:/home/app-user/.m2 -v $PWD:/usr/local/src/app shellbro/devbox-clojure
```

Once nREPL for your project is running you can connect to it from `CIDER`:

```
M-x cider-connect
> localhost
> 2000
```

# CI/CD build stage

Example Dockerfile

```
TODO
```
