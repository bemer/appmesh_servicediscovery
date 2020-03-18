FROM alpine:3.11.3
COPY ./app /app
WORKDIR /app
RUN apk update && apk add curl curl-dev bash
RUN chmod 777 script.sh
CMD ./script.sh