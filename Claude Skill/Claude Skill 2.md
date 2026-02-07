
# Using the r-hta-markov-replicator Skill; Case Study 1: myasthenia gravis

## Introduction

In a previous post, I described the process by which I built a Skill for Claude that builds models in R based on model-building process developed by [Thom, Soares, Krijkamp, and Lamrock (2025)](https://gianluca.statistica.it/books/online/r-hta/chapters/10.markov_models/markov-models). The Skill builds models using a six-part process with built-in quality checks and sample code that helps increase the consistency and accuracy of the code Claude writes.

In this post, I describe an early 'test drive' of the Skill.

## Case Study: eculizumab for myasthenia gravis

To replicate a model, the Skill requires detailed documentation about model structure, logic, and parameters. Such documentation can helpfully be found within Evidence Reports published by the Institute for Clinical and Economic Review (ICER). As part of a transparency initiative, ICER publishes the model analysis plan for their HTA reviews on the [Open Science Foundation (OSF) repository](https://osf.io/user/7awvd). These analysis plans are publicly available, and their express purpose is to [“allow other interested parties to replicate or extend analyses conducted by ICER and its collaborators”](https://icer.org/our-approach/methods-process/manufacturer-engagement/statement-of-icers-commitment-to-economic-model-transparency/). 

Despite this policy, when I reached out to ICER they clarified that they nevertheless retained Intellectual Property control over the contents of their report and that publishing replications of their work was a violation of the Terms of Service. They asked me to remove the original post that described the replication exercise. Until this issue is resolved, I am removing any further references to ICER reports and will not be able to publish any replication work involving their reports. The methods and results section has been removed from this post.

**THIS CONTENT HAS BEEN REMOVED DUE TO AN ASSERTION OF INTELLECTUAL PROPERTY BY THE AUTHOR OF THE ORIGINAL REPORT.**

## Case Study Discussion and Limitations

In the exercise described above, I was able to rapidly produce a valid replication of a 6-state time-dependent Markov model from a published source with the assistance of an AI agent. This was possible thanks to the Skills feature in Claude, which allowed me to specify a multi-step replication process with intermittent validity checks and an iterative development method based on best practices. The model is ready to use, to share, and to update with jurisdiction-specific values. Further validation work may be needed beyond meeting targets for cost and QALYs.

### Limitations

This document describes an “n of 1” case study. It has not yet been demonstrated that the replication exercise described above will work using other models with a different structure and/or greater complexity. As it is, the Skill is explicitly written to reproduce Markov models alone. It could not be used to replicate a Partitioned Survival Model, for example. Future replication exercises are likely to yield problems that require modifications to the Skill, and possibly to the replication process more broadly.
  
It is important to note that the model results were not identical to the reference value. Quality checks performed during the validation process found that the Markov trace was 99.96% accurate when predicting time in the response state. It is possible that the 6% error rate in QALYs for CT was caused by trying to calculate utilities from rounded published values. It is also possible that this difference is due to assumptions within utility mapping that were too minor to warrant disclosure in a publication. Finally, it is important to note that due to confidentiality agreements with the sponsors and authors of the original report, some values in the reference report were approximations. However, it is not possible to rule out the possibility that some small error was introduced during the replication process that eluded the quality checks.

An inherent limitation of an AI-assisted replication approach from published sources is that Claude requires a lot of very specific instruction about the model, structure, and logic. This level of description is seldom available in published literature, including reports from HTA agencies.Theoretically, the Claude skill could be used to produce a de novo model from detailed user specifications; however, this approach has yet to be tested and would require careful validation by the modeler without the benefit of calibration targets.

## Conclusion

In this post, I described a simple and straightforward process to build a model that behaves similarly to a description provided in a publicly available source. A simple model was chosen to give the replication process a high likelihood of success. The replicated model produced very similar results to the reference report for cost and for estimated QALYs for both the reference and new drug arms.

In the next post, I am going to talk more about what I learned during the process of building and testing this Skill and about the use of AI in general.
