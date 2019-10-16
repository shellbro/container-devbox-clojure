# shellbro/devbox-clojure

[![](https://img.shields.io/docker/cloud/build/shellbro/devbox-clojure)](https://hub.docker.com/r/shellbro/devbox-clojure/)

Container image for development of Clojure apps & CI build.

# Running development environment inside a container

From the root directory of your Clojure project start remote REPL:

```
docker run --rm -it -p 5000:5000 -v ~/.m2:/home/app-user/.m2 -v $PWD:/usr/local/src/app shellbro/devbox-clojure
```

By default, remote REPL listens on port 30123. You can customize this port
number by passing command line arguments and remembering to expose the new port:

```
docker run --rm -it -p 5000:5000 -v ~/.m2:/home/app-user/.m2 -v $PWD:/usr/local/src/app shellbro/devbox-clojure :port 5000
```

Once nREPL for your project
