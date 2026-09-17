#!/bin/bash
#SBATCH --job-name=4145-demonstration
#SBATCH --partition=Centaurus
#SBATCH --time=00:10:00
#SBATCH --mem=32G
make -f MakeFile
./array_max_part1 --sweep --reps 12 > bandwidth.csv
