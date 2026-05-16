---
title: Disease Analogue Models - Discussion
subtitle: Using a Claude Skill to generate five HTA-grade decision models
tags: [R, tools, AI, Decision Models]
---

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

 
# Experiment Summary

I developed an AI Skill (a set of instructions and documentation for the AI to hold in its context window) that allows Claude to replicate published decision models for health economic analysis. The Skill was then used to build a series of five models exploring fictional treatments for hypothetical diseases that are analogous to real-world conditions. These models contained several features that would be expected to be common among models used for HTA decision making - adjustment for background mortality, discontinuation, induction and maintenance phases, large numbers of states, and more.

Crucially, using this replication-based approach to developing the Skill did not require access to the source model files. The Skill used the published results as an anchor point and made iterative changes to its code until target values (LYs, QALYs, Costs for all comparators) were within tolerance ranges. The lessons learned from these exercises were added to the Skill, making it more sophisticated each time it was used.

This exercise offers a practical solution to a core problem of reproducibility when developing decision models with AI. It is possible, using currently available technology and publicly shared information, to develop decision models of the necessary quality to support decisions about health care resource allocation. Skills allow this to be done in a way that is consistent, transparent, and easily modifiable.

## Limitations

Fictionalized disease analogues were chosen for this exercise to avoid the risk of infringing on the intellectual property of the authors of the reports that built the models that were used for replication. Even though the models themselves were not fed into Claude, there is still a reasonable argument that it isn't okay to replicate other people's work without permission. Indeed, Anthropic has lost lawsuits for exactly this reason.

In order to address this concern, the `HEpackageR` Skill does not contain any explicit references to the source material, and does not require access to any source material when building models. The reference models were not, to the best of my knowledge, built with R. This means that there cannot possibly be any code within the Skill that was present in the reference models. It also means that every methodological feature and problem solved represents original work.

This unfortunately creates a situation where we are discussing the cost-effectiveness of fake treatments for fake diseases. It limits the usefulness and interpretability of the models. Some considerable adaptation would be needed to transform a CAIS model into an COPD model, for example. There are many disease-specific features that would need to be added in order for these models to be useful for real-life decision making.

Additionally, I did not perform a line-by-line audit of the code in these models. While I did run the code to verify the results, I didn't go through it myself, instead relying on the built-in validity checks to ensure the code's quality. It is possible that there is some unexpected code within the different model files that is having an unknown impact on the output. That being said, the use of the Skill is specifically designed to minimize the risk of this kind of mistake, since the original models were anchored against published results.

# Discussion

This work was intended to address a number of distinct but overlapping goals:

 1. **To demonstrate the use of the HEpackageR Skill:** I have been working on this thing for the better part of 8 months. While I've made passing reference to it a few times, I haven't actually shared any outputs for peer scrutiny. I think there is a lot of potential in this approach, but in order for that potential to be realized it first needs to be seen.
 2. **To serve as a basis for future work:** There are a number of other side experiments I've been tinkering with. These models can serve as the foundation for getting those projects out in the world as well. For example, all of the Github repositories and Shiny apps were built with another Skill I built called `HEpackageR`. There's more coming behind it, which I'm not ready to share just yet. Posting this bring me an important step closer.
 
 3. **To serve as a template for other models:** In my fondest dreams, other modelers looking to experiment with R take this code and adapt it for their own purposes. There are a solutions to a lot of tricky modeling problems in this code, and to the best of my knowledge there aren't a lot of documented solves out there. Hopefully this can help more people build better models.

I do want to take this opportunity to note some things that have been on my mind while doing this work that may have some implications for these goals.

## Model validity and structural divergence

One potential criticism of building models with an LLM is that it is very difficult to verify whether the LLM has built it 'correctly'. There are countless subtle structural choices that must be made when building a model. While responsible modelers disclose the key assumptions made in a modeling exercise, it is typically beyond the scope of even the most thorough reporting to document every structural and syntactical choice made during the coding process.

Consequently, two modellers (or two LLMs) could take the same set of natural language instructions for building a model and arrive at different results even without hallucinating or committing other errors. This presumably happens when LLMs arrive at decision points during the code-writing process where the language has more than one plausible interpretation. In those cases, the LLMs would produce two (or more) mathematically distinct but equally 'valid' solutions. Depending on the nature of these assumptions, the divergence in model results could be considerable. Model users would be left without a clear way of knowing which model is producing the more trustworthy values.

I flag the word 'correct' in quotes here, because it presumes that there is such a thing as absolute validity when it comes to models. Models are, after all, approximations of reality that attempt to predict future events. Since we cannot know the future, and because reality is always more complex than the models we build, we should not expect that any model will perfectly capture all relevant information and give us exact knowledge of the impact a health care decision will make.

However, it does not follow that all models are therefore equally good at predicting those impacts. In theory, two models with identical structure and parameters should produce identical results. When that doesn't happen, it seems facially inappropriate to simply conclude that they are equally valid, especially if the divergence is meaningful. Depending on the nature and size of the divergence and the population being modeled, differences between models could be the difference millions of dollars in health care spending.

In the face of an epistemic quandary where the truth cannot be known, it is helpful to be pragmatic. 

## Fit-for-purpose pragmatism

My position on this matter is anchored within a tautology: a model that is used to inform a decision is *de facto* fit for decision-making. The bar for quality, as it were, is set by the revealed preference of decision makers. There are models out there (I have seen some of them) that are so badly conceptualized that it would be irresponsible to draw policy conclusions from them. 

I am not speaking here about models informed by unreliable clinical evidence, which is its own problem. I am speaking about models with structures that do not adequately represent the decision problem, have health states based on irrelevant outcomes, or that fundamentally misconstrue the ways in which patients interact with the health care system. The outputs from models like this are meaningless, as they have no clear relationship to reality. Attentive health care systems should reject these models because they do not actually provide any economic evidence.

Any model that clears this standard, tautological and arbitrary though it may be, is by definition a model that reaches the minimum requirement of being fit for purpose. This implies the existence of a model quality spectrum that stretches between this minimum requirement and the theoretically ideal model that is methodologically flawless and contains all the information needed to predict the future exactly.

This spectrum itself implies a *pragmatic maximum* requirement - that is, a model that is as close to being fit for purpose as is reasonable to build given time and information constraints. Adding more rigour beyond this point will likely not lead to important improvements in the quality of the decisions being made.

![A graph illustrative the diminishing returns from improving model rigour, especially beyond a theoretical pragmatic maximum level](https://www.dropbox.com/scl/fi/ffto1njx2m67czdcaw10u/Diminishing-returns.png?rlkey=r88wvmmyi6wxtrsxcfm8uj7k4&st=9pd5n2im&dl=1)

## Models and incentives

In the pharmaceutical HTA space, models are predominantly built by the pharmaceutical industry. Because industry pays for these models, and because they are profit-seeking, they have a financial incentive to meet that minimum threshold of rigour without exceeding it. Failing to meet it would be incredibly costly, in the form of their model being thrown out. Exceeding the minimum threshold also imposes additional costs (represented in the figure by "ΔC") that do not necessarily translate into additional profits - a market access approval from a minimally rigorous model is just as good as an approval from a great model.

Public payers have the opposite set of incentives. Their incentive is to get the maximum amount of usefulness from a given model - one that answers all the relevant questions decision-makers might have. The gap between the rigour of the model that industry is incentivized to build and the one that payers are incentivized to desire the most is represented by "ΔE" in the figure. HTA agencies critique the rigour of those models as it relates to the usefulness of a given model for decision making, and try to describe generally where it sits within the figure's shaded area.

If decision-makers commission models themselves, or if a modeler is working with the goal of providing them the best model possible, then there is a theoretical bias toward reaching the pragmatic maximum. Absent a profit motive, the value proposition of building a model that is minimally fit for purpose is quite low (unless speed is a factor or the modeler doesn't have the capacity to exceed the minimum). The incentive is to build something more than the bare minimum so that it can inform the best possible decision.

If we accept the above arguments, then it follows that models that are built by decision-makers (or by HTA agencies) are, all other things being equal, likely to be closer to the pragmatic maximum than models build by industry. While it is undoubtedly the case that some industry-built models are more rigorous than models that are built on behalf of a public payer, we should expect this to be the exception rather than the rule.

Accordingly, it follows that models built by HTA agencies and that were used to inform a real funding decision represent the best proxy for a model with the pragmatic maximum level of rigour.

## Reference Models

In 2025, [NICE announced a position statement around their use of "reference models"](https://healthyuncertainty.substack.com/p/nice-spells-out-the-benefits-of-reference). This approach is designed to ensure that any models they commission for decision-making follow the same general logic. This makes their models more interoperable between different teams at NICE and reduces the time and effort required to update models. It also pointed in the direction of making reference models the 'base case' upon which other models should be built, if submitted by external sponsors - they use the term 'disease-specific reference case extensions'.

The Skill-assisted approach to model building sits nicely alongside the reference models idea. At a fundamental level, building a Skill is nothing more than establishing a set of norms about model structure, programming, and design. Multiple modelers using the same Skill will produce models that have similar logic, structure, syntax, and other features, even across different health conditions. Using Skills takes the same logic that makes reference models a good idea and broadens its scope.

Skills can also obviously be used to directly build reference models themselves. While it is highly questionable whether AI can build a model from conceptualization through parameterization and validation, this experiment demonstrates that Skills can equip AI to at least build ones that are comparable to those currently used for health care decision-making. HTA will still need thoughtful and skilled health economists and health services researchers to design models, collect input from experts, integrate available evidence, and make value judgments. However, the part of their job that involves actually programming models is likely going to shrink quite a bit.

If more HTA agencies adopt the reference models idea, there are many good reasons to build them collaboratively. While features of the health care system may differ between countries, the central logic and natural history of diseases are far more likely to be conserved. After all, pharmaceutical companies have global model-building teams who disseminate prototype models to domestic partners, who then customize them for the specific decision context. I see no reason why HTA agencies couldn't adopt exactly the same approach, especially if AI meaningfully reduces the effort that customization takes.

## Open Models, Open Skills

I make no secret of my affinity for making decision models open source. Models are full of decisions and value judgments, many of which are undisclosed. It seems uncontroversial to say that decisions that impact millions of dollars in health care spending and the health of potentially thousands of people should have some degree of openness. While open source publication is, in and of itself, insufficient to confer full transparency, it does offer a degree of accountability that is higher than the current standard of practice with proprietary models that are kept confidential. 

Beyond the transparency benefits, it also seems uncontroversial to contend that a reusable model is superior to a single-use model. Single-use models that are locked away in digital archives, never to see the light of day, are a wildly inefficient and wasteful approach. Even if a given model is only ever used for a single decision, making it available to others means those others can repurpose its components - its design, its syntax, its logic - for future modeling exercises. It benefits the discipline of health economics when modelers can leverage and improve upon each other's work. Open source gives us that too.

Skills are, as consequence of the way they are built and structured, inherently designed to be shared. One does not *have* to share them, but they can easily be published on places like Github, where other users can access and run them. Like R packages or any other open source code, it can be maintained and updated. Skills benefit from lessons learned, and get stronger through use. These lessons can be pushed to all users, allowing multiple people to benefit from each other's work.

I am choosing not to make `HEmodelR` open source for now. I think this approach has a lot of disruptive potential. Skills are easy to build, easy to use, and powerful. I think there is a good reason to approach this topic slowly and deliberately, rather than rushing to put stuff out before it's been subjected to proper peer review. This series of posts is an important step toward a more thoughtful route to introduce the Skill itself. As far as I can tell there is no rush - HTA agencies aren't clamoring for AI-generated models and it's not clear how far industry has gotten down this road. There is time, it seems to me, for socializing this work among colleagues and academics and releasing it where and when it can do the most good.

## International Collaboration

All of the above arguments weave together in a way that suggests a transformative reimagining of how pharmaceutical HTA can be conducted. Skills can help HTA agencies to rapidly develop reference models, and equally rapidly customize those models to reflect novel treatments and changing evidence. It would be straightforward for an HTA agency to develop a Skill that lets them build consistent and transparent models rather than relying on industry to build them. But the idea gets much more valuable if we widen the aperture.

A group of HTA agencies working together could rapidly share not only the reference models themselves, but the Skills used to build them. Many (perhaps most) resource allocation decisions are informed by international clinical trials. The data from those trials technically becomes available to every HTA agency at the same time, though industry presumably doesn't submit them all at once. However, given that any reference model would be the intellectual property of the group that built it, the model itself could be readily shared among willing agencies. This means the submitting companies would only need to share the trial data, not build a customized model for every submission.

A shared repository of reference models would also offer potential expansion of early HTA. In advance of conducting trials, health care systems could built prototype reference models that help them identify data gaps and effectiveness targets/thresholds. Revealing the data gaps would help clinical trialists design their trials to collect information that is relevant for decision-making, and could assist in the design of RWE databases and disease registries. Calculating thresholds would help identify whether or not drugs that are in the research pipeline are likely to provide good value for money, even before they are ready for full HTA appraisal.

Finally, shared reference models could be more amenable to input from patients, members of the public, and other people who are affected by reimbursement decisions. If patients, for example, know about the structural assumptions and value judgments that went into a reference model, they can have insight into any ways that those models are misaligned with patient interests. Since a reference model can be used and re-used, the model can be adapted and improved based on this additional perspective, then used for future adoption decisions or post-market reappraisals.

## Human In The Loop Development
My experiences working with AI have led me to align with what I think is an emerging consensus opinion: humans have to monitor the AI's behaviour. Claude really does a good job of solving problems and the models are just getting smarter. However, Claude is not a health economist or a decision modeler. The Skill validation process required me to provide a lot of active input. Each replication attempt typically spanned over at least a couple of days, especially when developing the initial prototype. The more complex the model being replicated, the more Claude relies on human direction lest it fall into logical rabbit holes.

There was a long process where I had to teach Claude not to 'cheat' by latching on to arbitrary calibration values or secretly inserting back-calculated adjustment factors to match the targets. The AI really wants to give you the answer it thinks will make you happy. It took some effort to convince it I wasn't happy with being tricked. The technology is developing rapidly though, so this may be less of an issue for people wanting to build Skills in the future.

As I mentioned above, I stopped short of performing an audit of all the code. Each replication was validated against multiple targets across multiple comparators with relatively strict margins of error. This guarded against possibly producing a model that was superficially similar to the original but that made important assumptions differently. This meant that the replicated models are as close to true replications as can be expected without access to the source model files. I did not see the need to review the underlying code myself, which means there may be some errors. 

# Conclusion

In this experiment I was able to generate five useful model prototypes quickly and easily with the help of an AI Skill that I developed for Claude. The Skill that built this model integrates best practices from the literature with methods and syntax developed by replicating publicly-available natural language descriptions of HTA-ready decision models. By anchoring the Skill against the published results from these models, we can have a high degree of confidence that the approaches within each model meet and likely exceed the minimum threshold of rigour needed for decision-making.

This experiment offers the first public demonstration of the `HEmodelR` Skill. It also provides useful code for other modelers working in R who may be looking for examples of code to solve methodological problems in the models they're building. It is also my intention for these models to serve as the basis for future work that demonstrates the capabilities of AI Skills in health economics.

I think this experiment also demonstrates an early proof of concept for the idea that public payers can reap substantial benefits - both financially and scientifically - if HTA agencies adopt an open source framework for reference models. Skills themselves are also well suited to open source sharing. Collaboration between jurisdictions would reduce costs, improve the quality and speed of decisions, and create real practical avenues for models to reflect the perspective of patients and the public.

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

> Written with [StackEdit](https://stackedit.io/).
