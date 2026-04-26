#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:15:00
#SBATCH -J synteny_comparison
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load MUMmer/4.0.1-GCCcore-13.3.0
module list

mkdir -p /home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/mummerplot_synteny_comparison_output
cd /home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/mummerplot_synteny_comparison_output

nucmer --prefix=efm_vs_E745_chr /home/dinghy/Genome_Analysis_Project/data/genomics/E745/E745_chr_CP014529.fasta \
	/home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/canu_assembly_output/efm.contigs.fasta

delta-filter -r -q efm_vs_E745_chr.delta > efm_vs_E745_chr.filter.delta

mummerplot \
  --png \
  --layout \
  -R /home/dinghy/Genome_Analysis_Project/data/genomics/E745/E745_chr_CP014529.fasta \
  -Q /home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/canu_assembly_output/efm.contigs.fasta \
  -p efm_vs_E745_chr \
  efm_vs_E745_chr.filter.delta
