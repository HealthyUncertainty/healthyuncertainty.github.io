#####################################################################################
#                                                                                   #
# TITLE: Building Health State Transition Models in R: Chapter 5                    #
#                                                                                   #
# DESCRIPTION: Here we perform a hypothetical cost-effectiveness exercise from      #
#               beginning to end - reading in variables from the table, creating    #
#               health states, simulating survival, applying costs and utilities,   #
#               estimating discounted ICERs, and performing PSA                     #
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
    ncycle <- 50  
    n <- 1000
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

  # Define Risk Modification
    P_riskmod <- 1 - rbeta(n, bdist(0.05, 0.02)[,1], bdist(0.05, 0.02)[,2])
    
  # Define reciprocal parameters
    P_W_return <- 1 - P_WtoX
    A_P_X_return <- 1 - (P_XtoW + P_XtoY*P_riskmod)
    B_P_X_return <- 1 - (P_XtoW + P_XtoY)
    P_Y_return <- 1 - P_YtoZ
    P_X     <- 1 - P_W


##### STEP 6 - DEFINE HEALTH STATES IN R #####

  # Define blank arrays for both arms
    A_HS_W <- A_HS_X <- array(0, dim=c(ncycle,1,n))
    A_HS_Y <- A_HS_Z <- array(0, dim=c(ncycle,2,n))
  
    B_HS_W <- B_HS_X <- array(0, dim=c(ncycle,1,n))
    B_HS_Y <- B_HS_Z <- array(0, dim=c(ncycle,2,n))
  
  # Define starting population in each state
    for (j in 1:n){
    A_HS_W[1,1,j] <- B_HS_W[1,1,j] <- npop*P_W[j]
    A_HS_X[1,1,j] <- B_HS_X[1,1,j] <- npop*P_X[j]}
  
  ### DESCRIBE TRANSITIONS BETWEEN HEALTH STATES
    # Experimental Arm
    for (j in 1:n){
      for (i in 2:ncycle){
        A_HS_W[i,,j] <- A_HS_W[(i-1),,j]*P_W_return[j] + A_HS_X[(i-1),,j]*P_XtoW[j]
        
        A_HS_X[i,,j] <- A_HS_X[(i-1),,j]*A_P_X_return[j] + A_HS_W[(i-1),,j]*P_WtoX[j]
    
        A_HS_Y[i,1,j] <- A_HS_X[(i-1),,j]*P_XtoY[j]*P_riskmod[j]
        A_HS_Y[i,2,j] <- sum(A_HS_Y[(i-1),,j])*P_Y_return[j]
    
        A_HS_Z[i,1,j] <- sum(A_HS_Y[(i-1),,j])*P_YtoZ[j]
        A_HS_Z[i,2,j] <- sum(A_HS_Z[(i-1),,j])
          }}

    # Control Arm
    for (j in 1:n){
      for (i in 2:ncycle){
        B_HS_W[i,,j] <- B_HS_W[(i-1),,j]*P_W_return[j] + B_HS_X[(i-1),,j]*P_XtoW[j]
  
        B_HS_X[i,,j] <- B_HS_X[(i-1),,j]*B_P_X_return[j] + B_HS_W[(i-1),,j]*P_WtoX[j]
  
        B_HS_Y[i,1,j] <- B_HS_X[(i-1),,j]*P_XtoY[j]
        B_HS_Y[i,2,j] <- sum(B_HS_Y[(i-1),,j])*P_Y_return[j]
  
        B_HS_Z[i,1,j] <- sum(B_HS_Y[(i-1),,j])*P_YtoZ[j]
        B_HS_Z[i,2,j] <- sum(B_HS_Z[(i-1),,j])
          }
    }
##### STEP 7 - APPLY COSTS, UTILITIES TO HEALTH STATES #####

  ### Apply Costs ###

  # Define additional cost paramter for experimental arm (Arm A)
    C_add<- rgamma(n, gdist(750, 100)[,1], scale = gdist(750, 100)[,2])
     
  # Create blank arrays for costs
    cost_AHSW <- cost_AHSX <- cost_BHSW <- cost_BHSX <- array(0, dim=c(ncycle,1,n))
    cost_AHSY <- cost_AHSZ <- cost_BHSY <- cost_BHSZ <- array(0, dim=c(ncycle,2,n))
  
  # Populate arrays
    for (j in 1:n){
      cost_AHSW[,,j] <- A_HS_W[,,j]*C_W[j]
      cost_AHSX[,,j] <- A_HS_X[,,j]*(C_X[j] + C_add[j])
      
      cost_AHSY[,1,j] <- A_HS_Y[,1,j]*(C_Ytransition[j] + C_Y[j])
      cost_AHSY[,2,j] <- A_HS_Y[,2,j]*C_Y[j]
      
      cost_AHSZ[,1,j] <- A_HS_Z[,1,j]*C_Ztransition[j]
    }

    for (j in 1:n){
      cost_BHSW[,,j] <- B_HS_W[,,j]*C_W[j]
      cost_BHSX[,,j] <- B_HS_X[,,j]*C_X[j]
      
      cost_BHSY[,1,j] <- B_HS_Y[,1,j]*(C_Ytransition[j] + C_Y[j])
      cost_BHSY[,2,j] <- B_HS_Y[,2,j]*C_Y[j]
      
      cost_BHSZ[,1,j] <- B_HS_Z[,1,j]*C_Ztransition[j]
    }
  
  ### Apply Utilities ###
  
  # Create blank arrays for utilities
    util_AHSW <- util_BHSW <- util_AHSX <- util_BHSX <- array(0, dim=c(ncycle,1,n))
    util_AHSY <- util_BHSY <- array(0, dim=c(ncycle,2,n))
  
  # Populate arrays
    for (j in 1:n){
      util_AHSW[,,j] <- A_HS_W[,,j]*U_W[j]
      util_AHSX[,,j] <- A_HS_X[,,j]*U_X[j]
      util_AHSY[,,j] <- A_HS_Y[,,j]*U_Y[j]
    }

    for (j in 1:n){
      util_BHSW[,,j] <- B_HS_W[,,j]*U_W[j]
      util_BHSX[,,j] <- B_HS_X[,,j]*U_X[j]
      util_BHSY[,,j] <- B_HS_Y[,,j]*U_Y[j]
    }

##### STEP 8 - CALCULATE SUMMARY STATISTICS FROM MODEL OUTPUT #####
## Summarize costs and outcomes
  # Create blank utilities for LYG, QALY, and costs from both arms
    LYG_A <- LYG_B <- QALY_A <- QALY_B <- COST_A <- COST_B <- array(0, dim=c(ncycle,1,n))

  for (i in 1:ncycle){
  # Calculate LYG per cycle for each arm
    LYG_A[i,,] <- A_HS_W[i,,] + A_HS_X[i,,] + colSums(A_HS_Y[i,,])
    LYG_B[i,,] <- B_HS_W[i,,] + B_HS_X[i,,] + colSums(B_HS_Y[i,,])

  # Calculate QALY per cycle for each arm
    QALY_A[i,,] <- util_AHSW[i,,] + util_AHSX[i,,] + colSums(util_AHSY[i,,])
    QALY_B[i,,] <- util_BHSW[i,,] + util_BHSX[i,,] + colSums(util_BHSY[i,,])

  # Calculate costs per cycle for each arm
    COST_A[i,,] <- cost_AHSW[i,,] + cost_AHSX[i,,] + colSums(util_AHSY[i,,]) + colSums(cost_AHSZ[i,,])
    COST_B[i,,] <- cost_BHSW[i,,] + cost_BHSX[i,,] + colSums(util_BHSY[i,,]) + colSums(cost_BHSZ[i,,])
  }

## Apply Discounting

  # Create an array for years of time passed
    year <- array(dim=c(ncycle,1,n))
    for (i in 1:ncycle){year[i,,] <- (i-1)}

  # Apply outcome discounting
    DLYG_A <- LYG_A*(1/(1+Disc_O)^(year))
    DLYG_B <- LYG_B*(1/(1+Disc_O)^(year))
    
    DQALY_A <- QALY_A*(1/(1+Disc_O)^(year))
    DQALY_B <- QALY_B*(1/(1+Disc_O)^(year))
    
  # Apply cost discounting
    DCOST_A <- COST_A*(1/(1+Disc_C)^(year))
    DCOST_B <- COST_B*(1/(1+Disc_C)^(year))

## Calculate Delta C, Delta E
  
  DeltaC <- DeltaE <- DeltaQ <- matrix(0, nrow=n, ncol=1)
    for (j in 1:n){
    DeltaC[j,] <- (sum(DCOST_A[,,j]) - sum(DCOST_B[,,j]))/npop
    DeltaE[j,] <- (sum(DLYG_A[,,j]) - sum(DLYG_B[,,j]))/npop
    DeltaQ[j,] <- (sum(DQALY_A[,,j]) - sum(DQALY_B[,,j]))/npop }

## Calculate ICER
    ICER <- mean(DeltaC)/mean(DeltaE)
    QICER <- mean(DeltaC)/mean(DeltaQ)

##### STEP 9 - PLOT COST-EFFECTIVENESS PLANE, CEACS, USING 'BCEA' PACKAGE #####

## Create blank matrices for effectiveness, cost
  BCEA_DC <- BCEA_DE <- BCEA_DQ <- matrix(nrow = n, ncol=2)

## Populate matrices
  for (j in 1:n){
    BCEA_DC[j,1] <- sum(DCOST_A[,,j])/npop
    BCEA_DC[j,2] <- sum(DCOST_B[,,j])/npop
    
    BCEA_DE[j,1] <- sum(DLYG_A[,,j])/npop
    BCEA_DE[j,2] <- sum(DLYG_B[,,j])/npop
    
    BCEA_DQ[j,1] <- sum(DQALY_A[,,j])/npop
    BCEA_DQ[j,2] <- sum(DQALY_B[,,j])/npop}


## Create BCEA plots
  BCEA.LYG <- bcea(e=BCEA_DE, c=BCEA_DC, interventions = c("A", "B"), Kmax=100000)
	BCEA.QALY <- bcea(e=BCEA_DQ, c=BCEA_DC, interventions = c("A", "B"), Kmax=100000)
	plot.bcea(BCEA.LYG)
	summary(BCEA.LYG, wtp=50000)

## 

#### This is the code I used to produce the graphs presented in this chapter

hist(DeltaC, main="Difference in Cost: A vs. B", 
     xlab="Dollars per person", col="green", breaks=100)
hist(DeltaE, main="Life Years Gained: A vs. B", xlab= "Average LYG", col="blue", breaks=100)
hist(DeltaQ, main="QALY Gained: A vs. B", xlab="Average QALY", col="purple", axes=TRUE, breaks=100)
hist(ICER, main="Cost Per LYG: A vs. B", xlab="ICER", col="red", breaks=100, xlim= c(0,400000))
hist(QICER, main="Cost Per QALY: A vs. B", xlab="ICER", col="cyan", breaks=100, xlim= c(0,400000))
