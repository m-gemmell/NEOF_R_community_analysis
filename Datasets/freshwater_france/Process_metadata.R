
library("tidyverse")
library("stringr")
setwd("D:/Git/NEOF_R_community_analysis/Datasets/freshwater_france")

#read in data
file_input <- read.csv("biosample_result.txt", header = FALSE)
#Remove some info from fields
file_input$V1  <- gsub(pattern = "^    /", replacement = "",
                   file_input$V1)
file_input$V1  <- gsub(pattern = ".*=", replacement = "",
                       file_input$V1)
file_input$V1  <- gsub(pattern = " .ENV.*", replacement = "",
                       file_input$V1)
#Tried to do with long to wide but it complaied a lot
#Therefore will make my own loops to do so
num_rows <- 36
num_cols <- 15
#Create empty df
df <- as.data.frame(matrix(data = NA, nrow=num_rows,
                           ncol=num_cols))
#Make column names
col_names <- c("info", "Identifiers", "Organism", "Atrributes",
               "Collection_date", "depth", 
               "broad-scale_environmental_context",
               "local-scale_environmental_context",
               "environmental_medium","geographic_location",
               "latitude_and_longitude", "Description_text",
               "Descriptions", "Keywords", "Accession")
colnames(df) <- col_names
#Fill in values
for (c in 1:num_cols) {
  col_info <- file_input[
    seq(from = c, to =  num_rows * num_cols,  by = num_cols, ),
    "V1"]
  df[,c] <- col_info
  }

#Remove unwanted columns
retain_col_names <- c("info", "Identifiers", "Organism",
                      "Collection_date", "depth", 
                      "broad-scale_environmental_context",
                      "local-scale_environmental_context",
                      "environmental_medium","geographic_location",
                      "latitude_and_longitude",
                      "Descriptions", "Keywords", "Accession")
df <- df[,retain_col_names]
#Now need to process some columns
#info
df$info  <- gsub(pattern = ".*: ", replacement = "",
                 df$info)
#identifiers
df$Identifiers  <- gsub(pattern = "Identifiers: ", replacement = "",
                 df$Identifiers)
df$BioSample <- gsub(pattern = "BioSample: ", replacement = "",
                     str_split_fixed(df$Identifiers, "; ", 3)[,1])
df$Sample_name <- gsub(pattern = "Sample name: ", replacement = "",
                     str_split_fixed(df$Identifiers, "; ", 3)[,2])
df$SRA <- gsub(pattern = "SRA: ", replacement = "",
                     str_split_fixed(df$Identifiers, "; ", 3)[,3])
