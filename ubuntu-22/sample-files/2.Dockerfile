# FROM BASE IMAGE
FROM mips22:0011

RUN env DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y \
        libva-glx2 \
        libvpl-dev \
        libvpl2 \
        vainfo

RUN cd /tmp && \
    git clone -b v2.17-branch https://github.com/intel/libva.git media/libva && \
    cd media/libva && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu/ && \
    make -j8 && \
    sudo make install

RUN cd /tmp && \
    git clone -b v2.17-branch https://github.com/intel/libva-utils.git media/libva-utils && \
    cd media/libva-utils && \
    ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu/ && \
    make -j8 && \
    sudo make install

RUN cd /tmp && \
    mkdir media_driver && cd media_driver && \
    git clone -b intel-media-23.1 https://github.com/intel/media-driver.git && \
#   wget https://github.com/intel/gmmlib/releases/tag/intel-gmmlib-22.3.3 && \
    git clone -b intel-gmmlib-22.3.3 https://github.com/intel/gmmlib.git && \ 
    mkdir build_media && cd build_media && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/ -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu/ ../media-driver/ && \
    make -j8 && \
    sudo make install

