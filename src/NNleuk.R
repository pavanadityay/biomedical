require("neuralnet")
#install.packages("tidyverse")
library(tidyverse)
library(neuralnet)
library(GGally)
library(dplyr)
#load the dataset


this.dir <- dirname(getSourceEditorContext()$path)# frame(3) also works.
setwd(this.dir)
setwd('..')

dataset = read.csv("/Biomed/dataset/mergeleuk.csv")
dataset = dataset[-c(1)]
dataset = dataset[-c(4)]
#dataset = dataset[-c(3)]
dataset = dataset[sample(1:nrow(dataset)),]
glimpse(dataset)


Hab_Data <- dataset

scale01 <- function(x){
  (x - min(x)) / (max(x) - min(x))
}


Hab_Data <- Hab_Data %>%
  mutate(t = scale01(t), 
         logFC = scale01(logFC), 
         status = as.numeric(status)-1)

Hab_Data <- Hab_Data %>%
  mutate(status = as.integer(status) - 1, 
         status = ifelse(status == 1, TRUE, FALSE))
#df <- as.data.frame(lapply(dataset[1:3], normalize))

ggpairs(Hab_Data, title = "Scatterplot Matrix of the Features of the Data Set")


set.seed(123)
Hab_NN1 <- neuralnet(status ~ t + logFC, 
                     data = Hab_Data, 
                     linear.output = FALSE, 
                     err.fct = 'ce', 
                     likelihood = TRUE)

plot(Hab_NN1, rep = 'best')

set.seed(123)
# 2-Hidden Layers, Layer-1 2-neurons, Layer-2, 1-neuron
Hab_NN2 <- neuralnet(status ~ t + logFC, 
                     data = Hab_Data, 
                     linear.output = FALSE, 
                     err.fct = 'ce', 
                     likelihood = 
                       TRUE, hidden = c(2,1))

# 2-Hidden Layers, Layer-1 2-neurons, Layer-2, 2-neurons
set.seed(123)
Hab_NN3 <- Hab_NN2 <- neuralnet(status ~ t + logFC, 
                                data = Hab_Data, 
                                linear.output = FALSE, 
                                err.fct = 'ce', 
                                likelihood = TRUE, 
                                hidden = c(2,2))

# 2-Hidden Layers, Layer-1 1-neuron, Layer-2, 2-neuron
set.seed(123)
Hab_NN4 <- Hab_NN2 <- neuralnet(status ~ t + logFC, 
                                data = Hab_Data, 
                                linear.output = FALSE, 
                                err.fct = 'ce', 
                                likelihood = TRUE, 
                                hidden = c(1,2))

# Bar plot of results
Class_NN_ICs <- tibble('Network' = rep(c("NN1", "NN2", "NN3", "NN4"), each = 3), 
                       'Metric' = rep(c('AIC', 'BIC', 'ce Error * 100'), length.out = 12),
                       'Value' = c(Hab_NN1$result.matrix[4,1], Hab_NN1$result.matrix[5,1], 
                                   100*Hab_NN1$result.matrix[1,1], Hab_NN2$result.matrix[4,1], 
                                   Hab_NN2$result.matrix[5,1], 100*Hab_NN2$result.matrix[1,1],
                                   Hab_NN3$result.matrix[4,1], Hab_NN3$result.matrix[5,1], 
                                   100*Hab_NN3$result.matrix[1,1], Hab_NN4$result.matrix[4,1], 
                                   Hab_NN4$result.matrix[5,1], 100*Hab_NN4$result.matrix[1,1]))

Class_NN_ICs %>%
  ggplot(aes(Network, Value, fill = Metric)) +
  geom_col(position = 'dodge')  +
  ggtitle("AIC, BIC, and Cross-Entropy Error of the Classification ANNs", "Note: ce Error displayed is 100 times its true value")

