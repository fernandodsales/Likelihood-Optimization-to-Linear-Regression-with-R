# Simulating data

#Fernando Delgado

setwd("C:/Users/fdelgado/OneDrive - IESEG/Documents/01. IESEG/17. Optimization/Individual Project")

#===============================================================================
# Libraries
#===============================================================================

#Data manipulation
for (i in c('dplyr','tidytext','tidyverse','data.table', 'fakeR')){
  if (!require(i, character.only=TRUE)) install.packages(i, repos = "http://cran.us.r-project.org")
  require(i, character.only=TRUE)
}

#Visualization
for (i in c('ggplot2','scales','maps','maptools','ggmap')){
  if (!require(i, character.only=TRUE)) install.packages(i, repos = "http://cran.us.r-project.org")
  require(i, character.only=TRUE)
}

#===============================================================================
# Import Data
#===============================================================================

fake_arrests <- fread("./data/fake_arrests.csv")
fake_arrests <- subset(fake_arrests, select = -V1)

#===============================================================================
# Linear Regression Model
#===============================================================================

#Reading the example data set icu from the package aplore3
library(aplore3)

## The following code is inspired by the code posted in this forum:
## https://www.joshua-entrop.com/post/optim_linear_reg/

#Define likelihood function to optimise
ll_lm <- function(par, y, x1, x2, x3, x4, x5){
  
  alpha <- par[1]
  beta1 <- par[2]
  beta2 <- par[3]
  beta3 <- par[4]
  beta4 <- par[5]
  beta5 <- par[6]
  sigma <- par[7]
  
  R = y - alpha - beta1 * x1 - beta2 * x2 - beta3 * x3 - beta4 * x4 - beta5 * x5
  
  -sum(dnorm(R, mean = 0, sigma, log = TRUE))
}

#Estimate Betas
est_alpha <- mean(fake_arrests$Assault)
est_beta1 <- mean(fake_arrests$var1)
est_beta2 <- mean(fake_arrests$var2)
est_beta3 <- mean(fake_arrests$var3)
est_beta4 <- mean(fake_arrests$var4)
est_beta5 <- mean(fake_arrests$var5)
est_sigma <- sd(fake_arrests$Assault)

#===============================================================================
# Optimization 
#===============================================================================

#
mle_par <- optim(fn = ll_lm,               
                 par = c(alpha = est_alpha, 
                         beta1 = est_beta1, 
                         beta2 = est_beta2,
                         beta3 = est_beta3,
                         beta4 = est_beta4,
                         beta5 = est_beta5,
                         sigma = est_sigma), 
                 y = fake_arrests$Assault,               
                 x1 = fake_arrests$var1,
                 x2 = fake_arrests$var2,
                 x3 = fake_arrests$var3,
                 x4 = fake_arrests$var4,
                 x5 = fake_arrests$var5)

mle_par$par

summary(lm(Assault ~ var1 + var2 + var3 + var4 + var5, data = fake_arrests))

tinytex::install_tinytex()
