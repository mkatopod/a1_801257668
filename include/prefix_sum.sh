#!/bin/sh
#SBATCH --job-name=prefix-sum
#SBATCH --partition=Centaurus
#SBATCH --time=00:30:00
#SBATCH --mem=32G

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$script_dir/.."

reps=${REPS:-5}
sizes=${SIZES:-1000000,10000000,100000000}

for level in O0 O2 O3; do
    make -f MakeFile clean
    make -f MakeFile prefix_sum OPT_LEVEL="$level"
    output="prefix_sum_${level}.csv"
    printf 'optimization, type, n, reps, avg_us, ns_per_element, checksum\n' > "$output"
    ./prefix_sum --sizes "$sizes" --reps "$reps" | tail -n +2 |
        sed "s/^/$level,/" >> "$output"
    printf 'Wrote %s\n' "$output"
done