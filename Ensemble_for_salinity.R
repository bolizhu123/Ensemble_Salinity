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
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
trainSet <- readRDS("data_cal.RData")
testSet <- readRDS("data_val.RData")
source("signal_ML.R")
source("fitting_coe.R")

# -------------- step2 --------------------
predictors_top<-c('ANN','MIKE11') 
outcomeName <- c('Obj')
all_EM_name <- c('glm', 'cubist', 'bstSm')

for (m in 1: length(all_EM_name)) {
  EM_name <- all_EM_name[m]
  
  EN_model<- train(data_cal[,predictors_top],data_cal[,outcomeName],method=EM_name, trControl=fitControl, tuneLength=3)
  
  #Prediction for the test data
  data_cal[[EM_name]] <- predict(EN_model,data_cal[,predictors_top])
  data_val[[EM_name]]<-predict(EN_model,data_val[,predictors_top])
  
  RES_ensemble$coe[[EM_name]][[station_name]] <- fitting_coe(data_val$Obj,data_val[[EM_name]])
  RES_ensemble$ts[[station_name]] <- list(cal = data_cal, val = data_val)
  RES_ensemble$model[[EM_name]][[station_name]] <- EN_model
}


