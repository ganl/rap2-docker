ARG NODE_VERSION=8.11.1
FROM node:${NODE_VERSION}-alpine

LABEL maintainer=ganl

WORKDIR /app

RUN mkdir /tmp/dolores && mkdir /tmp/update-check
COPY ./rap2-dolores /tmp/dolores

COPY ./config.prod.js /tmp/dolores/src/config/config.prod.js

ARG SERVER_HOST
ARG DELOS_PORT

RUN sed -i "s/delos:8080/${SERVER_HOST}:${DELOS_PORT}/" /tmp/dolores/src/config/config.prod.js && \
	cat /tmp/dolores/src/config/config.prod.js

ARG CHANGE_SOURCE=false
# RUN echo ${CHANGE_SOURCE}
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from TAONPM source
    npm config set registry https://registry.npm.taobao.org && \
    npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/ && \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
;fi

RUN apk update && apk add python tzdata

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN /bin/sh -c 'cd /tmp/dolores && npm install && npm rebuild node-sass && npm run build && mv ./build/* /app/ && rm -rf /tmp/dolores'

# RUN npm install -g http-server
RUN npm install -g serve

# ENTRYPOINT ["/bin/sh", "-c", "http-server -s -p 80"]
ENTRYPOINT ["serve", "-s", "-p", "80"]
