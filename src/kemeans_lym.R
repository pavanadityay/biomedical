library(dplyr)
library(e1071)
library(caTools)
library(caret)

dataset = read.csv("/Biomed/dataset/mergelymm.csv")
dataset = dataset[-c(1)]
dataset = dataset[-c(3)]
dataset = dataset[-c(3)]
dataset = dataset[sample(1:nrow(dataset)),]
glimpse(dataset)

#kmeans(df, 3)
#install.packages("animation")


rescale_df <- dataset %>%
  mutate(t_scal = scale(t),logFC_scal = scale(logFC)) %>%
  select(c(t,logFC))


normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x))) }
prc_n <- as.data.frame(lapply(dataset[1:2], normalize))
prc_n

set.seed(2345)
library(animation)
kmeans.ani(prc_n, 2)

kmean_withinss <- function(k) {
  cluster <- kmeans(prc_n, k)
  return (cluster$tot.withinss)
}

kmean_withinss(2)

# Set maximum cluster 
max_k <-20 
# Run algorithm over a range of k 
wss <- sapply(2:max_k, kmean_withinss)


# Create a data frame to plot the graph
elbow <-data.frame(2:max_k, wss)

# Plot the graph with gglop
ggplot(elbow, aes(x = X2.max_k, y = wss)) +
  geom_point() +
  geom_line() +
  scale_x_continuous(breaks = seq(1, 20, by = 1))

# according to plot 6 is the curve point

pc_cluster_2 <-kmeans(rescale_df, 6)

kmeans.ani(prc_n, 6)

center <-pc_cluster_2$centers
center

library(tidyr)

# create dataset with the cluster number

cluster <- c(1: 6)
center_df <- data.frame(cluster, center)

# Reshape the data

center_reshape <- gather(center_df, features, values, t: logFC)
head(center_reshape)

library(RColorBrewer)
# Create the palette
hm.palette <-colorRampPalette(rev(brewer.pal(10, 'RdYlGn')),space='Lab')

# Plot the heat map
ggplot(data = center_reshape, aes(x = features, y = cluster, fill = values)) +
  scale_y_continuous(breaks = seq(1, 7, by = 1)) +
  geom_tile() +
  coord_equal() +
  scale_fill_gradientn(colours = hm.palette(90)) +
  theme_classic()