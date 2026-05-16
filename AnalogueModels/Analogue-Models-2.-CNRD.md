---
title: Disease Analogue Models - 2. - CNRD
subtitle: Using a Claude Skill to generate five HTA-grade decision models
tags: [R, tools, AI, Decision Models]
---

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

# Introduction

I developed a Claude Skill that builds Markov models in R for cost-effectiveness analysis. I used this Skill to develop a model that considers hypothetical treatments for a fictitious disease that is structurally similar to models that would be used for HTA decision making. This post describes one such model.

# **CNRD — Chronic Neurological Relapsing Disorder** 

A lifelong psychiatric condition with recurring acute episodes, progressive metabolic complications from treatment, and sequential lines of therapy. 

 - _Real-world analogues_: schizophrenia, bipolar disorder,
   treatment-resistant depression.
  - _Structure:_ 18-state (3 × 6) quarterly Markov model, 80-year horizon, 2 arms, 3 treatment lines.

 - _Key features:_ Three coupled treatment lines with discontinuation cascade; metabolic complication progression (syndrome
   → diabetes/cardiovascular disease); line-specific relapse and adverse
   event rates; acute hospitalisation cost at model entry.

![enter image description here](https://www.dropbox.com/scl/fi/45m0sdeo8eklat7fp37ex/CNRD-Model-Schematic.png?rlkey=kh2vop6x2qjwyxd9rppsew89f&st=5d5rqqh5&dl=1)

# Cost-Effectiveness Analysis

After the model was calibrated and built, I asked Claude to generate a fictionalized cost-effectiveness report that contained all the information that someone would need if they wanted to replicate the model themselves using the Skill. That report follows.

## 1. Disease Background

Chronic Neurological Relapsing Disorder (CNRD) is a persistent psychiatric condition characterised by recurrent episodes of psychotic symptoms, cognitive impairment, and functional decline. The condition typically presents in early adulthood and follows a relapsing-remitting course, with acute episodes triggered by medication non-adherence, substance use, and psychosocial stressors. CNRD affects approximately 0.5–1.0% of the adult population, with treatment-resistant disease accounting for roughly one-third of prevalent cases.

The burden of CNRD is substantial. Patients experience recurring psychotic episodes, persistent negative symptoms, and progressive functional impairment that significantly affects quality of life, social functioning, and employment. Health state utilities in stable disease are typically in the range of 0.65–0.75, with acute relapse episodes reducing utility by 0.40–0.45. The economic burden includes direct medical costs (inpatient hospitalisations, outpatient psychiatric care, emergency department visits, and medications), as well as supported housing and community mental health services.

### 1.1 Current Treatment Landscape

The treatment of CNRD involves sequential lines of antipsychotic therapy. First-line treatment is selected from among several oral and long-acting injectable options, with response assessed after an acute stabilisation phase. Patients who achieve a clinically meaningful response continue on maintenance therapy; those who do not respond are switched to second-line and subsequently third-line regimens. Treatment discontinuation due to adverse effects (particularly metabolic syndrome and its complications) is a significant driver of treatment switching.

Two branded therapies are included in this analysis. Velonix is a novel atypical antipsychotic with a favourable metabolic profile and high response rates. Doralene is a generic first-generation antipsychotic with established efficacy but higher rates of metabolic adverse effects. Both therapies are evaluated as first-line treatments, with subsequent lines comprising mixed regimens of available agents.

## 2. Model Structure and Key Assumptions

### 2.1 Model Type and Time Horizon

A cohort-level Markov state-transition model was developed to evaluate the cost-effectiveness of Velonix versus Doralene as first-line treatment for CNRD. The model adopts a Canadian public payer perspective with an 80-year time horizon (320 quarterly cycles), reflecting the chronic, lifelong nature of the condition. Starting age is 42 years. Both costs and health outcomes are discounted at 3% per annum using mid-cycle convention.

### 2.2 Health States

The model comprises six health states within each treatment line, defined by disease control status and the presence of comorbid metabolic complications. Three treatment lines are modelled, yielding an 18-state expanded vector representation.

- **Stable (No Complications):** patients on active treatment with controlled symptoms and no metabolic comorbidities. This is the target state for treatment.
- **MetabX:** patients who develop metabolic syndrome, a common adverse effect of antipsychotic therapy characterised by weight gain, dyslipidaemia, and insulin resistance.
- **DiabX:** patients who progress from metabolic syndrome to type 2 diabetes, an irreversible complication with additional morbidity and cost.
- **CardioY:** patients who develop cardiovascular complications secondary to metabolic syndrome.
- **DiabX+CardioY:** patients with both diabetes and cardiovascular complications.
- **Dead:** absorbing state. Background mortality is age-dependent (Canadian life tables, 42% male) and increased by disease-specific and comorbidity-specific standardised mortality ratios.

### 2.3 Treatment Lines and Discontinuation Cascade

Patients enter the model at Line 1 (first-line therapy). During each cycle, patients on Lines 1 and 2 may discontinue treatment and move to the next line. Discontinuation is driven by adverse effects (primarily metabolic complications) and is modelled as a per-cycle probability that applies only during the active treatment period (cycles 1–80, i.e., the first 20 years). After cycle 80, discontinuation ceases and patients remain on their current line.

The three treatment lines for each arm are:

| Line | Velonix Arm | Doralene Arm |
|---|---|---|
| **Line 1** | Velonix | Doralene |
| **Line 2** | Mixed regimen (48% Doralene / 52% generic) | Mixed regimen (48% Doralene / 52% generic) |
| **Line 3** | Mixed regimen (33/37/30% blend) | Mixed regimen (33/37/30% blend) |

The discontinuation cascade is implemented as a coupled 18-state system: in each cycle, a proportion of alive patients on Line 1 transfer to Line 2, and similarly from Line 2 to Line 3. This coupling is modelled within a single REDUCE formula using an 18×18 block-diagonal transition matrix with off-diagonal discontinuation flows.

### 2.4 Key Structural Assumptions

Background mortality is age-dependent, using sex-weighted Canadian life tables (42% male, 58% female). Disease-specific mortality is elevated via a standardised mortality ratio (SMR) of 2.20 for CNRD, with additional SMRs of 2.00 for diabetes and 1.60 for cardiovascular complications. Metabolic syndrome develops as a treatment-related adverse effect at line-specific rates. Once metabolic complications (DiabX, CardioY) develop, they are irreversible. Relapse episodes occur at a line-specific per-cycle probability and incur acute costs and utility decrements but do not alter the Markov state.

## 3. Model Parameters

### 3.1 Treatment Response and Relapse

| Parameter | Velonix | Doralene | Line 2 | Line 3 |
|---|---|---|---|---|
| Response rate (Line 1) | 50% | 34% | 44% | — |
| Relapse probability (per cycle) | 0.10 | 0.12 | 0.11\* | 0.09\* |
| Discontinuation probability | 0.055 | 0.050 | 0.040 | — |

*\*Line 2 and 3 relapse rates are weighted averages of component regimens. PSA: Beta distribution (SE from 95% CI).*

### 3.2 Metabolic Adverse Effects

| Parameter | Velonix | Doralene | Line 2 | Line 3 |
|---|---|---|---|---|
| MetabX probability (per cycle) | 0.005 | 0.034 | 0.050\* | 0.105\* |
| DiabX \| MetabX (per cycle) | 0.011 | 0.011 | 0.011 | 0.011 |
| CardioY \| MetabX (per cycle) | 0.005 | 0.005 | 0.005 | 0.005 |

*\*Line 2 and 3 MetabX rates are weighted averages. DiabX and CardioY progression conditional on MetabX. PSA: Beta (MetabX, DiabX, CardioY).*

### 3.3 Mortality

| Parameter | Value | PSA Distribution |
|---|---|---|
| Background mortality | Canadian life tables | Fixed |
| SMR — CNRD | 2.20 | Gamma |
| SMR — Diabetes | 2.00 | Gamma |
| SMR — Cardiovascular | 1.60 | Gamma |

### 3.4 Health State Utilities

| Parameter | Value | PSA Distribution |
|---|---|---|
| Stable CNRD (no complications) | 0.710 | Utility (Gamma disutil.) |
| Disutility — MetabX | −0.055 | Gamma |
| Disutility — DiabX | −0.095 | Gamma |
| Disutility — CardioY | −0.095 | Gamma |
| Disutility — Relapse episode | −0.430 | Gamma |

### 3.5 Costs

| Parameter | Value | PSA Distribution |
|---|---|---|
| Velonix (annual) | $18,000 | Gamma |
| Doralene (annual) | $38 | Fixed |
| Stable base cost (quarterly) | $1,056 | Fixed |
| Relapse episode cost | $13,399 | Fixed |
| Acute hospitalisation (per line entry) | $30,000 | Fixed |
| DiabX management (quarterly) | $2,900 | Gamma |
| CardioY management (quarterly) | $3,700 | Gamma |

## 4. Base Case Results

### 4.1 Deterministic Analysis

Table 4.1 presents the total discounted costs, life years, and QALYs for each treatment strategy over the 80-year time horizon. Life years differ between arms because Velonix's lower metabolic complication rate results in lower excess mortality over the model horizon.

**Table 4.1. Deterministic base case results**

| Treatment | Total Cost | Total LYs | Total QALYs |
|---|---|---|---|
| **Velonix** | $348,316 | 17.6302 | 10.6480 |
| Doralene | $329,259 | 17.5176 | 10.4746 |
| *Incremental* | *$19,057* | *0.1126* | *0.1734* |

The incremental cost-effectiveness ratio of Velonix versus Doralene is **$109,903 per QALY gained**. The incremental life-year gain of 0.11 years reflects the mortality benefit from Velonix's lower metabolic complication rate over the 80-year horizon.

### 4.2 Probabilistic Sensitivity Analysis

Probabilistic sensitivity analysis was conducted with 1,000 Monte Carlo iterations. All uncertain parameters were sampled simultaneously from their specified distributions (Section 3). Table 4.2 presents the PSA mean results.

**Table 4.2. PSA mean results**

| Treatment | Mean Cost | Mean LYs | Mean QALYs |
|---|---|---|---|
| **Velonix** | $340,314 | 17.7856 | 10.8331 |
| Doralene | $319,506 | 17.6898 | 10.6661 |

PSA mean results are broadly consistent with the deterministic base case, confirming model stability. Minor differences reflect the non-linearity of the model's age-dependent mortality and coupled sub-cohort structure.

## 5. Discussion

This analysis demonstrates that Velonix offers a clinically meaningful improvement in both QALYs (+0.17) and life years (+0.11) over Doralene as first-line treatment for CNRD, at an incremental cost of approximately $19,000 over an 80-year horizon. The deterministic ICER of $109,903 per QALY places Velonix above conventional willingness-to-pay thresholds ($50,000–$100,000/QALY) but within the range considered for conditions with high unmet need.

The QALY advantage of Velonix is driven by two mechanisms. First, Velonix's higher first-line response rate (50% vs 34%) means more patients achieve stable disease control from the outset. Second, Velonix's substantially lower rate of metabolic adverse effects (MetabX probability 0.005 vs 0.034 per cycle) means fewer patients develop diabetes, cardiovascular complications, and the associated utility decrements and excess mortality. The life-year gain reflects this second mechanism: reduced comorbidity-related mortality over the 80-year horizon.

The cost difference between arms is modest ($19,057) despite Velonix's substantially higher drug cost ($18,000/year vs $38/year for Doralene). This is because Velonix patients spend less time on costly later-line regimens and incur fewer complication-related costs, partially offsetting the drug cost premium.

### 5.1 Limitations

Several limitations should be considered. The model uses a coupled 18-state structure to represent three treatment lines. Treatment switching follows a fixed cascade (Line 1 → 2 → 3) without the option of re-treatment or cross-class switching. Relapse episodes are modelled as per-cycle probability events affecting costs and utilities but do not alter the Markov state. The post-treatment-stop blending of relapse rates (cycles 81–320) uses a simplified weighted average in the PSA that omits the gradual transition modelled in the deterministic analysis. Background mortality uses the probability-scaling formula `1–(1–qx)^cycle_length`, which is the correct conversion for life table probabilities but differs from the rate-based formula used in some published R models. Finally, all parameter values are fictional and do not represent actual clinical data.

# HuncMarkovCNRD

The `huncMarkovCNRD` package is [available on Github](https://github.com/HealthyUncertainty/huncMarkovCNRD). 

A modifiable Shiny app can be found here.

### _AI Use Disclaimer_
_The near entirety of this post was written by Claude AI. The two small sections in which I speak in the first person are written by me._

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

> Written with [StackEdit](https://stackedit.io/).
