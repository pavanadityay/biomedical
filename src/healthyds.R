if (!requireNamespace("BiocManager", quietly = TRUE))
{
  install.packages("BiocManager")
  BiocManager::install("xml2")
  BiocManager::install("httr")
  BiocManager::install("GEOquery")
  BiocManager::install("limma")
  
  
}  

library(GEOquery)
library(limma)
library(umap)
library(rstudioapi)

#Set the current file path as the working directory

this.dir <- dirname(getSourceEditorContext()$path)# frame(3) also works.
setwd(this.dir)
setwd('..')


# load series and platform data from GEO

gset <- getGEO("GSE36474", GSEMatrix =TRUE, AnnotGPL=TRUE)
if (length(gset) > 1) idx <- grep("GPL570", attr(gset, "names")) else idx <- 1
gset <- gset[[idx]]
#gset
# make proper column names to match toptable 
fvarLabels(gset) <- make.names(fvarLabels(gset))
fvarLabels(gset)
# group membership for all samples
gsms <- "000"
sml <- strsplit(gsms, split="")[[1]]
#sml
# log2 transformation
ex <- exprs(gset)
#ex
qx <- as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
qx
LogC <- (qx[5] > 100) ||
  (qx[6]-qx[1] > 50 && qx[2] > 0)
if (LogC) { ex[which(ex <= 0)] <- NaN
exprs(gset) <- log2(ex) }
exprs(gset[,c(1:3)])

#a <- exprs(gset)
fit <- lmFit(ex)  # fit linear model

fit2 <- eBayes(fit, 0.01)
tT <- topTable(fit2, adjust="fdr", sort.by="B", number=250)
tT
#tT <- subset(tT, select=c("ID","adj.P.Val","P.Value","t","B","logFC","Gene.symbol","Gene.title","Gene.ID","UniGene.title","UniGene.symbol"))
#write.table(tT, file=stdout(), row.names=F, sep="\t")

colnames(tT)

write.csv(tT[c("t", "logFC","P.Value")],'/Biomed/dataset/healthyds.csv')
library(dplyr)

PATH <-"dataset/healthyds.csv"
df <- read.csv(PATH) %>%
  select(c(t,logFC,P.Value))
glimpse(df)

df$status <- 0
df$type <- myeloma

glimpse(df)

write.csv(df,'/Biomed/dataset/healthy.csv')


library(dplyr)

PATH <-"/Biomed/dataset/healthydb.csv"
dfa <- read.csv(PATH) %>%
  select(c(t,logFC))
glimpse(dfa)

