
# load series and platform data from GEO
library(GEOquery)
library(limma)
library(umap)

this.dir <- dirname(getSourceEditorContext()$path)# frame(3) also works.
setwd(this.dir)
setwd('..')


# load series and platform data from GEO
gset <- getGEO("GSE171272", GSEMatrix =TRUE, AnnotGPL=FALSE)
if (length(gset) > 1) idx <- grep("GPL18058", attr(gset, "names")) else idx <- 1
gset <- gset[[idx]]

# make proper column names to match toptable 
fvarLabels(gset) <- make.names(fvarLabels(gset))

# group membership for all samples
gsms <- "0000000000"
sml <- strsplit(gsms, split="")[[1]]
length(gsms)
# log2 transformation
ex <- exprs(gset)
qx <- as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
LogC <- (qx[5] > 100) ||
  (qx[6]-qx[1] > 50 && qx[2] > 0)
if (LogC) { ex[which(ex <= 0)] <- NaN
exprs(gset) <- log2(ex) }
es <- exprs(gset[,c(1:10)])
es

#a <- exprs(gset)
fit <- lmFit(ex)  # fit linear model

fit2 <- eBayes(fit, 0.01)
tT <- topTable(fit2, adjust="fdr", sort.by="B", number=250)

tT <- subset(tT, select=c("t","logFC"))
write.table(tT, file=stdout(), row.names=F, sep="\t")

tT

library(dplyr)


write.csv(tT[c("t", "logFC")],'/Biomed/dataset/cancerlym.csv')

PATH <-"/Biomed/dataset/cancerlym.csv"
df <- read.csv(PATH) %>%
  select(c(t,logFC))
glimpse(df)

df$status <- 1
df$type <- "lymphoma"

glimpse(df)


write.csv(df,'/Biomed/dataset/cancerlymm.csv')


PATH <-"/Biomed/dataset/cancerlymm.csv"
df <- read.csv(PATH) %>%
  select(c(t,logFC,status,type))
glimpse(df)
