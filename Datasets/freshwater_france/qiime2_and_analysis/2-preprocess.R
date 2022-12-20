#Preprocessing data
#https://microbiome.github.io/tutorials/Preprocessing.html

#Libraries
library("phyloseq")
library("microbiome")

#Load the phyloseq object
load("phyloseq.RData")

#Summarise the phyloseq object ####
#Summary of phyloseq objects
microbiome::summarize_phyloseq(pseq)

#Number of reads per sample
reads_sample <- microbiome::readcount(pseq)
reads_sample



#Sample with too few samples?
#In your analysis you may have a sample with too few reads
#All our samples are fine for a tutorial case but let us say we only wanted to
#keep samples with >11k reads
#We could remove samples with the following code
pseq_min11K <- phyloseq::subset_samples(pseq, reads_sample > 11000)
microbiome::summarize_phyloseq(pseq_min11K)
microbiome::readcount(pseq_min11K)

#Relative abundance ####
#Convert abundance table to relative abundance (compositional) table
pseq_relabund <- microbiome::transform(pseq, "compositional")
#Summarise and check sample counts which should each amount to 1
microbiome::summarize_phyloseq(pseq_relabund)
microbiome::readcount(pseq_relabund)

#Check the below logic
#When using total abundance values it is useful to have 0 values, singletons, and doubletons
#This is because some alpha diversity metrics require them
#However it is useful to remove low relative abundance data in relative abundance data
#This can be carried out with R microbiome



#Rarefy abundance table
#i.e. convert abundance numbers so each sample has equal depth
