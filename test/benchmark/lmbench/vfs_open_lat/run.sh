#!/bin/sh

# SPDX-License-Identifier: MPL-2.0

set -e

echo "*** Running the LMbench open latency test ***"

touch testfile
/benchmark/bin/lat_syscall -P 1 -W 1000 -N 1000 open testfile