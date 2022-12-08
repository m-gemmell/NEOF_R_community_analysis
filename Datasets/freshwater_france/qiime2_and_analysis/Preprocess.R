#Preprocessing data
#https://microbiome.github.io/tutorials/Preprocessing.html

#Load the phyloseq object
load("phyloseq.RData")

#Summarise the phyloseq object ####
#Install BiocManager
install.packages("BiocManager")
library(BiocManager)
#Install phyloseq
#https://joey711.github.io/phyloseq/install.html
BiocManager::install('phyloseq')
library("phyloseq")
#Install microbiome package
BiocManager::install("microbiome")
library("microbiome")

#Summary of phyloseq objects
microbiome::summarize_phyloseq(pseq)

#Number of reads per sample
reads_sample <- microbiome::readcount(pseq)
