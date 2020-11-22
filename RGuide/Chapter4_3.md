---
layout: page
title: Chapter 4.3 - Evaluate Model Inputs
permalink: /RGuide/Chapter4_3
---

# Chapter 4 - Building a Health State Transition Model in R
### 4.3 - Step 3 - Assign Input Values
-	Step 1: Draft a Model Schematic
-	Step 2: Clinical Validation
-	Step 3: List Model Inputs
-	**Step 4: Evaluate Model Inputs**

As I said in Chapter 4, this is actually an incredibly complicated step. There are numerous sources and types of data that can be used to evaluate a model parameter. We are going to use the simplest form – a point estimate mean, taken from the scientific literature. Also keep in mind that these values are arbitrary – we’re just using them to make the model’s code work.

So let’s fill in this table.

### 1 - Transition Probabilities
Let’s set some arbitrary values for our transition probabilities:
-	P_W_X = 0.30 – we expect 30% of people in state W will move to state X in a given cycle. This estimate has a standard deviation of 5% (these values are also arbitrary)
-	P_X_W = 0.05 – we expect 5% of people in state X will move to state W in a given cycle (standard deviation = 0.5%)
-	P_X_Y = 0.15 – we expect 15% of people in state X will move to state Y in a given cycle (standard deviation = 3%)
-	P_Y_Z = 0.67 – we expect 67% of people in state Y will move to state Z in a given cycle (standard deviation = 7%)

Now that we have our estimates for the transition probabilities and standard deviation, we can derive the values for the returning probabilities. Given that something has to happen to 100% of the person-groups in a state (they either transition or they stay where they are), the value of a returning transition is simply 1 – Σ(ptransition) or, in English, the value of the recurrent transition is 100% minus the sum of all the transition probabilities out of that state. This should make intuitive sense – the percentage of people that stay in a room is 100% minus the percentage that leave. The important thing here is to make sure you have accounted for all possible transitions out of a state.

We don't need to input these values at this point. We are going to write some useful code in a bit that will have R do that calculating for us.

### 3 - Costs
We need to come up with some values for our costs as well:
-	C_W = $300 – spending a cycle in state W generates $300 of cost (standard deviation = $60)
-	C_X = $850 – spending a cycle in state X generates $850 of cost (standard deviation = $200)
-	C_Yt = $1500 – entering state Y generates $1500 of cost, as a one-time cost (standard deviation = $1200)
-	C_Y = $750 – persisting in state Y generates $750 of cost per cycle (standard deviation = $115)
-	C_Zt = $2500 – entering state Z generates $10,000 of cost, as a one-time cost (standard deviation = $2500)

### 4 - Utilities
Finally, some arbitrary values for our health state utilities:
-	U_W = 0.95 (standard deviation = 7%)
-	U_X = 0.85 (standard deviation = 4%)
-	U_Y = 0.60 (standard deviation = 12%)

Let’s take another look at our table now:

| Parameter | Type | Description | Value | Error |
| --------- |-----:| ------------| ----: | ----: |
| P_WtoX    | 1 | transition from state W to state X | 0.30 | 0.05 |
| P_XtoW	| 1	| transition from state X to state W | 0.5 | 0.005 |			
| P_XtoY	| 1 | transition from state X to state Y | 0.15| 0.03 |
| P_XtoY	| 1	| transition from state X to state Y | 0.67 | 0.07 |
| P_Wreturn	| 1 | probability of staying in state W	| | |
| P_Xreturn	| 1	| probability of staying in state X | | |
| P_Yreturn	| 1 | probability of staying in state Y	| | |
| P_W	| 2 | probability of being ‘sorted’ into state W | 0.65 | 0.15 |
| P_X |	2	| probability of being ‘sorted’ into state X | | |
| C_W |	3 | cost of being in state W | 300 | 60 |
| C_X | 3| cost of being in state X	| 850 | 200 |
| C_Ytransition | 3|	cost of transitioning into state Y (a one-time cost) | 1500 | 450 |
| C_Y	|3|	cost of being in state Y		| 750 | 115 |
| C_Ztransition	| 3 | cost of transitioning into state Y (a one-time cost)	| 2500 |  2500|
| U_W |	4 |	utility value experienced by people in state W	| 0.95 | 0.07 |
| U_X |	4 |	utility value experienced by people in state X	| 0.85 | 0.04 |
| U_Y | 4 |	utility value experienced by people in state Y	| 0.6 | 0.12 |

The blank cells are values that are calculated based on another value – returning variables and the (1 – P_W) value for P_X.

It’s important to keep in mind that these are mean values, and we will need to know the standard error around these values in order to build the model. For this example, we’ll add the standard error in the R code, but it’s also possible and worthwhile to include them at this stage. Because it is easier to adjust standard errors automatically in the code, we will append this discussion for now and revisit it in the corresponding chapter.

[Next Chapter >](http://healthyuncertainty.github.io/RGuide/Chapter4_4)

[< Previous Chapter](http://healthyuncertainty.github.io/RGuide/Chapter4_2)

[<< Back to Start](http://healthyuncertainty.github.io/RGuide/Introduction)