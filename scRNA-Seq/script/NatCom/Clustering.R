#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
plan("multiprocess",workers=24)
options(future.globals.maxSize = 16000000000)
set.seed(1)

combined <- readRDS(args[1])
combined <- RunUMAP(combined,reduction = "pca",dims = 1:100,n.neighbors =20,min.dist=0.01)
combined <- FindNeighbors(combined,reduction = "pca", dim = 1:100,k.param = 9,prune.SNN=1/15)
combined <- FindClusters(combined, resolution =0.9)
new.cluster.ids <- as.character(1:length(unique(combined$seurat_clusters)))
names(new.cluster.ids) <- levels(combined)
combined <- RenameIdents(combined,new.cluster.ids)
combined$seurat_clusters <- combined@active.ident
saveRDS(combined,args[2])



