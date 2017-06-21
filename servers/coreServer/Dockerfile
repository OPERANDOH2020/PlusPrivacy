FROM  centos:centos7
RUN yum install -y epel-release
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN  yum install -y nodejs
#RUN node --version
#RUN   yum install -y npm
RUN   yum install -y redis
COPY . /op-sharedbus
RUN cd /op-sharedbus; npm install; npm dedupe
RUN npm install http-server -g
EXPOSE 8080  
CMD ["/bin/bash", "/op-sharedbus/container/start.sh"]









