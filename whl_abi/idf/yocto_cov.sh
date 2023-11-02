#!/bin/bash
export http_proxy=http://proxy-dmz.intel.com:912
export https_proxy=http://proxy-dmz.intel.com:912
export no_proxy=intel.com,.intel.com,10.0.0.0/8,192.168.0.0/16,localhost,.local,127.0.0.0/8,134.134.0.0/16
cd ${WORKSPACE}/meta-tep-build-setup
./setup.sh tep-container --options --manual
cd unified_build/tep-container
source ./openembedded-core/oe-init-build-env ./build-tep-container
bitbake -f -c compile mc:x86-tep-trusted-os-tgl-initramfs:ipc-p11-service-erpc mc:x86-tep-trusted-os-tgl-initramfs:ipc-p11-service-grpc mc:x86-tep-trusted-os-tgl-initramfs:ipc-p11-client-grpc mc:x86-tep-trusted-os-tgl-initramfs:ipc-p11-client-erpc mc:x86-tep-trusted-os-tgl-initramfs:tep-user-config mc:x86-tep-trusted-os-tgl-initramfs:tep-disk-encryption mc:x86-tep-trusted-os-tgl-initramfs:tagentlog mc:x86-tep-trusted-os-tgl-initramfs:trustagent
