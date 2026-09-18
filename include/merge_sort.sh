#!/bin/sh
#SBATCH --job-name=merge-sort
#SBATCH --partition=Centaurus
#SBATCH --time=02:00:00
#SBATCH --mem=32G

set -eu

submit_dir=${SLURM_SUBMIT_DIR:-$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)}
if [ -f "$submit_dir/MakeFile" ] || [ -f "$submit_dir/Makefile" ]; then
    project_dir=$submit_dir
else
    project_dir=$(CDPATH= cd -- "$submit_dir/.." && pwd)
fi

cd "$project_dir"

if [ -f "$project_dir/MakeFile" ]; then
    makefile=$project_dir/MakeFile
else
    makefile=$project_dir/Makefile
fi

reps=${REPS:-1}
opt_level=${OPT_LEVEL:-O3}
output=${OUTPUT:-merge_sort.csv}

make -f "$makefile" merge_sort OPT_LEVEL="$opt_level"
printf 'n, input, method, repetitions, avg_us, rate_mitems_per_s, sorted_and_preserved\n' > "$output"

for size in 1000000 10000000 100000000; do
    ./merge_sort "$size" "$reps" | tail -n +2 >> "$output"
done

printf 'Wrote %s\n' "$output"