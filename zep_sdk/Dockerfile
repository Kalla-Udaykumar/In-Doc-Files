#BASE IMAGE
FROM  amr-registry.caas.intel.com/esc-devops/baseline/linux/ubuntu/22.04:20220726_1210

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ARG CMAKE_VERSION=3.20.0
ARG DTS_VERSION=1.6.1
ARG ZSDK_VERSION=0.16.1
ARG GCC_ARM_NAME=gcc-arm-none-eabi-9-2019-q4-major

ENV http_proxy=http://proxy-iind.intel.com:912
#ENV http_proxy=http://proxy-dmz.intel.com:912
ENV https_proxy=http://proxy-dmz.intel.com:912
ENV no_proxy=intel.com,.intel.com,10.0.0.0/8,192.168.0.0/16,localhost,.local,127.0.0.0/8,134.134.0.0/16

RUN apt-get update && apt-get install -y  \
        ninja-build \
        make \
        gperf \
        git \
        repo \
        openssh-server \
        wget \
        ccache \
        doxygen \
        graphviz \
        dfu-util \
        python3-pip \
        build-essential \
        python3-wheel  \
        python3-setuptools \
        python3.10 \
        python3.10-dev \
        xz-utils \
        file \
        zlib1g-dev \
        python3-tk \
        gcc \
        gcc-multilib \
        autoconf \
        automake \
        libfdt1 \
        libfdt-dev \
        libyaml-0-2 \
        libtool \
        bzip2 \
        curl \
        tar \
        gzip \
        openssl \
        jq && \
        wget -O libfdt1.deb http://security.ubuntu.com/ubuntu/pool/main/d/device-tree-compiler/libfdt1_1.6.1-1_amd64.deb && \
        dpkg -i libfdt1.deb && \
        rm libfdt1.deb && \
        wget -O dtc.deb http://security.ubuntu.com/ubuntu/pool/main/d/device-tree-compiler/device-tree-compiler_${DTS_VERSION}-1_amd64.deb && \
        dpkg -i dtc.deb && \
        rm dtc.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN cd /tmp && \
    git clone -b main https://github.com/zephyrproject-rtos/zephyr.git zephyr_txt && \
    cd zephyr_txt && cd scripts && \
#    wget -r https://github.com/intel-innersource/os.rtos.zephyr.iot.zephyr/blob/ia_dev/scripts/requirements.txt && \
    pip3 install wheel &&\
    pip3 install -r requirements.txt && \
    pip3 install west &&\
    pip3 install pyelftools && \
    pip3 install pyyaml && \
    pip3 install defusedxml && \
    pip3 install sh


#    wget  https://github.com/zephyrproject-rtos/zephyr/blob/main/scripts/requirements.txt && \
#   pip3 install -r /zephyrproject/zephyr/scripts/requirements.txt && \
#    wget -q https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/master/scripts/requirements.txt && \
#    wget -q https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/master/scripts/requirements-base.txt && \
#    wget -q https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/master/scripts/requirements-build-test.txt && \
#    wget -q https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/master/scripts/requirements-doc.txt && \
#    wget -q https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/master/scripts/requirements-run-test.txt && \
#    wget -q https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/master/scripts/requirements-extras.txt && \
#    wget -q https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/master/scripts/requirements-compliance.txt && \
   #pip3 install -U pip && \
   # pip3 install wheel &&\
   # pip3 install -r requirements.txt && \
   # pip3 install west &&\
   # pip3 install pyelftools && \
  #  pip3 install pyyaml && \
 #   pip3 install defusedxml && \
#    pip3 install sh

#Clone a repository of siip tool
RUN git clone https://github.com/intel/iotg-fbu.git /opt/iotg-fbu && cd  /opt/iotg-fbu && \
    pip3 install -r requirements.txt && \
    pip3 install --upgrade cryptography && \
    pip3 install click

#CMAKE Installation
RUN wget -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh && \
    chmod +x cmake-${CMAKE_VERSION}-Linux-x86_64.sh && \
    ./cmake-${CMAKE_VERSION}-Linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm -f ./cmake-${CMAKE_VERSION}-Linux-x86_64.sh

#Zypher installation steps
#RUN  wget  https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.0/zephyr-sdk-0.16.1_linux-x86_64.tar.xz && \
#     wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.1/sha256.sum | shasum --check --ignore-missing && \
#     tar xvf zephyr-sdk-0.16.1_linux-x86_64.tar.xz && \
#     cd zephyr-sdk-0.16.1 && \
#     chmod +x setup.sh && \
#     ./setup.sh -t all -h -c && \
#     cd .. && \
#     rm -rf zephyr-sdk-0.16.1_linux-x86_64.tar.xz

RUN wget -q https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/RC2.1/${GCC_ARM_NAME}-x86_64-linux.tar.bz2  && \
        tar xf ${GCC_ARM_NAME}-x86_64-linux.tar.bz2 && \
        rm -f ${GCC_ARM_NAME}-x86_64-linux.tar.bz2 && \
        mv ${GCC_ARM_NAME} /opt/${GCC_ARM_NAME}

CMD ["/bin/bash"]
