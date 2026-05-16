---
title: Disease Analogue Models - 5. - CISS
subtitle: Using a Claude Skill to generate five HTA-grade decision models
tags: [R, tools, AI, Decision Models]
---

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

# Introduction

I developed a Claude Skill that builds Markov models in R for cost-effectiveness analysis. I used this Skill to develop a model that considers hypothetical treatments for a fictitious disease that is structurally similar to models that would be used for HTA decision making. This post describes one such model.

## **CISS — Chronic Immune Skin Syndrome** 
A chronic relapsing inflammatory skin condition treated with a range of targeted oral and injectable therapies assessed against supportive care. 

 - _Real-world analogues_: psoriasis, atopic dermatitis, hidradenitis suppurativa.
 - _Structure:_ 5-state 16-week cycle Markov model, 5-year horizon, 6 arms, 17 cycles.
 - _Key features:_ Distinct induction and maintenance phases with structurally different transition matrices; treatment-specific
   response rates across three response levels; time-varying
   discontinuation rates (year 1 vs year 2+)

![This model is split into induction and maintenance phases with different response rates (low, moderate, high, non-responder)](https://www.dropbox.com/scl/fi/pls79eg3v0zg1jzki9z86/CISS-diagram.png?rlkey=n92t3d4y74bl1cwbz17w20kwi&st=8q534tk6&dl=1)

# Cost-Effectiveness Analysis

After the model was calibrated and built, I asked Claude to generate a fictionalized cost-effectiveness report that contained all the information that someone would need if they wanted to replicate the model themselves using the Skill. That report follows.

## 1. Disease Background

Chronic Immune Skin Syndrome (CISS) is a chronic, relapsing inflammatory skin condition characterised by widespread erythematous plaques, intense pruritus, and impaired skin barrier function. The condition typically presents in early adulthood and follows a waxing-and-waning course, with flares triggered by environmental factors, stress, and immune dysregulation. CISS affects approximately 2–5% of the adult population, with moderate-to-severe disease accounting for roughly one-third of prevalent cases.

The burden of moderate-to-severe CISS is substantial. Patients experience persistent itch, sleep disruption, and visible skin involvement that significantly impairs quality of life, social functioning, and work productivity. Health state utilities in uncontrolled disease are typically in the range of 0.55–0.65, comparable to other chronic disabling conditions. The economic burden includes direct medical costs (outpatient visits, prescription medications, hospitalisations for severe flares), as well as indirect costs from reduced productivity, though the present analysis adopts a direct-cost payer perspective.

### 1.1 Current Treatment Landscape

The treatment of moderate-to-severe CISS has been transformed in recent years by the introduction of targeted therapies, including Janus kinase (JAK) inhibitors and monoclonal antibodies directed against key cytokines in the inflammatory cascade. Prior to these therapies, patients were managed with topical corticosteroids, phototherapy, and conventional systemic immunosuppressants — collectively referred to as best supportive care (BSC). BSC remains the relevant comparator for economic evaluation, as it represents the treatment pathway for patients who are not candidates for, or who have not yet received, targeted therapy.

Five targeted therapies are included in this analysis. Three are oral JAK inhibitors (Dravokimab, Barisetinib, Uvestinib), which offer the convenience of oral administration but carry class-specific safety considerations including potential cardiovascular and thromboembolic risks. Two are subcutaneous monoclonal antibodies (Tremacept, Dorilumab), which require injection training and periodic self-administration but have a favourable long-term safety profile. All five therapies have demonstrated superiority over BSC in randomised controlled trials, with varying response rates and durability of effect.

## 2. Model Structure and Key Assumptions

### 2.1 Model Type and Time Horizon

A cohort-level Markov state-transition model was developed to evaluate the cost-effectiveness of six treatment strategies for moderate-to-severe CISS. The model adopts a US payer perspective with a 5-year time horizon, reflecting the chronic but manageable nature of the condition. Cycles are 16 weeks in length, corresponding to the standard clinical assessment interval in pivotal trials, yielding 17 model cycles over the 5-year horizon. Both costs and health outcomes are discounted at 3% per annum using mid-cycle convention.

### 2.2 Health States

The model comprises five mutually exclusive health states, defined by treatment response level as measured by a validated composite severity index. Four states represent living patients at different levels of disease control, and one state represents death.

- **NonResponder:** patients who have not achieved a clinically meaningful response to therapy. This is the starting state for all patients entering the model and also serves as the absorbing alive state for patients who lose treatment response through discontinuation.
- **Resp_Low, Resp_Moderate, Resp_High:** increasing levels of disease control, corresponding to progressively better skin clearance and symptom improvement.
- **Dead:** absorbing state entered at a constant background mortality rate.

### 2.3 Model Phases

The model has a structurally distinctive two-phase design reflecting the clinical pathway of targeted therapy for CISS.

**Induction phase (cycle 1).** All patients enter the model as NonResponders and undergo a single response assessment at week 16. Based on treatment-specific response probabilities, patients are allocated to NonResponder, Resp_Low, Resp_Moderate, or Resp_High. This initial sorting reflects the clinical practice of evaluating treatment response at the end of the induction period and continuing therapy only in patients who demonstrate benefit.

**Maintenance phase (cycles 2–17).** During maintenance, patients in responder states may discontinue treatment at a treatment-specific per-cycle rate and transition to NonResponder. Once in NonResponder during maintenance, patients do not re-respond — this is an absorbing alive state. Discontinuation rates vary between year 1 (cycles 2–4) and year 2 onward (cycles 5–17), reflecting higher early attrition that stabilises over time.


### 2.4 Key Structural Assumptions

Background mortality is constant and identical across treatment arms, reflecting the negligible impact of CISS on life expectancy. There is no treatment-related mortality. Patients who discontinue therapy are assumed to revert to NonResponder status and remain there for the duration of the model; re-treatment or treatment switching is not modelled. Drug costs in the induction cycle are applied to all alive patients, reflecting the treat-to-assess paradigm, while in maintenance cycles drug costs accrue only to patients who remain in responder states. Subcutaneous injection training costs are applied once, in cycle 1, for injectable therapies only.

## 3. Model Parameters

### 3.1 Response Probabilities

**Table 3.1. Induction response probabilities by treatment**

| Treatment | P(Resp_Low) | P(Resp_Mod) | P(Resp_High) | P(NonResp) |
|---|---|---|---|---|
| BSC | 0.105 | 0.070 | 0.060 | 0.765 |
| Dravokimab | 0.155 | 0.175 | 0.380 | 0.290 |
| Barisetinib | 0.150 | 0.135 | 0.170 | 0.545 |
| Tremacept | 0.145 | 0.140 | 0.180 | 0.535 |
| Uvestinib | 0.130 | 0.170 | 0.475 | 0.225 |
| Dorilumab | 0.155 | 0.170 | 0.295 | 0.380 |

*PSA distribution: Beta (SE = 10% of mean) for each response probability.*

### 3.2 Discontinuation Rates

**Table 3.2. Discontinuation rates per 16-week cycle**

| Treatment | Year 1 | Year 2+ |
|---|---|---|
| BSC | 0.240 | 0.240 |
| Dravokimab | 0.040 | 0.040 |
| Barisetinib | 0.075 | 0.075 |
| Tremacept | 0.055 | 0.055 |
| Uvestinib | 0.075 | 0.075 |
| Dorilumab | 0.040 | 0.050 |

*PSA distribution: Beta (SE = 10% of mean).*

### 3.3 Health State Utilities

**Table 3.3. Health state utilities**

| Health State | Utility |
|---|---|
| NonResponder | 0.62 |
| Resp_Low | 0.78 |
| Resp_Moderate | 0.84 |
| Resp_High | 0.87 |
| Dead | 0.00 |

*PSA distribution: Utility (1 minus Gamma on disutility; SE = 0.02).*

### 3.4 Costs

All costs are expressed in 2021 US dollars. Drug costs are converted from annual to per-cycle values by multiplying by the cycle length in years (16/52). State costs represent the direct medical costs of managing a patient in each health state, excluding drug acquisition costs, and are similarly annualised to per-cycle values.

**Table 3.4a. Annual drug costs by treatment**

| Treatment | Annual Drug Cost |
|---|---|
| BSC | $0 |
| Dravokimab | $38,500 |
| Barisetinib | $18,200 |
| Tremacept | $29,500 |
| Uvestinib | $58,700 |
| Dorilumab | $29,500 |

*PSA distribution: Gamma (SE = 20% of mean); BSC fixed at $0.*

**Table 3.4b. Annual health state costs**

| Health State | Annual State Cost |
|---|---|
| NonResponder | $17,200 |
| Resp_Low | $9,500 |
| Resp_Moderate | $8,400 |
| Resp_High | $8,100 |

*PSA distribution: Gamma (SE = 20% of mean).*

A one-time subcutaneous injection training cost of $25.00 is applied in cycle 1 for Tremacept and Dorilumab.

## 4. Base Case Results

### 4.1 Deterministic Analysis

Table 4.1 presents the total discounted costs, life years, and QALYs for each treatment strategy over the 5-year time horizon. Strategies are sorted by ascending total cost. Life years are identical across all arms because background mortality is constant and unaffected by treatment.

**Table 4.1. Deterministic base case results (sorted by cost)**

| Treatment | Total Cost | Total LYs | Total QALYs |
|---|---|---|---|
| BSC | $80,929 | 4.8462 | 3.0555 |
| Barisetinib | $98,851 | 4.8462 | 3.2628 |
| Tremacept | $119,751 | 4.8462 | 3.3103 |
| Dorilumab | $131,276 | 4.8462 | 3.4518 |
| Dravokimab | $162,846 | 4.8462 | 3.5499 |
| Uvestinib | $197,126 | 4.8462 | 3.4796 |

### 4.2 Dominance Analysis

Uvestinib is strongly dominated: it is more costly than Dravokimab ($197,126 vs $162,846) while generating fewer QALYs (3.4796 vs 3.5499). Uvestinib is therefore excluded from the efficient frontier.

Among the remaining five strategies, sequential incremental cost-effectiveness ratios (ICERs) were computed along the cost-effectiveness frontier. Tremacept was found to be extendedly dominated. When compared sequentially, the ICER of Tremacept versus Barisetinib ($439,993/QALY) exceeds the ICER of the next non-dominated strategy, Dorilumab, versus Barisetinib ($81,449/QALY computed directly). This means a decision-maker willing to pay Tremacept's incremental price would prefer to move directly from Barisetinib to Dorilumab, which offers greater value for money. Tremacept is therefore removed from the efficient frontier.

### 4.3 Cost-Effectiveness Frontier

**Table 4.2. Deterministic cost-effectiveness frontier**

| Treatment | Total Cost | Total QALYs | Inc. Cost | Inc. QALY | Seq. ICER | Status |
|---|---|---|---|---|---|---|
| BSC | $80,929 | 3.0555 | — | — | — | Reference |
| Barisetinib | $98,851 | 3.2628 | $17,922 | 0.2073 | $86,453 | Frontier |
| Tremacept | $119,751 | 3.3103 | — | — | — | Ext. dom. |
| Dorilumab | $131,276 | 3.4518 | $32,425 | 0.1890 | $171,559 | Frontier |
| Dravokimab | $162,846 | 3.5499 | $31,570 | 0.0981 | $321,819 | Frontier |
| Uvestinib | $197,126 | 3.4796 | — | — | — | Dominated |

At a willingness-to-pay threshold of $150,000 per QALY, Barisetinib is the optimal strategy on the frontier, as its sequential ICER ($86,453/QALY) falls below the threshold while the next frontier strategy (Dorilumab, sequential ICER $171,559/QALY) exceeds it.

### 4.4 Probabilistic Sensitivity Analysis

Probabilistic sensitivity analysis (PSA) was conducted with 1,000 Monte Carlo iterations. Table 4.3 presents the PSA mean results, which closely approximate the deterministic base case, confirming the stability of the model and the appropriateness of the distributional assumptions.

**Table 4.3. PSA mean results (sorted by cost)**

| Treatment | Mean Cost | Mean LYs | Mean QALYs |
|---|---|---|---|
| BSC | $80,169 | 4.8462 | 3.0579 |
| Barisetinib | $98,275 | 4.8462 | 3.2650 |
| Tremacept | $119,338 | 4.8462 | 3.3126 |
| Dorilumab | $131,086 | 4.8462 | 3.4537 |
| Dravokimab | $162,738 | 4.8462 | 3.5500 |
| Uvestinib | $196,318 | 4.8462 | 3.4801 |

The dominance and frontier findings from the deterministic analysis are preserved in the probabilistic analysis. Uvestinib remains strongly dominated and Tremacept remains extendedly dominated. The probabilistic efficient frontier comprises the same four strategies.

**Table 4.4. Probabilistic cost-effectiveness frontier**

| Treatment | Total Cost | Total QALYs | Inc. Cost | Inc. QALY | Seq. ICER | Status |
|---|---|---|---|---|---|---|
| BSC | $80,169 | 3.0579 | — | — | — | Reference |
| Barisetinib | $98,275 | 3.2650 | $18,106 | 0.2071 | $87,426 | Frontier |
| Dorilumab | $131,086 | 3.4537 | $32,811 | 0.1887 | $173,879 | Frontier |
| Dravokimab | $162,738 | 3.5500 | $31,652 | 0.0963 | $328,681 | Frontier |

At a willingness-to-pay threshold of $150,000 per QALY, the probabilistic analysis confirms Barisetinib as the optimal frontier strategy, consistent with the deterministic base case.

## 5. Discussion

This analysis demonstrates that targeted therapies for moderate-to-severe CISS offer clinically meaningful QALY gains over best supportive care, ranging from 0.21 to 0.49 additional QALYs over 5 years. These gains are driven entirely by improved quality of life in responder health states, as the model assumes no treatment effect on mortality. The QALY differences between treatments are determined by two factors: the initial response rate (which sets the proportion of patients entering favourable health states) and the durability of response (governed by the discontinuation rate, which determines how long patients remain in those states).

Among the six strategies evaluated, two are excluded from the efficient frontier. Uvestinib, despite having the highest response rate to Resp_High (47.5%), is strongly dominated by Dravokimab, which achieves superior QALYs at lower cost. This is attributable to Uvestinib's substantially higher drug cost ($58,700/year vs $38,500/year) and a discontinuation rate that erodes the initial response advantage over the model horizon. Tremacept is extendedly dominated — while not directly dominated by any single comparator, a linear combination of Barisetinib and Dorilumab offers the same health gains at lower cost.

The efficient frontier identifies Barisetinib as the most cost-effective targeted therapy at a willingness-to-pay threshold of $150,000 per QALY, with a sequential ICER of approximately $86,000–$87,000 versus BSC. Decision-makers with higher willingness-to-pay may consider Dorilumab (sequential ICER approximately $172,000–$174,000 vs Barisetinib) or Dravokimab (sequential ICER approximately $322,000–$329,000 vs Dorilumab), though these options represent substantially diminishing marginal returns.

### 5.1 Limitations

Several limitations should be considered when interpreting these results. The model does not incorporate treatment switching or re-treatment after discontinuation, which may underestimate the real-world QALYs for strategies with high discontinuation rates. The time horizon of 5 years captures the initial treatment response and maintenance phases but does not model longer-term outcomes. Background mortality is simplified to a constant rate rather than age-dependent life table values, which is a reasonable approximation given the young starting age (38 years) and short horizon. Indirect costs, caregiver burden, and productivity effects are excluded consistent with the payer perspective. Finally, all parameter values used in this analysis are assumed for illustrative purposes and do not represent actual clinical trial data.

# HuncMarkovPCOS

The `huncMarkovCISS` package is [available on Github](https://github.com/HealthyUncertainty/huncMarkovCISS). 

A modifiable Shiny app can be found here.

### _AI Use Disclaimer_
_The near entirety of this post was written by Claude AI. The two small sections in which I speak in the first person are written by me._

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

> Written with [StackEdit](https://stackedit.io/).
