---
layout: page
title: Chapter 4.2 - List Model Inputs
permalink: /RGuide/Chapter4_2
---

# Chapter 4 - Building a Health State Transition Model in R
### 4.2 - Step 3 - List Model Inputs
- Step 1: Draft a Model Schematic
- Step 2: Clinical Validation
- **Step 3: List Model Inputs**

Now that we have the structure of our model decided, the next step is to make a list of the different inputs we’ll need to evaluate. I usually do this in an Excel spreadsheet. Here’s a reminder of what our model is going to look like:
 
Let’s work our way through the four types of inputs we’ll need to identify.

### 1 -	Transition Probabilities
There are four possible health state transitions in our model:
-	P_WtoX: the transition from state W to state X
-	P_XtoW: the transition from state X to state W
-	P_XtoY: the transition from state X to state Y
-	P_YtoZ: the transition from state Y to state Z

Note that it is not possible in the model to move from State W to State Y, and only people in State Y can transition to State Z.

There are, incidentally, three ‘hidden’ transition probabilities – the probability of not moving from a state in a given cycle. I refer to these, for the sake of clarity, as ‘returning’ probabilities:

-	P_Wreturn: the probability of staying in state W
-	P_Xreturn: the probability of staying in state X
-	P_Yreturn: the probability of staying in state Y [^1]

[^1]: We can think of state Z having a returning transition probability of 100% (i.e., everyone in state Z at cycle ‘Cn’ is present at cycle ‘Cn+1’, but we won’t need to program it that way.

### 2 -	Static Probabilities
There are two static probabilities in this model, and they are closely related to each other:
-	P_W: the probability of being ‘sorted’ into state W
-	P_X: the probability of being ‘sorted’ into state X

Note that, because a person-group in this model has to be triaged to either W or X, it follows mathematically that: P_W + P_X = 1 (or, conversely, P_X = 1 – P_W and vice versa).

### 3 -	Costs
For illustrative purposes, I am going to add a ‘wrinkle’ to our arbitrary model. Let’s say that people in Health State W and Health State X have a constant cost in every cycle of the model. That is to say, there is no additional cost associated with the transition into either one of those states. For State Y, however, there is an up-front cost when you start in that state (let’s say there’s a special treatment you get when you are ‘diagnosed’ with Y, given at one time at one up-front cost) – after the first cycle in Y, there is a separate cost (let’s say that people have to have regular follow-up appointments after the initial treatment).

A second ‘wrinkle’ I will add (one that is a feature of terminal states that represent death) is that there is a one-time cost associated with the transition to state Z, but after that point person-groups do not generate any costs. We will see that, programmatically, these two situations are handled in pretty much exactly the same way.
 
So let’s look at the list of our costs:
-	C_W: the cost of being in state W
-	C_X: the cost of being in state X
-	C_Ytransition: the cost of transitioning into state Y (a one-time cost)
-	C_Y: the cost of being in state Y (follow-up cost)
-	C_Ztransition: the cost of transitioning into state Z (a one-time cost)

*A note on costs*
For the purpose of this illustration, the model assumes that all cost inputs are single values, rather than the sum of several different costs. In reality, it is more likely that the cost of being in a health state is made up of a bunch of different costs – for example, the cost of a test plus the cost of an appointment, plus the cost of a drug, maybe plus societal/other costs – the process for dealing with costs as such an aggregate is just the application of a simple bit of arithmetic. For the purposes of this guide, it will be sufficient to view costs as single values.

### 4 -	Utilities
There are three health states [^2], each with its own utility value [^3] :
-	U_W: the utility value experienced by people in state W
-	U_X: the utility value experienced by people in state X
-	U_Y: the utility value experienced by people in state Y

[^2]: As above, we could very well consider people in Health State Z to have a utility value of 0.0 (if we assume that state Z is ‘death’). Otherwise there are four health states, and we’d have to include a ‘U_Z’. For the purpose of the illustration, we’ll assume that Z is a ‘death’ state, and that person-groups in that state have a utility value of 0.0. Since we're making our health state with arrays that start with a zero value already, we don't need to specify that.

[^3]: It’s also possible that a health state starts with one utility value and changes – either over time, or just once (let’s say, for example, that people who are newly-arrived in a state have a high level of pain/anxiety, but that goes away after a year). The way we handle that is the same way we handle the ‘wrinkle’ in costs, so for the sake of simplicity, we will arbitrarily decide that health utilities are constant in this model.

Now that we’ve identified all of the model parameters, let’s plunk them into a table: 

| Parameter | Type | Description | Value | Error |
| --------- |-----:| ------------| ----- | ----- |
| P_WtoX    | 1 | transition from state W to state X | | |
| P_XtoW	| 1	| transition from state X to state W | | |			
| P_XtoY	| 1 | transition from state X to state Y | | |
| P_YtoZ	| 1	| transition from state Y to state Z | | |
| P_Wreturn	| 1 | probability of staying in state W	| | |
| P_Xreturn	| 1	| probability of staying in state X | | |
| P_Yreturn	| 1 | probability of staying in state Y	| | |
| P_W	| 2 | probability of being ‘sorted’ into state W | | |
| P_X |	2	| probability of being ‘sorted’ into state X | | |
| C_W |	3 | cost of being in state W | | |
| C_X | 3| cost of being in state X	| | |
| C_Ytransition | 3|	cost of transitioning into state Y (a one-time cost) | | |
| C_Y	|3|	cost of being in state Y		| | |
| C_Ztransition	| 3 | cost of transitioning into state Y (a one-time cost)	| | |
| U_W |	4 |	utility value experienced by people in state W	| | |
| U_X |	4 |	utility value experienced by people in state X	| | |
| U_Y | 4 |	utility value experienced by people in state Y	| | |

Next, we're going to assign some mean and standard deviation values to each of our variables. We’re going to come back to variable “types” in later chapters, but for now they serve an illustrative purpose.

[Next Chapter >](http://healthyuncertainty.github.io/RGuide/Chapter4_3)

[< Previous Chapter](http://healthyuncertainty.github.io/RGuide/Chapter4_1)

[<< Back to Start](http://healthyuncertainty.github.io/RGuide/Introduction)