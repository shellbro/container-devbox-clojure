FROM clojure:openjdk-11-lein-2.9.1-slim-buster

ARG HOST_UID=1001
ARG HOST_GID=1001

RUN groupadd -g $HOST_GID app-user &&\
    useradd -u $HOST_UID -g $HOST_GID -m app-user &&\
    mkdir /usr/local/src/app && chown $HOST_UID:$HOST_GID /usr/local/src/app

USER app-user
WORKDIR /usr/local/src/app

ENTRYPOINT ["lein", "update-in", ":plugins", "conj",\
            "[cider/cider-nrepl \"0.24.0\"]", "--", "repl", ":start"]
