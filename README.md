                                                                           ######Antibiotic Resistance Gene Profiling in Clinical Klebsiella pneumoniae Strains######

**Description**

This project identifies and analyzes antibiotic resistance genes across multiple Klebsiella pneumoniae strains. The workflow combines Linux shell scripting for raw data retrieval and genome assembly with R for downstream analysis and visualization. It determines genes shared among all strains, strain-specific resistance genes, and patterns of antibiotic resistance across clinical isolates.

**Workflow Overview**

     1. Raw Data Download and Genome Assembly (Linux Shell Script)

Download raw sequencing data (.sra files) from NCBI SRA using sra-tools.

Convert .sra files to FASTQ format.

Assemble genomes for each strain using SPAdes.

Detect known antibiotic resistance genes with Abricate, generating .txt results for each strain.

      2. Resistance Gene Analysis (R Script)

Import Abricate output files into R.

Combine data across strains with strain identifiers.

Identify:

Genes shared by all strains

Unique genes per strain

Genes shared by some strains

Visualize the number of resistance genes per strain using bar plots.

**Datasets Used**

Raw sequencing data (.sra files) downloaded from NCBI SRA.

Genome assemblies generated with SPAdes.

Abricate output files: SRR35773224.txt, SRR35773225.txt, … SRR35773228.txt.

**Packages Used**

Linux / Command-Line Tools

sra-toolkit (prefetch, fasterq-dump) – Download and convert sequencing data

SPAdes – Genome assembly

Abricate – Antibiotic resistance gene detection

R Environment

tidyverse – Data manipulation and plotting

**Key Results**

Strain-exclusive genes.csv – Genes unique to each strain

Strain-shared genes.csv – Genes shared among all strains

Number of resistant genes per strain of Klebsiella pneumoniae.png – Bar plot visualization

**Files in This Repository**

abricate_analysis.R – R script for data analysis and visualization

assemble_and_annotate.sh – Shell script for genome download, assembly, and annotation

**Important Notes**

Combines command-line processing for computational efficiency with R for flexible analysis.

Results provide insights into distribution and prevalence of resistance genes across clinical K. pneumoniae strains.

Real-World Relevance

Supports antibiotic resistance surveillance and microbial genomics research.

Identifies strain-specific resistance profiles relevant to clinical treatment strategies.

Provides a reproducible pipeline applicable to other bacterial species and clinical datasets.
