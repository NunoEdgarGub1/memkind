#!/bin/bash
#
#
#  Copyright (2014) Intel Corporation All Rights Reserved.
#
#  This software is supplied under the terms of a license
#  agreement or nondisclosure agreement with Intel Corp.
#  and may not be copied or disclosed except in accordance
#  with the terms of that agreement.
#

basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
numactl --hardware | grep "^node 1" > /dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: $0 requires a NUMA enabled system with more than one node."
    exit -1
fi
hugetot=$(cat /proc/meminfo | grep HugePages_Total | awk '{print $2}')
if [ $hugetot -lt 4000 ]; then
    echo "ERROR: $0 requires at least 4000 2MB pages total (see /proc/meminfo)"
    exit -1
fi

if [ ! -f /sys/firmware/acpi/tables/PMTT ]; then
    export NUMAKIND_HBW_NODES=1
    numactl --membind=0 $basedir/all_tests $@
else
    $basedir/all_tests $@
fi
