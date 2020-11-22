---
layout: page
title: Chapter 6 - Discussion and Limitations
permalink: /RGuide/Chapter6
---

# Chapter 6 - Discssion and Limitations

The most daunting part of using R, in my experience, is the fact that you start with a blank page and a blinking cursor. There’s no pulldown menus to tell you what functions to use, no helpful wizards to get you started – the possibilities are endless. This terrified me when I began coding. However, once I got past the initial shock of the way the software is set up, I quickly realized that the broad scope of R meant that I could build models with any level of complexity I wanted, using only a handful of rudimentary commands. Basically, as long as you can work it out in your head, R can do it.

This brings me to an important question that you may have been asking all the way through this guide... 

### Why use R at all?

The best reason to use R is the flexibility I just mentioned. I have yet to encounter a modeling scenario that couldn’t be handled fairly easily in R. Tunnel states, recursive transitions, non-equal cycle lengths, time-dependent variables – no problem. R isn’t necessarily designed with these things in mind, but they’re all possible, and not that much more complex than the code that we’ve written together here.

The second-best reason to use R is the price. R is free, can be installed and run from a laptop, and (importantly) can be shared with other people at no cost. If you want to work collaboratively with other people – whether that’s other health economists, decision makers, clinicians, whoever – R’s lack of a license makes it the ideal software package for work that you want or need to share with others.

The third-best reason to use R happens when you have to build a complex model with lots of states and transitions. As long as you keep track of your transitions, there is no such thing as a model that is ‘too complex’ for R. I find tree diagrams very difficult to follow, especially when the number of potential pathways is large. While the R code might not be pleasant to look at, the programming itself is methodical and straightforward.

The fourth-best reason is a bit esoteric, so please bear with me: programming something yourself helps you understand it better. The method I’ve highlighted allows you not only to produce ICERs, but also any other summary statistic that you might want. Do you want to know the average additional cost per case? R can do that. Do you want to know the number of cycles it takes before something becomes cost-effective? R can do that. Do you want to know which health states generate the most costs? R can do that. You can fully understand everything that is happening in your model at all times, rather than having to peer at your results as they come out of a ‘black box’.

### Limitations of this Guide
Of course, there are some pretty important things that the model we’ve built doesn’t do. The biggest and most obvious limitation is that this method assumes that all the data we need is available in the form of point-estimate means and standard errors. In many cases, we may not have data in this form. This form isn’t even necessarily the best or most accurate way of representing costs or probabilities – it’s just the most simple one.

This modeling approach also hasn’t incorporated half-cycle corrections. The method assumes that all transitions happen right at the beginning of each cycle, but it would be a strange world indeed where all health events occur on the same date. Half-cycle correction methods try to blunt the effect of this assumption by distributing costs and QALYs over two half-cycles. We haven’t done that here, but rest assured it is possible.

The model also assumes that there is no effect of age on costs or transitions – an assumption that I am sure will make the heads of health services researchers and epidemiologists spin wildly. The model, as designed and programmed, also fails to account for the possibility that people might die of causes unrelated to their health state (e.g., dying in an accident, dying of some other disease).

All of the above are decisions I made to simplify the process, rather than true limitations of this approach. I have developed some ways of adding these, more or less seamlessly, into the code we have already generated, and I will be publishing those on the web as I find the time to do so. However, because each model is unique and has its own challenges and peculiarities, there will never be a functional “one size fits all” approach.

I have also chosen not to demonstrate a few techniques like univariate sensitivity and threshold analysis, or more involved approaches to Value of Information analysis (such as EVPPI). These are also important details, and the BCEA package is set up to provide estimates of those values but I’m not going to go into that here.

### Limitations of this approach

I want to prevail upon you as firmly as I can that this is not "the way to build models in R". This is a technique that I developed, with some help, over the course of building a few models. There are people whose area of academic and professional expertise is developing methods for model development, and I am quite sure that there are differences between their approaches and mine. I too am still learning. However, the method described in this guide will help you build simple, straightforward models for cost-effectiveness analysis. It gives you a place to start, and hopefully demystifies the process of working in R.

[Next Chapter](http://healthyuncertainty.github.io/RGuide/Chapter7)
[Previous Chapter](http://healthyuncertainty.github.io/RGuide/Chapter5)
[Back to Start](http://healthyuncertainty.github.io/RGuide/Introduction)