#!/bin/bash

set -euo pipefail

FIRMWAREVERSION="${1:-1100}"

pppwn_binary() {
    pushd .
    cd PPPwn_cpp
    cmake -B build && \
        cmake --build build -t pppwn -- -j2 && \
        install -D -o root -g root -m 555 build/pppwn /usr/local/bin/
    popd
}

systemd_service() {
    install -o root -g root -m 644 systemd/pppwn.service /etc/systemd/system/ && \
        systemctl daemon-reload && \
        systemctl enable --now pppwn.service
}

pppwn_stages() {
    install -D -o root -g root -m 444 stages/"stage1_${FIRMWAREVERSION}".bin /usr/local/share/pppwn/"stage1_${FIRMWAREVERSION}".bin && \
        install -D -o root -g root -m 444 stages/"stage2_${FIRMWAREVERSION}".bin /usr/local/share/pppwn/"stage2_${FIRMWAREVERSION}".bin
}

misc() {
    install -D -o root -g root -m 644 config/example.conf /usr/local/etc/pppwn.conf && \
        install -D -o root -g root -m 555 scripts/pppwn-wrapper.sh /usr/local/bin/pppwn-wrapper

    restorecon -FRv /usr/local/{etc,bin,share} /etc/systemd/system
}

usage() {
    echo "$0 (900|1100)"
    exit 0
}

main() {
    pppwn_binary
    pppwn_stages
    misc
    systemd_service
}

[[ $# -ne 1 ]] && usage

main
