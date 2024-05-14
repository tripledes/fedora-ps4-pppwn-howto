#!/bin/bash
#
# Script that watches over the pppwn binary.
# * Resets the Ethernet link so the PS4 (re) tries the PPPoe connection
# * Starts the pppwn binary with the right arguments
# * If successful, the Pi shuts down

set -euo pipefail

BASEDIR=$(dirname "$0")
CONFIG=$(dirname "${BASEDIR}")/etc/pppwn.conf
STAGES_DIR=$(dirname "${BASEDIR}")/share/pppwn

if [ ! -f "${CONFIG}" ]; then echo "to load the config file ${CONFIG}"; exit 1; fi

source "${CONFIG}"

(ip link set "${INTERFACE}" down && sleep 2 && ip link set "${INTERFACE}" up && sleep 2) || exit 1

if "${BASEDIR}"/pppwn --interface "${INTERFACE}" --fw "${FIRMWAREVERSION}" --stage1 \
    "${STAGES_DIR}/stage1_${FIRMWAREVERSION}.bin" --stage2 \
    "${STAGES_DIR}/stage2_${FIRMWAREVERSION}.bin"; then
    [[ $SHUTDOWN == "yes" ]] && systemctl poweroff
    exit 0
fi

exit 1
