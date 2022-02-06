FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y apt-utils 

# install steamcmd and accept the shitty license agreement prompt
RUN echo steam steam/question select "I AGREE" | debconf-set-selections
#RUN apt-get install -qq steamcmd

# rustserver dependencies
# curl wget file tar bzip2 gzip unzip bsdmainutils python3 util-linux ca-certificates binutils bc jq tmux netcat lib32gcc-s1 lib32stdc++6 libsdl2-2.0-0:i386 steamcmd lib32z1
RUN apt-get install -qq sudo curl git wget file tar bzip2 gzip unzip bsdmainutils \ 
python3 util-linux ca-certificates binutils bc jq tmux netcat lib32gcc-s1 \ 
lib32stdc++6 libsdl2-2.0-0:i386 lib32z1 steamcmd cpio xz-utils

# Create rustserver user
RUN useradd -m rustserver && echo "rustserver:rustserver" | chpasswd && adduser rustserver sudo

# switch to /home/rustserver
WORKDIR /home/rustserver

# download linuxgsm
RUN wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh

# switch to rustserver user and install rustserver
USER rustserver
RUN ./linuxgsm.sh rustserver

EXPOSE 28015/udp