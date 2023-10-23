# Ubuntu 20.04 baseline image from trusted registry
 FROM amr-registry.caas.intel.com/esc-devops/baseline/linux/ubuntu/20.04:20201023_1253
# FROM amr-registry.caas.intel.com/esc-devops/baseline/linux/ubuntu/20.04/abi:20230329-1101 

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
		make \
  		cmake \
		python3-pexpect \
		xz-utils \
		debianutils \
		iputils-ping \
		python3-git \
		python3-jinja2 \
		libegl1-mesa \
		libsdl1.2-dev \
		pylint3 \
		xterm \
		python3-subunit \
		mesa-common-dev \
		zstd \
		liblz4-tool \
		libncurses5-dev \
		libtinfo-dev \
		patchutils \
		vim \
		file \
        connect-proxy \
        jq \
        acpica-tools \
        libssl-dev \
        dh-autoreconf \
        git-lfs \
        automake \
        gcc-multilib \
        libtool \
        whiptail \
        ca-certificates \
        zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install sphinx sphinx_rtd_theme kas==2.5 ruamel.yaml

# Configuration, run bash interpreter by default
CMD ["/bin/bash"]
