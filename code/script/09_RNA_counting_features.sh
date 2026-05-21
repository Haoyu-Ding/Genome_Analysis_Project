#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 08:00:00
#SBATCH -J htseq_count
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

set -euo pipefail

module load HTSeq/2.1.2-gfbf-2024a
module list

MAP_BASE=/home/dinghy/Genome_Analysis_Project/analysis/output/transcriptomics/bwa_mapping_output
ANNOT_BASE=/home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/prokka_annotation_out
OUT_BASE=/home/dinghy/Genome_Analysis_Project/analysis/output/transcriptomics/htseq_counts_out

RAW_GFF="${ANNOT_BASE}/efm.gff"
CLEAN_GFF="${ANNOT_BASE}/efm.noFASTA.gff"

mkdir -p "${OUT_BASE}"

awk '/^##FASTA/{exit} {print}' "${RAW_GFF}" > "${CLEAN_GFF}"

for CONDITION in RNA-Seq_BHI RNA-Seq_Serum; do
    BAM_DIR="${MAP_BASE}/${CONDITION}"
    COUNT_DIR="${OUT_BASE}/${CONDITION}"

    mkdir -p "${COUNT_DIR}"

    for BAM in "${BAM_DIR}"/*.sorted.bam; do
        SAMPLE=$(basename "${BAM}" .sorted.bam)

        echo "$(date) Counting ${CONDITION} / ${SAMPLE}"

        htseq-count \
          -f bam \
          -r pos \
          -s no \
          -t CDS \
          -i ID \
          "${BAM}" \
          "${CLEAN_GFF}" \
          > "${COUNT_DIR}/${SAMPLE}.htseq.counts.txt"

        echo "$(date) Finished ${CONDITION} / ${SAMPLE}"
    done
done
