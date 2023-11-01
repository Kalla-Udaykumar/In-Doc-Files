#!/bin/bash
cd ${WORKSPACE}/meta-tep-build-setup
./setup.sh tep-container --options --manual
cd unified_build/tep-container
source ./openembedded-core/oe-init-build-env ./build-tep-container
bitbake -f -c compile mc:x86-tep-trusted-os-tgl-initramfs:ipc-p11-service-erpc mc:x86-tep-trusted-os-tgl-initramfs:ipc-p11-service-grpc mc:x86-tep-trusted-os-tgl-initramfs:ipc-p11-client-grpc mc:x86-tep-trusted-os-tgl-initramfs:ipc-p11-client-erpc mc:x86-tep-trusted-os-tgl-initramfs:tep-user-config mc:x86-tep-trusted-os-tgl-initramfs:tep-disk-encryption mc:x86-tep-trusted-os-tgl-initramfs:tagentlog mc:x86-tep-trusted-os-tgl-initramfs:trustagent
