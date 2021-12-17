library(GEOquery)
library(limma)
library(umap)
library(dplyr)
library(randomForest)
library(magrittr) # needs to be run every time you start R and want to use %>%
library(e1071)
library(caTools)
library(caret)
#png(file = "decision_tree1.png")
this.dir <- dirname(getSourceEditorContext()$path)# frame(3) also works.
setwd(this.dir)
setwd('..')

dataset = read.csv("/Biomed/mergelymm.csv")
dataset = dataset[-c(1)]
#dataset = dataset[-c(3)]
dataset = dataset[-c(4)]
dataset = dataset[sample(1:nrow(dataset)),]
glimpse(dataset)

dataset$t = as.numeric(as.factor(dataset$t))
dataset$logFC = as.numeric(as.factor(dataset$logFC))
dataset$status = as.numeric(as.factor(dataset$status))
dataset$status
# Create random forest


set.seed(123)
split = sample.split(dataset, SplitRatio = 0.75)

training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)
test_set

# For classification
rf <- randomForest(status ~ t+logFC,
                   data = training_set,
                   importance = TRUE,
                   proximity = TRUE)
print(rf)

pred = predict(rf, newdata=test_set[-3])
#round(pred)
length(pred)
length(test_set)
test_set
h = table(round(pred),test_set$status)
h

accuracy_test_bayes <- sum(diag(h)) / sum(h)

list('predict matrix' = h, 'accuracy' = accuracy_test_bayes)

# Model Evaluation
confusionMatrix(h)
# Output to be present
# As PNG file
#png(file = "randomForestClassification_lym.png")

# Plot the error vs
# The number of trees graph
plot(rf)

# Saving the file
#dev.off()
