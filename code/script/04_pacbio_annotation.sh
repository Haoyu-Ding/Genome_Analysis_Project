#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:15:00
#SBATCH -J genome_annotation
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load prokka/1.14.5-gompi-2024a
module list

prokka --outdir /home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/prokka_annotation_out \
       --prefix efm --kingdom Bacteria --genus Enterococcus --species faecium /home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/canu_assembly_output/efm.contigs.fasta
