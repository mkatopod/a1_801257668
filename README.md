# Array maximum bandwidth sweep

From WSL, install the Python plotting dependency in a virtual environment:

```sh
sudo apt update
sudo apt install python3-pip python3-venv
python3 -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt
```

Build the benchmark on the Linux node or from WSL:

```sh
make -f MakeFile
```

Record the node cache sizes and run the double branchless sweep:

```sh
sh include/cache_sizes.sh > include/cache_sizes.csv
./array_max_part1 --sweep --reps 12 > include/bandwidth.txt
```

The sweep measures array sizes from 2 KiB through 256 MiB, doubling each
time. Its CSV bandwidth is bytes per second, so the x-axis is already the
required array size in bytes.

Create the logarithmic plot with cache markers:

```sh
python include/plot_bandwidth.py include/bandwidth.txt
```

This writes `bandwidth.png`. Compare the first sustained bandwidth drops with
the vertical L1, L2, and L3 markers and report whether each drop is near the
corresponding cache capacity.

## Exclusive prefix sum

The in-place implementation is in `include/prefix_sum_part2.c`. It replaces
each element with the running sum before that element, so the first output is
zero. The input is refilled between repetitions, outside the timed region.

From Linux or WSL, measure `n = 10^6`, `10^7`, and `10^8` for both types at all
three requested optimization levels:

```sh
sh include/prefix_sum_measure.sh
```

This creates `prefix_sum_O0.csv`, `prefix_sum_O2.csv`, and `prefix_sum_O3.csv`.
Use `REPS=12` to match the first benchmark or `SIZES=...` to choose a different
size list.