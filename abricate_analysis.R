## ================================================
## Project: Analysis of Antibiotic Resistance Genes
## Description:
##   This script loads Abricate output files, combines data from multiple strains,
##   identifies shared and unique resistance genes, and visualizes gene counts.
## ================================================

## _ Environment set up--------

install.packages ('tidyverse')
library('tidyverse')

## _ Load the data  --------

data_SRR35773224 <-read_tsv('../data/SRR35773224.txt')

data_SRR35773225 <-read_tsv('../data/SRR35773225.txt')

data_SRR35773226 <-read_tsv('../data/SRR35773226.txt')

data_SRR35773227 <-read_tsv('../data/SRR35773227.txt')

data_SRR35773228 <-read_tsv('../data/SRR35773228.txt')
#Import the abricate results produced in the shell script for each strain

## _ Data modification  --------

## __ Addition of Strain Column  --------
data_SRR35773224 <-data_SRR35773224 %>% mutate(Strain='SRR35773224')
data_SRR35773225 <-data_SRR35773225 %>% mutate(Strain='SRR35773225')
data_SRR35773226 <-data_SRR35773226 %>% mutate(Strain='SRR35773226')
data_SRR35773227 <-data_SRR35773227 %>% mutate(Strain='SRR35773227')
data_SRR35773228 <-data_SRR35773228 %>% mutate(Strain='SRR35773228')

## __ Combination of datasets  --------

combined_data <- rbind(
  data_SRR35773224,
  data_SRR35773225,
  data_SRR35773226,
  data_SRR35773227,
  data_SRR35773228 )

## _ Analysis of genetic components of each strain  --------

## __ Genes shared by all strains  --------

genes_shared <- combined_data %>% group_by(GENE) %>%
                 summarise (n_strains=n_distinct(Strain)) %>% filter(n_strains == 5) # Present in all 5 strains

## __ Genes that are unique to one strain  --------

genes_unique_strain <-combined_data %>% group_by(GENE) %>% 
                 summarise (n_strains=n_distinct(Strain)) %>% filter(n_strains == 1) # Present in only one strain

genes_unique_identity <- combined_data %>% filter(GENE %in% genes_unique_strain$GENE) %>%
                         select(GENE, Strain) %>%
                         distinct () # This gives which strain has which unique genes

## __ Identify Genes Shared by Some but Not All Strains ----------

total_strains <- combined_data %>% pull (Strain) %>% unique () %>% length()

genes_partial <- combined_data %>% group_by(GENE) %>% 
                  summarise (n_strains=n_distinct(Strain)) %>% filter (n_strains >1 & n_strains<total_strains) # Shared partially

gene_partial_identity <-combined_data %>% filter(GENE %in% genes_partial$GENE) %>%
                        select(GENE,Strain) %>%
                        distinct () # Identify which strains share these partially shared genes

## _ Visualization of gene counts  --------

presence_matrix <- table(combined_data$GENE, combined_data$Strain)
presence_matrix[presence_matrix >=1] <-1
presence_matrix <- as.data.frame.matrix (presence_matrix)
presence_matrix$GENE <- rownames(presence_matrix)
rownames(presence_matrix) <- NULL
# Create a presence/absence matrix (1 if gene present, else 0)

counts_per_strain <- colSums(presence_matrix[,-which(names(presence_matrix)=='GENE')])
print(counts_per_strain)

gene_counts <-data.frame(
                Strain=names(counts_per_strain),
                Gene_count=as.integer(counts_per_strain)
)
# Calculate total number of unique genes per strain

ggplot(data=gene_counts, aes(y=Gene_count, x=Strain, fill=Strain)) +
    geom_bar(stat='identity') +
    labs(y='Strain',
         x='Gene count',
         title='Number of resistant genes per strain of Klebsiella pneumoniae') +
          theme (plot.title=element_text(hjust=0.5))
# Plot bar chart comparing gene counts across strains


