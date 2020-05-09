#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
plan("multiprocess",workers=8)

combined <- readRDS(args[1])

for (i in levels(combined$seurat_clusters)) {
  markers.i1 <- FindMarkers(combined, ident.1 = i,test.use = "LR",
                           latent.vars="sample_type.new",assay="integrated",logfc.threshold = log(1.5))
  markers.i1$p_val_adj <- p.adjust(markers.i1$p_val, method="BH")
  markers.i1$gene <- rownames(markers.i1)
  markers.i1.fil <- markers.i1[markers.i1$p_val_adj <= 0.01,]
  markers.i2 <- FindMarkers(combined, ident.1 = i,test.use = "LR",
                           latent.vars="sample_type.new",assay="RNA",logfc.threshold = log(1.5))
  markers.i2$p_val_adj <- p.adjust(markers.i2$p_val, method="BH")
  markers.i2$gene <- rownames(markers.i2)
  markers.i2.fil <- markers.i2[markers.i2$p_val_adj <= 0.01,]
  markers.i.fil <- markers.i1.fil[rownames(markers.i1.fil) %in% rownames(markers.i2.fil),]
  markers.i.fil <- markers.i.fil[,c("gene","avg_logFC","p_val","p_val_adj")]
  markers.i.fil[,"avg_logFC"] <- round(markers.i.fil[,"avg_logFC"],3)
  for (c in c("p_val","p_val_adj")) markers.i.fil[,c] <- round(log10(markers.i.fil[,c]),3)
  colnames(markers.i.fil) <- c("gene","avg_logFC","log10P","log10Padj")
  out_name <- paste(args[2], i, ".txt",sep="")
  write.table(markers.i.fil, out_name, quote=F, sep= "\t", row.names=F)
}



