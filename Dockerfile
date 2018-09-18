FROM centos:7

LABEL maintainer "oatkrittin@gmail.com" 

ENV PATH=$PATH:/usr/local/gemini/bin \
  MINICONDA_PREFIX=/usr/local/share/gemini/anaconda

# Install Deps for conda & gemini
RUN yum -y update && \
  yum -y install \
  wget \
  gcc \
  gcc-c++ \
  zlib-devel \
  bzip2 \
  && \
  yum clean all && \
  rm -rf /var/cache/yum/*

# Pre-installed Miniconda with bioconda, gemini(latest version only) deps
RUN wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
  chmod u+x Miniconda2-latest-Linux-x86_64.sh && \
  ./Miniconda2-latest-Linux-x86_64.sh -b -p $MINICONDA_PREFIX && \
  /usr/local/share/gemini/anaconda/bin/conda install --yes -c conda-forge -c bioconda gemini && \
  wget https://raw.github.com/arq5x/gemini/master/gemini/scripts/gemini_install.py && \
  rm -f Miniconda2-latest-Linux-x86_64.sh

# Expose mount point for pre-downloaded annotation dbs
VOLUME [ "/vcfs", "/dbs", "/usr/local/share/gemini/gemini_data" ]

# Repeat installation process to ensure we don't miss anything before useing container.
CMD ["python", "gemini_install.py", "/usr/local", "/usr/local/share/gemini"]