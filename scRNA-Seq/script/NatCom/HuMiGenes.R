#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
plan("multiprocess",workers=24)
options(future.globals.maxSize = 16000000000)
set.seed(1)

Seurat <- readRDS(args[1])
Seurat <- NormalizeData(Seurat,verbose=F)
Seurat <- RunALRA(Seurat)
Ours <- readRDS(args[2])
Seurat.fil <- Seurat[rownames(Seurat) %in% rownames(Ours),]
Seurat.fil <- ScaleData(Seurat.fil, block.size=1000000,verbose=F)
Seurat.fil <- RunPCA(Seurat.fil,npcs=100,features = rownames(Seurat.fil))
saveRDS(Seurat.fil,args[3])


