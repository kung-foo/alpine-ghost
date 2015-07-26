FROM mhart/alpine-node:0.10

MAINTAINER docker@jonathan.camp

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk update
RUN apk add curl

# gosu > su
RUN curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu

# binary sqlite3 on npm is incompatible with apline linux (musl)
RUN apk add python make gcc libc-dev g++ && \
    npm install -g "sqlite3@~3.0.9" --build-from-source --unsafe-perm && \
    apk --purge del python make gcc libc-dev g++

RUN mkdir -p /opt/ghost/
RUN adduser ghost -D -h /opt/ghost -s /bin/sh
WORKDIR /opt/ghost/

# needs to be run as root because npm link calls 'install'
# creates node_modules dir in /opt/ghost
RUN npm link sqlite3

VOLUME ["/opt/ghost/user-content/"]
EXPOSE 2368

ENV GHOST_VER 0.6.4

RUN curl -o /tmp/ghost.zip -sSL https://github.com/TryGhost/Ghost/releases/download/${GHOST_VER}/Ghost-${GHOST_VER}.zip && \
    unzip /tmp/ghost.zip -d . && \
    rm -f /tmp/ghost.zip

ADD entrypoint.sh /opt/ghost/
ADD config.js /opt/ghost/

# make sure ghost owns everything, including the node_modules dir from the
# sqlite3 link command above
RUN chown -R ghost:ghost * && chmod +x entrypoint.sh
RUN gosu ghost npm install --production

CMD ["/opt/ghost/entrypoint.sh"]
