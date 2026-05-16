---
title: GRepackaging the WXYZ Model
subtitle: An Illustration of the power of Claude Skills
tags: [R, tools, AI, Replication]
---

 
title: Disease Analogue Models with Generative AI
subtitle: Using a Claude Skill to generate five HTA-grade decision models
tags: [R, tools, AI, Decision Models]


# Introduction
Early on in my experiments with Claude AI, I spent a lot of time exploring its capabilities at building decision models. I deeply understand the amount of time and effort it takes to build models that are fit for their purpose. Beyond the time it takes to perform extensive research to understand the pathways and parameters, the actual act of building a model requires considerable effort. If AI could actually build something coherent and reliable, the cost of model building would decrease considerably.

And so of course I was far from the only person to explore AI for this purpose. I imagine that for every experiment I heard about there were a dozen others happening out of sight. In the conversations I've had with some of the folks who have been generous enough with their time to chat, I haven't seen anyone else using my particular approach. I think there are merits to doing things the way I am doing them, which I hope to demonstrate in the next few posts.

These posts will describe the results of a set of experiments I've run using Claude AI over the past few months. In these experiments I have been developing, refining, and validating a method for rapidly building HTA-grade decision models in minutes from a written natural language description of the model's structure and parameters. This method addresses some common criticisms and shortcomings associated with using AI for this purpose, while producing transparent and consistently formatted code.

This method was used to develop five fictionalized Markov health state transition models. These models describe the movement of a cohort of patients with a hypothetical disease. These hypothetical diseases are analogous to conditions that are commonly evaluated by HTA agencies. Each analogue model produces estimates of cost, LYs, and QALYs and conducts incremental cost-effectiveness analysis for two or more comparator treatments. Generating each analogue model from the written description took about 15 minutes - shorter for less complex models.

In this post I am going to describe the general process through which these analogue models were created.

## AI Skills

A common feature of the Large Language Models (LLMs) that underpin the performance of AI tools is that they are subject to a high degree of randomness. LLMs create responses using sophisticated mathematical predictions based on the context provided by the user and the underlying data that the LLM has access to. But these predictions are non-deterministic. So you can give the LLM an identical prompt 5 times, and expect 5 different answers.  The random nature of AI limits its usefulness for most scientific tasks. 

In October of 2025, Anthropic introduced [a feature called 'Skills'](https://platform.claude.com/cookbook/skills-notebooks-01-skills-introduction) to supplement their AI tool called Claude. Skills are sets of instructions that equip the AI with templates, workflows, and references that guide the way the AI approaches a given query. By providing this additional context, Skills reduce the amount of 'randomness' in the way that Claude does things like write code. Users can create custom Skills with any information they deem useful. Claude will access the Skill when prompted, and will deploy the parts of the Skill that are relevant to the task at hand.

The simplest form of a Skill is a formatted Markdown document called `SKILL.MD` that has plain-language instructions for the AI to read. However, Skills are better understood as a directory that, at minimum contains `SKILL.MD` along with any number of other files. Those other files might contain examples, troubleshooting guides, reference images, and anything else that could help the AI accomplish its task according to the user's expectations.

![A screenshot of the Skills menu in Claude, showing the directory structure of the mcp-builder Skill](https://www.dropbox.com/scl/fi/9h1de8pyi3z8pm6d6ophu/Claude-skill-directory.png?rlkey=whl222jxpnd5vfg8x35x8qcos&st=wd6trkts&dl=1)

Skills can therefore be thought of as a rudimentary form of [context engineering](https://aidesolutions.net/pub-context-engineering-why-genai-projects-fail-or-work.html). Beyond the more conventionally understood concept of prompt engineering, context engineering surrounds the AI with the kind of data that will ensure it follows a similar process to execute a similar given prompt. Unlike more robust forms of context engineering, Skills do not require the deployment of dedicated servers or customized agents. Instead, Skills work with the Claude chatbot's default behaviour and processing.

This makes Skills considerably easier to build, modify, and share among collaborators than rigorous context engineering systems. This additional accessibility theoretically comes at the price of scientific rigour and predictibility. The relative value of this trade-off is both an empirical question (how much rigour do we actually lose?) and a question of values (how much does that loss matter?). For reasons I will discuss later, my personal belief is that the loss is likely negligible and is far outweighed by the benefits.

## Using a Skill

A typical interaction between a user and Claude (or any AI) involves the user inputting a prompt - a question, an instruction, an idea - into a chat box. Claude analyses the prompt and algorithmically generates a response. The nature of the response is a product of the nature of the prompt, any previous instructions given by the user, and Claude’s underlying programming. Identical prompts may yield different responses. Claude may therefore be understood as a highly talented but naive assistant who needs detailed explanation to perform even simple tasks consistently. The role of the user is to provide that explanation and then to inspect Claude’s work and to challenge its assumptions. Active and thoughtful engagement by the user is a critical part of developing any code in Claude.

##### Figure 1 - Using the Claude interface

![The Claude AI chat interface](https://www.dropbox.com/scl/fi/j5l8f7i95a3yyte1efqvx/Claude-interface.png?rlkey=hxirykw7dew04xepwt5jnoxyk&st=nymhyu7q&dl=1)

Loading a Skill in Claude is even more straightforward than loading a package in R. It could be as easy as dragging and dropping a .zip file containing the Skill directory into your chat window with Claude. Or if you have an account you can equip Claude with whatever Skills you want in the 'Customize' window.

![A screenshot of the Customize window in the Claude web interface](https://www.dropbox.com/scl/fi/pjrb3r8bpwomownkc3fjf/Claude-Skill-Load-Window.png?rlkey=bubss386u2kgumsu96i6xc0sb&st=d2uudt67&dl=1)

Then you just ask Claude, in plain language, to use the Skill to do the thing you want it to do. Claude reads the contents of the Skill, starting with the `SKILL.MD` file and then responds to the user's query with the context of the Skill in its working memory.

## Skills vs. Packages

People familiar with R may find it helpful to consider Skills in Claude as being analogous to packages in R. Both are detailed sets of instructions that allow the computer to execute complex sequences of commands in pre-defined order. Both can be uploaded to allow an indefinite number of users to access them, and can be updated (and version managed) [using tools like Github](https://github.com/anthropics/skills).  Multiple Skills or packages could be built to accomplish the same desired objective (the same way that `dampack` and `bcea` will both perform cost-effectiveness analysis, albeit slightly differently).

##### Table 1: R Packages and Claude Skills - Similarities and Differences

![A table describing the similarities and differences between R Packages and Claude Skills across difference attributes](https://www.dropbox.com/scl/fi/swrveh3o8omlfseh0e8yo/Skills-vs-Packages.png?rlkey=mo4dghgun9sdjggu3a45oeul4&st=svv6a2io&dl=1)

Where these two approaches differ is in the flexibility of inputs and the consistency of outputs. Skills are highly adaptable to different data structures, model types, function syntax, and any other number of characteristics that are expected to vary from one model to another. Packages, by way of contrast, require data to be organized in ways that are specific to their design. A package that requires a dataframe with named columns will not accept data in any other format (e.g., a matrix with a vector of column names). 

A Skill is a set of natural language instructions and reference files that the AI uses as general guidance. Unless the Skill specifically tells the AI not to accept data in anything other than the desired format, the AI will attempt to find a way to convert the user's input into what the Skill says is the desired output.

This flexibility of inputs also introduces variability in what AI generates. While the output of a package will be 100% identical if given identical inputs (save for the generation of unseeded random numbers), the random nature of AI means that consistent prompting using a consistent dataset will nevertheless produce non-identical outputs. When a Skill is applied, the variability in outputs will be *reduced* but cannot be *eliminated*.

# Developing HEmodelR
I worked with Claude to develop a Skill that would read the description of a health economic decision model and generate a working version of that model in R. This Skill would not require access to the source materials or any model files. Instead, it could read in the methods used to describe the model including its structure, assumptions, inputs, and transition logic, and produce an R-based model fitting those specifications.

The Skill guides the replication process through six progressive steps:

1.  **Model Structure and Configuration**: Claude reads the model description and designs its framework and internal logic.
2.  **Parameterization:** Claude uses an adapted version of the [Batch Importer](https://healthyuncertainty.github.io/2020-11-25-the-batch-importer/) to define the values for all model parameters.
 
3.  **Create Probability and Payoff Functions:** Claude will write mathematical functions to describe the transition probabilities between model states, health care system costs, and health state utilities.

4.  **Generate Markov Trace:** Claude programs the model to calculate state membership over the course of the model’s time horizon based on the values generated in the previous steps.

5.  **Perform Cost-Effectiveness Analysis:** incremental cost-effectiveness is calculated for the experimental and comparator treatments.

6. **Probabilistic Analysis and Data Visualization**

Each step contains validation checks to evaluate whether the code is producing outputs in the expected way. The user reviews and inspects these validations checks and, if they pass, instructs Claude to continue. The final output of this process is a series of R scripts that power the model. The user can run these scripts to estimate cost-effectiveness.

## Modeling Methods Approach

The `HEmodelR` Skill used template code described in [R for Health Technology Assessment](https://gianluca.statistica.it/books/online/r-hta/), a methods textbook edited by Baio, Thom, and Pechlivanouglou. This book is a collection of coding practices and approaches for building HTA-relevant analysis, including cost-effectiveness models, in R, with more than 30 co-authors from around the world. This textbook likely represents the most authoritative source for R-based model specification in the available literature. Specifically for this exercise, [Chapter 9](https://gianluca.statistica.it/books/online/r-hta/chapters/10.markov_models/markov-models#sec-markov_probabilistic) (authors: Thom, Soares, Krijkamp, and Lamrock) was used to instruct Claude how to develop a Markov model.
  
The instructions from the book were supplemented by [code I developed](https://healthyuncertainty.github.io/2021-03-27-The-WXYZ-Model/) to handle parameters and conduct probabilistic analysis. In this code, parameter values are stored for both deterministic and probabilistic analysis. Each probabilistic run is an instance of the underlying logic of the deterministic model with a set of probabilistically sampled parameter values. Probabilistic sampling is conducted through the method of moments, using the mean and error terms for each parameter and making standard assumptions about parameter uncertainty distributions (gamma for costs, beta for probabilities, etc.).

## Skill Calibration and Validation

The `HEmodelR` Skill was used to replicate models from their natural language descriptions and parameter values as documented in public-facing sources. Claude did not have access to any model files or proprietary information, nor was any such information used in any way. For each replication exercise, Claude read the text within the documentation, built a model using the Skill, and performed iterative adjustments to the model code using the published results as calibration targets. If a model failed to match the targets within tolerances (LYs: 3%; QALYs: 3%; Costs: 5%) for any comparator, Claude investigated its code and formed hypotheses to explain the discrepancy. Those hypotheses were explored with my input, and new models were built. In many instances, I suggested potential causes of error and proposed solutions. In all instances I was working in tandem with Claude and made or signed off on all consequential decisions. In most cases, model results were replicated within <1% of published values.

Claude performs its own validity checks for code structure and syntax errors. The `HEmodelR` Skill contains multiple validity checks as well. These were developed during the replication process, learning and documenting solutions to problems encountered and the kinds of errors Claude was prone to making and then adding them to the Skill. Finally, the model was developed while connected to an MCP server that allowed me to see the code as Claude was building it, and to run it locally to perform my own checks and verify results.

# Developing the Analogue Models

I asked Claude to build me five models that were disease analogues of common HTA conditions. The Skill had previously been calibrated to handle specific model features that are commonly seen in models that are used to inform decision making. These features are present in the models Claude produced:

### CAIS — Chronic Airway Infection Syndrome 
A chronic respiratory condition with recurring acute episodes and risk of progressive chronic bacterial colonisation. 

 - _Real-world analogues_: non-cystic fibrosis bronchiectasis, chronic obstructive pulmonary disease, bronchiolitis obliterans. 

 - _Structure:_ 7-state annual Markov model, 100-year horizon, 2 arms.
 - _Key features:_ Dual chronic infection pathogen states (PathA/PathB) with spontaneous clearance; bidirectional exacerbation states; state-specific SMR-scaled excess mortality; age-dependent background mortality.

### **CNRD — Chronic Neurological Relapsing Disorder** 

A lifelong psychiatric condition with recurring acute episodes, progressive metabolic complications from treatment, and sequential lines of therapy. 

 - _Real-world analogues_: schizophrenia, bipolar disorder,
   treatment-resistant depression.
 - _Structure:_ 18-state (3 × 6) quarterly Markov model, 80-year horizon, 2 arms, 3 treatment lines.

 - _Key features:_ Three coupled treatment lines with discontinuation cascade; metabolic complication progression (syndrome
   → diabetes/cardiovascular disease); line-specific relapse and adverse
   event rates; acute hospitalisation cost at model entry.


### **ABD — Acute Bronchial Disorder** 
A chronic inflammatory airway condition with recurrent acute flare-ups of varying severity. 

 - _Real-world analogues_: asthma, eosinophilic bronchitis, allergic bronchopulmonary aspergillosis.
 - _Structure:_ 5-state biweekly Markov model with tunnel states, 50-year horizon, 2 arms, 1,300 cycles.
 - _Key features:_ Three severity-graded tunnel states (mild, moderate, severe) each resolving within one cycle; severity-specific treatment
   effect (strongest on most severe events); severe flare-up mortality
   risk; biweekly cycle granularity.

### **DMSS — Diffuse Mucosal Sclerosis Syndrome** 
A chronic structural cardiac condition classified by symptom severity, managed pharmacologically or surgically. 

 - _Real-world analogues_: mitral valve disease, hypertrophic obstructive cardiomyopathy, aortic stenosis.
 - _Structure:_ 4-state population proportion model, 80-year horizon, 5 arms, 1,040 cycles.
 
 - _Key features:_ Frozen symptom grade distributions (not transition probabilities); treatment-specific grade distributions assessed at
   different timepoints for pharmacological vs surgical arms; one-time
   perioperative mortality for surgical arms; 5-arm comparison with
   dominance analysis.

### **CISS — Chronic Immune Skin Syndrome** 
A chronic relapsing inflammatory skin condition treated with a range of targeted oral and injectable therapies assessed against supportive care. 

 - _Real-world analogues_: psoriasis, atopic dermatitis, hidradenitis suppurativa.
 - _Structure:_ 5-state 16-week cycle Markov model, 5-year horizon, 6 arms, 17 cycles.
 
 - _Key features:_ Distinct induction and maintenance phases with structurally different transition matrices; treatment-specific
   response rates across three response levels; time-varying
   discontinuation rates (year 1 vs year 2+);

These models were each used to conduct a hypothetical cost-effectiveness analysis using fictitious treatment comparators. 

# What's Next
The next five posts will describe the five analogue models. In a sixth and final post I will discuss the implications of this work and where I see it going.
> Written with [StackEdit](https://stackedit.io/).
