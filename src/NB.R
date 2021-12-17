library(dplyr)

this.dir <- dirname(getSourceEditorContext()$path)# frame(3) also works.
setwd(this.dir)
setwd('..')

dataset = read.csv("/Biomed/dataset/mergem.csv")
dataset = dataset[-c(1)]
dataset = dataset[-c(3)]
glimpse(dataset)
dataset = dataset[sample(1:nrow(dataset)),]

#dataset = dataset[1:3]

dataset = data.frame(dataset[1:3])
glimpse(dataset)

# Encoding the target feature as factor
#dataset$status = factor(dataset$status)
dataset$t = as.numeric(as.factor(dataset$t))
dataset$logFC = as.numeric(as.factor(dataset$logFC))
dataset$status = as.numeric(as.factor(dataset$status))
dataset$status
#dataset$P.Value = as.numeric(as.factor(dataset$P.value))
#glimpse(dataset$status)
# Splitting the dataset into the Training set and Test set
#install.packages('caTools')
library(caTools)

set.seed(123)
split = sample.split(dataset, SplitRatio = 0.75)

training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

glimpse(training_set)
#glimpse(test_set)
# Feature Scaling

#training_set = scale(training_set[,1:2])
training_set

#test_set = scale(test_set[,1:2])

#test_set = data.frame(test_set)
#training_set = data.frame(training_set)
head(test_set)


library(e1071)
library(caTools)
library(caret)
set.seed(120)  # Setting Seed
classifier_cl <- naiveBayes(status ~ t+logFC, data = training_set)
classifier_cl

#install.packages("magrittr") # package installations are only needed the first time you use it
#install.packages("dplyr")    # alternative installation of the %>%
library(magrittr) # needs to be run every time you start R and want to use %>%
library(dplyr)    # alternatively, this also loads %>%
pre <- predict(classifier_cl, test_set, type = "class")

# Confusion Matrix
cm <- table(test_set$status, pre)
cm

accuracy_test_bayes <- sum(diag(cm)) / sum(cm)

list('predict matrix' = cm, 'accuracy' = accuracy_test_bayes)

# Model Evaluation
confusionMatrix(cm)