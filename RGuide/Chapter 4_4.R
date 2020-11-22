#####################################################################################
#                                                                                   #
# TITLE: Building Health State Transition Models in R: Chapter 4.4                  #
#                                                                                   #
# DESCRIPTION: Here we import our model parameters from a saved .xls file, and turn #
#               the static inputs into probabalistic vectors (for PSA)              #
#                                                                                   #
# AUTHOR: Ian Cromwell                                                              #
#                                                                                   #
# DATE: January, 2020                                                               #
#                                                                                   #
#####################################################################################

### LOAD REQUIRED PACKAGES
  library(BCEA)
  library(gtools)
  library(readxl)

### SET WORKING DIRECTORY
  setwd("WHATEVER DIRECTORY YOU'VE SAVED THESE FILES IN")

### READ IN VALUES FROM TABLE
  Inputs <- read_excel("Model Inputs.xls")
  Inputs <- subset(Inputs, Value >-1)

##### STEP 5 - DEFINE PARAMETERS IN R #####

  ### DEFINE GLOBAL PARAMETERS FOR MODEL
  ncycle <- 10  
  n <- 10
  npop <- 1000
  Disc_O <- 0.015
  Disc_C <- 0.015
  
  ### DEFINE SHAPE VARIABLES FOR BETA- AND GAMMA-DISTRIBUTED PARAMETERS
  bdist <- function(x, y){
    alpha <- x*((x*(1-x)/y^2) - 1)
    beta <- (1-x)*(x/y^2*(1-x) - 1)
    return(t(c(alpha, beta)))}    
    
  gdist <- function(x, y){
    shape <- x^2/y^2
    scale <- y^2/x
    return(t(c(shape, scale)))}
  
  ### IDENTIFY VARIABLES BY TYPE
  Betavars <- subset(Inputs, Type==1 | Type==2)
    Betavars["Shape1"] <- 0
    Betavars["Shape2"] <- 0
  Gammavars <- subset(Inputs, Type==3)
    Betavars["Shape1"] <- 0
    Betavars["Shape2"] <- 0
  Utilvars <- subset(Inputs, Type==4)
    Betavars["Shape1"] <- 0
    Betavars["Shape2"] <- 0
  
  ### CALCULATE SHAPE PARAMETERS
  for (i in 1:nrow(Betavars)){Betavars[i,6] <- bdist(Betavars[i,4], Betavars[i,5])[1]
                              Betavars[i,7] <- bdist(Betavars[i,4], Betavars[i,5])[2]}
    
  for (i in 1:nrow(Gammavars)){Gammavars[i,6] <- gdist(Gammavars[i,4], Gammavars[i,5])[1]
                               Gammavars[i,7] <- gdist(Gammavars[i,4], Gammavars[i,5])[2]}
    
  for (i in 1:nrow(Utilvars)){Utilvars[i,6] <- gdist(1-Utilvars[i,4], Utilvars[i,5])[1]
                              Utilvars[i,7] <- gdist(1-Utilvars[i,4], Utilvars[i,5])[2]}
    
  ### PARAMETERIZE POINT ESTIMATES
    # Perform random draws based on assumptions about parametric distributions
      # Binary probabilities: beta distribution
      for (i in 1:nrow(Betavars)){
        sh1 <- as.numeric(Betavars[i,6])
        sh2 <- as.numeric(Betavars[i,7])
        assign(paste(Betavars[i,1]), rbeta(n, sh1, sh2))}
  
      # Costs: gamma distribution
      for (i in 1:nrow(Gammavars)){
        sh1 <- as.numeric(Gammavars[i,6])
        sh2 <- as.numeric(Gammavars[i,7])
        assign(paste(Gammavars[i,1]), rgamma(n, sh1, scale = sh2))}
      
      # Utilities: gamma distribution of disutility (1 - utility)
      for (i in 1:nrow(Utilvars)){
        sh1 <- as.numeric(Utilvars[i,6])
        sh2 <- as.numeric(Utilvars[i,7])
        assign(paste(Utilvars[i,1]), (1 - (rgamma(n, sh1, scale = sh2))))}
  
    # Define returning parameters
    P_W_return <- 1 - P_WtoX
    P_X_return <- 1 - (P_XtoW + P_XtoY)
    P_Y_return <- 1 - P_YtoZ
    P_X     <- 1 - P_W