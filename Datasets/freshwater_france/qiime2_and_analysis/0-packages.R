#Ensure to run RStudio as administrator
#Set you R library site to a relvent place in your home directory
R_LIBS_SITE="F:/R/library"

#RTools42 needs to be installed for windows users
#https://cran.r-project.org/bin/windows/Rtools/rtools42/rtools.html

#Install some problem packages
problem_pckgs <- c('rlang', 'vctrs', 'Biostrings', 'cli','DelayedArray', 
                   'GenomicRanges', 'IRanges', 'isoband',
                   'plyr', 'RCurl', 'S4Vectors', 'XVector', 'zlibbioc')
install.packages(problem_pckgs, INSTALL_opts = "--no-lock")

#Install qiime2r package
#https://github.com/jbisanz/qiime2R
install.packages("devtools")
devtools::install_github("jbisanz/qiime2R")

#Install BiocManager
install.packages("BiocManager")
#Ensure it is installed as version 3.16
BiocManager::install(version="3.16")
library(BiocManager)
#Install phyloseq
#https://joey711.github.io/phyloseq/install.html
BiocManager::install('phyloseq')
#Install microbiome package
BiocManager::install("microbiome")

#Install vegan
install.packages("vegan")


