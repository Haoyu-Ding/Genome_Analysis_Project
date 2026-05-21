#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 04:00:00
#SBATCH -J RNA_mapping
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load BWA/0.7.19-GCCcore-13.3.0
module load SAMtools/1.22.1-GCC-13.3.0
module list

REFERENCE=/home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/canu_assembly_output/efm.contigs.fasta
BASE=/home/dinghy/Genome_Analysis_Project/data/transcriptomics
OUTBASE=/home/dinghy/Genome_Analysis_Project/analysis/output/transcriptomics/BWA_RNA_mapping_output

mkdir -p "$OUTBASE"

if [ ! -f "${REFERENCE}.bwt" ]; then
    echo "Indexing reference with BWA"
    bwa index "$REFERENCE"
fi

for CONDITION in RNA-Seq_BHI RNA-Seq_Serum; do
    TRIM_DIR="${BASE}/${CONDITION}/trimmed"
    MAP_DIR="${OUTBASE}/${CONDITION}"

    mkdir -p "$MAP_DIR"

    for R1 in "${TRIM_DIR}"/*_1.paired.fastq.gz; do
        SAMPLE=$(basename "${R1}" _1.paired.fastq.gz)
        R2="${TRIM_DIR}/${SAMPLE}_2.paired.fastq.gz"

        echo "Mapping ${CONDITION} / ${SAMPLE}"

        bwa mem -t 2 "$REFERENCE" "$R1" "$R2" | \
        samtools sort -@ 2 -o "${MAP_DIR}/${SAMPLE}.sorted.bam" -

        samtools index -@ 2 "${MAP_DIR}/${SAMPLE}.sorted.bam"

        samtools flagstat "${MAP_DIR}/${SAMPLE}.sorted.bam" > "${MAP_DIR}/${SAMPLE}.flagstat.txt"
    done
done
