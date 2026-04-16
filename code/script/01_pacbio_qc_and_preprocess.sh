#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -n 2
#SBATCH -t 03:00:00
#SBATCH -J pacbio_qc_and_preprocess
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load FastQC/0.12.1-Java-17
module load NanoFilt/2.8.0-foss-2023b

cd /home/dinghy/Genome_Analysis_Project

# 1.quality control(before)
fastqc data/genomics/pacbio/raw/*.subreads.fastq.gz \
    --outdir analysis/output/fastqc_before \
    --threads 2

# 2.preprocess
for f in data/genomics/pacbio/raw/*.subreads.fastq.gz; do
    base=$(basename $f .subreads.fastq.gz)
    zcat $f | NanoFilt -l 500 -q 7 | gzip > data/genomics/pacbio/filtered/${base}.filtered.fastq.gz
done

# combine them into one
zcat data/genomics/pacbio/filtered/*.filtered.fastq.gz | gzip > data/genomics/pacbio/filtered/all_filtered.fastq.gz

# 3.quality control(after)
fastqc data/genomics/pacbio/filtered/all_filtered.fastq.gz \
    --outdir analysis/output/fastqc_after \
    --threads 2
