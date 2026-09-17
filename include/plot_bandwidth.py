import argparse
import csv

import matplotlib.pyplot as plt


def read_cache_sizes(path):
    with open(path, newline="") as handle:
        return {row["level"]: int(row["bytes"]) for row in csv.DictReader(handle)}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("csv_file")
    parser.add_argument("--cache-csv", default="cache_sizes.csv")
    parser.add_argument("--output", default="bandwidth.png")
    args = parser.parse_args()

    with open(args.csv_file, newline="") as handle:
        rows = list(csv.DictReader(handle))

    array_bytes = [int(row["array_bytes"]) for row in rows]
    bandwidth = [float(row["bandwidth_bytes_per_s"]) / (1024 ** 3) for row in rows]
    cache_sizes = read_cache_sizes(args.cache_csv)

    plt.figure(figsize=(8, 5))
    plt.plot(array_bytes, bandwidth, marker="o", markersize=3)
    for level in ("L1", "L2", "L3"):
        if level in cache_sizes:
            size = cache_sizes[level]
            label = f"{level} ({size / 1024:.0f} KiB)" if size < 1024 ** 2 else f"{level} ({size / 1024 ** 2:.0f} MiB)"
            plt.axvline(size, linestyle="--", label=label)
    plt.xscale("log", base=2)
    plt.xlabel("Array size (bytes)")
    plt.ylabel("Read bandwidth (GiB/s)")
    plt.title("Double branchless maximum: memory bandwidth vs. array size")
    plt.grid(True, which="both", alpha=0.25)
    plt.legend()
    plt.tight_layout()
    plt.savefig(args.output, dpi=160)


if __name__ == "__main__":
    main()