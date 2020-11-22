#####################################################################################
#                                                                                   #
# TITLE: Building Health State Transition Models in R: Chapter 3.3                  #
#                                                                                   #
# DESCRIPTION: In this section, we explore making 2D and 3D arrays in R             #
#                                                                                   #
# AUTHOR: Ian Cromwell                                                              #
#                                                                                   #
# DATE: August, 2014                                                                #
#                                                                                   #
#####################################################################################

test2d <- array(0,dim=c(3,3), dimnames=list(
          c("X1","X2","X3"),
          c("Y1","Y2","Y3")   ))
test2d

test3d <- array(0,dim=c(3,3,3), dimnames=list(
          c("X1","X2","X3"),
          c("Y1","Y2","Y3"),
          c("Z1","Z2","Z3")   ))
test3d

test3d[1,,]

test3d[1,,] <- sample(1:100, 9, replace=T)
test3d[2,,] <- sample(1000:10000, 9, replace=T)
test3d[3,,] <- sample(10001:1000000, 9, replace=T)

test3d[,1,] <- sample(1:100, 9, replace=T)
test3d[,2,] <- sample(1000:10000, 9, replace=T)
test3d[,3,] <- sample(10001:1000000, 9, replace=T)

test3d[,,] <- sample(1:100, 27, replace=T)

test3d[2,3,] <- 999

colSums(test3d)
colSums(test3d[1,,])
colSums(test3d[2,,])
rowSums(test3d)
rowSums(test3d[1,,])