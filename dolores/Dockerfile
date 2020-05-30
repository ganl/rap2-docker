ARG NODE_VERSION=lts
FROM node:${NODE_VERSION}-alpine

LABEL maintainer=ganl

WORKDIR /app

RUN mkdir /tmp/dolores && mkdir /tmp/update-check
COPY ./rap2-dolores /tmp/dolores
COPY ./config.prod.ts /tmp/dolores/src/config/config.prod.ts

ARG CHANGE_SOURCE=false
RUN echo "CHANGE_SOURCE" . ${CHANGE_SOURCE}
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from TAONPM source
    npm config set registry https://registry.npm.taobao.org && \
    npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/ && \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \ 
;fi

ARG DELOS_PROTOCOL=http
ARG DELOS_HOST=localhost
ARG DELOS_PORT=8080
RUN sed -i "s/http:\/\/delos:8080/${DELOS_PROTOCOL}:\/\/${DELOS_HOST}:${DELOS_PORT}/" /tmp/dolores/src/config/config.prod.ts && \
	cat /tmp/dolores/src/config/config.prod.ts && \
	apk update && apk add python make gcc g++ tzdata

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN /bin/sh -c 'cd /tmp/dolores && npm install && npm install typescript -g && npm run lint && npm run build && mv ./build/* /app/ && rm -rf /tmp/dolores'

# RUN npm install -g http-server
RUN npm install -g serve && apk del python make gcc g++ tzdata && rm -rf /var/cache/apk/*

# ENTRYPOINT ["/bin/sh", "-c", "http-server -s -p 80"]
ENTRYPOINT ["serve", "-s", "-p", "80"]
