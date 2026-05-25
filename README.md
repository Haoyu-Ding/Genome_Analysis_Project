# Genome_Analysis_Project

This repository contains my Genome Analysis project based on **Paper I: Zhang et al. (2017)**,  
*RNA-seq and Tn-seq reveal fitness determinants of vancomycin-resistant Enterococcus faecium during growth in human serum*.

## Project overview

The goal of this project is to investigate how *Enterococcus faecium* E745 adapts to growth in heat-inactivated human serum compared with rich BHI medium.

In this project, I reproduced the following parts of the original study:

- PacBio genome assembly
- assembly evaluation
- synteny comparison with the published E745 chromosome
- genome annotation
- RNA-seq preprocessing
- RNA-seq mapping
- read counting
- differential expression analysis

In addition, I also performed an extra analysis:

- Illumina DNA mapping and SNP calling

This project reproduces the **genome assembly and RNA-seq** parts of the original paper, but **does not include the Tn-seq experiments**. Therefore, the transcriptomic results identify candidate genes and pathways associated with serum adaptation, but do not by themselves prove which genes are essential for growth in serum.

## Main biological question

How does the vancomycin-resistant clinical isolate *E. faecium* E745 survive and adapt to growth in a host-associated serum environment?

## Repository structure

```text
code/
  script/
    01_pacbio_qc_trim_assembly.sh
    02_pacbio_genome_evaluation.sh
    02_pacbio_genome_evaluation_withRef.sh
    03_pacbio_synteny_comparison.sh
    04_pacbio_annotation.sh
    05_RNA_qc_before_trim.sh
    06_RNA_trim.sh
    06_RNA_trim_ERR1797971.sh
    07_RNA_qc_after_Trim.sh
    08_RNA_mapping.sh
    09_RNA_counting_features.sh
    10_DE_analysis.R
    11_illumina_mapping.sh
    12_snp_calling.sh

