---
layout: "page"
title: "1_1_why_build_models"
permalink: /RGuide/Chapter1
---

# Chapter 1

### 1.1 – Why Build Models?

The ‘gold standard’ for health care research is the Randomized Controlled Trial (RCT). People are randomly assigned to two or more groups: a group that receives the ordinary standard of care (or a placebo in some trials), and one or more groups that receive some experimental intervention. The difference between the groups, in terms of a health outcome of interest, is referred to as the efficacy of the intervention. By randomly assigning people to the groups, experimenters hope to eliminate the influence of factors other than the intervention – random assignment means that the groups should be similar in terms of average age, sex, and other factors that may influence their outcomes.

There are many health questions that cannot be answered through RCTs. In some cases, the sheer complexity and expense of conducting a trial is simply insurmountable. In others, the amount of time required to observe the outcome of interest is prohibitively long. In still others, there are reasons why random assignment is unethical – is it really appropriate to give placebo treatment (or no treatment at all!) to cancer patients just to see how well the experimental treatment works? Sometimes yes, sometimes no.

For these reasons and more, health economists rely on the use of health state transition models to answer questions about the difference in outcomes and costs between different alternatives – programs, treatments, technologies, and more. Models can, with careful design, simulate a process without the need for lengthy and expensive RCTs. Importantly, models also allow health economists to ask a potentially unlimited number of “what if?” questions that would be impossibly complicated to ask and answer in an observational trial.

Models have important drawbacks as well. First, reality is always more complicated than a model can take into account. Models will always have to make assumptions – demanding that reality conform to the ‘shape’ of the model itself. Second, models are limited by the availability of observational evidence – in order to know the relationship between different health states, we have to have some idea of what that relationship looks like in the real world. Third, and perhaps most importantly, models can’t give you any information you don’t ask them for. The best-designed model in the world can’t tell you about things you didn’t program it to do.

Models should be seen as a helpful and useful tool that can help expedite and guide the research process, but they can never be a substitute for carefully-conducted experiments, including RCTs.

### 1.2 – Health State Transition Models
A very common type of model used in health economics is the *health state transition model* [^1]. These models describe the passage of hypothetical cohorts of people through a series of ‘health states’ – states of being (such as ‘alive’, ‘sick’, and ‘dead’) that are experienced by people in a given population. This could be a population of people with a disease, people with a certain exposure, or people receiving a new type of drug.

Health State Transition models have two very important features. First, they are time-sensitive, meaning that they consider the passage of time. Unlike ordinary decision trees, Health State Transition models recognize that events occur over time rather than simultaneously. Second, and as a result of the first point, Health State Transition models allow users to observe differences in survival – a crucial part of calculating common health economic outcome measures like Life Years Gained (LYG) or Quality-Adjusted Life Years (QALY).

A Health State Transition model is, at its core, a very complicated mathematical equation that is evaluated several times. Think of it as hitting the ‘=’ button repeatedly on a calculator after you add or multiple some set of numbers. The value calculated after each push of the button depends on the value that was there before. Let’s illustrate by taking a trivial expression:

> Y = X/2 + 5

Where X is the value currently displayed on the calculator.

So, when X = 0 (i.e., the calculator started from the default value of zero): 
> Y = (0/2) + 5 = 5.

Now, evaluate the expression again. The value displayed on the calculator screen is 5, based on the first evaluation. Therefore: 
> Y = (5/2) + 5 = 7.5.

Evaluate the expression again and you get Y = (7.5/2) + 5 = 8.75. Hit the ‘=’ again, and you get 9.375, and so on.

Health State Transition models are, at their core, just a much more complicated version of this same process. Every push of the ‘=’ button is called a cycle. Cycles represent, in survival models, the passage of a fixed interval of time. This fixed interval is often a year, but it could be anything from a second to a century, depending on the process you are modeling. The amount of time in the interval is called the ‘cycle length’.

Cycle length should not be confused with the ‘time horizon’ of the model, although the two concepts are linked. The time horizon of a model is the length of time that the model runs for. Put another way, it is the number of cycles (the number of times you push ‘=’) before the model is ‘done’. It is considered good practice to model survival on a lifetime horizon, meaning that the model stops running when everyone is in a terminal state, but it is possible to build models with any time horizon that you deem relevant and that fits the process you are seeking to model. You just need to explain it.

An important limitation of health state transition models, at least the type we will be building in this guide, is that they are “memoryless”[^2]. This means that the model does not keep track of where people in the model have come from. If you end up in Health State Y having started in ‘Health State W’, the model will treat you as though you have the same risk of moving to another state (‘Health State Z’, for example) as if you had come from ‘Health State X’. This is important, because in reality it usually does matter how you ended up in a health state. Health State Transition models behave as though it doesn’t matter. It is possible to ‘relax’ the memoryless assumption, and that process will be explained later.

Now that we have a handle on the basics of model design, let’s talk a bit about building them using the R language.

[Next Chapter](healthyuncertainty.github.io/RGuide/Chapter2)
 
[^1]: *A quick note on nomenclature*: in this guide I will prefer the term “Health State Transition” model. These types of models are often called “Markov models”, “Health Simulation models” or sometimes simply “health economic models”. The semantic differences are trivial, but for reasons that are not worth exploring too deeply, I prefer “Health State Transition”.
[^2]: This, incidentally, is related to why they’re sometimes called “Markov models”.