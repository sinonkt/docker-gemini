FROM ubuntu:16.04

LABEL maintainer "oatkrittin@gmail.com" 

ENV HTSLIB_VERSION=1.9 \
  MINICONDA_PREFIX=/usr/local/share/gemini/anaconda \
  PATH=$PATH:/usr/local/bin:/usr/local/gemini/bin

# Install Deps for conda & gemini
RUN apt-get update && \
  apt-get -y install \
  wget \
  python2.7 \
  build-essential \
  bzip2 \
  build-essential \ 
  zlib1g-dev \
  libbz2-dev \
  libcurl4-openssl-dev \
  libssl-dev liblzma-dev \
  && \
  apt-get clean

# Pre-installed Miniconda with bioconda, gemini(latest version only) deps then Repeat Normal Install once again.
RUN wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
  chmod u+x Miniconda2-latest-Linux-x86_64.sh && \
  ./Miniconda2-latest-Linux-x86_64.sh -b -p $MINICONDA_PREFIX && \
  /usr/local/share/gemini/anaconda/bin/conda install --yes -c conda-forge -c bioconda gemini && \
  wget https://raw.github.com/arq5x/gemini/master/gemini/scripts/gemini_install.py && \
  python gemini_install.py /usr/local /usr/local/share/gemini --nodata && \
  rm -f gemini_install.py Miniconda2-latest-Linux-x86_64.sh && \
  ln -s /usr/local/share/gemini/gemini_data /gemini_data

# Install htslib to get tabix, bgzip utils tools
RUN wget https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2 \
  && tar -xjf htslib-${HTSLIB_VERSION}.tar.bz2 \
  && cd htslib-${HTSLIB_VERSION} \
  && ./configure \
  && make && make install \
  && rm ../htslib-${HTSLIB_VERSION}.tar.bz2 

# Expose mount point for pre-downloaded annotation dbs
VOLUME [ "/vcfs", "/dbs", "/gemini_data" ]