#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
plan("multiprocess",workers=8)

combined <- readRDS(args[1])
for (i in levels(combined@meta.data$seurat_clusters)) {
  for (x in c("GFPposi","GFPnega","Mock")) {
    data <- subset(combined,subset=sample_type.new == x)
    markers.xi <- FindMarkers(data, ident.1 = i,logfc.threshold = log(1.5),assay="integrated")
    markers.xi$p_val_adj <- p.adjust(markers.xi$p_val, method="BH")
    markers.xi <- markers.xi[,c(2,5)]
    colnames(markers.xi) <- paste(x,colnames(markers.xi),sep="_")
    if (x == "GFPposi") markers.pi <- markers.xi
    if (x == "GFPnega") markers.ni <- markers.xi
    if (x == "Mock") markers.mi <- markers.xi
  }
  markers.i <- merge(markers.pi,markers.ni,by=0,all=T)
  markers.i <- merge(markers.i,markers.mi,by.x="Row.names", by.y=0,all=T)
  for (c in c("GFPposi_p_val_adj","GFPnega_p_val_adj","Mock_p_val_adj")) markers.i[,c][is.na(markers.i[,c])] <- 1
  markers.i$GFPposi_marker <- ifelse(markers.i$GFPposi_p_val_adj <= 0.01 ,1,0)
  markers.i$GFPnega_marker <- ifelse(markers.i$GFPnega_p_val_adj <= 0.01 ,1,0)
  markers.i$Mock_marker    <- ifelse(markers.i$Mock_p_val_adj <= 0.01 ,1,0)
  markers.i$p.markers <- markers.i$GFPposi_marker + markers.i$GFPnega_marker + markers.i$Mock_marker
  markers.i$Check <- ifelse(markers.i$p.markers >= 1,1,0)
  markers.i$gene <- markers.i$Row.names
  markers.i.fil <- markers.i[which(markers.i$Check == 1),]
  markers.i.fil <- markers.i.fil[,c("gene","GFPposi_avg_logFC","GFPposi_p_val_adj","GFPposi_marker",
                                           "GFPnega_avg_logFC","GFPnega_p_val_adj","GFPnega_marker",
                                           "Mock_avg_logFC","Mock_p_val_adj","Mock_marker")]
  for (c in c("GFPposi_avg_logFC","GFPnega_avg_logFC","Mock_avg_logFC")) markers.i.fil[,c] <- round(markers.i.fil[,c],3)
  for (c in c("GFPposi_p_val_adj","GFPnega_p_val_adj","Mock_p_val_adj")) markers.i.fil[,c] <- round(log10(markers.i.fil[,c]),3)
  colnames(markers.i.fil) <- c("gene","GFP+_avglogFC","GFP+_log10Padj","GFP+_marker",
                                      "GFP-_avglogFC","GFP-_log10Padj","GFP-_marker",
                                      "Mock_avglogFC","Mock_log10Padj","Mock_marker")
  out_name <- paste(args[2], i, ".txt",sep="")
  write.table(markers.i.fil, out_name, quote=F, sep= "\t", row.names=F)
}



