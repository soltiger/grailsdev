FROM ubuntu:14.04

# Enable SSHD
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# Install Java8
RUN apt-get install -y software-properties-common
RUN apt-add-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -y oracle-java8-installer

# Install Grails 3.1.6
RUN apt-get install -y wget unzip
ENV GRAILS_VERSION 3.1.6
WORKDIR /usr/lib/jvm
RUN wget https://github.com/grails/grails-core/releases/download/v${GRAILS_VERSION}/grails-${GRAILS_VERSION}.zip
RUN unzip grails-${GRAILS_VERSION}.zip
RUN rm -rf grails-${GRAILS_VERSION}.zip
RUN ln -s grails-${GRAILS_VERSION} grails
ENV GRAILS_HOME /usr/lib/jvm/grails
ENV PATH $GRAILS_HOME/bin:$PATH
RUN echo "export GRAILS_HOME=/usr/lib/jvm/grails" >> /etc/profile
RUN echo "export PATH=$GRAILS_HOME/bin:$PATH" >> /etc/profile

# Create test application
WORKDIR /tmp
RUN grails create-app helloWorld
WORKDIR /tmp/helloWorld
RUN grails create-controller hello

EXPOSE 8080