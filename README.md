# Array maximum bandwidth sweep

Build the benchmark on the Linux node:

```sh
make -f MakeFile
```

Record the node cache sizes and run the double branchless sweep:

```sh
sh cache_sizes.sh > cache_sizes.csv
./array_max_part1 --sweep --reps 12 > bandwidth.csv
```

The sweep measures array sizes from 2 KiB through 256 MiB, doubling each
time. Its CSV bandwidth is bytes per second, so the x-axis is already the
required array size in bytes.

Create the logarithmic plot with cache markers:

```sh
python3 plot_bandwidth.py bandwidth.csv --cache-csv cache_sizes.csv
```

This writes `bandwidth.png`. Compare the first sustained bandwidth drops with
the vertical L1, L2, and L3 markers and report whether each drop is near the
corresponding cache capacity.