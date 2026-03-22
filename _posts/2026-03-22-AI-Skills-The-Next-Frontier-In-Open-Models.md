---
title: AI Skills are the Next Frontier in Open Models
subtitle: Reflecting on 6 months of developing Skills in Claude
tags: [R, tools, AI, Replication]
---

# Introduction

Statistics were, I am a bit embarrassed to say, my weakest subject in high school. I barely scraped by with a passing grade, well below my average in other math classes. Depending on how different in age we are, you may remember learning how to manually calculate an ANOVA table in math class. It was detailed, meticulous, and time-consuming work. So you can probably imagine my dread as I embarked on the journey of becoming a psychiatrist (my goal at the time) and learned about all the stats courses I would need to qualify for medical school.

If so, you can perhaps also imagine my overwhelming relief when I got to the post-secondary level and was introduced to statistical software. You give it the data, it gives you the answer. You aren't reviewing the software's code line by line to verify how the C++ back-end sums squares, but the values it gives are reasonable and match what you'd find if you did it with pencil and paper. It just turns that from a several-minutes-long laborious process into something that takes less than a second.

And that's good, because later in my scholastic journey I started doing survival analysis using complex linear regression. Pencil and paper weren't even slightly realistic for me. Luckily, the statistical software packages I'd used - SAS, SPSS, Stata - could give those answers. *Unluckily*, they cost a lot of money. More money than I could justify spending for a personal copy to do my school assignments with.

So you can imagine once again my relief at being introduced to R packages. Not only was R free to run and use, but incredibly smart and generous people had gone to the trouble of writing sophisticated code that took my data, performed a pre-specified set of tasks with it, and returned useful outputs. Something that would have either cost me more than I could reasonably afford, or that would have been beyond my skill level to produce myself.

R packages are solidly integrated into open source methods in health economics. Packages like `dampack`, `bcea`, `survHE`, `flexsurv` are just some of the many open source packages that comprise key infrastructure within models built by health economists. These packages radically simplify the amount of work required to produce an economic evaluation. They can calculate results, reorganize data, and generate visualizations simply, quickly, and effectively.

In this post I discuss a technology that I think has the same transformative potential as statistical software and open source packages. This technology is built from the same basic principles, and may be the logical evolution in the production of health economic models.

# AI Skills

A common feature of the Large Language Models (LLMs) that underpin the performance of AI tools is that they are subject to a high degree of randomness. LLMs create responses using sophisticated mathematical predictions based on the context provided by the user and the underlying data that the LLM has access to. But these predictions are non-deterministic. So you can give the LLM an identical prompt 5 times, and expect 5 different answers. 

This is a function of how complicated the prompt is. Asking it "who wrote *Uncertainty and the Welfare Economics of Medical Care*?" will probably get you the exact same answer every time; asking it "who is Kenneth Arrow?" will likely not. The former is a question with only one factual answer that requires no reasoning; the latter requires the AI to guess your intent (lots of people could be named Kenneth Arrow; which one does the user mean?) and make decisions about what a helpful response would be (how do you summarize who a person *is*? When you boil it down, who *are* any of us, really?).

The random nature of AI limits its usefulness for most scientific tasks. If your R model produced different deterministic results every time you ran it, you would chuck it in the bin. Coding a model, for example, is a much more precise target to hit than pulling together some biographical info from the web. While some early tests [have shown promise](https://link.springer.com/article/10.1007/s41669-024-00477-8), the fundamental relationship between task complexity and the likelihood of hallucination or other errors remains.

In October of 2025, Anthropic introduced [a feature called 'Skills'](https://platform.claude.com/cookbook/skills-notebooks-01-skills-introduction) to supplement their AI tool called Claude. Skills are sets of instructions that equip the AI with templates, workflows, and references that guide the way the AI approaches a given query. By providing this additional context, Skills reduce the amount of 'randomness' in the way that Claude does things like write code. Users can create custom Skills with any information they deem useful. Claude will access the Skill when prompted, and will deploy the parts of the Skill that are relevant to the task at hand.

The simplest form of a Skill is a formatted Markdown document called `SKILL.MD` that has plain-language instructions for the AI to read. However, Skills are better understood as a directory that, at minimum contains `SKILL.MD` along with any number of other files. Those other files might contain examples, troubleshooting guides, reference images, and anything else that could help the AI accomplish its task according to the user's expectations.

![A screenshot of the Skills menu in Claude, showing the directory structure of the mcp-builder Skill](https://www.dropbox.com/scl/fi/9h1de8pyi3z8pm6d6ophu/Claude-skill-directory.png?rlkey=whl222jxpnd5vfg8x35x8qcos&st=wd6trkts&dl=1)

## Skills Illustrated

When Anthropic first released Skills, the example applications were things like "incorporate my branding style". The user could use a Skill to tell Claude "whenever I ask you to generate a document, I want you to use Times New Roman font, with a header that is coloured the same way as my logo, and add my business address and motto at the bottom." Providing Claude with this additional level of instruction will ensure that, regardless of the content of the document (from a manifesto to an invoice), the presentation of the final output will be similar-looking.

Going up a level of complexity, you could build a Skill that contained not only this type of instruction, but also template documents that Claude can reference before it starts building. That way if you wanted your invoices to look the same as each other, but look different from an external-facing memo, the Skill can include detailed instructions on how to build those two different documents consistently while still sharing the same style guide.

The more complex the task you're asking the AI to perform, the more powerful AI Skills become at providing "context engineering", which is a concept that is related to, but distinct from, the more familiar term "prompt engineering" ([here's a very helpful dive into this idea](https://aidesolutions.net/pub-context-engineering-why-genai-projects-fail-or-work.html)). At its most basic level, Skills provide context engineering by setting up the AI with a stepwise workflow, validation rules, and pre-fabricated solutions it can draw on when it tries to solve problems. The more solutions contained within the Skill directory, the more likely the user is to get the output they expect.

## AI: an Imprecise Genie
A classic comedy trope is the someone summoning a genie who finds a way to twist the meaning of the wish into something dark and unintended.

<iframe width="560" height="315" src="https://www.youtube.com/embed/lM0teS7PFMo?si=_qkrBltuThrYybSm&amp;start=271" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

This trope helps us understand what it is like to work with AI and Skills. Claude is the genie, and Geoff is us. It's probably important to point out that the genie in the sketch is intentionally trying to bring harm to Geoff, whereas Claude is trying its best to help. Its fatal flaw is that sometimes it tries *too hard* to be helpful, but the consequences are (usually) more benign. The core analogy still holds: there are a lot of different ways to interpret the wording of a given wish, and if the user isn't abundantly specific about their interpretation, mayhem may follow. 

In the sketch, Geoff manages to elude all of the genie's loopholes through a very careful act of prompt engineering. He crafts the perfect set of preconditions and guardrails to remove any possibility that the wish could be interpreted in any way besides how Geoff intends. Despite the genie's tendency to create mischief, it is forced to concede that the phrasing of Geoff's wish is airtight and will have no unintended consequences.

Then Geoff wishes for "that", comically undoing his own meticulous safeguards.

A Skill, in the context of this analogy, would be if Geoff handed the notebook with the instructions to the genie as a standard set of disclaimers any times he asks for money. In this retelling of the story, Geoff could go back to the genie for money again and again, without having to go through the same elaborate ritual every time. He could wish for "that", and since "that" has been specifically defined by the Skill, the loophole in the sketch would close. The genie has its instructions, and won't deviate from the guardrails. Geoff can reasonably expect that, whatever fluctuations the genie might throw at him, it won't be any of the bad outcomes on the list.

## Using a Skill

A typical interaction between a user and Claude (or any AI) involves the user inputting a prompt - a question, an instruction, an idea - into a chat box. Claude analyses the prompt and algorithmically generates a response. The nature of the response is a product of the nature of the prompt, any previous instructions given by the user, and Claude’s underlying programming. Identical prompts may yield different responses. Claude may therefore be understood as a highly talented but naive assistant who needs detailed explanation to perform even simple tasks consistently. The role of the user is to provide that explanation and then to inspect Claude’s work and to challenge its assumptions. Active and thoughtful engagement by the user is a critical part of developing any code in Claude.

##### Figure 1 - Using the Claude interface

![The Claude AI chat interface](https://www.dropbox.com/scl/fi/j5l8f7i95a3yyte1efqvx/Claude-interface.png?rlkey=hxirykw7dew04xepwt5jnoxyk&st=nymhyu7q&dl=1)

Loading a Skill in Claude is even more straightforward than loading a package in R. It could be as easy as dragging and dropping a .zip file containing the Skill directory into your Claude chat window. Or if you have an account you can equip Claude with whatever Skills you want in the 'Customize' window.

![A screenshot of the Customize window in the Claude web interface](https://www.dropbox.com/scl/fi/pjrb3r8bpwomownkc3fjf/Claude-Skill-Load-Window.png?rlkey=bubss386u2kgumsu96i6xc0sb&st=d2uudt67&dl=1)

Then you just ask Claude, in plain language, to use the Skill to do the thing you want it to do. Claude reads the contents of the Skill, starting with the `SKILL.MD` file and then responds to the user's query with the context of the Skill in its working memory.

# Skills vs. Packages

People familiar with R may find it helpful to consider Skills in Claude as being analogous to packages in R. Both are detailed sets of instructions that allow the computer to execute complex sequences of commands in pre-defined order. Both can be uploaded to allow an indefinite number of users to access them, and can be updated (and version managed) [using tools like Github](https://github.com/anthropics/skills).  Multiple Skills or packages could be built to accomplish the same desired objective (the same way that `dampack` and `bcea` will both perform cost-effectiveness analysis, albeit slightly differently).

##### Table 1: R Packages and Claude Skills - Similarities and Differences

![A table describing the similarities and differences between R Packages and Claude Skills across difference attributes](https://www.dropbox.com/scl/fi/swrveh3o8omlfseh0e8yo/Skills-vs-Packages.png?rlkey=mo4dghgun9sdjggu3a45oeul4&st=svv6a2io&dl=1)

Where these two approaches differ is in the flexibility of inputs and the consistency of outputs. Skills are highly adaptable to different data structures, model types, function syntax, and any other number of characteristics that are expected to vary from one model to another. Packages, by way of contrast, require data to be organized in ways that are specific to their design. A package that requires a dataframe with named columns will not accept data in any other format (e.g., a matrix with a vector of column names). 

A Skill is a set of natural language instructions and reference files that the AI uses as general guidance. Unless the Skill specifically tells the AI not to accept data in anything other than the desired format, the AI will attempt to find a way to convert the user's input into what the Skill says is the desired output.

This flexibility of inputs also introduces variability in what AI generates. While the output of a package will be 100% identical if given identical inputs (save for the generation of unseeded random numbers), the random nature of AI means that consistent prompting using a consistent dataset will nevertheless produce non-identical outputs. When a Skill is applied, the variability in outputs will be *reduced* but cannot be *eliminated*.

# Potential of AI Skills in Building Open Models

In order to build a useful model, you need to train to become a competent health economist. This means becoming comfortable with concepts like competing risk, net present value, first- versus second-order uncertainty, and a number of other topics that aren't really fun to talk about at parties. 

In order to build that model in R, you need to train to become a competent coder. This means sorting through punishingly specific syntax requirements that differ between packages while addressing vague error messages and trying to decipher Stack Overflow threads.

In order to make that R model open source, you need to train to become a competent software developer. This means learning and fitting norms and practices from a community who largely expects people to know things like "what a gitignore file does" and to not be nervous when they open up the Terminal.

These are three separate hills to climb. Among the other perceived barriers to adopting open source model methods, we can't ignore the fact that building open source models is a *lot* of work. While the benefits of open models are undeniable, they are also ephemeral and distant compared to the very real present-time cost barrier. I certainly don't have to explain the nature of this trade-off to health economists.

Skills have the potential to be transformative in the same way that statistical software or R packages were. Skills allow an AI to take an incredibly flexible array of inputs and use a predictable process to produce a consistent output. This gives them the potential to dramatically reduce how steep a climb any (and possibly all) of these hills are. They can undoubtedly speed up mundane and routine tasks like converting data from one form to another - something that is almost always necessary and almost always a total drag.

The value proposition shifts dramatically when a technological advance allows us to speed up processes that otherwise were a drag. Skills, like packages, could profoundly reduce the time and effort needed to perform complex tasks in health technology assessment. Insofar as that time and effort is what is holding us back from making the open source transition, Skills could help health economists reduce task timelines from months to days to minutes, fundamentally changing the cost/benefit ratio.

But beyond questions of opportunity cost, Skills seem to fit the general ethos of open source. Shareability is a fundamental feature of how they work, and one of the first skills Anthropic introduced was a "Skill Builder" skill, meaning that every Claude user using any Skill benefits from their open source nature. They are also incredibly easy (and legit kind of fun) to build - you just have some conversations with the computer and it goes to work. This accessibility dramatically widens the pool of people who can contribute directly to building models.

# Ethical Considerations

Skills have power that is *way* out of scale with how simple they are to create.  They are relatively new within the field of publicly available AI, which itself is a relatively new field. In the 6 months since Anthropic introduced Skills, Claude has undergone two version updates - each of which made Claude noticeably more helpful. The technology is rapidly improving and I expect there will be many others who see the potential that Skills offer. Whatever the future holds, my assessment is that *today's* AI technology is capable of living up to its most basic hype when it comes to increasing productivity, and Skills seem poised to be a key component of harnessing it for use in health economics.

Reducing task timelines from months to days to minutes is not an unvarnished good. A reduction in labour cost is accompanied by a corresponding reduction in the need for labour. That materializes in the form of less demand for health economists who have invested the time and energy it takes to specialize in things like R. Arguably, if Skills become powerful enough, they could reduce the labour demand for *a lot* of things health economists are currently being paid to do. I don't think they're particularly far off. Whether that materializes as fewer health economics jobs is going to heavily depend on whether health economists find innovative ways to provide value to the health care system. Making economic evaluation easier might just mean we get to do a lot more of it!

Because Skills are built on open source architecture and benefit from its philosophical principles, I see a persuasive argument that Skills should be publicly shared in the same way and to the same extent that packages and functions are. In addition to being morally coherent, it provides a degree of transparency when someone uses a Skill that is auditable and has been validated through use rather than one that is undisclosed and bespoke. Making Skills open source creates an ecosystem in which a powerful tool can be collectively managed, maintained, and regulated by people who understand it.

That being said, I am not necessarily in favour of the benefits of public effort being used primarily to extract private profits. To put a finer point on it, I don't feel great about the idea of billion-dollar pharmaceutical companies reducing the size of their health economics teams to a couple of market access consultants equipped with a Skill that I built. I think it's reasonable to be deliberate about when and how Skills are released, to ensure that you're performing your due diligence about their impacts. I recognize that my attitude toward for-profit use of open source contributions differs from that of the mainstream open source community, who are far more laissez-faire about people monetizing their work.

Finally, I think it is worth taking this space to acknowledge a larger ethical critique about whether it is morally coherent to encourage the use of AI for *any* purpose. Given whose money is behind it, the ways it is being deployed to support war and genocide, and the profound ecological risks that come along with its infrastructure, there is a reasonable argument that ethical use of AI is a logical impossibility. I fall on the "we can use it" side, but I think health economists need to keep these valid critiques in mind as we decide how much we want to rely on this technology. I think using AI to build models as durable and reusable public goods (that don't require AI themselves) is a measured way to balance the net harms. I am also persuaded by the argument that there are disproportionate benefits of open source approaches that accrue to [Low and Middle-Income Countries (LMICs)](https://gianluca.statistica.it/books/online/r-hta/chapters/035.lmic/035.lmic). Others may strike the moral balance differently when it comes to using this technology.

## Becoming Glassy-eyed Mush People

It is an open question whether I am a better health economist today because I learned to manually calculate ANOVAs in high school rather than using software. Or whether I would be an even better health economist if I had learned to manually calculate eigenvectors or a covariance matrix rather than using R packages. I feel a lot more certain about the first one than the second one. I frequently despair at my lack of familiarity with economic methods and theory, and often find myself getting confused with concepts my colleagues take in stride. I'm doing the job, but I worry about the stuff I don't know. I don't miss calculating z-scores from tables printed in the back of a textbook.

There is a valid concern about knowledge loss that accompanies automation, particularly the way AI does it. It's unclear how much we are sacrificing when domain expertise stops being a barrier to taking on a given task. AI is capable of making so many things frictionless that there is a real risk that it renders us smooth-brained like the people in the last season of The Good Place.

<iframe width="560" height="315" src="https://www.youtube.com/embed/ey9Qh7U_PHY?si=yufKGqq4JWoJNq9y" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

I'm only sort of joking about this. As anyone who has "locked in" will tell you, there is something rewarding and beneficial about putting in effort to overcome challenges. There are lessons learned along the way that make you a more competent practitioner of your craft. Perhaps most importantly, going deep into an idea unlocks new forms of creative thinking. Using AI means we are less likely to need to "lock in", and thus it comes at the cost of those foregone benefits. The social science and neuroscience can't yet give us definitive answers about this pervasive technology that is still not fully understood even by its creators. There is every reason to think carefully and deliberately about the impact of adopting AI, lest the genie give us a nightmare version of our wish.

# An Optimistic Vision

I believe in open models for reasons I've [discussed elsewhere](https://healthyuncertainty.substack.com/p/why-i-am-for-public-models). Briefly, I think HTA can build trust with the public whose interests it seeks to serve by letting them in on what we're doing on their behalf. I think open and accessible models can be a path to getting there. We can do that by getting the public involved in [how models get built](https://healthyuncertainty.substack.com/p/open-models-and-the-patient-voice). 

There is a world where the rapid expansion of health economist's capabilities allows us to make models that can be customized to answer more questions than can be addressed by an ICER. This means building better and more credible models, helping us make better and more credible decisions. As the value of these decisions becomes apparent, the demand for economic analysis goes up. Health economists take on a more multifaceted creative role that leads to greater innovation.

There is also an interesting role for open models to play in that world when it comes to early HTA. AI use can help us build flexible and reusable models that adapt to a changing landscape. [Grand *et al.*](https://healthyuncertainty.substack.com/p/better-early-than-never) highlight that it can also help health economists build models that anticipate the eventual development of therapies, especially in rare diseases. Those models can help highlight targets for cost and efficacy even before therapies are fully developed. Further, it can identify knowledge gaps where better evidence would help lead to better decisions, guiding clinical trial design and planning.

In that world, an international collaborative agreement could exist between HTA agencies. A library of Skills could be built, maintained, and improved through use by people who understand its impacts and whose interests are aligned with the people's health. This library could function as a public good for use by researchers, decision-makers, patient advocates, and private actors alike. Models could be built, shared, reconfigured, and deployed quickly using publicly scrutinized methods with built-in validity checks.

This world also features health economists looking within other predictive disciplines to expand our repertoire of modeling approaches. Building patient-level simulations featuring interacting agents that allow us to observe the impact of queueing alongside the upstream effects of public health campaigns while getting an accurate view of the costs patients pay out-of-pocket is a level of model complexity that goes *well* beyond what health economists are doing now. But maybe not for long.

# Closing Thoughts

Whatever winds up becoming true about the future of AI and health economics, the present truth is that the technology is currently good enough to do a lot of stuff that is difficult for health economists to do. There are a lot of important conversations that should happen, and soon, about what we want that future to look like.

I did not originally choose to work with Claude out of any philosophical alignment with Anthropic. I'd heard good things about how well it handled code, and I found it much less annoying than ChatGPT. My work since then has become very Claude-centered. I am not necessarily advocating for one platform over another, but there are a lot of reasons that I am choosing to use Claude over its competitors. Chief among them is the fact that it simply works better. Skills were released after I started experimenting with Claude, but before Anthropic began achieving widespread international notoriety. Skills will not stay in the shadows for long.

If my predictions are correct and Skills are the key to AI becoming part of the day-to-day toolkit of health economics, there are profound questions about how to balance their potentially profound impact with their seductive ease of use. I believe that if we approach this thoughtfully, AI Skills can be transformative for health economics in a way that benefits patients and the public health care systems built to serve them. Whether it is a net benefit for health economists ourselves remains an open question. It's up to us to find the answer.

> Written with [StackEdit](https://stackedit.io/).
