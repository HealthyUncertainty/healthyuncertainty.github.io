---
layout: page
title: Chapter 4.5 - Define Health States in R
permalink: /RGuide/Chapter4_5
---

# Chapter 4 - Building a Health State Transition Model in R
### 4.5 - Step 6 - Define Health States in R
- Step 1: Draft a Model Schematic
- 	Step 2: Clinical Validation
-	Step 3: List Model Inputs
-	Step 4: Evaluate Model Inputs
-	Step 5: Define Parameters in R
-	**Step 6: Define Health States in R**

As described in earlier chapters, the health state transition process rests primarily on the use of three-dimensional arrays. R’s array functions allow us to ‘move’ person-groups through the cells of the array according to patterns that we define, and keep a record of each move. As the name would suggest, three-dimensional arrays have three principal components:

-	Rows: each row in an array represents one cycle of the model (one push of the ‘=’ button in our formula). When programming loops, I use the variable ‘i’ to denote an action that happens according to row.

- Columns: each column represents a sub-component of a health state. This sub-component might represent a group with differential costs or transition probabilities within the same health state. For example, we might use different columns to hold people who got Treatment A vs. Treatment B but who nevertheless are in Health State X, if Treatment A has a different set of costs from Treatment B, or if the risk of transition to another state is different for Treatment A than it is for B.

-	Slices: each slice is a probabilistic iteration of the model. In plain language, that means that each slice has a given set of randomly-drawn values for PSA (see chapter 7). That means that each slice tells one story of what the results of the model could be, given the uncertainty in each parameter. I use ‘j’ to denote actions that happen along slices. In fact, there are a number of examples of loops using ‘j’ in the previous chapter.

I prefer to use to use several arrays – one for each health state, with columns describing subgroups within that state. There is a reasonable argument to be made that this is unnecessary. You could, in theory, program a model in a single large array where each column represents one health state/subgroup. Such an approach would be no less accurate or flexible than an approach that uses several arrays. In fact, such a programming approach might run a lot faster because of how R processes array and matrix multiplication. 

However, because of the amount of debugging and editing involved in successfully programming a model, I think there is a real value in working with multiple arrays. I think it’s a lot cleaner, simpler, and conceptually easier to have each array correspond to a health state, especially if you’re making a very complicated model with lots of tunnel states. It’s entirely up to you though.

The first step of this process is to create a set of arrays to represent the health states in our model. Before we create the health states, we’ll need to load the transition probabilities that we defined in the previous chapter. If you still have R open from when you ran the code from chapter 7, those values will already be loaded in the R environment (check the top right quadrant of the RStudio screen, or simply enter one of the names of the parameters in the console to see if they’re still there. If you haven’t been working through this guidebook in a single session, you can load the entire Chapter 7 program  with a single command line:

~~~
13	### SET WORKING DIRECTORY
14	setwd("WHATEVER DIRECTORY YOU SAVED THESE FILES IN")
15	
16	### LOAD IN TRANSITION PROBABILITIES FROM PREVIOUS CHAPTER
17	source("Chapter 4_4.R")
~~~

Once these values are loaded, we can start creating our health states. As we’ve seen before, creating arrays is pretty simple:
~~~
19	### CREATE HEALTH STATES ###
20	# Define blank arrays
21	
22	# Health states W and X have a single column
23	HS_W <- HS_X <- array(0, dim=c(ncycle,1,n))
24	# Health states Y and Z have two columns for costing differences
25	HS_Y <- HS_Z <- array(0, dim=c(ncycle,2,n))
~~~

In this step, we create blank arrays with either 1 or 2 subgroups to describe our health states. Health State W (‘HS_W’) and Health State X (‘HS_X’) both have a single column. ‘HS_Y’ and ‘HS_Z’ have two columns. Why?

In order to answer that question we have to return to an earlier discussion we had in the introduction.

### The Markov ‘memoryless’ assumption

Health State Transition models built using arrays in R do not ‘remember’ what states a person has been in before their current state. Everyone who is in Health State X is treated as though they have identical costs and transition probabilities, regardless of if they started there and have stayed from the previous cycle, or if they just arrived from Health State W. If you’re in X during a given cycle, the model does not know or care where you were in the previous cycle.

For some processes, that assumption is perfectly reasonable. In our model, people in ‘HS_X’ have an identical set of costs and probabilities. But if we look at how we’ve defined the costs for ‘HS_Y’, we have said that there is a ‘transition’ cost for Health State Y (that we’ve called ‘C_Yt’). That implies that people who are entering ‘HS_Y’ from ‘HS_X’ are different in an important way from people who are returning to ‘HS_Y’ from the previous cycle. This is also true for ‘HS_Z’.

In a truly ‘memoryless’ model, we would not be able to differentiate these people. By creating a two-column array, however, we can bend the ‘memoryless’ rules a bit. The model still doesn’t remember, but it can and does differentiate between new arrivals and returning person-groups. This allows us to apply the appropriate cost to each subgroup within the health state, without the model needing to remember where people have come from.

There are reasons besides costs to create subgroups – sometimes it’s just easier for visual inspection, sometimes there are quality-of-life or transition probability differences among subgroups of a health state. There is no limit to the number of arrays and columns we could have – it simply becomes a question of practicality: how many columns can you keep track of?

### With that explained... 
We can now populate the starting values for each array. Recall that we are modeling a process in which person-groups are sorted into either ‘HS_W’ or ‘HS_X’. This tells us where we expect people to start. Because there are ‘n’ starting value s(one for each person-group), we will have to tell R to define each starting value using a loop:

~~~
27	# Define starting population in each state
28	for (j in 1:n){
29	  HS_W[1,1,j] <- npop*P_W[j]
30	  HS_X[1,1,j] <- npop*P_X[j]}
~~~

The number of person-groups in ‘HS_W’ at the beginning of the model (cycle 1, time 0) is the total number of person-groups in the population (‘npop’) multiplied by the proportion of that population that will be ‘sorted’ into Health State W (‘P_W’).
Here’s the result (using an ‘ncycle’ of 3 and an ‘n’ of 5 – 3 rows, 5 slices):
~~~
> HS_W
, , 1

         [,1]
[1,] 593.1927
[2,]   0.0000
[3,]   0.0000

, , 2

         [,1]
[1,] 563.8631
[2,]   0.0000
[3,]   0.0000

, , 3

         [,1]
[1,] 709.0672
[2,]   0.0000
[3,]   0.0000

, , 4

         [,1]
[1,] 527.3671
[2,]   0.0000
[3,]   0.0000

, , 5

         [,1]
[1,] 437.3485
[2,]   0.0000
[3,]   0.0000
~~~

As you can see, the values are slightly different in the first row/column of each slice, reflecting the fact that ‘P_W’ is drawn from a probabilistic distribution rather than being a fixed value. You can verify the values in ‘HS_X’ for yourself if you like.

You may have noticed that we haven’t defined starting values for ‘HS_Y’ and ‘HS_Z’. Because our simulated cohort members cannot start in those states, their starting values are zero. When we created the blank arrays, we specified a value of ‘0’ for all cells in those arrays, so they already have the appropriate number of people. If you wanted to, you could think of the starting values of ‘HS_Y’ and ‘HS_Z’ as being “npop*PR_Y” and “npop*PR_Z” respectively, but with both ‘PR_Y’ and ‘PR_Z’ having values of zero.

Now we have the task of telling R what to do with these people in the subsequent cycles. In order to do that, I want to take a minute and explain two concepts. The first is a function of our looping code, and the second is a piece of syntax we’re going to be using regularly during this process.

### Using ‘nested’ loops
R will allow you to build a loop within another loop, allowing you to conduct processes on multiple ascending values at the same time. There is no real difference, besides the obvious changes to the code, between nested and non-nested loops. It’s just that one loop statement includes another. Not terrifically complicated.
##### Understanding “i-1”
‘i’ represents a cycle of the model, which is interchangeable with the row of an array. When we want to specify something that happens in the third cycle, we refer to it as ‘i=3’. If we are talking about something in the nth cycle, we refer to it as ‘i=n’.

If ‘i’ refers to a given cycle, then ‘i-1’ refers to the previous cycle. Since the values in cycle 3 are dependent on the values from cycle 2, when i=3, i-1=2.

Because we may have several cycles where the model’s values in a given cycle are based on the values in the previous cycle, we can save a lot of time and energy by building a loop that allows ‘i’ to be evaluated as an ascending integer value, based on the value of the previous cycle, ‘i-1’.

Now we tell R how to evaluate each cycle – that is, where do the numbers in each cycle come from? Where are person-groups going between cycles? How many of them are going there? That’s what we have to specify in the code.
~~~
32	### DESCRIBE TRANSITIONS BETWEEN HEALTH STATES
33	  for (j in 1:n){
34	  for (i in 2:ncycle){
35	  # State W
36	    HS_W[i,,j] <- HS_W[(i-1),,j]*P_Wreturn[j] + HS_X[(i-1),,j]*P_XtoW[j]
~~~
Let’s break down what’s happening in this line of code :
-	**for (j in 1:n){** - Perform the following actions for all values of ‘j’ as an ascending integer between 1 and “n”. Each value of ‘j’ represents a different slice.

-	**for (i in 2:ncycle){** - Perform the following actions for all values of ‘i’ as an ascending integer between 2 and “ncycle”. Each value of ‘i’ represents a model cycle. Recall that we have already defined what happens in the first cycle, which is why we start in cycle 2.

-	**HS_W[i,,j]** - We are defining the number of person-groups in ‘HS_W’ in a given cycle ‘i’ for each value of ‘j’. Because ‘HS_W’ only has one column, we do not need to specify a column subscript, but we could if we wanted to.

-	HS_W[(i-1),,j]*P_Wreturn[j] - Some person-groups stay in ‘HS_W’ from one cycle to the next. The number of person-groups in ‘HS_W’ in the cycle before cycle ‘i’ is ‘HS_W[(i-1),,j]’. We have defined the proportion of person-groups that stay as ‘P_Wreturn’, the returning transition probability for state W (which is equal to 100% minus the proportion of people who transition to State X).

- HS_X[(i-1),,j]*P_XtoW[(i-1),,j] - Some person-groups transition to Health State W from Health State X. The number of person-groups who could make this transition is the number of people in ‘HS_X’ during the previous cycle – ‘HS_X[(i-1),,j]’. The proportion of those person-groups that make this transition is defined in the code as ‘P_XtoW’

So, the number of people in HS_W in state ‘i’ is the sum of those who stay in that state from a previous cycle, plus the number of people who arrive from another state.

Let’s look at Health State X now:
~~~
38	# State X
39	HS_X[i,,j] <- HS_X[(i-1),,j]*P_Xreturn[j] + HS_W[(i-1),,j]*P_WtoX[j]
~~~
It’s pretty much the same as the previous lines – the number of person-groups in ‘HS_X’ is equal to the sum of those who stay in Health State X from the previous cycle, plus the number who have transitioned from Health State W.

Health State Y is, as you might expect, a little trickier:
~~~
39	# State Y
40	HS_Y[i,1,j] <- HS_X[(i-1),,j]*P_XtoY[(i-1),,j]
41	HS_Y[i,2,j] <- sum(HS_Y[(i-1),,j])*P_Yreturn[(i-1),,j]
~~~

Let’s break this one down in the same way:
- **HS_Y[i,1,j]**: we are defining the number of person-groups in the first column of row ‘i’ of ‘HS_Y’ for each slice. This is simply defined as the number of person-groups who have transitioned into Health State Y from the previous cycle of Health State X, according to the transition probability (like in the previous steps).

- **HS_Y[i,2,j]**: we are defining the number of person-groups in the second column of row ‘i’ of ‘HS_Y’ for each slice. The number of person-groups who could remain in Health State Y is the sum of person-groups in the first column and the second column of ‘HS_Y’. In plainer language, people who have just transitioned into Health State Y during the previous cycle and people who have spent more than one cycle in this state.  There are only two columns in our array, so if we wanted to we could say that “HS_Y[i,2,j]” is the sum of “HS_Y[(i-1),1,j]” plus “HS[(i-1),2,j]”. Using the *sum* function in R does that in fewer characters.

It’s important, perhaps, to note that if we wanted to select only some columns from an array (but not all of them), we’d have to take some steps to specify which columns we want. I’m not going to do that here, but I do want to make it clear that there are circumstances where using sum(ArrayName) isn’t the right approach. 

The proportion of person-groups who stay in ‘HS_Y’ from cycle to cycle is defined as “P_Yreturn” – the returning probability for Y.

And finally, we describe the Z health state:
~~~
43	# State Z
44	HS_Z[i,1,j] <- sum(HS_Y[(i-1),,j])*P_YtoZ[j]
45	HS_Z[i,2,j] <- sum(HS_Z[(i-1),,j])
~~~

- We define the first column as the total number of person-groups in Health State Y in the previous cycle who transition into Health State Z, multiplied by the proportion who make this transition.
- We define the second column as the sum of those in column 1 and column 2 of Health State Z. Because there is no way to transition out of Health State Z (i.e., it’s a terminal state), person-groups simply accumulate in the second column.

Let’s look at the result when we run the code. Because it will take more than 3 cycles for a few things to become visible, I am going to re-run the code from Chapter 7 and Chapter 8 with an ‘ncycle’ of 10. I’ll show the output from the first slice (j = 1), so you can see what it looks like. The other slices will look very similar, the only difference being that the numbers will be slightly different.

![alt text][HealthState_Out]

[HealthState_Out]: https://www.dropbox.com/s/b06gl2e2wqth0wu/4_4%20LYG%20States.jpg?dl=1 "Output of Health States"
 
As we can see from the output above, person-groups start in either ‘HS_W’ or ‘HS_X’ and move between states according to the transitions we described in the code. The first person-groups don’t enter ‘HS_Y’ until the second cycle, because the only way to arrive in that health state is to go through ‘HS_X’. The second column of ‘HS_Y’ is empty until cycle 3, since you have to have gone through ‘HS_X’ and the first column of ‘HS_Y’. This pattern is similar for HS_Z, but with an additional cycle’s “delay”.

At the end of the model run of 10 cycles, person-groups are concentrated primarily in the terminal state ‘HS-Z’, but a fair number (~30%) are in ‘HS_X’. The remainder is divided almost evenly between the other two states. If you were to whip out your calculator, you’d see that the sum of each row is 1000 across the 4 health states. This is how we know we’ve satisfied the requirement that the total number of person-groups in the model remain constant. If we had made a mistake in describing our transitions, we would see either an increase or a decrease in the number of person-groups in the model. It should always be equal to ‘npop’ within a given slice.

If you run the code with all the default values intact, you may notice that it takes a few seconds to complete all the calculations. Remember that we are asking R to perform hundreds of thousands of calculations, and while computers are fast they aren’t instantaneous. 

Let’s relate this output back to the structure of our model:

![alt text][Model_Out]

[Model_Out]: https://www.dropbox.com/s/oujlb1f30u3fcv4/4_5%20Model%20with%20outputs.jpg?dl=1 "Model Structure with Outputs"
 
What we have done is take our model schematic, represent the health states as three-dimensional arrays, calculate estimates of the transitions between each state, and let that process repeat for 10 cycles, for ‘n’ iterations of that process.

Having done that, we are very close to being finished. All that remains to do is apply our cost and utility estimates, which we will cover in the next section.

[Next Chapter](healthyuncertainty.github.io/RGuide/Chapter4_6)
[Previous Chapter](healthyuncertainty.github.io/RGuide/Chapter4_4)
[Back to Start](healthyuncertainty.github.io/RGuide/Welcome)