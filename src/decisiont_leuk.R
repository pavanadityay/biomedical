library(party)
library(GEOquery)
library(limma)
library(umap)
library(dplyr)

this.dir <- dirname(getSourceEditorContext()$path)# frame(3) also works.
setwd(this.dir)
setwd('..')

#png(file = "decision_tree1.png")

dataset = read.csv("/Biomed/dataset/mergeleuk.csv")
dataset = dataset[-c(1)]
#dataset = dataset[-c(3)]
dataset = dataset[-c(4)]
dataset = dataset[sample(1:nrow(dataset)),]
glimpse(dataset)
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x))) }
prc_n <- as.data.frame(lapply(dataset[1:3], normalize))

df = prc_n
glimpse(df)
# Create the tree.
output.tree <- ctree(status~t+logFC,data = df)

# Plot the tree.
plot(output.tree)

# Save the file.
#dev.off()


#install.packages("rpart")
library(rpart)
library(rpart.plot)
png(file = "/Biomed/output/decision_treeleuk.png")
fit <- rpart(status~t+logFC, data = df, method = 'class')
rpart.plot(fit, extra = 106)
dev.off()