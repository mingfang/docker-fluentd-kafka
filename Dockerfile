FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
RUN echo "export PS1='\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" >> /root/.bashrc

#Runit
RUN apt-get install -y runit 
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc

RUN apt-get install -y build-essential

#RUN apt-get install -y libcurl4-openssl-dev make

RUN wget -O - http://packages.treasuredata.com/GPG-KEY-td-agent | apt-key add - && \
    echo "deb [arch=amd64] http://packages.treasuredata.com/2/ubuntu/trusty/ trusty contrib" > /etc/apt/sources.list.d/treasure-data.list && \
    apt-get update
RUN apt-get install -y td-agent

RUN /usr/sbin/td-agent-gem install fluent-plugin-kafka 

COPY td-agent.conf /etc/td-agent/td-agent.conf

#Add runit services
COPY sv /etc/service 

