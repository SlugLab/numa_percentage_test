#!/bin/bash
first_arg="$1"
shift
echo First argument: "$first_arg"
echo Remaining arguments: "$@"

second_arg="$1"
shift
echo Secont argument: "$second_arg"
OMP_NUM_THREADS=$1 ./a.out &
pid1=$!
echo $pid1 >/sys/fs/cgroup/memory/numa/cgroup.procs
echo $(($first_arg * 1024 * 1024 * 1024)) >/sys/fs/cgroup/memory/numa/memory.limit_in_bytes
echo $pid1 >/sys/fs/cgroup/cpuset/numa/cgroup.procs
echo 0-1 >/sys/fs/cgroup/cpuset/numa/cpuset.mems
echo $second_arg >/sys/fs/cgroup/cpuset/numa/cpuset.cpus

/opt/intel/oneapi/vtune/latest/bin64/vtune -collect uarch-exploration -target-pid $pid1 -r test-numastat-$first_arg-uarch 2>&1 | tee test-numastat-$first_arg-uarch.txt &

while true; do
    # numastat -p $pid1 >> test-numastat-$first_arg.txt
    sleep 0.1
    if ! ps -p $pid1 >/dev/null; then
        kill -INT $pid2
        exit 0
    fi
done
