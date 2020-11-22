---
layout: page
title: Chapter 4.6 - Apply Costs, Utilities
permalink: /RGuide/Chapter4_6
---

# Chapter 4 - Building a Health State Transition Model in R
### 4.6 - Step 7 - Apply Costs, Utilities
- Step 1: Draft a Model Schematic
- Step 2: Clinical Validation
- Step 3: List Model Inputs
- Step 4: Evaluate Model Inputs
- Step 5: Define Parameters in R
- Step 6: Define Health States in R
- **Step 7: Apply Costs, Utilities**

The penultimate step in this process is to apply our cost and utility estimates to the health states. This process is simple, and can be done with just a few lines of code. 

Again, the sample code provided for this chapter requires you to run the code from previous chapters. Assuming you’ve saved all of the files in the same location on your hard drive, running lines 14-18 should bring you up to speed. For the sake of display, I am once again presenting results with an ‘ncycle’ of 10 and an ‘n’ of 5 (that is, 10 rows, 5 slices).

First, we create some arrays to hold our cost and utility values for each state:
~~~
19	### APPLY COSTS TO HEALTH STATES ###
20	
21	# Create blank arrays for costs
22	cost_HSW <- cost_HSX <- array(0, dim=c(ncycle,1,n))
23	cost_HSY <- cost_HSZ <- array(0, dim=c(ncycle,2,n))
~~~

Note that the dimensions of each cost array (“cost_STATE”) are the same as the health state arrays from the previous chapters. 

The cost of a state is simply defined as the number of person-groups in that state (in a given cycle) multiplied by the costs associated with that state. Utilities work in the same way – multiply the number of people in a state by the utility value for that state. We can accomplish that quite simply:
~~~
25	# Populate arrays
26	for (j in 1:n){
27	for (i in 1:ncycle){
28	cost_HSW[i,,j] <- HS_W[i,,j]*C_W[j]
29	cost_HSX[i,,j] <- HS_X[i,,j]*C_X[j]
30	
31	cost_HSY[i,1,j] <- HS_Y[i,1,j]*(C_Yt[j] + C_Y[j])
32	cost_HSY[i,2,j] <- HS_Y[i,2,j]*C_Y[j]
33	
34	cost_HSZ[i,1,j] <- HS_Z[i,1,j]*C_Zt[j]
35	}
~~~
Our previously-defined costs for each state are multiplied by the number of people in each state. The cost of entering state “HS_Y” is the one-time transition cost plus the cost associated with staying in that state (think of it like an up-front treatment, plus an ordinary ‘maintenance’ cost like a doctor’s appointment). Remaining in that state does not incur the transition cost, however, which is reflected in column 2. Because the cost of remaining in “HS_Z” is zero, we do not need to specify a cost for column 2 (as we have already done that on line 23 by creating an array full of zeroes).

The process for applying the utilities is essentially identical:
~~~
37	### APPLY UTILITIES TO HEALTH STATES ###
38	
39	# Create blank arrays for utilities
40	Q_HSW <- util_HSX <- array(0, dim=c(ncycle,1,n))
41	Q_HSY <- array(0, dim=c(ncycle,2,n))
42	
43	# Populate arrays
44	for (j in 1:n){
45	for (i in 1:ncycle){
46	    Q_HSW[i,,j] <- HS_W[i,,j]*U_W[j]
47	    Q_HSX[i,,j] <- HS_X[i,,j]*U_X[j]
48	    Q_HSY[i,,j] <- HS_Y[i,,j]*U_Y[j]
49	}
~~~

We don’t bother to calculate utilities for “HS_Z”, because Health State Z has a health state utility of zero (i.e., state is equally preferable to death).

Let’s take a look at our output from these steps, for costs:

![alt text][Cost_Output]

[Cost_Output]: https://www.dropbox.com/s/es17yy0dg4vi1fb/4_6%20Cost%20Outputs.jpg?dl=1 "Output of cost arrays"
 
And for QALYs:

![alt text][QALY_Out]

[QALY_Out]: https://www.dropbox.com/s/8rrz2i3alkeenl5/4_6%20QALY%20Outputs.jpg?dl=1 "Output of QALY arrays"
 
It’s really that simple.

I’m not sure what I can say about these outputs that isn’t obvious just by looking at the numbers. I haven’t included an image summarizing the quality of life in ‘HS_Z’, because the utility for that state is assigned a value of zero, and as a result the array will have ‘0’ in all cells.

The model is now built. It has all of the pieces you’ll need to propose and conduct cost-effectiveness analysis. Technically, if you are only interested in learning how to build models, you’ve got all the information you need and you can stop reading now. If you do decide to stick around for the next chapter, I am going to conduct a cost-effectiveness analysis exercise, complete with data analysis and tables/figures suitable for publication. I will show how to use the model we’ve built to perform uncertainty analysis.

[Next Chapter >](http://healthyuncertainty.github.io/RGuide/Chapter5)

[< Previous Chapter](http://healthyuncertainty.github.io/RGuide/Chapter4_5)

[<< Back to Start](http://healthyuncertainty.github.io/RGuide/Introduction)