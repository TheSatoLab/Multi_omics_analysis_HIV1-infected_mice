#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
plan("multiprocess",workers=8)

combined <- readRDS(args[1])
combined <- RunUMAP(combined,reduction = "pca",dims = 1:20,n.neighbors =20,min.dist=0.01)
combined <- FindNeighbors(combined,reduction = "pca", dim = 1:20,k.param = 9,prune.SNN=1/15)
combined <- FindClusters(combined, resolution =0.9)
new.cluster.ids <- as.character(1:9)
names(new.cluster.ids) <- levels(combined)
combined <- RenameIdents(combined,new.cluster.ids)
combined$seurat_clusters <- combined@active.ident
saveRDS(combined,args[1])



