---
title: Whole Disease Models and Health Technology Management
subtitle: The need for an Open Source approach
tags: [whole disease model, HTA, academia]
---

On Jan 20th I was invited to present to the [Network of Alberta Health Economists (NOAHE)](https://noahe.ca/events/past/noahe-rounds/health-economics-and-technology-assessment-rounds-iv/whole-disease-modeling-for-health-technology-management-the-need-for-open-source-approaches). This afforded me the opportunity to discuss an aspect of my doctoral work that didn't really get much attention in my actual dissertation, despite being the aspect of the work I was most intrigued by.

Here's a link to the talk, cued up to the most relevant part.

[![Video Link](http://img.youtube.com/vi/skNc4aQrIiQ/0.jpg)](http://www.youtube.com/watch?v=skNc4aQrIiQ "My presentation to NOAHE")

I thought I would write this companion post to flesh out a couple of the arguments I had to breeze through.

## Whole Disease Models

The Whole Disease Model (WDM) approach to decision modelling was formalized by [Dr. Paul Tappenden and colleagues](https://pubmed.ncbi.nlm.nih.gov/23244816/). The general concept is simple enough to understand: build one model that represents all the relevant pathways and events for a given disease, all the way from preclinical to terminal illness. The goal of using a WDM is to allow health economists to evaluate policy decisions that might occur at any point along the disease trajectory - one model that can evaluate both a screening program and a change in palliative care.

The justification behind building models in this way, according to Tappenden, is that models that are specific to a particular decision ("piecewise", in his terminology) lack the ability to incorporate changes that may occur outside the modelled pathway. For single adoption problems (i.e., comparing one new policy to the current standard of practice), this isn't an issue. However, in cases where it's likely that multiple decisions are going to be made at or around the same time, the piecewise approach runs into problems.

Here's an illustration:

***
![Fig1](https://www.dropbox.com/s/2gdf7rgjau99m4h/Fig1%20-%20D1%20piecewise.jpg?raw=1)
***

Here is a pretty typical scenario, where we are trying to estimate the cost-effectiveness of a decision ("D1" in this case) that will affect people with late-stage disease. Let's say it's a new kind of chemotherapy. We build a model that starts with people diagnosed with late-stage disease, and includes the possibility that they might experience more severe disease, and that they might become terminally ill and eventually die. We can use this model to estimate the incremental costs and quality-adjusted survival impact of "D1".

![Fig2](https://www.dropbox.com/s/ay2rxk3xo7lcjyw/Fig2%20-%20D2%20piecewise.jpg?raw=1)

Let's now imagine a different policy decision "D2" that is used to treat people with less severe disease. Let's say it's a new and better surgical procedure. In order to evaluate this new surgical approach, we would need to move the decision node "upstream" and build a model that includes all the possibilities that might happen to people after they get surgery. Such a model would still include all the health states relevant to "D1", but would include early stage disease outcomes, which are outside the scope of the D1 decision problem (failure of surgery to achieve local control, surgery-specific morbidity, etc.). And we could use this second model to evaluate the incremental costs and quality-adjusted survival of "D2".

Where the WDM framework enters the conversation is when we need to look at a bunch of different decisions that might be made simultaneously:

![Fig3](https://www.dropbox.com/s/js213pj0kfcip95/Fig3%20-%20MultipleD.jpg?raw=1)

In this example, we also consider the cost-effectiveness of "D3" (maybe a preclinical screening program of some kind) and "D4" (a population-level intervention like poverty eradication or asbestos removal, where a huge number of people will experience a risk reduction). The issue is that these "upstream" decisions are going to affect the rate at which events occur "downstream". In this example, we might see a different mix of patients making it to the point where they *would be* affected by "D1" and/or "D2". That change in the case mix is obviously going to change the overall change in costs and survival for the health care system as a whole, and so we need a model that can look at all these changes at the same time.

But there is an additional consideration, which is that it is entirely likely that the population that encounters "D1" is going to be different than the population the "D1" evidence is drawn from. If, for instance, "D3" preferentially screens people who have access to a family doctor or if "D2" means people with a particular gene variant are less likely to have a recurrence, then our evaluation of the *combined effect* is going to mean that the incremental cost-effectiveness of "D1" is likely to be different than it would be if neither "D2" or "D3" was adopted.

## Health Technology Management

This brings us to a second topic of discussion, which is about the limitations of Health Technology Assessment (HTA). One goal of HTA is to ensure the health care system is getting good value for the money society invests in it. We do our cost-effectiveness analyses on a technology of interest, and consider how much we are willing to pay for the additional QALYs that it offers. If the cost to the system is less than what we're willing to pay, then adopting the technology is a good idea. If it isn't, then it isn't.

The criticism of this approach is that it is always premised on the idea that we will *add* technologies. Missing from these kinds of considerations is the idea that adopting a new technology might mean we can jettison another one without it affecting patient outcomes. We might expect that clinical practice would just naturally "phase out" older technologies in favour of newer and more effective ones, but that might not happen if there is no obvious connection between them. 

For example, while it is reasonable to suspect that the adoption of more effective treatments will change the value proposition for a screening program (since fewer people will die, but at higher cost), those two interventions are being administrated by different parts of the health care system that likely don't share decision-making processes (the surgeons who treat diseases *might* also be part of the screening program, but there's no obvious reason why they *would* be). And so when we make our adoption decisions using HTA, we are failing to ask an important question: how might the choice to add this new thing affect the cost-effectiveness of other decisions that we've made in the past?

This is the distinction that is drawn within [Health Technology Management (HTM)](https://journals.sagepub.com/doi/abs/10.1177/0272989X16653397). HTM invites us to look at the full system and find places where we can "disinvest" or re-allocate resources as a result of changes that have been made elsewhere. Following a HTM strategy allows us to free up health care funding and control overall system costs in a way that still ensures patients are receiving high-quality care.

Going back to our example above, imagine that "D2" was already funded. HTM invites us to ask the question: what is the cost-effectiveness of adopting "D1", "D3", and "D4" and **removing** "D2" from the our funding formulary:

![Fig4](https://www.dropbox.com/s/w4zwtn4vy5rncqr/Fig4%20-%20NoD2.jpg?raw=1)

In that case, by removing D3, we would be evaluating the cost-effectiveness of "D2" in the presence of these other policies (D1, D3, D4), compared to the status quo (D2 alone). We can conduct a HTM exercise by simply re-arranging the *adoption* question into a *disinvestment* question: is D2 still cost-effective within this new set of policies, or does a change in the overall pattern of health resource utilization from these other policies mean we are no longer getting good value for money from "D2"?

## The Implication of HTM for WDM

Hopefully this simplistic example illustrates the potential that WDMs have when it comes to looking at HTM decisions. WDMs are specifically designed to be able to consider the impact of multiple policy changes at the same time. And while that is great for addressing situations where we are considering the *adoption* of multiple technologies, it is also perfectly suited for considering the *withdrawal* of different technologies. Technologies that might already have been approved. Technologies whose effectiveness may be "displaced" by the new stuff we're thinking of bringing in. Technologies that, by being "displaced", would free up health resources that we can re-allocate elsewhere in the system.

But the WDM framework has two important limitations that I encountered first-hand while I was attempting to build one. 

First, WDMs are *insanely hard to do*. The original WDM took years to build and validate. Even mine, which used a considerably less technically rigorous approach (I didn't try to model incident premalignancy, my calibration method was much more simplistic, and I stripped out a lot of process complexity) was a massive undertaking that involved the input a wide variety of medical specialists. The data that powers my model was only available to me through sheer fluke - if someone else (Kelly Liu specifically, to whom I am forever indebted) hadn't already done a full chart review of hundreds of oral cancer patients I would have needed months to years of additional time. Indeed, my ability to link survival and resource utilization outcomes in that dataset was only possible because I was a full-time employee of BC Cancer, which allowed me immediate access to a bunch of data that 'regular' researchers would have had to crawl over the bureaucratic equivalent of broken glass to obtain.

This practicality problem creates the second problem, which is that the health care system we want to model is subject to various types of change. Clinical pathways within a given jurisdiction (a province, a country, whatever) are going to change over time. Imagine my dismay when I reached the end of my dissertation and discovered that the entire method for managing preclinical disease had changed since I started! But those pathways change between jurisdictions too, which means that the WDM that you build in BC might not apply to Ontario. And *neither* a BC or an Ontario WDM would apply to Rotterdam or Geneva or Kinshasa or wherever you might be reading this from.

It's just not practical to build multiple wholly-distinct WDMs for each decision-making jurisdiction in the world. Especially since your model will probably be obsolete by the time you finish building it!

There's a third consideration, which takes us back to the main argument behind the WDM framework. Recall that the reason for building a WDM in the first place is because a "piecewise" model doesn't reflect all the events and processes that might be relevant to a given decision. This invites the obvious question of whether any *given* WDM (mine, Tappenden's, whomever's) lives up to that standard. After all, models are simplifications of reality, which means we've stripped out some processes. If excluding processes is a shortcoming of the "piecewise" approach, isn't it a shortcoming in my model too? Is any attempt to solve the "piecewise" problem going to fail its own standards? Are we simply creating larger "piecewise" models?

## Open Source: a potential solution?

I hope I have successfully convinced you that a WDM is the right tool to do HTM. I further hope that I have convinced you that any WDM you could build will, in all likelihood, fail to meet the challenges that the WDM framework levels at conventional modelling approaches. What the situation seems to demand is a model that can reflect pathways that it wasn't designed to reflect, and that is constantly evolving in time with the real-world decision environment.

Easy, right?

The way I think this can actually be accomplished starts with recognizing that the task is too big for any one person or team of people. Instead, what is needed is a collaborative approach that allows researchers to adapt the model to fit their local context. In this approach, model users can change the parts that are the most specific to the way their system is set up, while leaving the parts that are similar alone. They can change the data that goes into the model such that it reflects the characteristics of the affected population, and the various interventions that are available to serve their needs.

The model I worked on for my thesis was designed for this purpose, since I recognized that the burden of oral cancer is not felt equally in Vancouver, Canada as it might be in Phnom Penh, Cambodia. The populations are different, the health care systems are different, and the distribution of risk factors and disease prevalence are different. What I wanted to build was something that wouldn't necessarily be tied to one specific place and time.

My approach to accomplishing this was to build a model that is made up of a bunch of interacting functions, each of which could be pulled out, reprogrammed to the user's specifications, then plugged back in to the rest of the model. The result looked something like this:

![Fig5](https://www.dropbox.com/s/m62xsfp7v9jejaf/Fig5%20-%20Whole%20Model.jpg?raw=1)

Like the example shown above, the model has several pathways, from management of asymptomatic preclinical disease all the way through to end-of-life care. Each pathway is made up of a collection of subordinate processes that apply some kind of change to a simulated patient (change in expected survival, resource utilization, change in their utility, etc.), and tells the model what is scheduled to happen next. Any of these processes can be rewritten, and if it's rewritten properly you can run the adapted model and get the outputs you want.

My approach to designing this beast was influenced by my (admittedly shallow) understanding of the [Open Source methodology](https://opensource.com/resources/what-open-source). Open Source is a set of principles that emphasize collaboration and transparency. The source code is publicly available and can be copied and edited by whomever wants to do so. Accordingly, while [the original WDM](https://pubmed.ncbi.nlm.nih.gov/23796288/) was built in proprietary Discrete Event Simulation software, my model was built in Python.

In theory, this means anyone (including you, dear reader) can [take the source code](https://github.com/HealthyUncertainty/WDMOC) and use it themselves. In practice, this was written for a doctoral dissertation in my off-work hours, so it is unevenly documented and pretty clunky to run. There are a lot of elements of this work that, in hindsight, could use some serious improvement. There are also a bunch of technical and scientific problems I wasn't able to solve in version 1. Which is the other beauty of Open Source - the model is a living document that you can tinker with, share with collaborators, and update as you gain skills.

My intention is to use this website to break down the methods I used to build this model, and in so doing add some helpful documentation that will allow people to use it themselves or make one of their own. This too will be done in my off-work hours though, so if you're *super impatient* to do this right away you will have to figure out a lot of this stuff on your own. But I spent years of my life on this and I'd hate for the sole result of all that effort to be the letters that come after my name.

## Wrapping Up

That's it for now. I really enjoyed being able to finally share these ideas with people besides my friends; people who aren't just politely feigning interest in my deep dive into the peculiarities of different approaches to decision modelling. My sincere thanks to Nicole Riley and John Sproule at NOAHE for offering me the chance to talk about this work, to my committee and the others who helped me develop this work, and to *you* for getting to the end of this very long blog post. Hopefully you found something interesting in here. Let me know if you did, especially if you found something *wrong*.

More to come soon!
