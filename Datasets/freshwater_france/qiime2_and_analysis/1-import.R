#Import data ####
#Load package
library("qiime2R")

#Import data
pseq <- qiime2R::qza_to_phyloseq(
  features = "table-dada2.qza",
  tree = "rooted-tree.qza",
  taxonomy = "taxonomy.sklearn.qza",
  metadata = "media_metadata.txt"
)

#Save the phyloseq object
save(pseq, file = "phyloseq.RData")
