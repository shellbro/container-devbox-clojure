FROM clojure:openjdk-11-lein-2.9.1

ARG UID=1000
ARG GID=1000
ARG LOGIN=app-user

ENV LEIN_REPL_PORT=30123

RUN groupadd -g $GID $LOGIN && useradd -u $UID -g $GID -m $LOGIN &&\
    mkdir /usr/local/src/app && chown $LOGIN:$LOGIN /usr/local/src/app
USER $LOGIN
WORKDIR /usr/local/src/app

EXPOSE $LEIN_REPL_PORT
