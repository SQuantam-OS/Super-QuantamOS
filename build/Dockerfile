FROM debian:latest

ENV OUTPUT_DIR /output
RUN \
 apt-get update \
 apt install -y git xorriso \
 git clone https://github.com/SQuantam-OS/Super-QuantamOS \
 cd Super-QuantamOS \
 cd scripts \
 ./build.sh \ 

WORKDIR /workdir/scripts
