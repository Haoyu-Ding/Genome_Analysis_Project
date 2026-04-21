#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:20:00
#SBATCH -J assembly_evaluation
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load QUAST/5.3.0
module list

mkdir -p /home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/quast_assembly_evaluation_output

quast.py /home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/canu_assembly_output/efm.contigs.fasta \
         -o /home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/quast_assembly_evaluation_output
