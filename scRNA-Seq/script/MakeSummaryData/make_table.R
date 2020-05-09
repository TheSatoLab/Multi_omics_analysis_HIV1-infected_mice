#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
sample_Id.info <- read.table(args[1],header=T,sep="\t")
sample_Id.info$sequence_Id <- formatC(sample_Id.info$sequence_Id,width=3,flag="0")
sample_Id.info$cell_Id <- formatC(sample_Id.info$cell_Id,width=3,flag="0")

# featureCounts metadata
feature.summary <- data.frame(matrix(rep(NA, 6), nrow=1))[numeric(0), ]
for(dir_Id in levels(sample_Id.info$dir_Id)){
  feature.name <- paste(args[2],dir_Id,'/', dir_Id, '_counts2.txt.summary.txt',sep="")
  feature <- read.table(feature.name,sep="\t",header=T,check.names=F,row.names=1)
  selFeatures <- c("Assigned","Unassigned_Ambiguity","Unassigned_MultiMapping","Unassigned_NoFeatures")
  feature <- as.data.frame(t(feature[rownames(feature) %in% selFeatures,]))
  rownames(feature) <- paste(dir_Id,rownames(feature),sep="_")
  feature$sample_Id.short <- rownames(feature)
  feature.summary <- rbind(feature.summary,feature)
}

# concatenate count_matrix
dir_Id <- levels(sample_Id.info$dir_Id)[1]
data.exp.name <- paste(args[2],dir_Id,'/',dir_Id, '_exp_matrix.txt',sep="")
data.exp.sum <- read.table(data.exp.name,sep="\t",header=T,row.names=1,check.names=F)
colnames(data.exp.sum) <- paste(dir_Id,colnames(data.exp.sum),sep="_")

for(dir_Id in levels(sample_Id.info$dir_Id)[2:length(levels(sample_Id.info$dir_Id))]){
  data.exp.name <- paste(args[2],dir_Id,'/',dir_Id,'_exp_matrix.txt',sep="")
  data.exp <- read.table(data.exp.name,sep="\t",header=T,row.names=1,check.names=F)
  colnames(data.exp) <- paste(dir_Id,colnames(data.exp),sep="_")
  data.exp.sum <- cbind(data.exp.sum,data.exp)
}

# calc RPM
total_reads <- as.vector(apply(data.exp.sum,2,sum))
calc_rpm <- function(x) return(x / total_reads * 1E+6)
data.exp.sum.rpm <- as.data.frame(t(apply(data.exp.sum,1,calc_rpm)))

# count non-zero genes
count_nonzero <- function(x) return(length(x[x>0]))
nonzero.df <- data.frame(sample_Id.short = colnames(data.exp.sum), 
                         nonzero.num = as.vector(apply(data.exp.sum,2,count_nonzero))) 

# check distribution
calc_summary <- function(x) return(summary(x[x>0]))
distribution.df <- as.data.frame(t(apply(data.exp.sum.rpm,2,calc_summary)))
distribution.df$sample_Id.short <- rownames(distribution.df)

# merge data
sample_Id.info <- merge(sample_Id.info,nonzero.df,by="sample_Id.short")
sample_Id.info <- merge(sample_Id.info,distribution.df,by="sample_Id.short")

# filtering summary data
sample_Id.info.fil <- sample_Id.info[,9:ncol(sample_Id.info)]
rownames(sample_Id.info.fil) <- sample_Id.info$sample_Id.short
sample_Id.info.fil <- sample_Id.info.fil[sample_Id.info$cell_state==1,]
sample_Id.info.fil.norm <- as.data.frame(apply(log(sample_Id.info.fil,2), 2, scale))
sample_Id.info.fil <- sample_Id.info.fil[(abs(sample_Id.info.fil.norm$Median) < 2) & (sample_Id.info.fil.norm$Assigned > -2),]
sample_Id.info.fil$sample_Id.short <- rownames(sample_Id.info.fil)
sample_Id.info.fil <- merge(sample_Id.info,sample_Id.info.fil)
sample_Id.info.fil <- sample_Id.info.fil[,colnames(sample_Id.info)]

# filtering count & rpm data
data.exp.sum.fil <- data.exp.sum[,colnames(data.exp.sum) %in% sample_Id.info.fil$sample_Id.short]
data.exp.sum.rpm.fil <- data.exp.sum.rpm[,colnames(data.exp.sum.rpm) %in% sample_Id.info.fil$sample_Id.short]

# output
write.table(sample_Id.info.fil,args[3], quote=F, col.names=T,row.names=F,sep="\t")
saveRDS(data.exp.sum.fil,args[4])

