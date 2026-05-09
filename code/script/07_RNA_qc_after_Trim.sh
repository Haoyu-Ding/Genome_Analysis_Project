#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:30:00
#SBATCH -J fastqc_after_trim
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load FastQC/0.12.1-Java-17

mkdir -p /home/dinghy/Genome_Analysis_Project/analysis/output/transcriptomics/fastqc_after_trim_output
mkdir -p /home/dinghy/Genome_Analysis_Project/analysis/output/transcriptomics/fastqc_after_trim_output/RNA-Seq_Serum
mkdir -p /home/dinghy/Genome_Analysis_Project/analysis/output/transcriptomics/fastqc_after_trim_output/RNA-Seq_BHI

fastqc /home/dinghy/Genome_Analysis_Project/data/transcriptomics/RNA-Seq_Serum/trimmed/*.fastq.gz -o /home/dinghy/Genome_Analysis_Project/analysis/output/transcriptomics/fastqc_after_trim_output/RNA-Seq_Serum

fastqc /home/dinghy/Genome_Analysis_Project/data/transcriptomics/RNA-Seq_BHI/trimmed/*.fastq.gz -o /home/dinghy/Genome_Analysis_Project/analysis/output/transcriptomics/fastqc_after_trim_output/RNA-Seq_BHI
