#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
data <- readRDS(args[1])
data <- data[apply(data,1,sum) != 0,]
set.seed(42)
Seurat <- CreateSeuratObject(data, project = "pnm")
Seurat[["percent.mt"]] <- PercentageFeatureSet(Seurat, pattern = "^MT-")
mt <- Seurat@meta.data
mt$scale_percent.mt <- scale(mt$percent.mt)
mt.fil <- mt[which(mt$scale_percent.mt <= 1.5),]
data <- data[,colnames(data) %in% rownames(mt.fil)]
saveRDS(data,args[2])


