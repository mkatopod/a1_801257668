#!/bin/sh
set -eu

reps=${REPS:-5}
sizes=${SIZES:-1000000,10000000,100000000}

for level in O0 O2 O3; do
    make -f MakeFile clean
    make -f MakeFile prefix_sum CFLAGS="-$level -Wall -Wextra -std=c11"
    output="prefix_sum_${level}.csv"
    printf 'optimization, type, n, reps, avg_us, ns_per_element, checksum\n' > "$output"
    ./prefix_sum --sizes "$sizes" --reps "$reps" | tail -n +2 |
        sed "s/^/$level,/" >> "$output"
    printf 'Wrote %s\n' "$output"
done