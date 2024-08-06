FROM randomdude/gcc-cross-x86_64-elf

RUN apt-get update 
RUN cd ../scripts/
RUN ./build.sh
ENTRYPOINT ../scripts/build.sh
VOLUME /root/env/
WORKDIR /root/env/
