#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 06:00:00
#SBATCH -J RNA_trim_ERR1797971
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load Trimmomatic/0.39-Java-17
module list

ADAPTERS=/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-PE.fa
RAW_DIR=/home/dinghy/Genome_Analysis_Project/data/transcriptomics/RNA-Seq_Serum/raw
TRIM_DIR=/home/dinghy/Genome_Analysis_Project/data/transcriptomics/RNA-Seq_Serum/trimmed

mkdir -p "${TRIM_DIR}"

trimmomatic PE -threads 2 -phred33 \
  "${RAW_DIR}/ERR1797971_1.fastq.gz" \
  "${RAW_DIR}/ERR1797971_2.fastq.gz" \
  "${TRIM_DIR}/ERR1797971_1.paired.fastq.gz" \
  "${TRIM_DIR}/ERR1797971_1.unpaired.fastq.gz" \
  "${TRIM_DIR}/ERR1797971_2.paired.fastq.gz" \
  "${TRIM_DIR}/ERR1797971_2.unpaired.fastq.gz" \
  ILLUMINACLIP:${ADAPTERS}:2:30:10 \
  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
