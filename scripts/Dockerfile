# I am only using SteamOS since It has a lot of the packages we use preinstalled
FROM ekultails/steamos:latest
#FROM archlinux:latest
#FROM jonathonf/manjaro:latest
RUN pacman -S git base-devel make xorriso tar bxip2 gzip
RUN ./build.sh
RUN echo "Build Completed"
