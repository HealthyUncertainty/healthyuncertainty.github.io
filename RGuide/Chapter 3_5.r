#####################################################################################
#                                                                                   #
# TITLE: Building Health State Transition Models in R: Chapter 3.5                  #
#                                                                                   #
# DESCRIPTION: Here we use the 'for' function in arrays                             #
#                                                                                   #
# AUTHOR: Ian Cromwell                                                              #
#                                                                                   #
# DATE: September, 2014                                                             #
#                                                                                   #
#####################################################################################

test <- array(0, dim=c(10,1,1))

start <- 1
finish <- 10

for (x in start:finish)
  {
  test[x,,] <- x^2
  }

test2 <- array(0, dim=c(10,1,1))
start2 <- 3
finish2 <- 7
for (x in start2:finish2)
{
  test2[x,,] <- x^2
}

test3 <- array(0, dim=c(10,1,1))
start3 <- 4
finish3 <- 9
for (x in start3:finish3)
{
  test3[x,,] <- 1 + test3[(x-1),,]^2
}