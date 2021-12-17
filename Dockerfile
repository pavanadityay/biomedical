From rocker/r-ver:3.5.1

#System dependencies

#RUN apt-get update

#R Packages


RUN Rscript -e 'install.packages(c("caTools","caret","ClusterR","dplyr","e1071","ElemStatLearn","GGally","magrittr","MASS","neuralnet","party","randomForest","tidyverse","thePackage","umap"))'

RUN mkdir Biomed

RUN cd /Biomed

RUN mkdir /Biomed/src

RUN mkdir /Biomed/dataset

RUN mkdir /Biomed/generatedResults


COPY ./dataset/mergem.csv /Biomed/dataset/

COPY ./src/* /Biomed/src/

COPY ./generatedResults/* /Biomed/generatedResults/ 

RUN mkdir /Biomed/output/

  

#Leukemia

RUN Rscript /Biomed/src/healthyds.R
RUN Rscript /Biomed/src/cancerds.R
RUN Rscript /Biomed/src/decisionTree.R
RUN Rscript /Biomed/src/kmeans.R
RUN Rscript /Biomed/src/kmeansnew.R
RUN Rscript /Biomed/src/knnoutput.R
RUN Rscript /Biomed/src/NB.R
RUN Rscript /Biomed/src/NNnew.R
RUN Rscript /Biomed/src/randomforest.R
RUN Rscript /Biomed/src/SVM.R

#Lymphoma

RUN Rscript /Biomed/src/h_lym.R
RUN Rscript /Biomed/src/c_lym.R
RUN Rscript /Biomed/src/decisiontree_lym.R
RUN Rscript /Biomed/src/kmeans_lym.R
RUN Rscript /Biomed/src/KNN_lym.R
RUN Rscript /Biomed/src/NB_lym.R
RUN Rscript /Biomed/src/randomforest_lym.R
RUN Rscript /Biomed/src/SVM_lym.R







