#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 08:00:00
#SBATCH -J pacbio_assembly
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load SAMtools/1.22.1-GCC-13.3.0
module load canu/2.3-GCCcore-13.3.0-Java-17
module list

cd /home/dinghy/Genome_Analysis_Project/data/genomics/pacbio/raw

canu -p efm -d /home/dinghy/Genome_Analysis_Project/analysis/output/genomics/pacbio/canu_assembly_output \
  genomeSize=3.0m \
  useGrid=false \
  maxThreads=2 \
  corThreads=2 \
  oeaThreads=2 \
  cnsThreads=2 \
  -pacbio-raw *.subreads.fastq.gz
