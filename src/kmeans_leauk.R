library(dplyr)
library(e1071)
library(caTools)
library(caret)
#install.packages("ClusterR")
library(ClusterR)
library(cluster)

this.dir <- dirname(getSourceEditorContext()$path)# frame(3) also works.
setwd(this.dir)
setwd('..')

dataset = read.csv("/Biomed/dataset/mergeleuk.csv")
dataset = dataset[-c(1)]
#dataset = dataset[-c(3)]
dataset = dataset[-c(4)]
dataset = dataset[sample(1:nrow(dataset)),]
glimpse(dataset)

dataset1 = dataset[-c(3)]

set.seed(240) # Setting seed
kmeans.re <- kmeans(dataset1, centers = 2, nstart = 10)
kmeans.re



# Cluster identification for 
# each observation
kmeans.re$cluster

g <- as.data.frame(kmeans.re$cluster)
dataset <- as.data.frame(dataset)
dataset$status = as.numeric(as.factor(dataset$status))
dataset$status
# Confusion Matrix
cm <- table(dataset$status, kmeans.re$cluster)
cm

plot(dataset1[c("t", "logFC")])
plot(dataset1[c("t", "logFC")], 
     col = kmeans.re$cluster)
plot(dataset1[c("t", "logFC")], 
     col = kmeans.re$cluster, 
     main = "K-means with 2 clusters")

## Ploting cluster centers
kmeans.re$centers
kmeans.re$centers[,c("t", "logFC")]

# cex is font size, pch is symbol
points(kmeans.re$centers[, c("t", "logFC")], 
       col = 1:2, pch = 1, cex = 1) 

## Visualizing clusters
y_kmeans <- kmeans.re$cluster
clusplot(dataset1[, c("t", "logFC")],
         y_kmeans,
         lines = 0,
         shade = TRUE,
         color = TRUE,
         labels = 2,
         plotchar = FALSE,
         span = TRUE,
         main = paste("Cluster dataset"),
         xlab = 't',
         ylab = 'logFC')