#################################################################################
#                                                                               #
# Batch import variables from an Excel table and assign them names and either   #
# deterministic or probabilistic values.                                        #
#                                                                               #
# DATE: August 2020                                                             #
#                                                                               #
# AUTHOR: Ian Andrew Cromwell                                                   #
#                                                                               #
#################################################################################

### SET WORKING DIRECTORY (WHERE YOUR FILES ARE)
  setwd("//mydirectory")

### READ IN VALUES FROM TABLE
  #install.packages('readxl')
  library(readxl)
  Inputs <- read_excel("Model Inputs.xls") #The Excel file name
  Inputs <- subset(Inputs, Value >-1) #Remove blank rows

  #View(Inputs)
  
### LOAD THE IMPORT FUNCTION
  source("ImportVars.R")
  
### RUN THE IMPORT FUNCTION
  # Specify the number of probabilistic draws you want to make
  varlist <- ImportVars(Inputs, num_iter = 10)
  
### PASS VARIABLES INTO THE GLOBAL ENVIRONMENT
  # Deterministically (just means)
  for (i in 1:length(varlist$varname)){
    assign(paste(varlist$varname[i]), unlist(varlist$varmean[i]))
  }
  
  # Probabilistically
  for (i in 1:length(varlist$varname)){
    assign(paste(varlist$varname[i]), unlist(varlist$varprob[i]))
  }