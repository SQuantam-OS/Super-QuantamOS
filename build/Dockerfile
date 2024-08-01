FROM debian:latest

FROM debian:latest

RUN apt update && apt-get install bash

WORKDIR /build

COPY build.sh .
RUN chmod a+x build.sh

ENTRYPOINT ["/scripts/build.sh"]
