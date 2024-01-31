FROM gvp-base:latest

ARG OPENVINO_INSTALL_DIR=/opt/intel/openvino
ARG OPENVION_ENV=$OPENVINO_INSTALL_DIR/setupvars.sh
ARG DPCPP_ENV=/opt/intel/oneapi/compiler/2021.2.0/env/vars.sh

ARG OpenCV_DIR=/root/opencv/build/install
ARG LD_LIBRARY_PATH=/root/opencv/build/install:${LD_LIBRARY_PATH}
ARG PYTHONPATH=/root/opencv/build/install/python:${PYTHONPATH}

WORKDIR /root
RUN wget https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.10.0%2Bcpu.zip
RUN unzip libtorch-cxx11-abi-shared-with-deps-1.10.0+cpu.zip
#TorchVision library(v0.11.1)

RUN wget https://github.com/pytorch/vision/archive/refs/tags/v0.11.1.zip
RUN unzip v0.11.1.zip
RUN cd vision-0.11.1/ &&\
 mkdir build && \
 cd build && \
 cd ../../ && \
 current_working_directory=$(pwd) && \
 cd $current_working_directory && \
 cd vision-0.11.1/build \
&& cmake -DCMAKE_PREFIX_PATH=/root/libtorch -DCMAKE_INSTALL_PREFIX=/root/ptlibs/torchvision-install .. \
&& make -j8 \
&& make install
#New Environment variable for MIPS backend compilation
ARG Torch_DIR=/root/libtorch/share/cmake/Torch
ARG PYTORCH_CPU_LIB_PATH=/root/libtorch
ARG TorchVision_DIR=/root/ptlibs/torchvision-install/share/cmake/TorchVision
ARG TORCHVISION_CPU_LIB_PATH=/root/ptlibs/torchvision-install

WORKDIR /root

RUN mkdir tf_library \
&& cd tf_library \
&& wget https://af01p-png.devtools.intel.com/artifactory/hspe-edge-png-local/ubuntu-adl/TF/ww38/libtensorflow.tar.gz \
&& tar -xvf libtensorflow.tar.gz -C /root/tf_library \
&& cd ..

ENV no_proxy "127.0.0.1,localhost,intel.com,.intel.com,af01p-png.devtools.intel.com,ubit-artifactory-or.intel.com,10.34.40.193,10.34.42.14,10.221.253.199"


ARG Torch_DIR=/root/libtorch/share/cmake/Torch
ARG PYTORCH_CPU_LIB_PATH=/root/libtorch
ARG TorchVision_DIR=/root/ptlibs/torchvision-install/share/cmake/TorchVision
ARG TORCHVISION_CPU_LIB_PATH=/root/ptlibs/torchvision-install
ARG LIBVA_DRIVERS_PATH='/usr/lib/x86_64-linux-gnu/dri'
ARG LIBVA_DRIVER_NAME='iHD'
ARG LD_LIBRARY_PATH='/usr/local/lib/:$LD_LIBRARY_PATH'
ARG LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/2021.2.0/linux/lib:/opt/intel/oneapi/compiler/2021.2.0/linux/compiler/lib/intel64_lin/:$LD_LIBRARY_PATH
ARG STREAM_PATH=applications.media.gui.mips/content/
ARG RTSPSERVER_PATH=applications.media.gui.mips/tools/rtsp-server/
ARG SPDLOG_LEVEL='info'
ARG TEMPLATE_PATH=applications.media.gui.mips/mfil/templates/
ARG LIBGPU_PATH=applicatios.media.gui.mips/mfdl/src/Node/WatermarkNode/lib/
ARG cl_cache_dir=mipsdep/cl_cache
ARG TENSORFLOW_CPU_LIB_PATH=/root/tf_library
RUN mkdir /opt/intel/mips-binary




WORKDIR /root

RUN wget https://dl.influxdata.com/influxdb/releases/influxdb_1.8.6_amd64.deb
RUN dpkg -i influxdb_1.8.6_amd64.deb \
&& apt-get install libcurl4-gnutls-dev


ARG username
ARG token
#iti-client

#requirement libcurl4-openssl-dev
RUN apt-get install -y libcurl4-openssl-dev cython3 libmfx-dev libavdevice-dev libavfilter-dev chrpath libssl-dev libmfx-gen-dev -y\
&& GIT_LFS_SKIP_SMUDGE=1 git clone https://$username:$token@github.com/intel-sandbox/applications.services.gvp.observability -b v0.7-sprint14 \
&& cd applications.services.gvp.observability && ./build_all.sh && dpkg -i iti-client-*-amd64.deb \
&& cd /root/applications.services.gvp.observability/third_party/opentelemetry-cpp/build \
&& make -j8 install


#MIPS
RUN git clone https://$username:$token@github.com/intel-sandbox/applications.media.gui.mips-sandbox.git applications.media.gui.mips 
RUN cd applications.media.gui.mips \
&& ls \
&& git checkout upgrade_observability_lib \
&& sed -i "s|https://github.com/intel-sandbox|..|g" .gitmodules \
&& git submodule update --init --recursive \
&& git submodule update --recursive \
&& mkdir build \
&& cd build \
&& source /opt/intel/openvino/setupvars.sh \
&& cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DBUILD_TEST=1 -DCMAKE_INSTALL_PREFIX=/opt/intel/mips-binary \
&& make -j8 \
&& make install

RUN export RTSP_SERVERKEY=/root/applications.media.gui.mips/content/TestVectors/certs/server.key
RUN export RTSP_SERVERCERT=/root/applications.media.gui.mips/content/TestVectors/certs/server.crt

RUN echo 'source /opt/intel/openvino/setupvars.sh' >> ~/.bashrc
RUN echo '# Media driver' >> ~/.bashrc
RUN echo 'export LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri' >> ~/.bashrc
RUN echo 'export LIBVA_DRIVER_NAME=iHD' >> ~/.bashrc

RUN echo '# OpenVINO' >> ~/.bashrc
RUN echo 'source /opt/intel/openvino/setupvars.sh' >> ~/.bashrc

RUN echo "#opencv" >> ~/.bashrc
RUN echo "export OpenCV_DIR=/root/opencv/build/install/cmake" >> ~/.bashrc
RUN echo "export LD_LIBRARY_PATH=/root/opencv/build/install/lib:${LD_LIBRARY_PATH}" >> ~/.bashrc
RUN echo "export PYTHONPATH=/root/opencv/build/install/python:${PYTHONPATH}" >> ~/.bashrc

RUN echo '# OneAPI' >> ~/.bashrc
RUN echo 'export LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/2021.2.0/linux/lib:/opt/intel/oneapi/compiler/2021.2.0/linux/compiler/lib/intel64_lin/:$LD_LIBRARY_PATH' >> ~/.bashrc

RUN echo 'export cl_cache_dir=/root/cl_cache/' >> ~/.bashrc

RUN echo '# MIPS backend environment variable' >> ~/.bashrc
RUN echo 'export STREAM_PATH=/root/applications.media.gui.mips/content/' >> ~/.bashrc
RUN echo 'export RTSPSERVER_PATH=/root/applications.media.gui.mips/tools/rtsp-server/' >> ~/.bashrc
RUN echo 'export SPDLOG_LEVEL=info' >> ~/.bashrc
RUN echo 'export TEMPLATE_PATH=/root/applications.media.gui.mips/mfil/templates/' >> ~/.bashrc
RUN echo 'export LIBGPU_PATH=/root/applications.media.gui.mips/mfdl/src/Node/WatermarkNode/lib/' >> ~/.bashrc
RUN echo 'export TENSORFLOW_CPU_LIB_PATH=/root/tf_library/' >> ~/.bashrc
RUN echo 'source /opt/intel/dg_media_driver/dg2.sh' >> ~/.bashrc
RUN echo 'export Torch_DIR=/root/libtorch/share/cmake/Torch' >> ~/.bashrc
RUN echo 'export PYTORCH_CPU_LIB_PATH=/root/libtorch' >> ~/.bashrc
RUN echo 'export TorchVision_DIR=/root/ptlibs/torchvision-install/share/cmake/TorchVision' >> ~/.bashrc
RUN echo 'export TORCHVISION_CPU_LIB_PATH=/root/ptlibs/torchvision-install' >> ~/.bashrc
RUN echo 'export MFDLROOT=/opt/intel/mips-binary/' >> ~/.bashrc
RUN echo 'export LD_LIBRARY_PATH=$TENSORFLOW_CPU_LIB_PATH/lib/:$MFDLROOT/lib/:$TORCHVISION_CPU_LIB_PATH/lib/:$PYTORCH_CPU_LIB_PATH/lib/:/root/applications.services.gvp.observability/third_party/pre-generated/opentelemetry-cpp/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
RUN echo 'export WAYLAND_DISPLAY=wayland-0' >> ~/.bashrc


RUN cp -rf /root/applications.media.gui.mips/content/TestVectors/models/* /root/applications.media.gui.mips/content/
RUN mkdir -p /root/applications.media.gui.mips/content/output



CMD ["/bin/bash"]
