#####################################################################################
#                                                                                   #
# TITLE: Building Health State Transition Models in R: Chapter 3.4                  #
#                                                                                   #
# DESCRIPTION: Here we draw random numbers from statistical distributions           #
#                                                                                   #
# AUTHOR: Ian Cromwell                                                              #
#                                                                                   #
# DATE: August, 2014                                                                #
#                                                                                   #
#####################################################################################

test <- rnorm(10,25,5)
hist(test)

test2 <- rnorm(1000,25,5)
summary(test2)
quantile(test2, c(0.05, 0.25, 0.5, 0.75, 0.95))

beta1 <- rbeta(1000, 1, 1)
beta2 <- rbeta(1000, 1, 10)
beta3 <- rbeta(1000, 10, 1)
beta4 <- rbeta(1000, 10, 10)
beta5 <- rbeta(1000, 2, 10)

betaoutput <- c("beta1", "mean =", round(mean(beta1),3), "95% quantiles =", round(quantile(beta1, c(0.5, 0.05, 0.95)),3),
                "beta2", "mean =", round(mean(beta2),3), "95% quantiles =", round(quantile(beta2, c(0.5, 0.05, 0.95)),3),
                "beta3", "mean =", round(mean(beta3),3), "95% quantiles =", round(quantile(beta3, c(0.5, 0.05, 0.95)),3),
                "beta4", "mean =", round(mean(beta4),3), "95% quantiles =", round(quantile(beta4, c(0.5, 0.05, 0.95)),3),
                "beta5", "mean =", round(mean(beta5),3), "95% quantiles =", round(quantile(beta5, c(0.5, 0.05, 0.95)),3))