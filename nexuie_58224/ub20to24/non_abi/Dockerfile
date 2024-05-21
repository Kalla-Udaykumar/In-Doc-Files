# Ubuntu 20.04 baseline image from trusted registry
FROM amr-registry.caas.intel.com/esc-devops/baseline/linux/ubuntu/20.04:20201023_1253

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
		libegl1-mesa \
		libsdl1.2-dev \
		pylint3 \
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

RUN pip3 install GitPython pylint sphinx sphinx_rtd_theme pyyaml

# Others, download git proxy script from external
RUN curl -s http://git.yoctoproject.org/cgit/cgit.cgi/poky/plain/scripts/oe-git-proxy > /tmp/git-proxy
