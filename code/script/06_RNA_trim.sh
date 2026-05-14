#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 28:00:00
#SBATCH -J RNA_trim
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load Trimmomatic/0.39-Java-17
module list

ADAPTERS=/sw/arch/eb/software/Trimmomatic/0.39-Java-17/adapters/TruSeq3-PE.fa
BASE=/home/dinghy/Genome_Analysis_Project/data/transcriptomics

for CONDITION in RNA-Seq_BHI RNA-Seq_Serum; do
    RAW_DIR="${BASE}/${CONDITION}/raw"
    TRIM_DIR="${BASE}/${CONDITION}/trimmed"

    mkdir -p "${TRIM_DIR}"

    for R1 in "${RAW_DIR}"/*_1.fastq.gz; do
        SAMPLE=$(basename "${R1}" _1.fastq.gz)
        R2="${RAW_DIR}/${SAMPLE}_2.fastq.gz"

        echo "Trimming ${CONDITION} / ${SAMPLE}"

        trimmomatic PE -threads 2 -phred33 \
          "${R1}" \
          "${R2}" \
          "${TRIM_DIR}/${SAMPLE}_1.paired.fastq.gz" \
          "${TRIM_DIR}/${SAMPLE}_1.unpaired.fastq.gz" \
          "${TRIM_DIR}/${SAMPLE}_2.paired.fastq.gz" \
          "${TRIM_DIR}/${SAMPLE}_2.unpaired.fastq.gz" \
          ILLUMINACLIP:${ADAPTERS}:2:30:10 \
          LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    done
done
