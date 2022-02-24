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
# Simulating Dataset
#===============================================================================

# Predictors ===================================================================

# Create a first column to test 
a <- rnorm(1000,0)
df <- a

# Create 5 columns with random data
columns <- cbind(1:5)

# For loop data into columns
for (i in columns){
  name <- paste("var",i, sep="")
  tmp <- rnorm(1000,0)
  df <- data.frame(df, tmp)
  names(df)[names(df) == 'tmp'] <- name
}

# Fix first column 
names(df)[names(df) == 'df'] <- 'var0'

# Creating Target Variables=====================================================

## We create a fake data set of USA Arrests using USArrests data set and 
## simulating with fakeR package. The following code is taken from: 
## https://rviews.rstudio.com/2020/09/09/fake-data-with-r/

# Create empty df with USA state names
state_names <- rownames(USArrests)
fake_arrests <- tibble(state_names)  

# Simulate data
data <- USArrests
rownames(data) <- NULL
sim_data <- simulate_dataset(data)

# Merge with our predictor variables
fake_arrests <- cbind(fake_arrests, df)
fake_arrests <- cbind(fake_arrests, sim_data)

fake_arrests <- subset(fake_arrests, select = -c(state_names, var0, UrbanPop, Rape, Murder))

# take a look at the data
head(fake_arrests)

# export to csv
write.csv(fake_arrests, "./data/fake_arrests.csv")
