pgludkrbsp020$ cat Dockerfile
# Ubuntu 20.04 baseline image from trusted registry
# FROM amr-registry.caas.intel.com/esc-devops/baseline/linux/ubuntu/20.04:20201023_1253

FROM amr-registry.caas.intel.com/esc-devops/baseline/linux/ubuntu/24.04:20240214_1550


# Packages install from OS repositories
RUN apt-get update && \
    apt-get install -y \
        gawk \
        wget \
        git \
        diffstat \
        unzip \
        texinfo \
        gcc \
        build-essential \
        chrpath \
        socat \
        cpio \
        python3 \
        python3-pip \
        python3-pexpect \
        xz-utils \
        debianutils \
        iputils-ping \
        python3-git \
        python3-jinja2 \
#        libegl1-mesa \
        libglx-mesa0 \
                libsdl1.2-dev \
#               pylint3 \
#        python3-subunit \
#        libsdl1.2-dev \
#        pylint3 \
        python3-subunit \
        mesa-common-dev \
        zstd \
        liblz4-tool \
        make \
        file \
        parted \
        iproute2 \
        xterm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install GitPython pylint sphinx sphinx_rtd_theme pyyaml --break-system-packages

RUN apt-get update && \
    apt-get install -y \
    build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm \
    libncurses5-dev libncursesw5-dev xz-utils tk-dev \
    libffi-dev liblzma-dev python3-openssl git

RUN cd /tmp && \
    mkdir python3.8 && \
    cd python3.8 && \
    wget https://www.python.org/ftp/python/3.8.16/Python-3.8.16.tgz && \
    tar -xf Python-3.8.16.tgz && \
    cd Python-3.8.16 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    sudo make install

# Install ABI Dependencies
RUN apt-get update && \
    apt-get install -y \
#        python3.10 \
#        python3.10-dev \
#        python3.10-distutils \
#        python3.10-venv \
#        python3-venv \
#        python3-dev \
        gcc \
        libkrb5-dev \
        p7zip-full \
        git \
        zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the default python3 to be python3.8
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8.16 10

RUN cd tmp/ && \
    wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb && \
    sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb

## This section to set custom configuration
RUN groupadd -g 17838 lab_bldmstr \
    && useradd -c "lab_bldmstr user" -d /home/lab_bldmstr -u 44051 -g 17838 -m lab_bldmstr \
    && echo "lab_bldmstr:lab_bldmstr" | chpasswd \
    && echo 'lab_bldmstr ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && mkdir -p /OWR \
    && chmod -R 777 /OWR \
    && chown -R lab_bldmstr:lab_bldmstr /OWR \
    && chmod -R 777 /home/lab_bldmstr \
    && chown -R lab_bldmstr:lab_bldmstr /home/lab_bldmstr

USER lab_bldmstr

CMD /bin/bash

# Install wit after COPY, so that it re-runs everytime
ENV PATH "/home/lab_bldmstr/.abivenv/bin:/home/lab_bldmstr/.local/bin:${PATH}:/OWR:/OWR/Tools"
RUN mkdir -p /OWR/Tools \
    && mkdir -p /OWR/Tools/tmp \
    && wget -nv -O /OWR/Tools/wit https://ubit-artifactory-or.intel.com/artifactory/devops-repos/tools/wit/launcher/linux/wit \
    && chmod +x /OWR/Tools/wit \
    && wit --version-number \
    && rm /tmp/.wit/version.txt

# ABI Installation
RUN python3 -m pip install --upgrade pip \
&& python3 -m pip install --upgrade abi==2.5.0 --extra-index-url=https://ubit-artifactory-or.intel.com/artifactory/api/pypi/one-windows-pypi-local/simple \
&& cd /home/lab_bldmstr \
&& python3 -m venv .abivenv \
&& .abivenv/bin/python -m pip install --upgrade pip \
&& .abivenv/bin/python -m pip install --upgrade abi==2.5.0 --extra-index-url=https://ubit-artifactory-or.intel.com/artifactory/api/pypi/one-windows-pypi-local/simple

# Install MCAfee
RUN wget -nv -P /tmp http://owrdropbox.intel.com/dropbox/public/Ansible/McAfee_Docker_Scanner/6.1/mcafee-client-6.1_linux-x64.tar.gz \
&& tar -C /OWR/Tools -xzf /tmp/mcafee-client-6.1_linux-x64.tar.gz \
&& rm /tmp/mcafee-client-6.1_linux-x64.tar.gz

# Others, download git proxy script from external
RUN curl -s http://git.yoctoproject.org/cgit/cgit.cgi/poky/plain/scripts/oe-git-proxy > /tmp/git-proxy

# Configuration, run bash interpreter by default
CMD ["/bin/bash"]
