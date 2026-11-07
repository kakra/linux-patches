#!/usr/bin/env python3
"""Summarize the fio results of btrfs-read-policies.sh as a Markdown table.

Usage: tools/bench/fio-summary.py <results dir>

Reads the fio text output files named
  defrag_<on|off>_policy_<policy>_fio_<test>_fio.txt
and prints one row per defrag state, test, policy and direction: IOPS,
bandwidth, average total latency and the 99th and 99.9th completion latency
percentiles. Works for runs of the original gist script as well.
"""

import pathlib
import re
import sys

NAME = re.compile(r"defrag_(on|off)_policy_(.+)_fio_(.+)_fio\.txt$")
UNIT = {"nsec": 1e-6, "usec": 1e-3, "msec": 1.0}
SCALE = {"": 1, "k": 1e3, "M": 1e6}
BW = {"B/s": 1 / 1024, "KiB/s": 1, "MiB/s": 1024, "GiB/s": 1024 * 1024}


def number(text):
    m = re.fullmatch(r"([\d.]+)([kM]?)", text)
    return float(m.group(1)) * SCALE[m.group(2)]


def parse(path):
    """Return {direction: metrics} for one fio output file."""
    result = {}
    section = None
    pct_unit = None
    for line in path.read_text(errors="replace").splitlines():
        m = re.match(r"\s+(read|write): IOPS=([\d.]+[kM]?), BW=([\d.]+)(\w+/s)", line)
        if m:
            section = m.group(1)
            result[section] = {
                "iops": number(m.group(2)),
                "bw": float(m.group(3)) * BW[m.group(4)],
            }
            continue
        if section is None:
            continue
        m = re.match(r"\s+lat \((\w+)\): min=.*avg=\s*([\d.]+)", line)
        if m and m.group(1) in UNIT:
            result[section]["avg"] = float(m.group(2)) * UNIT[m.group(1)]
            continue
        m = re.match(r"\s+clat percentiles \((\w+)\):", line)
        if m:
            pct_unit = UNIT[m.group(1)]
            continue
        if pct_unit is not None:
            for key, pct in (("p99", "99.00th"), ("p999", "99.90th")):
                m = re.search(re.escape(pct) + r"=\[\s*(\d+)\]", line)
                if m:
                    result[section][key] = int(m.group(1)) * pct_unit
            if not line.lstrip().startswith("|"):
                pct_unit = None
    return result


def fmt(value, digits):
    return "-" if value is None else f"{value:,.{digits}f}"


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__.strip().splitlines()[2])
    rows = []
    for path in sorted(pathlib.Path(sys.argv[1]).glob("*_fio.txt")):
        m = NAME.search(path.name)
        if not m:
            continue
        defrag, policy, test = m.groups()
        # Runs with several fio jobs carry the job count in the policy part
        # of the name (pid_jobs4); keep it out of the policy column.
        policy = re.sub(r"_jobs\d+$", "", policy)
        for direction, v in parse(path).items():
            rows.append((defrag, test, policy, direction, v))
    if not rows:
        sys.exit("no fio results found")
    order = {"off": 0, "on": 1}
    rows.sort(key=lambda r: (order[r[0]], r[1], r[3], r[2]))
    print("| Defrag | Test | Policy | Dir | IOPS | BW (KiB/s) | Avg lat (ms) | 99% (ms) | 99.9% (ms) |")
    print("|---|---|---|---|---:|---:|---:|---:|---:|")
    for defrag, test, policy, direction, v in rows:
        print(
            f"| {defrag} | {test} | {policy} | {direction} | {fmt(v.get('iops'), 0)} "
            f"| {fmt(v.get('bw'), 0)} | {fmt(v.get('avg'), 2)} "
            f"| {fmt(v.get('p99'), 2)} | {fmt(v.get('p999'), 2)} |"
        )


if __name__ == "__main__":
    main()
