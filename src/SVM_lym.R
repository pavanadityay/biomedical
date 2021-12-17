library(dplyr)
library(randomForest)
library(magrittr) # needs to be run every time you start R and want to use %>%
library(e1071)
library(caTools)
library(caret)
library(ElemStatLearn)

this.dir <- dirname(getSourceEditorContext()$path)# frame(3) also works.
setwd(this.dir)
setwd('..')

dataset = read.csv("/Biomed/dataset/mergelymm.csv")
dataset = dataset[-c(1)]
#dataset = dataset[-c(3)]
dataset = dataset[-c(4)]
glimpse(dataset)
dataset = dataset[sample(1:nrow(dataset)),]
glimpse(dataset)
dataset$status = factor(dataset$status)

set.seed(123)
split = sample.split(dataset$status, SplitRatio = 0.75)

training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

training_set[-3] = scale(training_set[-3])
test_set[-3] = scale(test_set[-3])
glimpse(test_set)
# Fitting SVM to the Training set
#install.packages('e1071')

classifier = svm(formula = status ~ .,
                 data = training_set,
                 type = 'C-classification',
                 kernel = 'linear')

# Predicting the Test set results
y_pred = predict(classifier, newdata = test_set[-3])
#plot(y_pred, newdata = test_set[, 3])

# Making the Confusion Matrix
cm = table(test_set[, 3], y_pred)
cm


accuracy <- sum(diag(cm)) / sum(cm)

list('predict matrix' = cm, 'accuracy' = accuracy)

# Model Evaluation
confusionMatrix(cm)

######################## Source of the plotting code and some funtions are taken from geeksforgeeks website(https://www.geeksforgeeks.org/classifying-data-using-support-vector-machinessvms-in-r/)##############################

# Plotting the training data set results
set = training_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
#glimpse(X1)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
#glimpse(X2)
grid_set = expand.grid(X1, X2)
#print(grid_set)
colnames(grid_set) = c('t', 'logFC')
y_grid = predict(classifier, newdata = grid_set, , type ='class')

plot(set[, -3],
     main = 'SVM (Training set)',
     xlab = 't', ylab = 'logFC',
     xlim = range(X1), ylim = range(X2))

contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)

points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'coral1', 'aquamarine'))

points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))

#png(file = "svm_lymm1.png")

set = test_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
#glimpse(X1)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
#glimpse(X2)
grid_set = expand.grid(X1, X2)
#print(grid_set)
colnames(grid_set) = c('t', 'logFC')
y_grid = predict(classifier, newdata = grid_set, , type ='class')

plot(set[, -3],
     main = 'SVM (Test set)',
     xlab = 't', ylab = 'logFC',
     xlim = range(X1), ylim = range(X2))

contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)

points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'coral1', 'aquamarine'))

points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))


#dev.off()

#install.packages("caret", dependencies = TRUE)
library(caret)
trctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

svm_Linear <- train(status ~., data = training_set, method = "svmLinear",
                    trControl=trctrl,
                    preProcess = c("center", "scale"),
                    tuneLength = 10)

svm_Linear
s <- as.factor(test_set$status)
s
test_set
test_pred <- predict(svm_Linear, newdata = test_set)


confusionMatrix(table(as.factor(test_pred), as.factor(test_set$status)))

precision <- posPredValue(test_pred, test_set$status, positive="1")
recall <- sensitivity(test_pred, test_set$status, positive="1")

F1 <- (2 * precision * recall) / (precision + recall)

precision
recall
F1

#precision(confusionMatrix)
precision(data = test_pred, reference = test_set$status  , positive = "0")