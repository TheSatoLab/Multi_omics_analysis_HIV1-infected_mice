#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(future)
plan("multiprocess",workers=10)

set.seed(1)
data <- readRDS(args[1])
sample <- data.frame(col.Id = 1:ncol(data), 
                     sample_Id.short=colnames(data),
                     sample_type = substr(colnames(data),7,10),
                     mouse_Id =substr(colnames(data),1,5))
sample$sample_type.new <- ifelse(sample$sample_type == "GFP+","GFPposi",
                            ifelse(sample$sample_type == "GFP-", "GFPnega", "Mock"))
Seurat <- CreateSeuratObject(data, project = "pnm")
Seurat@meta.data$mouse_Id <- sample$mouse_Id
Seurat@meta.data$sample_type.new <- sample$sample_type.new
Seurat <- NormalizeData(Seurat,verbose=F)
Seurat <- RunALRA(Seurat)
Seurat.s <- SplitObject(Seurat,split.by = "mouse_Id")
for (i in 1:length(Seurat.s)) Seurat.s[[i]] <- FindVariableFeatures(Seurat.s[[i]], selection.method = "mvp", nfeatures = nrow(data),verbose=F)
combined <- FindIntegrationAnchors(Seurat.s, dims = 1:25, k.filter = 20,k.score = 20,anchor.features = nrow(data),max.features=2000,verbose=F)
combined <- IntegrateData(combined,new.assay.name = "integrated", dims= 1:25,verbose=F)
combined <- ScaleData(combined, block.size=1000000,verbose=F)
scale.data <- combined@assays$integrated@scale.data
scale.data.noHIV <- scale.data[rownames(scale.data) != "NLCSFV3-EGFP",]
noHIV <- rownames(scale.data.noHIV)
combined <- RunPCA(combined,npcs=100,features = noHIV)
saveRDS(combined,args[2])

