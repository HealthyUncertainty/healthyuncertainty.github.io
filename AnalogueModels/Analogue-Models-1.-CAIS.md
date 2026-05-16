---
title: Disease Analogue Models - 1. - CAIS
subtitle: Using a Claude Skill to generate five HTA-grade decision models
tags: [R, tools, AI, Decision Models]
---

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

# Introduction

I developed a Claude Skill that builds Markov models in R for cost-effectiveness analysis. I used this Skill to develop a model that considers hypothetical treatments for a fictitious disease that is structurally similar to models that would be used for HTA decision making. This post describes one such model.


## CAIS — Chronic Airway Infection Syndrome 
A chronic respiratory condition with recurring acute episodes and risk of progressive chronic bacterial colonisation. 

 - _Real-world analogues_: non-cystic fibrosis bronchiectasis, chronic obstructive pulmonary disease, bronchiolitis obliterans. 
 - _Structure:_ 7-state annual Markov model, 100-year horizon, 2 arms.
 - _Key features:_ Dual chronic infection pathogen states (PathA/PathB) with spontaneous clearance; bidirectional exacerbation states; state-specific SMR-scaled excess mortality; age-dependent background mortality.

![A schematic describing the transition logic of the Markove model as patients move between different states of health, each associated with different health state utility values](https://www.dropbox.com/scl/fi/6vh4ywtfjyozitcptnab4/cais_model_state_diagram.png?rlkey=jaypmy6ibg8r9pz9nlbud9o11&st=a4bykilz&dl=1)

# Cost-Effectiveness Analysis

After the model was calibrated and built, I asked Claude to generate a fictionalized cost-effectiveness report that contained all the information that someone would need if they wanted to replicate the model themselves using the Skill. That report follows.

## 1. Disease Background

Chronic Airway Infection Syndrome (CAIS) is a progressive chronic respiratory condition characterised by recurring exacerbations and susceptibility to two distinct patterns of chronic bacterial colonisation. Patients experience recurring inflammatory episodes (exacerbations) that are associated with hospitalisation, quality-of-life impairment, and elevated mortality. Left untreated, a substantial proportion of patients acquire chronic infections of type PathA or PathB, each of which further amplifies exacerbation risk and disease-specific mortality.

CAIS patients carry approximately 50% higher all-cause mortality than age-matched general population individuals (standardised mortality ratio 1.50). Exacerbation states and chronic infection states carry additional mortality increments. At baseline (age 60, 55% female), the burden of disease is substantial: annual exacerbation rates approach 35% in untreated patients on Usual Care, and acquisition of chronic infection further elevates exacerbation risk by 25–30%. Healthcare resource utilisation is high, with per-exacerbation costs of approximately $3,200 and chronic infection adding $6,000–$7,500 per year in additional management costs.

### 1.1 Current Treatment Landscape

Usual Care (UC) represents standard background pharmacological management for CAIS, including regular physician visits, standard inhaled medications, and routine microbiological monitoring at an estimated annual background cost of $4,500. There are no approved disease-modifying agents for CAIS in the base case comparator arm.

Infectaguard is a novel oral small-molecule agent targeting airway neutrophil elastase activity. In the clinical programme (assumed for illustration), Infectaguard reduced the annual exacerbation rate by 45% (rate ratio 0.55; log-scale SE 0.12) and substantially reduced rates of PathA and PathB acquisition (RR 0.55 and 0.58, respectively). Infectaguard is available as a generic oral formulation at an annual drug cost of $2,000, substantially below conventional biologics.

## 2. Model Structure and Key Assumptions

### 2.1 Model Type and Time Horizon

A cohort-level Markov state-transition model was developed to evaluate the cost-effectiveness of Infectaguard versus Usual Care for CAIS. The model adopts a Canadian public payer perspective with a lifetime (100-year) time horizon, using annual cycles (100 cycles total). The starting cohort age is 60 years (55% female). Both costs and QALYs are discounted at 3% per annum. Half-cycle correction is applied via standard weighting (0.5 weight on first and final cycle rows).

This model uses a standard Markov state-transition architecture, with per-cycle transition probability matrices applied iteratively across the cohort. Age-dependent background mortality is embedded directly in the transition matrix at each cycle via interpolation of Canadian life table data, consistent with the approach described by Paulden (2025) for array-formula Excel implementations.

### 2.2 Health States

The model comprises seven mutually exclusive and exhaustive health states, structured to capture both exacerbation status and chronic infection status:

- **Stable:** no exacerbation in the current cycle; no chronic bacterial infection.
- **Stable_Exac:** exacerbation occurring in the current cycle; no chronic infection. Patients recovering from exacerbation return to Stable in the following cycle.
- **PathA:** chronic PathA infection (Gram-negative bacterial analogue); no current exacerbation. Patients can clear PathA spontaneously at 5% per year.
- **PathA_Exac:** concurrent PathA infection and active exacerbation.
- **PathB:** chronic PathB infection (mycobacterial analogue); no current exacerbation. Spontaneous clearance rate 4% per year.
- **PathB_Exac:** concurrent PathB infection and active exacerbation.
- **Dead:** absorbing state, entered via age-dependent background mortality scaled by disease- and state-specific standardised mortality ratios.

All patients enter the model in the Stable state. PathA and PathB infections are treated as mutually exclusive within any single annual cycle; direct transitions between PathA and PathB states are not permitted.

### 2.3 Transition Probability Structure

In each annual cycle, the cohort distributes across states according to a 7×7 transition probability matrix. Key structural features include:

- Exacerbation onset (Stable → Stable_Exac) is governed by the arm-specific exacerbation probability, with PathA and PathB states experiencing proportionally elevated rates via multiplicative rate ratios.
- Exacerbation recovery (Stable_Exac → Stable, PathA_Exac → PathA, PathB_Exac → PathB) occurs with probability 0.85 per cycle.
- PathA and PathB acquisition (Stable → PathA / PathB) are modelled as competing events, jointly with exacerbation, within each annual cycle.
- Background mortality is age-dependent (from Canadian life tables, piecewise linearly interpolated) and scaled by state-specific SMRs. The CAIS SMR (1.50) applies to all alive states; exacerbation states carry an additional SMR of 1.20; PathA states carry an additional 1.30; PathB states carry an additional 1.35.

## 3. Model Parameters

### 3.1 Treatment Arms and Efficacy Parameters

Table 3.1 presents transition probability parameters for both treatment arms. All values are assumed for illustration and are not derived from any proprietary source.

**Table 3.1. Transition probability parameters**

| Parameter | Usual Care | Infectaguard | SE | PSA Dist. |
|---|---|---|---|---|
| Annual exacerbation rate | 0.35 | 0.193 | 0.070 | Beta |
| Annual PathA acquisition rate | 0.04 | 0.022 | 0.008 | Beta |
| Annual PathB acquisition rate | 0.03 | 0.017 | 0.006 | Beta |
| Exacerbation recovery probability | 0.85 | 0.85 | 0.043 | Beta |
| PathA spontaneous clearance | 0.05 | 0.05 | 0.013 | Beta |
| PathB spontaneous clearance | 0.04 | 0.04 | 0.010 | Beta |
| RR for exacerbation (Infectaguard vs UC) | — | 0.55 | 0.12† | Log-normal |
| RR for PathA acquisition (Infectaguard vs UC) | — | 0.55 | 0.15† | Log-normal |
| RR for PathB acquisition (Infectaguard vs UC) | — | 0.58 | 0.15† | Log-normal |

*† SE on log scale. Infectaguard exacerbation rate = UC rate × RR. All values assumed for illustration.*

### 3.2 Health-State Utilities

Utilities are assigned to health states using a multiplicative approach. The baseline Stable utility (0.72) represents the chronic respiratory disease burden in a stable, non-infected, non-exacerbating CAIS patient. Exacerbation imposes a utility multiplier of 0.82 (reflecting short-term but meaningful HRQoL reduction). Chronic infection states carry multipliers of 0.88 (PathA) and 0.86 (PathB), capturing the additional burden of chronic infection management.

**Table 3.2. Health-state utility values**

| Health state | Utility | Derivation | PSA Dist. |
|---|---|---|---|
| Stable | 0.720 | Base utility — direct estimate | Utility (1−Gamma) |
| Stable_Exac | 0.590 | 0.720 × 0.82 multiplier | Derived |
| PathA | 0.634 | 0.720 × 0.88 multiplier | Derived |
| PathA_Exac | 0.520 | 0.720 × 0.88 × 0.82 | Derived |
| PathB | 0.619 | 0.720 × 0.86 multiplier | Derived |
| PathB_Exac | 0.508 | 0.720 × 0.86 × 0.82 | Derived |
| Dead | 0.000 | Conventional | Fixed |

Relapse disutility is applied proportionally within each cycle: state utility is reduced by disutil_relapse × P(relapse) for all alive states, reflecting the expected quality-of-life reduction from the probability of experiencing an exacerbation in that cycle.

### 3.3 Costs

All costs are expressed in 2026 Canadian dollars and represent direct costs from the perspective of the Canadian public payer. Costs are applied per cycle, with drug and management costs accruing throughout the modelled lifetime. Per-exacerbation event costs are applied as a per-cycle expected cost (alive × P(exacerbation) × per-event cost). Chronic infection states incur additional annual management costs.

**Table 3.3. Cost parameters**

| Cost component | Annual value | SE | PSA Dist. |
|---|---|---|---|
| Infectaguard drug cost | $2,000 | $400 | Gamma |
| Usual Care background cost | $4,500 | $900 | Gamma |
| Per-exacerbation event cost | $3,200 | $800 | Gamma |
| Additional annual cost — PathA infection | $6,000 | $1,200 | Gamma |
| Additional annual cost — PathB infection | $7,500 | $1,500 | Gamma |

*All costs in 2026 CAD; assumed for illustration. Drug and background costs accrue annually; infection costs accrue while patients occupy the relevant state.*

### 3.4 Mortality Parameters

Background mortality is drawn from Canadian life tables (sex-weighted at 55% female) and updated at each model cycle as the cohort ages. Piecewise linear interpolation is used between published age points. Disease- and state-specific excess mortality is applied via multiplicative standardised mortality ratios (SMRs), consistent with the approach used in the reference R model. The "in addition to" convention is applied: condition-specific SMRs are additive to the base CAIS SMR, not replacing it.

**Table 3.4. Mortality parameters**

| Mortality parameter | Value | PSA Dist. |
|---|---|---|
| SMR — CAIS vs general population | 1.50 | Gamma |
| Additional SMR — exacerbation states | 1.20 | Gamma |
| Additional SMR — PathA infection states | 1.30 | Gamma |
| Additional SMR — PathB infection states | 1.35 | Gamma |

## 4. Base Case Results

### 4.1 Deterministic Analysis

**Table 4.1. Deterministic base case results**

| Treatment | Total cost | Total LYs | Total QALYs | Inc. cost | ICER ($/QALY) |
|---|---|---|---|---|---|
| **Infectaguard** | $118,708 | 13.841 | 9.357 | +$13,588 | **$26,246** |
| Usual Care | $105,120 | 13.575 | 8.839 | — | — |

*All outcomes discounted at 3% per annum. Half-cycle correction applied. Incremental analysis: Infectaguard vs Usual Care.*

Infectaguard generates 0.52 incremental QALYs and 0.27 incremental life years compared to Usual Care over a 100-year lifetime horizon. The incremental cost of $13,588 yields a base-case ICER of $26,246 per QALY gained. This is well below conventional Canadian willingness-to-pay (WTP) thresholds of $50,000–$100,000 per QALY.

The QALY gain reflects the combined benefit of a 45% reduction in exacerbation frequency and a 42–45% reduction in chronic infection acquisition rates, reducing time spent in the more severe infection and exacerbation health states. The modest incremental cost reflects the low drug acquisition price of Infectaguard ($2,000/year) as a generic oral agent, partially offset by increased survival leading to extended accumulation of background management costs.

### 4.2 Probabilistic Sensitivity Analysis

Probabilistic sensitivity analysis (PSA) was conducted with 1,000 Monte Carlo simulations drawing from the parameter distributions defined in Section 3. PSA mean results are summarised in Table 4.2.

**Table 4.2. PSA mean results**

| Treatment | Mean cost | Mean LYs | Mean QALYs | Inc. cost | PSA ICER |
|---|---|---|---|---|---|
| **Infectaguard** | $118,717 | 13.855 | 9.358 | +$13,552 | **~$26,700** |
| Usual Care | $105,165 | 13.593 | 8.851 | — | — |

*PSA means based on 1,000 Monte Carlo iterations. Differences from deterministic < 0.2% across all outcomes.*

PSA mean results are consistent with the deterministic base case across all outcomes (< 0.2% difference). At a WTP threshold of $50,000 per QALY, Infectaguard has a 91% probability of being cost-effective. At $100,000 per QALY, the probability increases to 100%. The CEAC confirms that parameter uncertainty does not materially affect the cost-effectiveness conclusion.

**Table 4.3. Cost-effectiveness acceptability (P(CE) at selected WTP thresholds)**

| WTP threshold ($/QALY) | P(Infectaguard cost-effective) |
|---|---|
| $0 | 35% |
| $25,000 | 73% |
| $50,000 | 91% |
| $75,000 | 97% |
| $100,000 | 100% |


## 5. Discussion

This cost-effectiveness analysis demonstrates that Infectaguard is likely to be cost-effective for the treatment of Chronic Airway Infection Syndrome from the perspective of the public payer. At the base-case ICER of $26,246 per QALY gained, Infectaguard is well within conventional Canadian WTP thresholds of $50,000–$100,000 per QALY. The PSA confirms this finding is robust to parameter uncertainty.

The cost-effectiveness of Infectaguard is driven by three factors. First, a substantial clinical benefit: a 45% reduction in exacerbations significantly reduces time spent in high-cost, low-utility exacerbation states across the lifetime horizon. Second, reduced chronic infection acquisition (42–45% reduction for both PathA and PathB) prevents progression to infection states that carry elevated costs ($6,000–$7,500/year additional) and additional mortality risk. Third, a modest drug acquisition cost ($2,000/year as a generic oral agent) limits the incremental budget impact relative to the achieved health benefits.

The relatively low ICER reflects the structural dynamics of CAIS: patients who avoid chronic infection remain in healthier states for longer, accumulating substantially fewer healthcare costs while enjoying higher quality-adjusted survival. The model captures this compounding benefit over the lifetime horizon.

### 5.1 Limitations

Several limitations should be considered when interpreting these results.

- PathA and PathB infections are treated as mutually exclusive within any annual cycle. The model does not permit dual chronic infection, which may understate disease burden in a minority of patients with co-colonisation.
- Exacerbations are modelled as fully transient (one-cycle duration). Prolonged or recurrent exacerbations within a single year are not explicitly modelled.
- Treatment effect is assumed constant over the lifetime horizon. Waning efficacy over time is not incorporated in the base case.
- The model does not capture treatment switching, dose escalation, or the potential emergence of antimicrobial resistance relevant to PathA or PathB infection management.
- All parameter values are assumed for illustration and are not derived from any real clinical trial, epidemiological study, or proprietary data source.

# HuncMarkovCAIS

The `huncMarkovCAIS` package is [available on Github](https://github.com/HealthyUncertainty/huncMarkovCAIS). 

A modifiable Shiny app can be found here.

### _AI Use Disclaimer_
_The near entirety of this post was written by Claude AI. The two small sections in which I speak in the first person are written by me._

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

> Written with [StackEdit](https://stackedit.io/).
