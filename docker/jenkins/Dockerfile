FROM jenkins/jenkins:2.516.1-jdk17

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

USER jenkins

# ENV JENKINS_HOME=/var/jenkins_home
# ENV REF=/usr/share/jenkins/ref
ENV TZ=Asia/Dubai
ENV JENKINS_SLAVE_AGENT_PORT=50001
ENV JAVA_OPTS="-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false -Djava.io.tmpdir=$JENKINS_HOME/tmp"

RUN mkdir -p $JENKINS_HOME/tmp

COPY plugins.txt $REF/plugins.txt
RUN jenkins-plugin-cli --plugin-file $REF/plugins.txt

ENV CASC_JENKINS_CONFIG=$JENKINS_HOME/jenkins.yml
COPY jenkins.yml $JENKINS_HOME

# COPY jobs/*.groovy $REF/init.groovy.d/

WORKDIR $JENKINS_HOME

# CMD ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
