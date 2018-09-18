FROM centos:7

LABEL maintainer "oatkrittin@gmail.com" 

ENV PATH=$PATH:/usr/local/gemini/bin

RUN yum -y update && \
  yum -y install \
  wget \
  && \
  yum clean all && \
  rm -rf /var/cache/yum/*

RUN wget https://raw.github.com/arq5x/gemini/master/gemini/scripts/gemini_install.py

CMD ["python", "gemini_install.py", "/usr/local", "/usr/local/share/gemini"]

VOLUME [ "/vcfs", "/dbs", "/usr/local/share/gemini/gemini_data" ]