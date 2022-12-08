
#Import data ####

#Install qiime2r package
#https://github.com/jbisanz/qiime2R
if (!requireNamespace("devtools", quietly = TRUE)){install.packages("devtools")}
devtools::install_github("jbisanz/qiime2R")

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
