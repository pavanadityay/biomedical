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
gsms <- "000000000011111"
sml <- strsplit(gsms, split="")[[1]]
gsms
# log2 transformation
ex <- exprs(gset)
qx <- as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
LogC <- (qx[5] > 100) ||
  (qx[6]-qx[1] > 50 && qx[2] > 0)
if (LogC) { ex[which(ex <= 0)] <- NaN
exprs(gset) <- log2(ex) }

es <- exprs(gset[,c(11:15)])
es
#a <- exprs(gset)
fit <- lmFit(es)  # fit linear model

fit2 <- eBayes(fit, 0.01)
bT <- topTable(fit2, adjust="fdr", sort.by="B", number=250)

bT <- subset(bT, select=c("t","logFC"))
write.table(bT, file=stdout(), row.names=F, sep="\t")

bT

library(dplyr)

write.csv(bT[c("t", "logFC")],'/Biomed/dataset/healthylym.csv')

PATH <-"/Biomed/dataset/healthylym.csv"
df <- read.csv(PATH) %>%
  select(c(t,logFC))
glimpse(df)

df$status <- 0
df$type <- "lymphoma"

glimpse(df)


write.csv(df,'/Biomed/dataset/healthylymm.csv')

df <- read.csv("/Biomed/dataset/healthylymm.csv")
df

dfa <- read.csv("/Biomed/dataset/cancerlymm.csv")
dfa


mergelym <- rbind(dfa,df)

write.csv(mergelym,"/Biomed/dataset/mergelym.csv")

dfb <- read.csv("/Biomed/dataset/mergelym.csv")

f <- dfb[-c(1)]
#f <- dfb[-c(1)]
f <- dfb[-c(2)]
g <- f[-c(1)]
g

write.csv(g,"/Biomed/dataset/mergelymm.csv")