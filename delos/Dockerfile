FROM node:8.11.1-alpine

LABEL maintainer=ganl

WORKDIR /app

RUN mkdir /tmp/delos
ADD ./rap2-delos /tmp/delos

#RUN ls /tmp/delos

ARG CHANGE_NPM_SOURCE=false
RUN if [ ${CHANGE_NPM_SOURCE} = true ]; then \
    # Change application source from TAONPM source
    npm config set registry https://registry.npm.taobao.org \
    npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/ \
;fi

RUN /bin/sh -c 'cd /tmp/delos && npm install && npm install -g typescript && npm run build && mv ./dist/* /app/ && mv ./node_modules /app/ && rm -rf /tmp'

CMD ["node", "dispatch.js"]
