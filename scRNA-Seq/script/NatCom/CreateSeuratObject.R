#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
library(tidyverse)
plan("multiprocess",workers=2)
set.seed(1)

Run <- args[1]
barcodes <- read.table(args[5],header=T, check.names=F, sep="\t")
barcodes.fil <- barcodes %>%
  filter(stimulation_status == args[2]) %>%
  filter(tissue == args[3]) %>%
  filter(donor == args[4]) %>%
  filter(cd4cd8_status == "CD4")

data <- read.table(args[6], header=T)
data.fil <- data %>%
  select(Gene,one_of(as.character(barcodes.fil$barcode)))
data.fil <- data.fil[!duplicated(data.fil$Gene),]
rownames(data.fil) <- data.fil$Gene
data.fil <- data.fil[,2:ncol(data.fil)]
data.fil <- data.fil[which(apply(data.fil, 1, sum) != 0),]
Seurat <- CreateSeuratObject(counts = data.fil,project = Run,min.cells = 0)
Seurat$stimulation <- args[2]
Seurat$tissue <- args[3]
Seurat$donor <- args[4]
saveRDS(Seurat, args[7])


