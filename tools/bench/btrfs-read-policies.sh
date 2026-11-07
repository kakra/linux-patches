#!/bin/bash
# Benchmark the btrfs RAID1 read policies with fio.
#
# Usage: sudo tools/bench/btrfs-read-policies.sh [options] <dir> [<policy>...]
#
#   <dir>       a directory on the btrfs file system to test; the test file
#               is created there and kept for later runs
#   <policy>    read policies to test (default: all policies the kernel
#               offers in read_policy, except devid)
#
# Options:
#   -o <dir>    results directory (default: ./btrfs_policy_benchmark_<date>)
#   -s <size>   size of the test file (default: 50G, should exceed RAM and
#               cache)
#   -t <secs>   runtime per fio test (default: 120)
#   -n          skip the runs with a background defrag
#
# For each policy and with and without a background defrag (metadata heavy
# writes), runs random reads 4k QD1 and QD32 and sequential reads 1M QD16
# with direct I/O and dropped caches, and records the per-device read_stats
# before and after each test. The tests are the same as in the original
# script of 2025-04, so results stay comparable. The read policy is
# restored at the end. Summarize with tools/bench/fio-summary.py.
#
# Runtime: about 2 x 3 x <secs> per policy plus setup; the defaults take
# around 60 minutes for five policies and put the pool under heavy load.
#
# Based on the script published on 2025-04-25 in gist kakra/ce99896e5915f9b26d13c5637f56ff37.

set -uo pipefail

TOOLS=$(dirname "$0")/..
RESULTS_DIR=./btrfs_policy_benchmark_$(date +%Y%m%d_%H%M%S)
FIO_TEST_FILE_SIZE=50G
FIO_RUNTIME=120
DEFRAG_STATES=(off on)

while getopts o:s:t:n opt; do
	case $opt in
	o) RESULTS_DIR=$OPTARG ;;
	s) FIO_TEST_FILE_SIZE=$OPTARG ;;
	t) FIO_RUNTIME=$OPTARG ;;
	n) DEFRAG_STATES=(off) ;;
	*) exit 1 ;;
	esac
done
shift $((OPTIND - 1))
(($# >= 1)) || {
	sed -n '2,16p' "$0" >&2
	exit 1
}
BTRFS_MOUNT_POINT=$1
shift

[[ $EUID -eq 0 ]] || {
	echo "error: needs root (read policy, drop_caches)" >&2
	exit 1
}
FSID=$(findmnt -no UUID -T "$BTRFS_MOUNT_POINT") && [[ -n $FSID ]] || {
	echo "error: $BTRFS_MOUNT_POINT is not on a mounted file system" >&2
	exit 1
}
SYSFS_POLICY_PATH=/sys/fs/btrfs/$FSID/read_policy
SYSFS_DEVINFO_PATH=/sys/fs/btrfs/$FSID/devinfo
[[ -w $SYSFS_POLICY_PATH ]] || {
	echo "error: $SYSFS_POLICY_PATH not found, is this btrfs with read policies?" >&2
	exit 1
}

ORIGINAL_POLICY=$(sed -E 's/.*\[([^]]+)\].*/\1/' "$SYSFS_POLICY_PATH")
if (($# > 0)); then
	POLICIES_TO_TEST=("$@")
else
	read -ra POLICIES_TO_TEST < <(tr -d '[]' <"$SYSFS_POLICY_PATH" |
		tr ' ' '\n' | sed 's/:.*//' | grep -vx 'devid' | tr '\n' ' ')
fi

FIO_TEST_FILE=$BTRFS_MOUNT_POINT/fiotest.tmp
mkdir -p "$RESULTS_DIR"
DEFRAG_PID=

log() {
	echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$RESULTS_DIR/benchmark.log"
}

set_policy() {
	log "Setting read policy to: $1"
	if ! echo "$1" >"$SYSFS_POLICY_PATH"; then
		log "ERROR: Failed to set policy $1"
		exit 1
	fi
	sleep 1
	log "Current policy: $(cat "$SYSFS_POLICY_PATH")"
}

get_read_stats() {
	{
		echo "--- Timestamp: $(date +'%Y-%m-%d %H:%M:%S.%N') ---"
		for f in "$SYSFS_DEVINFO_PATH"/*/read_stats; do
			echo "devinfo/$(basename "$(dirname "$f")")/read_stats:$(cat "$f")"
		done
		echo "--- End Stats ---"
	} >>"$1" 2>&1
}

run_fio_test() {
	local test_name=$1 rw_mode=$2 block_size=$3 io_depth=$4 output_file=$5
	log "Starting fio test: $test_name (rw=$rw_mode, bs=$block_size, iodepth=$io_depth)"
	sync && echo 3 >/proc/sys/vm/drop_caches
	if fio --filename="$FIO_TEST_FILE" --filesize="$FIO_TEST_FILE_SIZE" --direct=1 \
		--rw="$rw_mode" --bs="$block_size" --iodepth="$io_depth" \
		--ioengine=libaio --group_reporting --time_based --runtime="$FIO_RUNTIME" \
		--name="$test_name" --output="$output_file" \
		--exitall_on_error --refill_buffers --norandommap; then
		log "Finished fio test: $test_name"
	else
		log "ERROR: fio test $test_name failed, stopping"
		return 1
	fi
}

start_defrag() {
	log "Starting background defrag on $BTRFS_MOUNT_POINT"
	btrfs filesystem defrag -r "$BTRFS_MOUNT_POINT" >"$RESULTS_DIR/defrag.log" 2>&1 &
	DEFRAG_PID=$!
	sleep 5
}

stop_defrag() {
	if [[ -n $DEFRAG_PID ]] && kill -0 "$DEFRAG_PID" 2>/dev/null; then
		log "Stopping background defrag (PID $DEFRAG_PID)"
		kill "$DEFRAG_PID"
		wait "$DEFRAG_PID" 2>/dev/null
	fi
	DEFRAG_PID=
}

cleanup() {
	stop_defrag
	echo "$ORIGINAL_POLICY" >"$SYSFS_POLICY_PATH" 2>/dev/null &&
		log "Restored read policy: $ORIGINAL_POLICY"
}
trap cleanup EXIT
trap 'exit 130' INT TERM

log "Benchmark Started"
log "Mount point: $BTRFS_MOUNT_POINT"
log "Policies: ${POLICIES_TO_TEST[*]}"
log "Defrag states: ${DEFRAG_STATES[*]}"
log "Test file size: $FIO_TEST_FILE_SIZE, runtime per test: ${FIO_RUNTIME}s"
log "Results Dir: $RESULTS_DIR"
"$TOOLS/state.sh" >"$RESULTS_DIR/state.txt" 2>&1

log "Setting up fio test file..."
if ! fio --name=setup --filename="$FIO_TEST_FILE" --size="$FIO_TEST_FILE_SIZE" \
	--rw=write --bs=1M --iodepth=16 --direct=1 --ioengine=libaio --exitall_on_error \
	>"$RESULTS_DIR/setup.log" 2>&1; then
	log "ERROR: Failed to create/setup test file $FIO_TEST_FILE"
	exit 1
fi
log "Test file setup complete."

for defrag_state in "${DEFRAG_STATES[@]}"; do
	log "===== Starting tests with Defrag $defrag_state ====="
	for policy in "${POLICIES_TO_TEST[@]}"; do
		log "----- Testing Policy: $policy -----"
		set_policy "$policy"
		sync && echo 3 >/proc/sys/vm/drop_caches
		sleep 5
		[[ $defrag_state == on ]] && start_defrag

		for test in "randread 4k 1 RandRead_4k_QD1 randread_4k_qd1" \
			"randread 4k 32 RandRead_4k_QD32 randread_4k_qd32" \
			"read 1M 16 SeqRead_1M_QD16 seqread_1M_qd16"; do
			read -r rw bs qd name id <<<"$test"
			test_id=defrag_${defrag_state}_policy_${policy}_fio_${id}
			get_read_stats "$RESULTS_DIR/${test_id}_readstats.txt"
			run_fio_test "$name" "$rw" "$bs" "$qd" "$RESULTS_DIR/${test_id}_fio.txt" || exit 1
			get_read_stats "$RESULTS_DIR/${test_id}_readstats.txt"
		done

		[[ $defrag_state == on ]] && stop_defrag
		log "----- Finished Policy: $policy -----"
		sleep 5
	done
	log "===== Finished tests with Defrag $defrag_state ====="
done

log "Benchmark Finished"
echo "Results saved in: $RESULTS_DIR"
