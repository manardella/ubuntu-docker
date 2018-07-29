# sudo docker run -d -p 25901:5901 -p 26901:6901 accetto/ubuntu-vnc-xfce
# FROM ubuntu:rolling
# FROM ubuntu:16.04
# FROM ubuntu:18.04 as build
FROM accetto/ubuntu-vnc-xfce

ENV DEBIAN_FRONTEND=noninteractive

# RUN apt-get update -y && apt-get install -y aptitude && aptitude dist-upgrade --purge-unused -y && aptitude clean
# RUN apt-get update && apt-get install -y software-properties-common sudo


# RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
#     && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
# ENV LANG en_US.utf8

# Update the system
RUN apt-get update -y

# Build essentials
RUN apt-get install -yy build-essential

# install useful system apps
RUN apt-get install -yy nano htop vim xterm ssh openssh-server curl wget git terminator firefox

# Install ubuntu desktop
#RUN apt-get -yy install ubuntu-desktop

# Install development related software
RUN apt-get install -yy openjdk-11-jdk maven nodejs npm 

# Chrome 
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update -y && apt-get install -y google-chrome-stable

# Docker
RUN apt-get remove -yy docker docker-engine docker.io
RUN apt-get install -yy apt-transport-https ca-certificates curl software-properties-common
RUN apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update -y && apt-get install -yy docker-ce docker-compose


# Cleanup
RUN apt-get autoremove


EXPOSE 4000
# EXPOSE 23 4001


# use environment variables USER and PASSWORD (passed by docker run -e) 
# to create a priviledged user account, and set it up for use by SSH and NoMachine;
# note that ADD is executed by the host, not the container (unlike RUN)
ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]