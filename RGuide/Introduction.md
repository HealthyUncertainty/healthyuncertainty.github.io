---
layout: page
title: Health State Transition Models in R
subtitle: A Guide
permalink: /RGuide/Introduction
---

# Introduction to This Guide

The first model I ever built was part of my MSc thesis. The model was slow, cumbersome, and ultimately required three or four redesigns from scratch. A senior analyst and I bashed our heads together repeatedly trying to make the software do what I needed it to do. The product was… highly imperfect and probably wouldn’t make it past peer review.

And so when it came time to build my second model, this time for an actual funded research project, I was understandably fearful. I was instructed to use the work of a former colleague as a guide, which is how I happened into the world of R. I felt pretty lost – learning a brand new language, applying some very rudimentary skills, and having nobody around me who had much experience using R.

I am writing this series as a distillation of what I’ve learned over the past 10+ years of building health state transition models in R. It contains a step-by-step description of the modeling process I use, with sample code and outputs. In it, I try to explain my process in the way I wish had been available when I was starting, and is aimed at people building their first model.

### An important note:

This guide almost certainly won't pass muster with acknowledged experts in R. There are important and good reasons to use the techniques developed by these experts, not the least of which is to make model design and build compatible across different modelers. The code and approach used here are largely based on a ‘trial and error’ process, rather than a comprehensive knowledge of R code. As a result, some of the techniques I describe in here might not be the ‘best’ way to accomplish a task, but they all work.

This guide does try, as best I could manage, to follow the conventions set forth by the [Decision Analysis in R for Technologies in Health (DARTH) Working Group](https://darthworkgroup.com/). While some of their advice goes beyond the scope of this guide, I consider their recommendations best practices for model development. Models used for research should also be developed according to guidelines set by the [International Society for Pharmacoeconomics and Outcomes Research (ISPOR)](https://www.ispor.org/). Different countries and provinces/states may have their own guidelines as well that govern how a model should be built. Because I am Canadian, for me that means the ones issued by the [Canadian Agency for Drugs and Technologies in Health (CADTH)](https://www.cadth.ca/).

### Using this guide

The series assumes that the reader has some basic knowledge of the purpose and theory of health state transition modeling, some basic background in statistics, and a relatively firm grasp of health economics (specifically economic evaluation). If you’re finding yourself lost, I recommend the following resources:
- [“Methods for the Economic Evaluation of Health Care Programmes”](https://global.oup.com/academic/product/methods-for-the-economic-evaluation-of-health-care-programmes-9780199665884?cc=ca&lang=en&); Drummond, Sculpher, Torrance, O’Brien, Stoddart; 2001 (3rd ed.). Known among health economists as “the Blue Book”, this is widely recognized as a standard text in Health Economics.
- [“Decision Modeling for Health Economic Evaluation”](https://www.herc.ox.ac.uk/downloads/decision-modelling-for-health-economic-evaluation); Briggs, Claxton, Sculpher; 2006. This is a very useful applied text that gives good in-depth descriptions of the use of models in health economics, and contains downloadable examples for Microsoft Excel.
- [The MarinStatsLectures channel](https://www.youtube.com/channel/UCaNIxVagLhqupvUiDK01Mgg) on Youtube. Mike Marin is an award-winning instructor at the University of British Columbia whose teaching style is especially targeted at people coming in with little or no statistics in their background.

This series does not expect you to have any background whatsoever in computer coding or software development. If you’ve never touched R, or any other computer language for that matter, then this is the guide for you. I will do my absolute best to keep the instructions simple and retrievable without relying on complex jargon.

The first section of this guide will explain, with as much detail as I think will be helpful, the basic functions in R that we will be using to build our models. I will then walk you through a step-by-step guide on the process I use to build a model, from the design to the interpretation of the output. I will also be including sample code where relevant. I’ll post the code as a self-contained R file at the end of the relevant chapters so you can download it and run it yourself if you want. 

Please feel free to use any and all parts of the code that you need – the code is governed by the MIT Open Source license. The lines used in the text correspond to the lines in the code, just to make things simpler to find. I’m also going to make available any Microsoft Excel or other files that I use. I would appreciate, if you use any of my code for a publication, if you’d put my name in the acknowledgments and shoot me an e-mail, but I don’t have an army of lawyers to track you down, so it’s really up to you.

One thing I should make clear is that I don’t really consider myself “an expert” in this field. I’ve built a handful of models, and I am constantly learning and refining my own skills, both theoretical and technical. Models can be as simple or as complex as the situation requires, and often experts are needed. My hope for this guide is that you will be able to use it to get started building models, to at least the level of expertise that I have.

All comments, concerns, questions, and corrections should be left as comments below the relevant post. All I ask is that you read the whole guide before asking questions, as your question may be covered in another section.

Thanks for reading, and I hope you find this guide useful. Let’s get going!

### Table of Contents
[Chapter 1 - Building Models](http://healthyuncertainty.github.io/RGuide/Chapter1)

[Chapter 2 - Getting and Installing R](http://healthyuncertainty.github.io/RGuide/Chapter2)

[Chapter 3 - Some Basic Commands in R](http://healthyuncertainty.github.io/RGuide/Chapter3)

[Chapter 4 - Building a Health State Transition Model in R](http://healthyuncertainty.github.io/RGuide/Chapter4_1)

[Chapter 5 - Cost-Effectiveness Analysis](http://healthyuncertainty.github.io/RGuide/Chapter5)

[Chapter 6 - Discussion and Limitations](http://healthyuncertainty.github.io/RGuide/Chapter6)

[Chapter 7 - Conclusion](http://healthyuncertainty.github.io/RGuide/Chapter7)
