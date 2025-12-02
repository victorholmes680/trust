#!/bin/bash
#
# create tun0
# sudo ip tuntap add dev tun0 mode tun -- dev is short for device

CARGO_TARGET_DIR="/root/workspace/stream/trust/target"
cargo b --release
ext=$?
if [[ $ext -ne 0 ]]; then
    exit $ext
fi
sudo setcap cap_net_admin=eip $CARGO_TARGET_DIR/release/trust
$CARGO_TARGET_DIR/release/trust &
pid=$!
#sudo ip addr add 10.8.0.1/16 dev tun0
sudo ip link set tun0 up
sudo ip link set up dev tun0
trap "kill $pid" INT TERM
wait $pid
