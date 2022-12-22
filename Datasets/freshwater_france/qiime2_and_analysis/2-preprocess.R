#Preprocessing data
#https://microbiome.github.io/tutorials/Preprocessing.html

#Libraries
library("phyloseq")
library("microbiome")
library("vegan")

#Load the phyloseq object
load("phyloseq.RData")

#Summarise the phyloseq object ####
#Summary of phyloseq objects
microbiome::summarize_phyloseq(pseq)


#Number of reads per sample
reads_sample <- microbiome::readcount(pseq)
reads_sample

#Can extract ASV table (known as otu table in phyloseq)
phyloseq::otu_table(pseq)

#Each row is an ASV and each column is the samples
#Therefore we can get the number of ASVs in data
#Let's make a new vector with this info so we can easily keep track
num_asvs_vec <- c(nrow(phyloseq::otu_table(pseq)))
#Give the 1st element a relevant name
names(num_asvs_vec)[1] <- "abundance"
#View current vector
num_asvs_vec

#Sample with too few samples?
#In your analysis you may have a sample with too few reads
#All our samples are fine for a tutorial case but let us say we only wanted to
#keep samples with >11k reads
#We could remove samples with the following code
pseq_min11K <- phyloseq::subset_samples(pseq, reads_sample > 11000)
microbiome::summarize_phyloseq(pseq_min11K)
microbiome::readcount(pseq_min11K)

#We won't be using this as we are happy with our sample numbers
#Let us therefore remove this sample subsetted variable
rm(pseq_min11K)

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
#This is so the rare ASVs do not overly affect certain types of analysis

#first remove ASV with relabund equal to 0
#This can occur if samples were removed which had ASVs 
#not present in the remaining samples
pseq_relabund <-  filter_taxa(pseq_relabund, function(x) sum(x) > 0, TRUE)

#Summarise and check sample counts which should each amount to around 1
microbiome::summarize_phyloseq(pseq_relabund)
microbiome::readcount(pseq_relabund)

#All the total relative abundances still equal 1
#This is expected since no samples were removed
#As this is the case there is no need to check if ASVs were removed

#We will now remove rare ASVs as these are not as useful in relative abundance data
#compared to abundance data
#There are many ways to do this
#A common way, recommended by the phyloseq developer
#Remove ASVs with a mean (across samples) less than 1e-5 (relabund)
pseq_relabund <-  
  phyloseq::filter_taxa(
    pseq_relabund, function(x) mean(x) > 1e-5, TRUE)

#Summarise and check sample counts which should each amount to around 1
microbiome::summarize_phyloseq(pseq_relabund)
microbiome::readcount(pseq_relabund)

#Total relative abundance has decreased by a very small amount
#This is what we are looking for, if too much is being removed >0.05
#you will need to try to be gentler with the filtering
#Such as trying 1e-6 rather than 1e-5

#We should also check how many ASVs have been removed
num_asvs_vec["relabund"] <- nrow(phyloseq::otu_table(pseq_relabund))
num_asvs_vec
num_asvs_vec["abundance"] - num_asvs_vec["relabund"]

#We have lost a good amount of ASVs but these only equate to a very small
#amount relabund. This is fine as we generally use relative abundance
#when looking at the larger picture rather than at closer pictures
#instead we can use a rarefied abundance table to look at the closer picture

#We are now happy with our relative abundance table
#Therefore we can save it for further use
save(pseq_relabund, file = "phyloseq_relabund.RData")

#Rarefy abundance table ####
#i.e. convert abundance numbers so each sample has equal depth

#Before rarefying a table it is good to make a rarefaction curve
#This is to help us choose an appropriate rarefaction threshold

#We will use the very useful package vegan
#Ignore any warning message
vegan::rarecurve(
  x = as.data.frame(t(phyloseq::otu_table(pseq))), step = 50)

#Let us improve this and save it into a file
png(filename = "./rarefaction_plot.png", res = 300,
    units = "mm", height = 200, width = 300)
vegan::rarecurve(
  x = as.data.frame(t(phyloseq::otu_table(pseq))), step = 50,
  ylab="ASVs", lwd=1,label=F)
#Add a vertical line of the smallest sample depth
abline(v = min(reads_sample), col="red")
dev.off()

#With this we can see that the majorty of samples plateau at 
#the minimum sampleing depth
#Therefore we can use this as a rarefaction size
pseq_rarefy <- 
  phyloseq::rarefy_even_depth(
    pseq, sample.size = min(reads_sample), rngseed = 1000)

#Summarise and check sample counts which should each amount to 10433
microbiome::summarize_phyloseq(pseq_rarefy)
microbiome::readcount(pseq_rarefy)

#Check ASVs
num_asvs_vec["rarefied"] <- nrow(phyloseq::otu_table(pseq_rarefy))
num_asvs_vec

#Save phyloseq object
save(pseq_relpseq_rarefyabund, file = "phyloseq_rarefied.RData")