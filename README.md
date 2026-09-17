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
sh cache_sizes.sh > cache_sizes.csv
./array_max_part1 --sweep --reps 12 > bandwidth.csv
```

The sweep measures array sizes from 2 KiB through 256 MiB, doubling each
time. Its CSV bandwidth is bytes per second, so the x-axis is already the
required array size in bytes.

Create the logarithmic plot with cache markers:

```sh
python include/plot_bandwidth.py bandwidth.csv --cache-csv cache_sizes.csv
```

This writes `bandwidth.png`. Compare the first sustained bandwidth drops with
the vertical L1, L2, and L3 markers and report whether each drop is near the
corresponding cache capacity.