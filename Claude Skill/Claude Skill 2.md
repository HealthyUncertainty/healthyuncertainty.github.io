
# Using the r-hta-markov-replicator Skill; Case Study 1: myasthenia gravis

## Introduction

In a previous post, I described the process by which I built a Skill for Claude that builds models in R based on model-building process developed by [Thom, Soares, Krijkamp, and Lamrock (2025)](https://gianluca.statistica.it/books/online/r-hta/chapters/10.markov_models/markov-models). The Skill builds models using a six-part process with built-in quality checks and sample code that helps increase the consistency and accuracy of the code Claude writes.

In this post, I describe an early 'test drive' of the Skill.

## Case Study: eculizumab for myasthenia gravis

To replicate a model, the Skill requires detailed documentation about model structure, logic, and parameters. Such documentation can helpfully be found within Evidence Reports published by the Institute for Clinical and Economic Review (ICER). As part of a transparency initiative, ICER publishes the model analysis plan for their HTA reviews on the [Open Science Foundation (OSF) repository](https://osf.io/user/7awvd). These analysis plans are publicly available, and their express purpose is to [“allow other interested parties to replicate or extend analyses conducted by ICER and its collaborators”](https://icer.org/our-approach/methods-process/manufacturer-engagement/statement-of-icers-commitment-to-economic-model-transparency/).

  

For this replication exercise, I chose [a report describing an adoption decision](https://icer.org/wp-content/uploads/2021/03/ICER_Myasthenia-Gravis_Revised-Evidence-Report_091021.pdf) in an autoimmune condition called myasthenia gravis (MG). This report was chosen for two principal reasons. First, the model is representative of models used by HTA agencies while still being structurally simple enough to lend itself to straightforward replication. Models with multiple tunnel states, complex internal logic, and nonstandard data sources would add layers of difficulty to the replication process and would potentially preclude the ability to validate results. Second, the report contains cost and QALY outputs that could be used as calibration targets for the replicated model’s results. Any variation between the report and the model suggests potential problems within the replication process that can be investigated by the modeler.

### Model Description
Readers are invited to consult the full report for details on the structure, assumptions, and inputs of the reference MG model. In brief, it is a six-state semi-Markov model with time-dependent transitions. The modeled cohort may experience an initial treatment response (defined as an increase of 3 or more points on the Quantitative Myasthenia Gravis score (QMG) at either 4 or 8 weeks). Non-responders will try a secondary treatment with identical continuation criteria. If there is insufficient response to secondary treatment, cohort members remain in a state of ‘Unimproved MG’ for the duration of the model. Death from MG or from other causes may happen from any state.

![The schematic of the ICER Myasthenia Gravis model](https://www.dropbox.com/scl/fi/76ma8vej471q6hdjc15oq/MG-Model-Schematic.png?rlkey=ci1d1raiq3zonkqagsmr2uerl&st=6cbk8385&dl=1)
The time horizon for the evaluation was 2 years. Cycle length was reported as one month. Parameter values describing transition probabilities and health state utility were derived from clinical trial data. Health care resource costs (including drug costs), were derived from the literature, fee schedules, and sources elsewhere in the literature. Probabilistic analysis was performed using 1,000 Monte Carlo draws.

  

The comparators in the analysis were eculizumab plus conventional immunosuppressive therapy (CT) versus CT alone. CT was defined based on therapies received by participants in the REGAIN trial, generally encompassing high-dose corticosteroids and immunosuppressant drugs. The results of ICER’s evaluation are presented in Table 1:

##### Table 1: Costs and QALYs from ICER base case for eculizumab plus conventional therapy versus conventional therapy alone in patients with retractory anti-AChR Antibody Positive gMG
| Treatment          | Drug Cost | Total Cost | QALYs | ICER ($/QALY gained) |
| ------------------ | --------- | ---------- | ----- | -------------------- |
| Eculizumab plus CT | $760,700  | $855,400   | 1.13  | $5,210,000           |
| CT alone           | $0        | $95,500    | 0.98  | Reference            |
###### CT = conventional therapy; QALY = quality-adjusted life year; ICER = incremental cost-effectiveness ratio

Astute readers will have noticed that the incremental cost-effectiveness ratio provided in the results does not mathematically follow from the costs and QALYs in the table. The value computed using the numbers in the table is $5,066,000. The values in the original table are an approximation of the actual result. Some of this discrepancy can likely be explained by values being rounded for publication.

### Replication with Claude

The R-HTA Replicator Skill was loaded into Claude. A chat window was opened running Haiku version 4.5. A .pdf version of the ICER Evidence Report was loaded into Claude, which I then prompted to replicate the model using the skill. Table 2 describes the replication process and my exchanges with Claude.

##### Table 2: Stepwise description of model replication process

| Step | User Prompt                                                                                                                                                                                           | Claude's Action                                                                                                                                                                                                                                                                                                                                                                 | Claude's Prompt of User                                                                                                                                    |
| ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1    | Use the r-hta skill to replicate a model from an ICER report. Section E contains model structure. Base case results in tables 4.4 and 4.5. Don't replicate scenario analyses or create documentation. | Read r-hta-markov-replicator skill; fetched ICER PDF; extracted Section E model structure (4-state Markov, 4-week cycles, 2-year horizon); identified key parameters (response rates, costs, utilities); began systematic parameterization using batch importer approach                                                                                                        | Should I use week 4 response only (53% eculizumab, 37% CT), OR use a blended approach where non-responders at week 4 can respond by week 8 (reaching 58%)? |
| 2    | Use the blended approach. Non-responders at week 4 should have a chance of responding at week 8.                                                                                                      | Created 01_mg_parameters.R (model configuration: 4 states, 26 cycles, 3% discount rate, 4-week cycles); implemented blended response logic with conditional probability P(respond week 8 \| non-respond week 4) = (0.58−0.53)/(1−0.53) ≈ 10.6% for eculizumab arm                                                                                                               | [Implicit: proceed to next step—build parameterization]                                                                                                    |
| 3    | [Implicit: continue building model structure]                                                                                                                                                         | Created 02_mg_parameterization.R and 03_mg_functions.R; built l_params batch importer structure with 18 parameters (response probabilities, event rates, costs, utilities); defined treatment-specific transition probability functions with proper conditional logic for blended week 4→week 8 response pathway; created get_state_costs() and get_state_utilities() functions | [Implicit: generate Markov trace and test deterministic model]                                                                                             |
| 4    | [Implicit: test the model against published targets]                                                                                                                                                  | Created 04_mg_markov_trace.R and 05_mg_costeffectiveness.R; ran deterministic model; generated Markov trace and cost-effectiveness calculations; compared results to ICER published targets (Table 4.4-4.5): achieved 99.2% cost accuracy ($848.5K vs $855.4K for eculizumab; $91.4K vs $95.5K for CT) but QALYs showed discrepancy (1.038 vs 0.98 for CT arm; 5.8% high)       | What's causing the QALY discrepancy? Should I investigate the utility calculation methodology and baseline disease state in the supplemental materials?    |
| 5    | [Implicit: investigate root cause of QALY variance]                                                                                                                                                   | Examined Table E2.2 in supplemental materials; discovered utilities empirically derived from EQ5D health state data linked to QMG score changes; identified utility formula: Utility = 0.47 + (baseline_QMG − current_QMG) × 0.03; concluded ~6% QALY error acceptable given 99.2% cost accuracy and correct model structure; no further investigation needed                   | [Implicit: complete PSA and finalize model]                                                                                                                |
| 6    | [Implicit: run PSA and create final documentation]                                                                                                                                                    | Created 06_mg_psa.R; ran probabilistic sensitivity analysis (1,000 Monte Carlo simulations); generated ICER distribution and uncertainty quantification; PSA results: median ICER $8.24M/QALY, 95% CI $0.65M–$33.18M, probability cost-effective at $100K threshold = 0%; created validation summary; copied all 6 R files + documentation to /mnt/user-data/outputs/           | Conclusion                                                                                                                                                 |
 

During this process, I prompted Claude to continue after each step of the replication process as described in the r-hta-replicator Skill. I also pushed Claude to investigate discrepancies, and identified where it could find parameter data and validation targets.

### Results

As described in Table 3, Claude was able to produce a model that estimated costs and QALYs that were very similar to reference values.

##### Table 3: Deterministic Economic Outputs of the reference report versus the replicated model

| Value                        | Reference Estimate | Replicated Estimate | Accuracy (%)     |
| ---------------------------- | ------------------ | ------------------- | ---------------- |
| Total costs: eculizumab + CT | $855,400           | $848,513            | 99               |
| Total costs: CT              | $95,500            | $91,373             | 96               |
| Total QALYs: eculizumab + CT | 1.13               | 1.084               | 99               |
| Total QALYs: CT              | 0.98               | 1.038               | 106% (5.8% high) |
| ICER vs. CT                  | $5,210,000         | $8,240,000          | Not great, Bob   |

  

Notably, the replicated model produced a smaller estimate of incremental QALYs, compared to the reference report. This was both due to lower estimated QALYs in the eculizumab + CT arm, but also higher QALYs in the CT arm. The CT arm was also estimated to have lower costs than the reference did. The ICER for the two models was therefore also higher, mostly owing to a much smaller denominator (0.046 QALYs in the replicated model versus 0.15 in the reference model). While the absolute value of these differences is small, their impact on comparative cost-effectiveness estimates is dramatic in this case.

While runtime estimates were not available for the reference model, the replicated model performed 1,000 probabilistic estimations for both model arms in less than five seconds. The model replication process in Claude took less than 30 minutes.

## Case Study Discussion and Limitations

In the exercise described above, I was able to rapidly produce a valid replication of a 6-state time-dependent Markov model from a published source with the assistance of an AI agent. This was possible thanks to the Skills feature in Claude, which allowed me to specify a multi-step replication process with intermittent validity checks and an iterative development method based on best practices. The model is ready to use, to share, and to update with jurisdiction-specific values. Further validation work may be needed beyond meeting targets for cost and QALYs.

### Limitations

This document describes an “n of 1” case study. It has not yet been demonstrated that the replication exercise described above will work using other models with a different structure and/or greater complexity. As it is, the Skill is explicitly written to reproduce Markov models alone. It could not be used to replicate a Partitioned Survival Model, for example. Future replication exercises are likely to yield problems that require modifications to the Skill, and possibly to the replication process more broadly.
  
It is important to note that the model results were not identical to the reference value. Quality checks performed during the validation process found that the Markov trace was 99.96% accurate when predicting time in the response state. It is possible that the 6% error rate in QALYs for CT was caused by trying to calculate utilities from rounded published values. It is also possible that this difference is due to assumptions within utility mapping that were too minor to warrant disclosure in a publication. Finally, it is important to note that due to confidentiality agreements with the sponsors and authors of the original report, some values in the reference report were approximations. However, it is not possible to rule out the possibility that some small error was introduced during the replication process that eluded the quality checks.

An inherent limitation of an AI-assisted replication approach from published sources is that Claude requires a lot of very specific instruction about the model, structure, and logic. This level of description is seldom available in published literature, including reports from HTA agencies. It is only thanks to ICER’s forward-thinking transparency initiative that this replication exercise could be validated. Theoretically, the Claude skill could be used to produce a de novo model from detailed user specifications; however, this approach has yet to be tested and would require careful validation by the modeler without the benefit of calibration targets.

## Conclusion

In this post, I described a simple and straightforward process to build a model that behaves similarly to a description provided in a publicly available source (a report published by ICER). A simple model was chosen to give the replication process a high likelihood of success. The replicated model produced very similar results to the reference report for cost and for estimated QALYs for both the reference and new drug arms.

In the next post, I am going to talk more about what I learned during the process of building and testing this Skill and about the use of AI in general.
