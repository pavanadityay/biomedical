# Blood cancer prediction using  microarray gene data
## _Predicting Cancer by a determininstic approach using R_

Blood cancer has become more prevalent over the previous decade, necessitating early detection in order to begin adequate therapy. The diagnosing process is costly and time-consuming, requiring the participation of medical specialists and a variety of tests. As a result, an automatic diagnosis system with precise prognosis is critical. The use of leukaemia microarray gene data with a machine learning approach to diagnose blood cancer has become a significant medical research topic in recent years. Despite research efforts, more improvements are required to achieve the desired accuracy and efficiency. Using supervised machine learning, this work suggests a method for predicting blood cancer diseases including Leukemia,Myeloma and Lymphoma.

## Dataset

The dataset in the datasets folder contains the details of patients with it's respective t, logFC, status and cancer type values of Microarray gene data.

## Installation

The project code should be executed on R and can be downloaded from below:
- [R](https://cran.r-project.org/bin/windows/base/) 

R's package manager(which is internal) can be used to install required R libraries. We just need to search for the respective library name and type `library(package name)` and run it.

In RStudio go to Tools → Install Packages and in the Install from option select Repository (CRAN) and then specify the packages you want. After Installation you can load it using below command.
- library(package_name)


To run the code, we also need an IDE which can be installed from [R studio](https://www.rstudio.com/products/rstudio/download/)

## Code

- The executable codes are given in the src folder. The code first loads all the required libraries and gets the required Genes data from Geo omnibus and then performs the preprocessing on training and testing datasets followed by data visulization, normalization,PCA and trained using Machine Learning algorithms like Bayesian Classifier, Support Vector Classifier, UMAP etc. 

-  The model is built and the test data is passed to calclulate accuracy which is our evaluation metric. 

## Execution
Run all the source codes that are available in the Code folder, dataset files that are mentioned above should be placed in `datasets` folder.
## Repository

Project Link: https://github.com/pavanadityay/biomedical








