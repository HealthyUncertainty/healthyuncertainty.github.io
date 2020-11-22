---
layout: page
title: Chapter 4 - Overview
permalink: /RGuide/Chapter4_1
---

# Chapter 4 - Building a Health State Transition Model in R
### 4.1 - Model Design Overview
Health State Transition Models are built on computers, but they are designed on scrap paper. The true art of model-building is not in the coding, but in the drawing. Personally speaking, I generally feel that once you have the structure of a model figured out, you’ve done all the hard work already. The rest is just brute force.

There is a principle that I live by when it comes to model design: GIGO. GIGO stands for ‘garbage in, garbage out’. In broad terms, this means that if the structure of your model doesn’t do a good job of approximating reality, no amount of data quality or fancy coding will help you. Just as you can’t get valid answers from a poorly-designed study, you can’t get valid answers from a poorly-designed model.

There is, of course, an inherent tension between a model’s quality and its limitations. No model can completely re-create reality, so there will always be some level of ‘wrongness’ that comes along with modeling. Researchers must walk the delicate line between practicability and applicability, and there is no guide, no ‘silver bullet’, no foolproof method to design models ‘properly’. It is a matter of using examples found elsewhere in the literature, clinical expertise, and research experience. Model building, like any research design, is an inexact process.

There are many approaches to model design, and I would not dream of claiming that mine is the best. What I will do, however, is describe the basic steps I’d take if someone approached me to build them a model. 

### *Step 1: Draft a Model Schematic*

The first step is to draft a model ‘schematic’, which is an image that describes (in rough terms) the process that is being modeled. The best place to start this process is by searching the literature and finding models that others have built of the same process. Models can always be improved upon, but there is usually little point in trying to start completely from scratch in model design. There’s a pretty good chance that someone else has tried to answer a similar question to yours, and you can learn from them.

There are two features of a Health State Transition model. The first feature is the health state. As described earlier, these are states of being that people occupy over time. Health states can be as simple or as varied as the research question requires, but people must occupy these health states for a period of time. A specific event, such as a relapse or a treatment, does not qualify as a health state unless people experience that relapse or treatment over a long period of time – this depends on the cycle length of the model, which will be explained later in this section.

The second feature of the Health State Transition model is the transition probabilities. Put simply, transition probabilities are estimates of the chance that someone will move between different health states. This could be the chance that a healthy person gets sick, that a sick person gets better, or that someone dies of illness. Health state transitions are probabilities between 0.0 and 1.0 (0 – 100%). The transition probabilities around a given health state (including the probability of remaining in the same state) must sum to 100%.

A common way of depicting Health State Transition models is through the use of “bubble and arrow” diagrams. These simple illustrations show the health states in the model and the possible transitions between the states. In my own “bubble and arrow” diagrams, I use the following notation:

- **A -	Bubble**: a health state
- **B - Bubble with double-line border**: a ‘terminal’ or ‘absorbing’ health state. These are states where, once a person enters that state, they do not leave. Death is the most common terminal state in survival models.
- **C -	Curved arrow**: a transition that occurs from one cycle to the next (what I will call a “time-sensitive” transition). This could be between different health states, or a ‘returning’ transition into the same state.
- **D - Straight/bent arrow**: a probability of something happening that does not happen over time. Examples include the probability of being sorted into a group, having a successful treatment, or any other probability that, for the purpose of the model, does not happen from one cycle to the next.
- **E -	Box**: an event that occurs in the course of the model that does not occupy time. These are simply for descriptive purposes and are not a functional part of the model.

You can see an illustration of a simple model below:

![A schematic of a decision model][modelschematic]

[modelschematic]: https://www.dropbox.com/s/fsul5q9264lf2cr/4_1%20Model%20Schematic.jpg?dl=1
 
People in this model are sorted into one of two health states – W or X, according to some underlying probability (which I have called ‘PtoW’ and ‘PtoX’). This sorting process happens instantaneously (i.e., within a single cycle). From there, people can move between states according to the transition probabilities (for example, ‘P_WtoX’ is the probability of moving from ‘Health State W’ to ‘Health State X’ in a given cycle), or they can remain in the same state until the next cycle. ‘Health State Z’ is a terminal state, meaning that the probability of transitioning into another state is 0.

Now that we have drafted a model schematic, we can move on to the next step.

### *Step 2: Clinical Validation*
Unless you are a health economist with a medical degree, and/or you have extensive experience with the health process you are modeling, you’ll likely need to have your schematic scrutinized by a clinical expert. The point you are trying to reach is a balance between the model’s simplicity and the real world’s complexity. While it may not be possible to model every possible outcome a person with the condition of interest may face, your model should describe a representative variety of experiences, and you should describe where and how you’ve made trade-offs whenever you can. 

There’s nothing other than expertise and research acumen that can help you through this process, so I’m not going to try and produce a ‘how-to’ guide for clinical validation. It’s probably impossible, and even if it isn’t I’m really not the one you want guidance from. I will say, though, that this is the part of the process that requires true scientific knowledge – weighing up different strengths/weaknesses, assessing evidence, searching the literature and learning – as far as I’m concerned this is the hard part of modeling. The rest is just code.

### *Step 3: List Model Parameters*
Once you’ve arrived at a model schematic that satisfies you and your clinical team, the next step is to make a list of every value you’re going to need to actually make the model ‘go’. I will refer to these values as ‘parameters’ from here on out. Model parameters can be thought of as variables in an equation – values that are used in calculating the final answer. Health state transition model inputs fall into four broad categories:

1.	**Transition Probabilities**
These, as the name would suggest, are where health state transition models derive their names. Put simply, a transition probability is the chance that a person in one health state will move to another health state in a given cycle of the model. The defining feature of a transition probability is that it is something that happens over time, rather than at once.

2.	**Static Probabilities**
These are our ‘sorting’ values (the straight/bent arrows). They represent the proportion of things that can happen at a fixed point. Examples include: sensitivity/specificity of a test, percentage of people in a risk group, basically any proportion that doesn’t rely on time. 

3.	**Costs**
Cost parameters are both time-dependent and time-independent (i.e., they can be applied to either transition or static probabilities). That is because sometimes there is a cost associated with a sort (e.g., the cost of a screening test or a medical appointment), and other times the cost is associated with a health state (e.g., the cost of treating active disease, the cost of end-of-life care).

4.	**Utilities**
Utilities are a score between 1.0 and 0.0 that represents a person’s preference for being in a health state. They can be *very roughly* thought of as a “percentage” of full health , and are useful for calculating QALYs. Accordingly, they are applied to health states rather than static probabilities.

You should be able to list and describe each of the parameters of your model. Later, I’ll show you the way I do this.

### *Step 4: Evaluate Model Inputs*
This step probably doesn’t need to be spelled out, but once you’ve listed the various inputs, you need to find their values. This certainly falls into the category of ‘Easier Said Than Done’. There are a huge variety of methods of doing this from different sources of data. These are far beyond the scope of this guide, so I will be using instead the most simplistic version – point estimate means. There are lots of different ways to read in data, but for the purposes of this guide we’ll stick with the basics.

### *Step 5: Define Inputs and Parameters in R*
We’re going to spend quite a bit of time doing this later in this chapter. We will need to take our inputs and convert them to probabilistic model parameters, using similar processes to the ones we explored in Chapter 3.

### *Step 6: Define Health States in R*
We’re going to use R to create arrays that describe each health state, using processes we discussed in Chapter 3.
 
### *Step 7: Describe Starting Populations*
We’ll have to set up the model to show where the person-groups start at time ‘t0’.

### *Step 8: Describe Health State Transitions*
Next, we tell R how our person-groups move between cycles from ‘t1’ until the end of the model run.

### *Step 9: Apply Costs, Utilities*
Once we have our fully-populated health states from ‘t1’ to the end of the run, we apply costs and utility values to the number of person-groups in each health state.

### *Step 10: Discounting*
Discounting is a procedure done in health economic analysis to account for time preferences. Basically, it quantifies the assumption that we inherently place more value on things we have right now than we do on things we expect to get in the future [^1]. Please note that this is not the same thing as accounting for inflation – this is a common misunderstanding.

[^1]: Would you rather have $100 right now or $100 in a week? Presumably most people would rather have money right now. But how much more money would you be willing to wait a week for? What if I offered you $100 now or $200 in a week? $150? $101? At some point you’re going to say that the additional money in the future isn’t worth the time you have to wait for it. It is this shifting preference for future costs and benefits that we try to reflect in the discounting parameter.

### *Step 11: Tabulate Outcomes*

Now the exciting part: what is the incremental cost and effectiveness between the arms of your model? What do the ICERs look like?

### *Step 12: Extensions*
How else can we use the data generated by our model? How do we assess the effect of uncertainty around our parameters? We can do this in R quite readily.

For the purpose of this guide, we are going to start at the end of Step 2, using the three-state model schematic provided earlier in this chapter. The structure and parameter values (or ‘estimates’) are entirely arbitrary for this model – I’m just making them up off the top of my head as an illustration of the techniques.


[Next Chapter >](http://healthyuncertainty.github.io/RGuide/Chapter4_2)

[< Previous Chapter](http://healthyuncertainty.github.io/RGuide/Chapter3)

[<< Back to Start](http://healthyuncertainty.github.io/RGuide/Introduction)
