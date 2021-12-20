library(caTools)
library(e1071)
library(caTools)
library(caret)
library(dplyr)

this.dir <- dirname(getSourceEditorContext()$path)# frame(3) also works.
setwd(this.dir)
setwd('..')


dataset = read.csv("/Biomed/dataset/mergeleuk.csv")
dataset = dataset[-c(1)]
#dataset = dataset[-c(3)]
dataset = dataset[-c(4)]
glimpse(dataset)
dataset = dataset[sample(1:nrow(dataset)),]
glimpse(dataset)
prc <- dataset[1:3]
prc
prc = prc[sample(1:nrow(dataset)),]
prc
#dataset = dataset[1:3]

#dataset = data.frame(dataset[1:3])
#glimpse(dataset)

# Encoding the target feature as factor
#dataset$status = factor(dataset$status)
#dataset$t = as.numeric(as.factor(dataset$t))
#dataset$logFC = as.numeric(as.factor(dataset$logFC))
#dataset$status = as.numeric(as.factor(dataset$status))
#dataset$status
#dataset$P.Value = as.numeric(as.factor(dataset$P.value))
#glimpse(dataset$status)
# Splitting the dataset into the Training set and Test set
#install.packages('caTools')


normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x))) }
prc_n <- as.data.frame(lapply(prc[1:2], normalize))
#training_set <- as.data.frame(lapply(training_set[1:2], normalize))
#dataset <- as.data.frame(lapply(dataset[1:2], normalize))

#print(dataset)

prc_train <- prc_n[1:350,]
#prc_train

prc_test <- prc_n[351:500,]

prc_train_labels <- prc[1:350, 3]
prc_test_labels <- prc[351:500, 3]
library(class)
library(gmodels)
prc_test_pred <- knn(train = prc_train, test = prc_test,cl = prc_train_labels, k=8)
# k = 8 gives the best accuracy
#install.packages("gmodels")


CrossTable(x = prc_test_labels, y = prc_test_pred,prop.chisq = FALSE)

tab <- table(prc_test_pred,prc_test_labels)
accuracy <- function(x){sum(diag(x)/(sum(rowSums(x)))) * 100}

accuracy(tab)

