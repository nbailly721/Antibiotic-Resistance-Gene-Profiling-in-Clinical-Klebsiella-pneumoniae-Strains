#!/bin/bash

# Load sra-tools module
module load sra-toolkit/3.0.9

echo "Downloading .sra files..."
prefetch SRR35773224
prefetch SRR35773225
prefetch SRR35773226
prefetch SRR35773227
prefetch SRR35773228
echo "All downloads complete."

echo "Converting .sra files to FASTQ..."
fasterq-dump SRR35773224
fasterq-dump SRR35773225
fasterq-dump SRR35773226
fasterq-dump SRR35773227
fasterq-dump SRR35773228
echo "Conversion complete."

# Load SPAdes module
module load spades/4.2.0

# Make sure output directory exists
mkdir -p assemblies

# Assemble each strain separately
spades.py \
  -1 SRR35773224_1.fastq \
  -2 SRR35773224_2.fastq \
  -o assemblies/SRR35773224 \
  -t 8

spades.py \
  -1 SRR35773225_1.fastq \
  -2 SRR35773225_2.fastq \
  -o SRR35773225 \
  -t 8

spades.py \
  -1 SRR35773226_1.fastq \
  -2 SRR35773226_2.fastq \
  -o SRR35773226 \
  -t 8

spades.py \
  -1 SRR35773227_1.fastq \
  -2 SRR35773227_2.fastq \
  -o SRR35773227 \
  -t 8

spades.py \
  -1 SRR35773228_1.fastq \
  -2 SRR35773228_2.fastq \
  -o SRR35773228 \
  -t 8

echo "All assemblies complete!"

####Load prerequisite module
module load StdEnv/2020
module load gcc/9.3.0

####Load abricate module
module load  abricate/1.0.0

#####Determining the detect known antibiotic resistant genes

echo 'Running abricate for SRR35773224'
abricate --db  resfinder SRR35773224 > SRR35773224.txt

echo 'Running abricate for SRR35773225'
abricate --db resfinder SRR35773225 > SRR35773225.txt

echo 'Running abricade for SRR35773226'
abricate --db resfinder SRR35773226 > SRR35773226.txt

echo  'Running abricade for SRR35773227'
abricate --db resfinder SRR35773227 > SRR35773227.txt

echo 'Running abricade for SRR35773228'
abricate --db resfinder SRR35773228  > SRR35773228.txt














