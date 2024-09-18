# loading packages ------
# for ML
library(caret) # all models
library(RANN)

# for calculation
library(lubridate)
library(dplyr)
library(hydroGOF) # NSE
library(forecast)
library(tidyr) 

# for plot
library(openair) # Taylor diagram
library(patchwork)  
library(magick) # image read

# -------------- step1 --------------------
# loading test data
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
df <- readRDS("test_data.RData")

#Spliting training set into two parts based on outcome: 2018 for validation, other for calibration
set.seed(1)
random_index <- 1:as.integer(nrow(df))
random_index_cal <<-  which(year(df$Timestamp) != 2018)
random_index_val <<-  which(year(df$Timestamp) == 2018)

trainSet <- df[random_index_cal,]
testSet <- df[random_index_val,]

#Defining the training control
fitControl <<- trainControl(method = "repeatedcv", number = 10, repeats = 3)
incomeName <<- c("Q", "WT", "SL")
outcomeName <<-'Obj'   

# -------------- step2 --------------------
Res_ann <- signal_ML(trainSet, testSet,'nnet')
Res_rf <- signal_ML(trainSet, testSet,'rf')
Res_svm <- signal_ML(trainSet, testSet, 'svmRadial') 





