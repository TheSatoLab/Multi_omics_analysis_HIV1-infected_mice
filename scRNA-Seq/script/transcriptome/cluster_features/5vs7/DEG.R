#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(ggplot2)
library(reshape2)
library(future)
plan("multiprocess",workers=8)

combined <- readRDS(args[1])
mt.i <- combined@meta.data
mt.i$Infected_Id <- 1:nrow(mt.i)
exp <- readRDS(args[2])
exp <- exp[,colnames(exp) %in% colnames(combined)]
col.df <- data.frame(col_Id = 1:ncol(exp),
                     cell = colnames(exp))
col.df.m <- merge(col.df,mt.i,by.x = "cell", by.y=0)
col.df.s <- col.df.m[order(col.df.m$Infected_Id),]
exp <- exp[,col.df.s$col_Id]

Seurat <- CreateSeuratObject(exp, project = "pnm")
Seurat$mouse_Id <- combined$mouse_Id
Seurat$sample_type.new <- combined$sample_type.new
Seurat$seurat_clusters <- combined$seurat_clusters
Seurat <- NormalizeData(Seurat,verbose=F)
Idents(Seurat) <- "seurat_clusters"

markers.pnm <- FindMarkers(Seurat, ident.1 = 5,ident.2 = 7,
                           test.use = "LR",latent.vars="sample_type.new")
markers.pnm$gene <- rownames(markers.pnm)
markers.pnm$padj <- p.adjust(markers.pnm$p_val, method="BH")
markers.pnm.fil <- markers.pnm[markers.pnm$padj <= 0.05,]
markers.pnm.fil <- markers.pnm.fil[,c("gene","avg_logFC","p_val","padj")]
markers.pnm.fil[,"avg_logFC"] <- round(markers.pnm.fil[,"avg_logFC"],3)
for (c in c("p_val","padj")) markers.pnm.fil[,c] <- round(log10(markers.pnm.fil[,c]),3)
colnames(markers.pnm.fil) <- c("gene","avg_logFC","log10P","log10Padj")
write.table(markers.pnm.fil,args[3],sep="\t",quote=F,row.names=F)

