## _ Install and loadm packages--------

install.packages ('tidyverse')
library('tidyverse')

## _ Load the data  --------

data_SRR35773224 <-read_tsv('../data/SRR35773224.txt')

data_SRR35773225 <-read_tsv('../data/SRR35773225.txt')

data_SRR35773226 <-read_tsv('../data/SRR35773226.txt')

data_SRR35773227 <-read_tsv('../data/SRR35773227.txt')

data_SRR35773228 <-read_tsv('../data/SRR35773228.txt')

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
                 summarise (n_strains=n_distinct(Strain)) %>% filter(n_strains == 5)

## __ Genes that are unique to one strain  --------

genes_unique_strain <-combined_data %>% group_by(GENE) %>% 
                 summarise (n_strains=n_distinct(Strain)) %>% filter(n_strains == 1)

genes_unique_identity <- combined_data %>% filter(GENE %in% genes_unique_strain$GENE) %>%
                         select(GENE, Strain) %>%
                         distinct ()
#To determine the identity of the strains that have unique genes

## __ Genes that are shared by some but not all strains  --------

total_strains <- combined_data %>% pull (Strain) %>% unique () %>% length()

genes_partial <- combined_data %>% group_by(GENE) %>% 
                  summarise (n_strains=n_distinct(Strain)) %>% filter (n_strains >1 & n_strains<total_strains)

gene_partial_identity <-combined_data %>% filter(GENE %in% genes_partial$GENE) %>%
                        select(GENE,Strain) %>%
                        distinct ()

#To determine the identify of the strains that share some genes

## _ Visualization of gene counts  --------

presence_matrix <- table(combined_data$GENE, combined_data$Strain)
presence_matrix[presence_matrix >=1] <-1
presence_matrix <- as.data.frame.matrix (presence_matrix)
presence_matrix$GENE <- rownames(presence_matrix)
rownames(presence_matrix) <- NULL
#Make a matrix table to then produce the bar plot

counts_per_strain <- colSums(presence_matrix[,-which(names(presence_matrix)=='GENE')])
print(counts_per_strain)

gene_counts <-data.frame(
                Strain=names(counts_per_strain),
                Gene_count=as.integer(counts_per_strain)
)
#Calculate total number of genes per strain

ggplot(data=gene_counts, aes(y=Gene_count, x=Strain, fill=Strain)) +
    geom_bar(stat='identity') +
    labs(y='Strain',
         x='Gene count',
         title='Number of resistant genes per strain of Klebsiella pneumoniae') +
          theme (plot.title=element_text(hjust=0.5))
#Bar plot comparing the amount of resistant genes


