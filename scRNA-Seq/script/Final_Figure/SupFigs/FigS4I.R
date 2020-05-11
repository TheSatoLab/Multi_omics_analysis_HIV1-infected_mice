#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)

Seurat1 <- readRDS(args[1])
Seurat2 <- readRDS(args[2])
mt1 <- Seurat1@meta.data
mt2 <- Seurat2@meta.data

p1_1 <- DimPlot(Seurat1, reduction = "umap",group.by ="seurat_clusters")
p1_2 <- DimPlot(Seurat2, reduction = "umap",group.by ="seurat_clusters")

p <- plot_grid(p1_1,p1_2, ncol = 2,align = "h",rel_widths=c(1,1))

pdf(args[6],height=7, width=14)
print(p)
dev.off()


