#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 03:00:00
#SBATCH -J pacbio_qc_and_preprocess
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out
