FROM node:18.11.0-slim

WORKDIR /app

RUN npm install -g coffeescript

ADD . .

RUN ./bin/build.sh

FROM nginx

COPY --from=0 /app /usr/share/nginx/html

