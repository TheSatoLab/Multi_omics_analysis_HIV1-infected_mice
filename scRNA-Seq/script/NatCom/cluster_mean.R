#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
library(tidyverse)
plan("multiprocess",workers=24)
options(future.globals.maxSize = 16000000000)

geneset <- read.table(args[1], header=T, check.names=F)
commonISG.df <- geneset[geneset$category %in% c("commonISG","commonISG*"),]

Seurat1 <- readRDS(args[2])
data1 <- as.matrix(Seurat1@assays$alra@scale.data)
data1 <- data1[setdiff(rownames(data1),commonISG.df$ISG),]
mean.df1 <- apply(data1,1,tapply,Seurat1$seurat_clusters,mean)
mean.df1 <- mean.df1 %>% as.data.frame() %>% t()
colnames(mean.df1) <- paste(unique(Seurat1$donor),colnames(mean.df1),sep="__")

Seurat2 <- readRDS(args[3])
data2 <- as.matrix(Seurat2@assays$alra@scale.data)
data2 <- data2[setdiff(rownames(data2),commonISG.df$ISG),]
mean.df2 <- apply(data2,1,tapply,Seurat2$seurat_clusters,mean)
mean.df2 <- mean.df2 %>% as.data.frame() %>% t()
colnames(mean.df2) <- paste(unique(Seurat2$donor),colnames(mean.df2),sep="__")

mean.df.m <- merge(mean.df1,mean.df2,by=0)
rownames(mean.df.m) <- mean.df.m$Row.names
mean.df.m <- select(mean.df.m,-Row.names)
saveRDS(mean.df.m,args[4])





