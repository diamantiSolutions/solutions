#FROM jenkins/jenkins:lts-alpine
FROM jenkins/jenkins:lts
COPY groovy/* /usr/share/jenkins/ref/init.groovy.d/
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
#RUN /usr/local/bin/install-plugins.sh docker-slaves github-branch-source:1.8

#ADD  plugins-wrapper.sh /var/jenkins_home/
#RUN  /var/jenkins_home/plugins-wrapper.sh && rm -f /var/jenkins_home/plugins-wrapper.sh
#VOLUME /var/jenkins_home


