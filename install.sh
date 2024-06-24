#!/bin/bash
#
# FIXME(sjr): handle errors 

set -euo pipefail

FIRMWAREVERSION="1100"
BASE_DIR=/usr/local

deps() {
    dnf install --refresh -y gcc g++ llvm cmake libpcap-devel dpdk-devel bison
}

pppwn_binary() {
    pushd .
    cd PPPwn_cpp
    cmake -B build && \
        cmake --build build -t pppwn -- -j2 && \
        install -D -o root -g root -m 555 build/pppwn ${BASE_DIR}/bin/
    popd
}

pppwn_stages() {
    install -D -o root -g root -m 444 stages/"stage1_${FIRMWAREVERSION}".bin ${BASE_DIR}/share/pppwn/"stage1_${FIRMWAREVERSION}".bin && \
        install -D -o root -g root -m 444 stages/"stage2_${FIRMWAREVERSION}".bin ${BASE_DIR}/share/pppwn/"stage2_${FIRMWAREVERSION}".bin
}

misc() {
    install -o root -g root -m 644 systemd/pppwn.service /etc/systemd/system/ && \
        sed -i -e "s@REPLACE_BASE_DIR@${BASE_DIR}@g" /etc/systemd/system/pppwn.service && \
        systemctl daemon-reload && \
        systemctl enable --now pppwn.service
    install -D -o root -g root -m 644 config/example.conf ${BASE_DIR}/etc/pppwn.conf && \
        restorecon -FRv ${BASE_DIR}/etc/pppwn.conf ${BASE_DIR}/bin/pppwn \
            ${BASE_DIR}/share/pppwn /etc/systemd/system/pppwn.service && \
        systemctl enable --now pppwn.service
}

usage() {
    echo "$0 (1100|uninstall)"
    exit 0
}

uninstall() {
    rm -r "${BASE_DIR}/share/pppwn"
    rm -r "${BASE_DIR}/bin/pppwn"
    rm "${BASE_DIR}/etc/pppwn.conf"

    if (systemctl is-enabled pppwn.service); then
        systemctl disable --now pppwn.service
    fi

    rm /etc/systemd/system/pppwn.service

    systemctl daemon-reload

    if [[ -f "${BASE_DIR}/bin/pppwn-wrapper" ]]; then
        rm "${BASE_DIR}/bin/pppwn-wrapper"
    fi
}

main() {
    deps
    pppwn_binary
    pppwn_stages
    misc
}

[[ $# -ne 1 ]] && usage

case $1 in
    1100)
        main
        ;;
    "uninstall")
        uninstall
        ;;
    *)
       usage
        ;;
esac
