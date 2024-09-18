#### fitting_coe() ---------R2 + MPE + NSE + precentile-----------------------------------------------------
fitting_coe <- function(obs, sim){
  # MAE and MAPE here weird, not recommended for some Inf
  
  coe <- NULL
  percentile <- NULL
  
  lm_equation = lm(obs ~ sim)
  coe$R2 <- summary(lm_equation)$r.squared
  coe$NSE <- NSE(sim, obs)
  acc = as.data.frame(accuracy(obs, sim))
  coe <- cbind(as.data.frame(coe), acc)
  coe$Pbias <- pbias(sim, obs)
  coe$obs <- mean(obs)
  coe$sim <- mean(sim)
  
  pre_obs = quantile(obs, probs = c(0.05,0.25,0.50,0.75, 0.95, 0.99))
  pre_sim = quantile(sim, probs = c(0.05,0.25,0.50,0.75, 0.95, 0.99))
  pre_RE = (pre_sim - pre_obs)/pre_obs*100
  
  percentile[['percentile_obs']] <- pre_obs
  percentile[['percentile_sim']] <- pre_sim
  percentile[['percentile_RE']] <- pre_RE
  
  coe_all = list(coe=coe, percentile = percentile)
  
  return(coe_all)}