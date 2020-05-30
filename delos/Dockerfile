ARG NODE_VERSION=lts

FROM node:${NODE_VERSION}-alpine

LABEL maintainer=ganl

WORKDIR /app

RUN mkdir /tmp/delos
ADD ./rap2-delos /tmp/delos

ARG CHANGE_SOURCE=false
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from TAONPM source
    npm config set registry https://registry.npm.taobao.org && \
    npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/ && \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
;fi

RUN apk add -U tzdata python make gcc g++

RUN wget http://rap2-taobao-org.oss-cn-beijing.aliyuncs.com/pandoc-2.7.3-linux.tar.gz && \
    tar -xf pandoc-2.7.3-linux.tar.gz && \
    cp pandoc-2.7.3/bin/* /usr/bin/ && \
    pandoc -v && \
    rm -rf pandoc-2.7.3-linux.tar.gz pandoc-2.7.3

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN /bin/sh -c 'cd /tmp/delos && ls && npm install -g typescript && npm install && npm run build && mv ./dist/* /app/ && mv ./node_modules /app/ && mv ./public /app/ && cp -f ./package.json /app/ && rm -rf /tmp && ls && ls /app'

CMD ["node", "dispatch.js"]
