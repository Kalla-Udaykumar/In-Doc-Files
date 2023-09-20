# FROM BASE IMAGE UBUNTU:22.04
FROM amr-registry.caas.intel.com/esc-devops/baseline/linux/ubuntu/22.04:20221125_1521

ENV HTTP_PROXY "http://proxy.png.intel.com:911"
ENV HTTPS_PROXY "http://proxy.png.intel.com:912"
ENV NO_PROXY "127.0.0.1,localhost,intel.com,.intel.com,af01p-png.devtools.intel.com,10.34.40.193,10.34.42.14,10.221.253.199"
ENV http_proxy "http://proxy.png.intel.com:911"
ENV https_proxy "http://proxy.png.intel.com:912"
ENV no_proxy "127.0.0.1,localhost,intel.com,.intel.com,af01p-png.devtools.intel.com,10.34.40.193,10.34.42.14,10.221.253.199"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        gpg-agent \
        software-properties-common

# Basic Packages
RUN apt-get install -y --no-install-recommends \
        unzip \
        git \
        meson \
        ninja-build \
        wget \
        bison \
        flex \
        cmake \
        pkg-config \
        autoconf \
        build-essential \
        automake \
        libtool \
        libssl-dev \
        libpciaccess-dev \
        cpio

# Dependencies
RUN apt-get install -y --no-install-recommends \
        libigdgmm12 \
        libigdgmm-dev \
        intel-media-va-driver-non-free \
        va-driver-all \
        gir1.2-gst-plugins-bad-1.0 \
        gir1.2-gst-rtsp-server-1.0 \
        gstreamer1.0-alsa \
        gstreamer1.0-gl \
        gstreamer1.0-gtk3 \
        gstreamer1.0-opencv \
        gstreamer1.0-plugins-bad-apps \
        gstreamer1.0-plugins-base-apps \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-pulseaudio \
        gstreamer1.0-qt5 \
        gstreamer1.0-rtsp \
        gstreamer1.0-vaapi \
        gstreamer1.0-wpe \
        libgstreamer-gl1.0-0 \
        libgstreamer-opencv1.0-0 \
        libgstreamer-plugins-bad1.0-0 \
        libgstreamer-plugins-bad1.0-dev \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-0 \
        libgstreamer-plugins-good1.0-dev \
        libgstreamer1.0-0 \
        libgstreamer1.0-dev \
        libgstrtspserver-1.0-0 \
        libgstrtspserver-1.0-dev \
        libmfx-dev \
        libmfx-tools \
        libmfx1 \
        libmfx-gen-dev \
        libmfx-gen1.2 \
        libvpl-dev \
        libvpl2 \
        vainfo

# MIPS Dependencies
RUN apt-get install -y --no-install-recommends \
        libavfilter-dev \
        libavdevice-dev \
        weston

#==========================================================
# intel-gmmlib=22.2.0*
# level zero 1.6.2
# intel-oneapi-compiler-dpcpp-cpp-2021.2.0
# openvino_2022.2.0
# libjpeg9
# libjpeg9-dev
# pytorch 0.11.1
# libtensorflow 2.9.1
# g++-10
# gcc-10
# intel-media-driver22.5.4 
# dg2.sh (sourced to enable DGPU support if DG2 card is detected on Host PC)
# ================================================================================

ENV no_proxy "127.0.0.1,localhost,af01p-png.devtools.intel.com,ubit-artifactory-or.intel.com,10.34.40.193,10.34.42.14,10.221.253.199"

# Install DPC++ dependencies
RUN curl -fsSL https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | apt-key add - \
    && apt-add-repository "deb https://apt.repos.intel.com/oneapi all main"

RUN apt-get update

# level zero 1.7.9 release https://github.com/oneapi-src/level-zero/releases/tag/v1.7.9
# level zero dependencies
# intel-level-zero-gpu (https://github.com/intel/compute-runtime/releases)
# Minimum required version 21.09.19150 https://github.com/intel/compute-runtime/releases/tag/22.10.22597
RUN cd /tmp && \
    mkdir neo && cd neo && \
    wget https://github.com/oneapi-src/level-zero/releases/download/v1.7.9/level-zero-devel_1.7.9+u18.04_amd64.deb && \
    wget https://github.com/oneapi-src/level-zero/releases/download/v1.7.9/level-zero_1.7.9+u18.04_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/22.10.22597/intel-gmmlib_22.0.2_amd64.deb  && \
    wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.10409/intel-igc-core_1.0.10409_amd64.deb && \
    wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.10409/intel-igc-opencl_1.0.10409_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/22.10.22597/intel-opencl-icd_22.10.22597_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/22.10.22597/intel-level-zero-gpu_1.3.22597_amd64.deb && \
    sudo dpkg -i *.deb

# install dpc++ compiler
RUN apt-get install -y --no-install-recommends \
    intel-oneapi-compiler-dpcpp-cpp-2021.2.0

# components
RUN env DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        adb \
        apt-transport-https \
        autoconf \
        automake \
        bison \
        build-essential \
        cmake \
        curl \
        default-jre \
        docker-compose \
        flex \
        ffmpeg \
        g++ \
        gcc \
        git \
        git-lfs \
        gnuplot \
        intel-gpu-tools \
        lbzip2 \
        libtool \
        make \
        mc \
        mosquitto \
        mosquitto-clients \
        openssl \
        pciutils \
        python3-pandas \
        python3-pip \
        python3-seaborn \
        qemu-kvm \
        software-properties-common \
        terminator \
        vim \
        wmctrl \
        i2c-tools \
        xdotool \
        gnupg \
        lsb-release \
        intel-igc-core \
        intel-igc-opencl \
        intel-opencl-icd \
        intel-level-zero-gpu

RUN env DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        libavcodec-dev \
        libavformat-dev \
        libglew-dev \
        libglm-dev \
        libsdl2-dev \
        libssl-dev \
        libswscale-dev \
        rpm \
        python-gi-dev \
        libgtk2.0-dev \
        python3-virtualenv \
        libpugixml-dev \
        libva-dev \
        libxcb-randr0-dev \
        libtbb2 \
        libtbb2-dev \
        socat \
        libenchant1c2a \
        libjson-c3

RUN pip3 install meson
