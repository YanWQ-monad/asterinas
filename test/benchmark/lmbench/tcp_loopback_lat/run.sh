#!/bin/sh

# SPDX-License-Identifier: MPL-2.0

set -e

echo "*** Running lmbench TCP latency test ***"

/benchmark/bin/lat_tcp -s 127.0.0.1 -b 1
/benchmark/bin/lat_tcp -P 1 127.0.0.1
/benchmark/bin/lat_tcp -S 127.0.0.1
