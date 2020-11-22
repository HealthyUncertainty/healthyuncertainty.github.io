#####################################################################################
#                                                                                   #
# TITLE: Building Health State Transition Models in R: Chapter 8                    #
#                                                                                   #
# DESCRIPTION: We create and populate arrays that represent our model health states #
#                                                                                   #
# AUTHOR: Ian Cromwell                                                              #
#                                                                                   #
# DATE: November, 2014                                                              #
#                                                                                   #
#####################################################################################

### SET WORKING DIRECTORY
  setwd("WHATEVER DIRECTORY YOU'VE SAVED THESE FILES IN")

### LOAD IN TRANSITION PROBABILITIES FROM PREVIOUS CHAPTER
  source("Chapter 4_4.R")

### CREATE HEALTH STATES ###
  # Define blank arrays
  
    # Health states W and X have a single column
    HS_W <- HS_X <- array(0, dim=c(ncycle,1,n))
    # Health states Y and Z have two columns for costing differences
    HS_Y <- HS_Z <- array(0, dim=c(ncycle,2,n))
  
  # Define starting population in each state
  for (j in 1:n){
    HS_W[1,1,j] <- npop*P_W[j]
  	HS_X[1,1,j] <- npop*P_X[j]}

### DESCRIBE TRANSITIONS BETWEEN HEALTH STATES
    for (j in 1:n){
      for (i in 2:ncycle){
      # State W
      HS_W[i,,j] <- HS_W[(i-1),,j]*P_W_return[j] + HS_X[(i-1),,j]*P_XtoW[j]
     
      # State X
      HS_X[i,,j] <- HS_X[(i-1),,j]*P_X_return[j] + HS_W[(i-1),,j]*P_WtoX[j]
      
      # State Y
      HS_Y[i,1,j] <- HS_X[(i-1),,j]*P_XtoY[j]
      HS_Y[i,2,j] <- sum(HS_Y[(i-1),,j])*P_Y_return[j]

      # State Z
      HS_Z[i,1,j] <- sum(HS_Y[(i-1),,j])*P_YtoZ[j]
      HS_Z[i,2,j] <- sum(HS_Z[(i-1),,j])
        }}