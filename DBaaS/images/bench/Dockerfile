FROM centos
MAINTAINER agupta@diamanti.com

WORKDIR /opt/bench

RUN yum -y install httpd-tools mysql java-devel mysql-connector-java postgresql && rpm -ivh http://rpm.datastax.com/community/noarch/cassandra22-2.2.7-1.noarch.rpm && yum install -y  https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.4/x86_64/RPMS/mongodb-org-shell-3.4.1-1.el7.x86_64.rpm && yum install -y http://downloads.mysql.com/archives/mysql-5.1/MySQL-shared-compat-5.1.49-1.rhel5.x86_64.rpm && yum clean all
ADD master.sh /master.sh
ADD user.my.cnf /root/.my.cnf
COPY . /opt/bench

MKDIR /opt/nfs

CMD /master.sh
#CMD sleep 1000 && echo "success"


