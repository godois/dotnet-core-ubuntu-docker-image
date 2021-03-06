############################################################
# Dockerfile to build Dotnet Core 1.0.3 environment
# Based on Ubuntu Trusty image
############################################################

# Set the base image to ubuntu:trusty
FROM ubuntu:trusty

# File Author / Maintainer
MAINTAINER Marcio Godoi <souzagodoi@gmail.com>

# Run as a root user
USER root

# Install Ubuntu basic packages
RUN apt-get update && \
    apt-get install -y \
    wget \
   	tar \
	less \
	curl \
	vim \
	wget \
	unzip \
	netcat \
	software-properties-common \
	telnet \
	git \
	apt-transport-https

# Install .NET Core Package
RUN sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
RUN sudo apt-get update
RUN sudo apt-get --assume-yes install dotnet-dev-1.0.3

#Creating and setting a workdir
ENV DOTNET_HOME=/opt/dotnet
RUN mkdir -p $DOTNET_HOME

#Adding an entrypoint file responsible for execute the image first steps
ADD bin/entrypoint.sh $DOTNET_HOME/entrypoint.sh
RUN chmod 755 $DOTNET_HOME/entrypoint.sh

#Creating a specific user to run applications
RUN groupadd -g 1000 dotnetapp \
  && useradd -d "$DOTNET_HOME" -u 1000 -g 1000 -s /sbin/nologin dotnetapp

#Changing the owner for the application directory
RUN chown -R dotnetapp:dotnetapp $DOTNET_HOME

# Change to the .Net user
USER dotnetapp

# Changing the workdir
WORKDIR "$DOTNET_HOME"

EXPOSE 5000

#Entrypoint file
ENTRYPOINT ["/opt/dotnet/entrypoint.sh"]