#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(GSVA)
library(pforeach)
library(future)
plan("multiprocess",workers=10)

combined <- readRDS(args[1])
combined$cluster_sampletype <- paste(combined$seurat_clusters,combined$sample_type.new,sep="__")
geneset <- read.table(args[2], header=T, check.names=F)
commonISG.df <- geneset[geneset$category %in% c("commonISG","commonISG*"),]
exp <- readRDS(args[3])
commonISG <- commonISG.df[commonISG.df$ISG %in% rownames(exp),]
ISG <- gsva(as.matrix(log10(exp + 1)), list(ISG = commonISG$ISG), mx.diff=TRUE, 
                 verbose=T,parallel.sz=4,min.sz=10,max.sz=500,method="ssgsea")

exp.fil <- exp[rownames(exp) %in% commonISG$ISG,]
cor <- pforeach (i = rownames(exp.fil)) ({cor(as.numeric(ISG),as.numeric(exp[i,]),method="pearson")})
names(cor) <- rownames(exp.fil)
cor.df <- data.frame(gene = rownames(exp.fil),
                     correlation = cor,
                     Check = ifelse(cor >= quantile(cor)["25%"], 1, 0))
cor.fil <- cor[which(cor >= quantile(cor)["25%"])]
commonISG <- commonISG[commonISG$ISG %in% names(cor.fil),]
ISG <- gsva(as.matrix(log10(exp + 1)), list(ISG = commonISG$ISG), mx.diff=TRUE, 
                 verbose=T,parallel.sz=4,min.sz=10,max.sz=500,method="ssgsea")

combined$commonISG <- as.numeric(t(ISG))
saveRDS(combined,args[1])


