#### signal_model ------------------------------------------
signal_ML <- function(trainSet, testSet, model_name){
  
  #Training the model
  signal_model<-train(trainSet[,incomeName],trainSet[,outcomeName],method= model_name, linout = TRUE,
                      trControl=fitControl,tuneLength=3, preProcess = c('BoxCox'), na.action = na.omit)
  
  trainSet$sim<- predict(signal_model,trainSet[,incomeName])
  coe_cal <- fitting_coe(trainSet$Obj,trainSet$sim)
  
  testSet$sim<-predict(signal_model,testSet[,incomeName]) 
  coe_val <- fitting_coe(testSet$Obj,testSet$sim)
  
  ggplot(data = testSet, aes(x = Timestamp)) +
    geom_line(aes(y = Obj, color = "Time Series 0")) +
    geom_line(aes(y = sim, color = "Time Series 1")) +
    geom_line(aes(y = sim1, color = "Time Series 2"))
  
  data <- list(trainSet = trainSet, testSet = testSet, coe_cal = coe_cal, coe_val = coe_val, model = signal_model)
  
  return(data)
}