#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 04:00:00
#SBATCH -J DNA_mapping
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

set -euo pipefail

module load BWA/0.7.19-GCCcore-13.3.0
module load SAMtools/1.22.1-GCC-13.3.0
module list

REFERENCE=/home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/canu_assembly_output/efm.contigs.fasta

R1=/home/dinghy/Genome_Analysis_Project/data/genomics/illumina/raw/E745-1.L500_SZAXPI015146-56_1_clean.fq.gz
R2=/home/dinghy/Genome_Analysis_Project/data/genomics/illumina/raw/E745-1.L500_SZAXPI015146-56_2_clean.fq.gz

OUTDIR=/home/dinghy/Genome_Analysis_Project/analysis/output/genomics/illumina_dna_mapping_output
PREFIX=E745_illumina_vs_pacbio

mkdir -p "${OUTDIR}"

if [ ! -f "${REFERENCE}.bwt" ]; then
    bwa index "${REFERENCE}"
fi

bwa mem -t 2 "${REFERENCE}" "${R1}" "${R2}" | \
samtools sort -@ 2 -o "${OUTDIR}/${PREFIX}.sorted.bam" -

samtools index -@ 2 "${OUTDIR}/${PREFIX}.sorted.bam"

samtools flagstat "${OUTDIR}/${PREFIX}.sorted.bam" > "${OUTDIR}/${PREFIX}.flagstat.txt"
