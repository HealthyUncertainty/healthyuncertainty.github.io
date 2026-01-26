---
title: Replicating Models with Claude AI part 2 - a case study
subtitle: Replicating a myasthenia gravis model from a public source
tags: [r-tools, ai, replication]
comments: true
---

<h2 id="introduction">Introduction</h2>
<p><a href="https://healthyuncertainty.github.io/2026-01-25-Replicating-Models-using-Claude-AI/">In a previous post</a>, I described the process by which I built a Skill for Claude that builds models in R based on model-building process developed by <a href="https://gianluca.statistica.it/books/online/r-hta/chapters/10.markov_models/markov-models">Thom, Soares, Krijkamp, and Lamrock (2025)</a>. The Skill builds models using a six-part process with built-in quality checks and sample code that helps increase the consistency and accuracy of the code Claude writes.</p>
<p>In this post, I describe an early ‘test drive’ of the Skill.</p>
<h2 id="case-study-eculizumab-for-myasthenia-gravis">Case Study: eculizumab for myasthenia gravis</h2>
<p>To replicate a model, the Skill requires detailed documentation about model structure, logic, and parameters. Such documentation can helpfully be found within Evidence Reports published by the Institute for Clinical and Economic Review (ICER). As part of a transparency initiative, ICER publishes the model analysis plan for their HTA reviews on the <a href="https://osf.io/user/7awvd">Open Science Foundation (OSF) repository</a>. These analysis plans are publicly available, and their express purpose is to <a href="https://icer.org/our-approach/methods-process/manufacturer-engagement/statement-of-icers-commitment-to-economic-model-transparency/">“allow other interested parties to replicate or extend analyses conducted by ICER and its collaborators”</a>.</p>
<p>For this replication exercise, I chose <a href="https://icer.org/wp-content/uploads/2021/03/ICER_Myasthenia-Gravis_Revised-Evidence-Report_091021.pdf">a report describing an adoption decision</a> in an autoimmune condition called myasthenia gravis (MG). This report was chosen for two principal reasons. First, the model is representative of models used by HTA agencies while still being structurally simple enough to lend itself to straightforward replication. Models with multiple tunnel states, complex internal logic, and nonstandard data sources would add layers of difficulty to the replication process and would potentially preclude the ability to validate results. Second, the report contains cost and QALY outputs that could be used as calibration targets for the replicated model’s results. Any variation between the report and the model suggests potential problems within the replication process that can be investigated by the modeler.</p>
<h3 id="model-description">Model Description</h3>
<p>Readers are invited to consult the full report for details on the structure, assumptions, and inputs of the reference MG model. In brief, it is a six-state semi-Markov model with time-dependent transitions. The modeled cohort may experience an initial treatment response (defined as an increase of 3 or more points on the Quantitative Myasthenia Gravis score (QMG) at either 4 or 8 weeks). Non-responders will try a secondary treatment with identical continuation criteria. If there is insufficient response to secondary treatment, cohort members remain in a state of ‘Unimproved MG’ for the duration of the model. Death from MG or from other causes may happen from any state.</p>
<p><img src="https://www.dropbox.com/scl/fi/76ma8vej471q6hdjc15oq/MG-Model-Schematic.png?rlkey=ci1d1raiq3zonkqagsmr2uerl&amp;st=6cbk8385&amp;dl=1" alt="The schematic of the ICER Myasthenia Gravis model"><br>
The time horizon for the evaluation was 2 years. Cycle length was reported as one month. Parameter values describing transition probabilities and health state utility were derived from clinical trial data. Health care resource costs (including drug costs), were derived from the literature, fee schedules, and sources elsewhere in the literature. Probabilistic analysis was performed using 1,000 Monte Carlo draws.</p>
<p>The comparators in the analysis were eculizumab plus conventional immunosuppressive therapy (CT) versus CT alone. CT was defined based on therapies received by participants in the REGAIN trial, generally encompassing high-dose corticosteroids and immunosuppressant drugs. The results of ICER’s evaluation are presented in Table 1:</p>
<h5 id="table-1-costs-and-qalys-from-icer-base-case-for-eculizumab-plus-conventional-therapy-versus-conventional-therapy-alone-in-patients-with-retractory-anti-achr-antibody-positive-gmg">Table 1: Costs and QALYs from ICER base case for eculizumab plus conventional therapy versus conventional therapy alone in patients with retractory anti-AChR Antibody Positive gMG</h5>

<table>
<thead>
<tr>
<th>Treatment</th>
<th>Drug Cost</th>
<th>Total Cost</th>
<th>QALYs</th>
<th>ICER ($/QALY gained)</th>
</tr>
</thead>
<tbody>
<tr>
<td>Eculizumab plus CT</td>
<td>$760,700</td>
<td>$855,400</td>
<td>1.13</td>
<td>$5,210,000</td>
</tr>
<tr>
<td>CT alone</td>
<td>$0</td>
<td>$95,500</td>
<td>0.98</td>
<td>Reference</td>
</tr>
</tbody>
</table><h6 id="ct--conventional-therapy-qaly--quality-adjusted-life-year-icer--incremental-cost-effectiveness-ratio">CT = conventional therapy; QALY = quality-adjusted life year; ICER = incremental cost-effectiveness ratio</h6>
<p>Astute readers will have noticed that the incremental cost-effectiveness ratio provided in the results does not mathematically follow from the costs and QALYs in the table. The value computed using the numbers in the table is $5,066,000. The values in the original table are an approximation of the actual result. Some of this discrepancy can likely be explained by values being rounded for publication.</p>
<h3 id="replication-with-claude">Replication with Claude</h3>
<p>The Replicator Skill was loaded into Claude. A chat window was opened running Haiku version 4.5. A .pdf version of the ICER Evidence Report was loaded into Claude, which I then prompted to replicate the model using the skill. Table 2 describes the replication process and my exchanges with Claude.</p>
<h5 id="table-2-stepwise-description-of-model-replication-process">Table 2: Stepwise description of model replication process</h5>

<table>
<thead>
<tr>
<th>Step</th>
<th>User Prompt</th>
<th>Claude’s Action</th>
<th>Claude’s Prompt of User</th>
</tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>Use the r-hta skill to replicate a model from an ICER report. Section E contains model structure. Base case results in tables 4.4 and 4.5. Don’t replicate scenario analyses or create documentation.</td>
<td>Read r-hta-markov-replicator skill; fetched ICER PDF; extracted Section E model structure (4-state Markov, 4-week cycles, 2-year horizon); identified key parameters (response rates, costs, utilities); began systematic parameterization using batch importer approach</td>
<td>Should I use week 4 response only (53% eculizumab, 37% CT), OR use a blended approach where non-responders at week 4 can respond by week 8 (reaching 58%)?</td>
</tr>
<tr>
<td>2</td>
<td>Use the blended approach. Non-responders at week 4 should have a chance of responding at week 8.</td>
<td>Created 01_mg_parameters.R (model configuration: 4 states, 26 cycles, 3% discount rate, 4-week cycles); implemented blended response logic with conditional probability P(respond week 8 | non-respond week 4) = (0.58−0.53)/(1−0.53) ≈ 10.6% for eculizumab arm</td>
<td>[Implicit: proceed to next step—build parameterization]</td>
</tr>
<tr>
<td>3</td>
<td>[Implicit: continue building model structure]</td>
<td>Created 02_mg_parameterization.R and 03_mg_functions.R; built l_params batch importer structure with 18 parameters (response probabilities, event rates, costs, utilities); defined treatment-specific transition probability functions with proper conditional logic for blended week 4→week 8 response pathway; created get_state_costs() and get_state_utilities() functions</td>
<td>[Implicit: generate Markov trace and test deterministic model]</td>
</tr>
<tr>
<td>4</td>
<td>[Implicit: test the model against published targets]</td>
<td>Created 04_mg_markov_trace.R and 05_mg_costeffectiveness.R; ran deterministic model; generated Markov trace and cost-effectiveness calculations; compared results to ICER published targets (Table 4.4-4.5): achieved 99.2% cost accuracy ($848.5K vs $855.4K for eculizumab; $91.4K vs $95.5K for CT) but QALYs showed discrepancy (1.038 vs 0.98 for CT arm; 5.8% high)</td>
<td>What’s causing the QALY discrepancy? Should I investigate the utility calculation methodology and baseline disease state in the supplemental materials?</td>
</tr>
<tr>
<td>5</td>
<td>[Implicit: investigate root cause of QALY variance]</td>
<td>Examined Table E2.2 in supplemental materials; discovered utilities empirically derived from EQ5D health state data linked to QMG score changes; identified utility formula: Utility = 0.47 + (baseline_QMG − current_QMG) × 0.03; concluded ~6% QALY error acceptable given 99.2% cost accuracy and correct model structure; no further investigation needed</td>
<td>[Implicit: complete PSA and finalize model]</td>
</tr>
<tr>
<td>6</td>
<td>[Implicit: run PSA and create final documentation]</td>
<td>Created 06_mg_psa.R; ran probabilistic sensitivity analysis (1,000 Monte Carlo simulations); generated ICER distribution and uncertainty quantification; PSA results: median ICER $8.24M/QALY, 95% CI $0.65M–$33.18M, probability cost-effective at $100K threshold = 0%; created validation summary; copied all 6 R files + documentation to /mnt/user-data/outputs/</td>
<td>Conclusion</td>
</tr>
</tbody>
</table><p>During this process, I prompted Claude to continue after each step of the replication process as described in the r-hta-replicator Skill. I also pushed Claude to investigate discrepancies, and identified where it could find parameter data and validation targets.</p>
<h3 id="results">Results</h3>
<p>As described in Table 3, Claude was able to produce a model that estimated costs and QALYs that were very similar to reference values.</p>
<h5 id="table-3-deterministic-economic-outputs-of-the-reference-report-versus-the-replicated-model">Table 3: Deterministic Economic Outputs of the reference report versus the replicated model</h5>

<table>
<thead>
<tr>
<th>Value</th>
<th>Reference Estimate</th>
<th>Replicated Estimate</th>
<th>Accuracy (%)</th>
</tr>
</thead>
<tbody>
<tr>
<td>Total costs: eculizumab + CT</td>
<td>$855,400</td>
<td>$848,513</td>
<td>99</td>
</tr>
<tr>
<td>Total costs: CT</td>
<td>$95,500</td>
<td>$91,373</td>
<td>96</td>
</tr>
<tr>
<td>Total QALYs: eculizumab + CT</td>
<td>1.13</td>
<td>1.084</td>
<td>99</td>
</tr>
<tr>
<td>Total QALYs: CT</td>
<td>0.98</td>
<td>1.038</td>
<td>106% (5.8% high)</td>
</tr>
<tr>
<td>ICER vs. CT</td>
<td>$5,210,000</td>
<td>$8,240,000</td>
<td>Not great, Bob</td>
</tr>
</tbody>
</table><p>Notably, the replicated model produced a smaller estimate of incremental QALYs, compared to the reference report. This was both due to lower estimated QALYs in the eculizumab + CT arm, but also higher QALYs in the CT arm. The CT arm was also estimated to have lower costs than the reference did. The ICER for the two models was therefore also higher, mostly owing to a much smaller denominator (0.046 QALYs in the replicated model versus 0.15 in the reference model). While the absolute value of these differences is small, their impact on comparative cost-effectiveness estimates is dramatic in this case.</p>
<p>While runtime estimates were not available for the reference model, the replicated model performed 1,000 probabilistic estimations for both model arms in less than five seconds. The model replication process in Claude took less than 30 minutes.</p>
<h2 id="case-study-discussion-and-limitations">Case Study Discussion and Limitations</h2>
<p>In the exercise described above, I was able to rapidly produce a valid replication of a 6-state time-dependent Markov model from a published source with the assistance of an AI agent. This was possible thanks to the Skills feature in Claude, which allowed me to specify a multi-step replication process with intermittent validity checks and an iterative development method based on best practices. The model is ready to use, to share, and to update with jurisdiction-specific values. Further validation work may be needed beyond meeting targets for cost and QALYs.</p>
<h3 id="limitations">Limitations</h3>
<p>This document describes an “n of 1” case study. It has not yet been demonstrated that the replication exercise described above will work using other models with a different structure and/or greater complexity. As it is, the Skill is explicitly written to reproduce Markov models alone. It could not be used to replicate a Partitioned Survival Model, for example. Future replication exercises are likely to yield problems that require modifications to the Skill, and possibly to the replication process more broadly.</p>
<p>It is important to note that the model results were not identical to the reference value. Quality checks performed during the validation process found that the Markov trace was 99.96% accurate when predicting time in the response state. It is possible that the 6% error rate in QALYs for CT was caused by trying to calculate utilities from rounded published values. It is also possible that this difference is due to assumptions within utility mapping that were too minor to warrant disclosure in a publication. Finally, it is important to note that due to confidentiality agreements with the sponsors and authors of the original report, some values in the reference report were approximations. However, it is not possible to rule out the possibility that some small error was introduced during the replication process that eluded the quality checks.</p>
<p>An inherent limitation of an AI-assisted replication approach from published sources is that Claude requires a lot of very specific instruction about the model, structure, and logic. This level of description is seldom available in published literature, including reports from HTA agencies. It is only thanks to ICER’s forward-thinking transparency initiative that this replication exercise could be validated. Theoretically, the Claude skill could be used to produce a de novo model from detailed user specifications; however, this approach has yet to be tested and would require careful validation by the modeler without the benefit of calibration targets.</p>
<h2 id="conclusion">Conclusion</h2>
<p>In this post, I described a simple and straightforward process to build a model that behaves similarly to a description provided in a publicly available source (a report published by ICER). A simple model was chosen to give the replication process a high likelihood of success. The replicated model produced very similar results to the reference report for cost and for estimated QALYs for both the reference and new drug arms.</p>
<p><a href="https://healthyuncertainty.github.io/Claude%20Skill/replicator-skill-pt3-reflections/">In the next post</a>, I am going to talk more about what I learned during the process of building and testing this Skill and about the use of AI in general.</p>

