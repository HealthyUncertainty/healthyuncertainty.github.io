---
title: Disease Analogue Models - 3. - ABD
subtitle: Using a Claude Skill to generate five HTA-grade decision models
tags: [R, tools, AI, Decision Models]
---

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

# Introduction

I developed a Claude Skill that builds Markov models in R for cost-effectiveness analysis. I used this Skill to develop a model that considers hypothetical treatments for a fictitious disease that is structurally similar to models that would be used for HTA decision making. This post describes one such model.

## **ABD — Acute Bronchial Disorder** 
A chronic inflammatory airway condition with recurrent acute flare-ups of varying severity. 

 - _Real-world analogues_: asthma, eosinophilic bronchitis, allergic bronchopulmonary aspergillosis.
 -  _Structure:_ 5-state biweekly Markov model with tunnel states, 50-year horizon, 2 arms, 1,300 cycles.
 - _Key features:_ Three severity-graded tunnel states (mild, moderate, severe) each resolving within one cycle; severity-specific treatment
   effect (strongest on most severe events); severe flare-up mortality
   risk; biweekly cycle granularity.
![_Notes: Solid coloured arrows show flare-up transitions (amber = mild/moderate, red = severe with extra mortality). Teal arrows show tunnel state return to Stable after 1 cycle. Dashed arrows show age-dependent background mortality from all alive states. Self-loop on Stable represents patients who remain flare-up-free in a given cycle._](https://www.dropbox.com/scl/fi/7pf275ndtg9jd36z5vyrg/abd_diagram.png?rlkey=nsegeweqo3latrtdbxpefced7&st=ojceen76&dl=1)(_Notes: Solid coloured arrows show flare-up transitions (amber = mild/moderate, red = severe with extra mortality). Teal arrows show tunnel state return to Stable after 1 cycle. Dashed arrows show age-dependent background mortality from all alive states. Self-loop on Stable represents patients who remain flare-up-free in a given cycle._)

# Cost-Effectiveness Analysis

After the model was calibrated and built, I asked Claude to generate a fictionalized cost-effectiveness report that contained all the information that someone would need if they wanted to replicate the model themselves using the Skill. That report follows.

## 1. Disease Background

Acute Bronchial Disorder (ABD) is a chronic inflammatory airway condition characterised by recurrent episodes of bronchospasm, mucus hypersecretion, and airflow limitation. The condition typically presents in middle adulthood and follows a variable course, with acute flare-ups triggered by respiratory infections, allergen exposure, and environmental irritants. ABD affects approximately 3–5% of the adult population, with moderate-to-severe disease accounting for roughly 40% of prevalent cases.

The burden of moderate-to-severe ABD is substantial. Patients experience recurrent flare-ups of varying severity — from mild episodes managed with oral corticosteroids to severe episodes requiring emergency department visits and hospitalisation. Between flare-ups, patients maintain a stable baseline with residual symptoms and impaired lung function. Health state utilities in stable disease range from 0.70–0.82 depending on treatment, with disutilities of 0.08–0.22 during flare-up episodes. The economic burden includes direct costs from drug therapy, urgent care visits, hospitalisations during severe flare-ups, and ongoing monitoring.

### 1.1 Current Treatment Landscape

The treatment of moderate-to-severe ABD centres on maintenance therapy with inhaled corticosteroids and long-acting bronchodilators, collectively referred to as standard of care (SoC). In recent years, biologic therapies targeting key inflammatory mediators have been introduced for patients with persistent disease despite optimised SoC. These biologics reduce flare-up frequency and severity through different mechanisms of action.

This analysis evaluates Lunavar, a biosimilar-class biologic administered subcutaneously, as add-on therapy to SoC. Lunavar has demonstrated efficacy in reducing flare-up rates across all severity levels, with particularly strong effects on severe flare-ups (relative risk 0.18). As a biosimilar-class agent, Lunavar is priced at $4,800 per year — substantially below premium biologics — making it a potentially cost-effective option for patients with moderate-to-severe ABD.

## 2. Model Structure and Key Assumptions

### 2.1 Model Type and Time Horizon

A cohort-level Markov state-transition model was developed to evaluate the cost-effectiveness of Lunavar + SoC versus SoC alone for moderate-to-severe ABD. The model adopts a Canadian public payer perspective with a 50-year (lifetime) time horizon, using 2-week cycles (1,300 cycles total) to capture the episodic nature of flare-ups at clinically relevant granularity. Starting age is 48 years. Both costs and health outcomes are discounted at 3% per annum using mid-cycle convention.

### 2.2 Health States

The model comprises five mutually exclusive health states. One state represents stable disease, three states represent flare-up episodes of increasing severity, and one state represents death.

- **Stable:** patients with controlled disease and no active flare-up. This is the starting state for all patients and the state to which patients return after each flare-up episode.
- **FlareUp_Mild:** a mild flare-up episode managed with a short course of oral corticosteroids. This is a 1-cycle (2-week) tunnel state: patients enter from Stable and return to Stable in the following cycle.
- **FlareUp_Moderate:** a moderate flare-up requiring an urgent care or emergency department visit. Also a 1-cycle tunnel state.
- **FlareUp_Severe:** a severe flare-up requiring hospitalisation. A 1-cycle tunnel state with additional mortality risk (probability of death 0.55% per episode).
- **Dead:** absorbing state entered via age-dependent background mortality (from all states) or severe flare-up mortality.

### 2.3 Tunnel State Mechanism

The three flare-up states are 1-cycle tunnel states. In each cycle, patients in Stable may transition to any of the three flare-up states based on severity-specific probabilities derived from the annual aggregate event rate (AAER). In the following cycle, all surviving flare-up patients return to Stable. This structure captures the acute, self-limiting nature of ABD flare-ups while allowing the model to track per-cycle costs and utility decrements associated with each severity level.

Treatment effects are modelled as relative risks applied to the flare-up event rates. Lunavar reduces the rate of mild flare-ups (RR 0.45), moderate flare-ups (RR 0.25), and severe flare-ups (RR 0.18), with the strongest effect on the most severe and costly events.


### 2.4 Key Structural Assumptions

Background mortality is age-dependent, using sex-weighted Canadian life tables (55% female, 45% male) with linear interpolation between published age points. The cycle-length conversion uses the probability-scaling formula 1–(1–qx)^cycle_length, which is the correct method when the source provides annual probabilities rather than rates. There is no disease-specific excess mortality apart from the per-episode severe flare-up death probability. Drug costs accrue to all alive patients (both arms receive SoC; the Lunavar arm receives add-on biologic cost).


## 3. Model Parameters

### 3.1 Flare-Up Rates and Treatment Effect

| Parameter | SoC Rate | Lunavar RR | Lunavar Rate | PSA Dist. |
|---|---|---|---|---|
| AAER (aggregate annual) | 1.65 | — | — | Gamma |
| Proportion mild | 72% | 0.45 | 32.4% | Beta / LN |
| Proportion moderate | 12% | 0.25 | 3.0% | Beta / LN |
| Proportion severe | 16% | 0.18 | 2.9% | Beta / LN |
| Death from severe flare-up | 0.55% | — | 0.55% | Beta |

*Relative risks drawn from LogNormal; proportions from Beta. AAER = annual aggregate exacerbation rate.*

### 3.2 Health State Utilities

| Parameter | Value | PSA Distribution |
|---|---|---|
| Stable (Lunavar) | 0.805 | Utility (Gamma disutil.) |
| Stable (SoC) | 0.760 | Utility (Gamma disutil.) |
| Disutility — Mild flare-up | −0.08 | Fixed |
| Disutility — Moderate flare-up | −0.14 | Fixed |
| Disutility — Severe flare-up | −0.22 | Fixed |

### 3.3 Costs

| Parameter | Value | PSA Distribution |
|---|---|---|
| Lunavar (annual) | $4,800 | Gamma |
| SoC (annual) | $5,200 | Fixed |
| Mild flare-up (per event) | $1,350 | Gamma |
| Moderate flare-up (per event) | $1,850 | Gamma |
| Severe flare-up (per event) | $8,200 | Gamma |

*Drug costs are pro-rated by cycle length (2/52 of annual cost per cycle). Flare-up event costs are applied in full during the tunnel-state cycle.*

## 4. Base Case Results

### 4.1 Deterministic Analysis

Table 4.1 presents the total discounted costs, life years, and QALYs for each treatment strategy over the 50-year time horizon.

**Table 4.1. Deterministic base case results**

| Treatment | Total Cost | Total LYs | Total QALYs |
|---|---|---|---|
| **Lunavar + SoC** | $224,483 | 20.1022 | 16.1372 |
| SoC | $178,974 | 19.7822 | 14.9067 |
| *Incremental* | *$45,509* | *0.3200* | *1.2305* |

The incremental cost-effectiveness ratio of Lunavar + SoC versus SoC alone is **$36,986 per QALY gained**. The QALY gain of 1.23 is driven primarily by the utility benefit of reduced flare-up frequency, while the life-year gain of 0.32 years reflects the reduction in severe flare-up mortality over the 50-year horizon.

### 4.2 Probabilistic Sensitivity Analysis

Probabilistic sensitivity analysis was conducted with 1,000 Monte Carlo iterations. At a willingness-to-pay threshold of $50,000 per QALY, Lunavar + SoC has approximately a 74% probability of being cost-effective.

**Table 4.2. PSA CEAC results**

| WTP Threshold ($/QALY) | P(Lunavar Cost-Effective) |
|---|---|
| $25,000 | 27% |
| $50,000 | 74% |
| $75,000 | 95% |
| $100,000 | 99% |
| $150,000 | 100% |

*The CEAC shows a monotonically increasing probability of cost-effectiveness, rising from 27% at $25,000/QALY to near-certainty above $100,000/QALY. This pattern reflects the concentrated incremental cost ($45,509) and substantial QALY gain (1.23), producing an ICER with relatively low uncertainty.*

## 5. Discussion

This analysis demonstrates that Lunavar + SoC offers substantial clinical benefit over SoC alone for moderate-to-severe ABD, with a QALY gain of 1.23 and a life-year gain of 0.32 over the 50-year time horizon. At an ICER of $36,986 per QALY, Lunavar falls well below conventional willingness-to-pay thresholds ($50,000–$100,000/QALY), making it a cost-effective treatment option.

The cost-effectiveness of Lunavar is driven by three factors. First, its biosimilar-class pricing ($4,800/year) keeps the incremental drug cost modest relative to the clinical benefit. Second, Lunavar's strong efficacy against severe flare-ups (RR 0.18) reduces the most expensive events (hospitalisations at $8,200 per event), generating cost offsets that partially compensate for the drug cost premium. Third, the reduction in severe flare-up mortality produces a small but meaningful life-year gain that compounds over the 50-year horizon.

The ICER of $36,986 is robust to probabilistic sensitivity analysis, with a 74% probability of cost-effectiveness at $50,000/QALY and 95% at $75,000/QALY. The relatively tight CEAC reflects the fact that the key model drivers (AAER, relative risks, event costs) are well-characterised with moderate uncertainty.

### 5.1 Limitations

Several limitations should be considered. The model uses 1-cycle tunnel states for flare-ups, which assumes all episodes resolve within 2 weeks; in practice, severe flare-ups may require longer recovery. The model does not include treatment discontinuation, switching, or dose adjustment for Lunavar. Background mortality uses probability-scaling (1–(1–qx)^t), which was found to be more correct than the rate-based formula (1–exp(–qx×t)) used in the original R source model. Finally, all parameter values are fictional and do not represent actual clinical data.

# HuncMarkovABD

The `huncMarkovABD` package is [available on Github](https://github.com/HealthyUncertainty/huncMarkovABD). 

A modifiable Shiny app can be found here.

### _AI Use Disclaimer_
_The near entirety of this post was written by Claude AI. The two small sections in which I speak in the first person are written by me._

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

> Written with [StackEdit](https://stackedit.io/).
