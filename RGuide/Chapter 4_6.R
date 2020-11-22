#####################################################################################
#                                                                                   #
# TITLE: Building Health State Transition Models in R: Chapter 9                    #
#                                                                                   #
# DESCRIPTION: We apply costs and utilities to our survival model                   #
#                                                                                   #
# AUTHOR: Ian Cromwell                                                              #
#                                                                                   #
# DATE: November, 2014                                                              #
#                                                                                   #
#####################################################################################

### SET WORKING DIRECTORY
  setwd("WHATEVER DIRECTORY YOU'VE SAVED THESE FILES IN")

### LOAD IN VALUES FROM PREVIOUS CHAPTERS
  source("Chapter 4_5.R")

### APPLY COSTS TO HEALTH STATES ###

  # Create blank arrays for costs
  cost_HSW <- cost_HSX <- array(0, dim=c(ncycle,1,n))
  cost_HSY <- cost_HSZ <- array(0, dim=c(ncycle,2,n))

  # Populate arrays
  for (j in 1:n){
    for (i in 1:ncycle){
      cost_HSW[i,,j] <- HS_W[i,,j]*C_W[j]
      cost_HSX[i,,j] <- HS_X[i,,j]*C_X[j]
      
      cost_HSY[i,1,j] <- HS_Y[i,1,j]*(C_Ytransition[j] + C_Y[j])
      cost_HSY[i,2,j] <- HS_Y[i,2,j]*C_Y[j]
      
      cost_HSZ[i,1,j] <- HS_Z[i,1,j]*C_Ztransition[j]
  }}

### APPLY UTILITIES TO HEALTH STATES ###

  # Create blank arrays for utilities
    qol_HSW <- qol_HSX <- array(0, dim=c(ncycle,1,n))
    qol_HSY <- array(0, dim=c(ncycle,2,n))

  # Populate arrays
    for (j in 1:n){
    for (i in 1:ncycle){
      qol_HSW[i,,j] <- HS_W[i,,j]*U_W[j]
      qol_HSX[i,,j] <- HS_X[i,,j]*U_X[j]
      qol_HSY[i,,j] <- HS_Y[i,,j]*U_Y[j]
    }}