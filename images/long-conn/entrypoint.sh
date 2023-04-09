#!/usr/bin/env bash

# Work around https://github.com/cilium/cilium/issues/24791.
echo "sleeping 15s to allow the egress rules to apply"
sleep 15

curl --keepalive-time 5 https://stream.wikimedia.org/v2/stream/recentchange
