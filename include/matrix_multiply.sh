#!/bin/sh
#SBATCH --job-name=matrix-multiply
#SBATCH --partition=Centaurus
#SBATCH --time=01:00:00
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


reps=${REPS:-3}
opt_level=${OPT_LEVEL:-O3}
output=${OUTPUT:-matrix_multiply.csv}

make -f "$makefile" matrix_multiply OPT_LEVEL="$opt_level"
printf 'M, K, N, order, reps, avg_us, gflops, correct\n' > "$output"

for dimensions in \
    '256 256 256' \
    '512 512 512' \
    '1024 1024 1024' \
    '256 512 1024'
do
    set -- $dimensions
    ./matrix_multiply "$1" "$2" "$3" "$reps" | tail -n +2 >> "$output"
done

printf 'Wrote %s\n' "$output"