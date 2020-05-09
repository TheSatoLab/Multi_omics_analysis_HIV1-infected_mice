#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(tidyverse)

Seurat <- readRDS(args[1])
data <- as.matrix(Seurat@assays$integrated@scale.data)
mean.df <- apply(data,1,tapply,Seurat$seurat_clusters,mean)
mean.df <- mean.df %>% as.data.frame() %>% t()
colnames(mean.df) <- paste("HuMice",colnames(mean.df),sep="__")
mean.df.m <- readRDS(args[2])
mean.df.m <- merge(mean.df.m,mean.df,by=0)
rownames(mean.df.m) <- mean.df.m$Row.names
mean.df.m <- select(mean.df.m,-Row.names)
col.df <- data.frame(ID = colnames(mean.df.m),
                     donor = gsub("__[0-9]+","",colnames(mean.df.m)),
                     cluster = gsub("......__","",colnames(mean.df.m)))
col.dfH <- filter(col.df,donor == "HuMice")
meanH <- select(mean.df.m,one_of(as.character(col.dfH$ID)))
col.dfN <- filter(col.df,donor != "HuMice")
meanN <- select(mean.df.m,one_of(as.character(col.dfN$ID)))
cor.df <- cor(meanN,meanH,method="spearman")
write.table(cor.df,args[3],sep="\t",quote=F)

