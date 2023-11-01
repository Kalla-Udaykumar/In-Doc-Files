#!/bin/bash
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/pkcs11
cd ${WORKSPACE}/abi/bandit/meta-tep-ipc-stack/
./bootstrap.sh
cd ipc_stack/grpc
mkdir build
cd build 
cmake -DCMAKE_PREFIX_PATH=../../3rd_party/grpc/cmake/build/install_dir -DENABLE_CLIENT=1 -DENABLE_SERVER=1 ../
make -j
