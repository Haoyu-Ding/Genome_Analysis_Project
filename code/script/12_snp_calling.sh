#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 06:00:00
#SBATCH -J snp_calling
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

set -euo pipefail

module load BCFtools/1.22.1-GCC-13.3.0
module load SAMtools/1.22.1-GCC-13.3.0
module list

REFERENCE=/home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/canu_assembly_output/efm.contigs.fasta
BAM=/home/dinghy/Genome_Analysis_Project/analysis/output/genomics/illumina_dna_mapping_output/E745_illumina_vs_pacbio.sorted.bam

OUTDIR=/home/dinghy/Genome_Analysis_Project/analysis/output/genomics/bcftools_snp_calling_output
PREFIX=E745_illumina_vs_pacbio

mkdir -p "${OUTDIR}"

if [ ! -f "${REFERENCE}.fai" ]; then
    samtools faidx "${REFERENCE}"
fi

if [ ! -f "${BAM}.bai" ]; then
    samtools index -@ 2 "${BAM}"
fi

bcftools mpileup \
  -Ou \
  -f "${REFERENCE}" \
  "${BAM}" | \
bcftools call \
  --ploidy 1 \
  -mv \
  -Oz \
  -o "${OUTDIR}/${PREFIX}.vcf.gz"

bcftools index "${OUTDIR}/${PREFIX}.vcf.gz"

bcftools view \
  -i 'QUAL>=20' \
  "${OUTDIR}/${PREFIX}.vcf.gz" \
  -Oz \
  -o "${OUTDIR}/${PREFIX}.QUAL20.vcf.gz"

bcftools index "${OUTDIR}/${PREFIX}.QUAL20.vcf.gz"

bcftools stats "${OUTDIR}/${PREFIX}.QUAL20.vcf.gz" > "${OUTDIR}/${PREFIX}.QUAL20.stats.txt"
