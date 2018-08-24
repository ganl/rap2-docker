FROM node:8.11.1-alpine

LABEL maintainer=ganl

WORKDIR /app

RUN mkdir /tmp/dolores
COPY ./rap2-dolores /tmp/dolores

COPY ./config.prod.js /tmp/dolores/src/config/config.prod.js

ARG SERVER_HOST
ARG DELOS_PORT

RUN sed -i "s/delos:8080/${SERVER_HOST}:${DELOS_PORT}/" /tmp/dolores/src/config/config.prod.js && \
	cat /tmp/dolores/src/config/config.prod.js

ARG CHANGE_NPM_SOURCE=false
RUN if [ ${CHANGE_NPM_SOURCE} = true ]; then \
    # Change application source from TAONPM source
    npm config set registry https://registry.npm.taobao.org \
    npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/ \
;fi

RUN npm install -g http-server
# RUN npm install -g serve
# RUN npm install --unsafe-perm -g node-sass

RUN /bin/sh -c 'cd /tmp/dolores && npm install && npm run build && mv ./build/* /app/ && mv ./node_modules /app/ && rm -rf /tmp'

ENTRYPOINT ["/bin/sh", "-c", "http-server -s ./build -p 80"]
#ENTRYPOINT ["/bin/sh", "-c", "serve -s ./build -p 80"]
