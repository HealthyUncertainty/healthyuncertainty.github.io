---
title: Disease Analogue Models - 4. - DMSS
subtitle: Using a Claude Skill to generate five HTA-grade decision models
tags: [R, tools, AI, Decision Models]
---

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

# Introduction

I developed a Claude Skill that builds Markov models in R for cost-effectiveness analysis. I used this Skill to develop a model that considers hypothetical treatments for a fictitious disease that is structurally similar to models that would be used for HTA decision making. This post describes one such model.

## **DMSS — Diffuse Mucosal Sclerosis Syndrome** 
A chronic structural cardiac condition classified by symptom severity, managed pharmacologically or surgically. 

 - _Real-world analogues_: mitral valve disease, hypertrophic obstructive cardiomyopathy, aortic stenosis.
 -  _Structure:_ 4-state population proportion model (not a true Markov), 80-year horizon, 5 arms, 1,040 cycles.
 - _Key features:_ Frozen symptom grade distributions (not transition probabilities); treatment-specific grade distributions assessed at
   different timepoints for pharmacological vs surgical arms; one-time
   perioperative mortality for surgical arms; 5-arm comparison with
   dominance analysis.

![Three health states for Grade 1, 2, and 3, plus a Dead state](https://www.dropbox.com/scl/fi/i7oub57shhg65td62aapo/dmss_state_diagram.png?rlkey=8ekypekq6qpyo9r7sg9mc8scl&st=xml9zkt0&dl=1)
(_Notes: Blue arrows represent proportional redistribution of surviving patients (not transition probabilities). Red arrows show age-dependent background mortality from all alive states. Self-loops indicate patients remaining in the same grade under the frozen distribution. The annotation box describes the population proportion mechanism._)

# Cost-Effectiveness Analysis

After the model was calibrated and built, I asked Claude to generate a fictionalized cost-effectiveness report that contained all the information that someone would need if they wanted to replicate the model themselves using the Skill. That report follows.

## 1. Disease Background

Diffuse Mucosal Sclerosis Syndrome (DMSS) is a chronic cardiac condition characterised by progressive obstruction of the left ventricular outflow tract due to asymmetric septal hypertrophy. The condition is classified by symptom severity into three grades: Grade I (asymptomatic or mildly symptomatic), Grade II (moderate symptoms with exertional limitation), and Grade III (severe symptoms with significant functional impairment). Disease onset typically occurs in middle adulthood, and the condition follows a chronic course with symptom burden determined primarily by the degree of obstruction.

At diagnosis, approximately 68% of patients present with Grade II symptoms and 32% with Grade III symptoms; Grade I classification at presentation is rare. The burden of moderate-to-severe DMSS is substantial, with utilities ranging from 0.68–0.93 depending on grade and treatment. Treatment aims to reduce the proportion of patients in higher-grade states and improve quality of life. Background mortality is not elevated relative to age-matched general population in the base case.

### 1.1 Current Treatment Landscape

Treatment options include pharmacological therapy (beta-blockers, calcium channel blockers, and Zonapride), and surgical interventions (Septoplasty and Ablatherm). Standard of care (SoC) consists of optimised beta-blocker and calcium channel blocker therapy. This analysis evaluates Cardivex, a novel cardiac myosin inhibitor administered orally, as an alternative to existing treatment strategies.

Cardivex has demonstrated efficacy in shifting the symptom distribution toward Grade I, with 48% of patients achieving Grade I status at the week-32 assessment (compared to 22% with SoC). As a premium oral therapy priced at approximately $64,000 per year, the cost-effectiveness of Cardivex relative to existing pharmacological and surgical options is a key question for payers.

## 2. Model Structure and Key Assumptions

### 2.1 Model Type and Time Horizon

A cohort-level population proportion model was developed to evaluate the cost-effectiveness of five treatment strategies for DMSS. The model adopts a US payer perspective with an 80-year (lifetime) time horizon, using 4-week cycles (1,040 cycles total). Starting age is 55 years (48% female). Costs are discounted at 3% per annum. Half-cycle correction is not applied.

This model uses a population proportion structure rather than a standard Markov state-transition model. In each cycle, the surviving cohort is redistributed across severity grades using a fixed ("frozen") treatment-specific distribution, rather than transitioning between states according to per-state transition probabilities. Survival is determined solely by age-dependent background mortality (from sex-blended life tables) and, for surgical arms, one-time perioperative mortality at cycle 2.

### 2.2 Health States

The model comprises four mutually exclusive states:

- **Grade I:** asymptomatic or mildly symptomatic patients with minimal functional limitation.
- **Grade II:** moderate symptoms with exertional limitation. This is the predominant state at baseline (68%).
- **Grade III:** severe symptoms with significant functional impairment (32% at baseline).
- **Dead:** absorbing state entered via age-dependent background mortality or perioperative mortality.

### 2.3 Frozen Grade Distribution Mechanism

Unlike a standard Markov model where patients transition between states via a probability matrix, this model assigns a fixed distribution among surviving patients. After an initial treatment response assessment, the proportions of surviving patients in each grade are "frozen" and held constant for the remainder of the time horizon. Only aggregate survival changes over time.

For Cardivex and SoC, grade distributions are assessed at cycle 8 (week 32) using clinical trial data. For Zonapride and the surgical strategies, distributions freeze after cycle 1 based on immediate treatment response.

## 3. Model Parameters

### 3.1 Treatment Strategies and Frozen Distributions

| Treatment | Grade I | Grade II | Grade III | Freeze Cycle | Periop. Mort. |
|---|---|---|---|---|---|
| **Cardivex** | 48.0% | 43.5% | 8.5% | 8 | — |
| **SoC** | 22.0% | 56.0% | 22.0% | 8 | — |
| **Zonapride** | 30.0% | 47.6% | 22.4% | 1 | — |
| **Septoplasty** | 72.0% | 19.0% | 9.0% | 1 | 1.1% |
| **Ablatherm** | 72.0% | 19.0% | 9.0% | 1 | 0.9% |

### 3.2 Health State Utilities

| Parameter | Cardivex | SoC | Other | PSA Dist. |
|---|---|---|---|---|
| Grade I | 0.93 | 0.93 | 0.93 | Utility |
| Grade II | 0.85 | 0.83 | 0.84 | Utility |
| Grade III | 0.69 | 0.68 | 0.69 | Utility |
| Age decrement | 0.0008/yr | 0.0008/yr | 0.0008/yr | Fixed |

Surgical disutilities: Septoplasty −0.08 for 6 cycles post-procedure + lifetime pacemaker disutility (−0.04 × 5%). Ablatherm −0.04 for 1 cycle + lifetime pacemaker (−0.04 × 12%).

### 3.3 Costs (per 4-week cycle)

| Parameter | Value | PSA Dist. |
|---|---|---|
| Grade I state cost | $680 | Gamma |
| Grade II state cost | $1,850 | Gamma |
| Grade III state cost | $2,560 | Gamma |
| Cardivex (per cycle) | $4,923 | Gamma |
| Zonapride (per cycle, ongoing) | $380 | Gamma |
| Septoplasty procedure (one-time) | $110,000 | Fixed |
| Ablatherm procedure (one-time) | $50,000 | Fixed |
| Zonapride hospitalisation (one-time) | $7,800 | Fixed |

Background medication costs (beta-blocker + calcium channel blocker) accrue to all alive patients at treatment-specific utilisation rates. Cardiac scan monitoring at $95 per scan: Cardivex arm at cycles 1, 3, 5; all others at cycle 1 then biannually.

---

## 4. Base Case Results

### 4.1 Deterministic Analysis

**Table 4.1. Deterministic base case results**

| Treatment | Total Cost | Total LYs | Total QALYs |
|---|---|---|---|
| **Cardivex** | $1,465,197 | 17.80 | 15.39 |
| SoC | $417,791 | 17.80 | 14.40 |
| Zonapride | $491,781 | 17.80 | 14.65 |
| Septoplasty | $367,217 | 17.61 | 15.44 |
| **Ablatherm** | $307,733 | 17.64 | 15.45 |

Life years are nearly identical across pharmacological arms (17.80) because background mortality is age-dependent and identical across treatments. Surgical arms show marginally lower LYs (17.61–17.64) due to perioperative mortality. QALYs vary substantially (14.40–15.45) driven by the frozen grade distribution: arms with higher Grade I proportions accrue more QALYs.

### 4.2 Dominance Analysis

Sorting treatments by cost reveals that Ablatherm ($307,733) is both the least costly and the most effective (15.45 QALYs). Septoplasty is slightly more expensive ($367,217) with marginally fewer QALYs (15.44). Cardivex ($1,465,197 / 15.39 QALYs) is dominated by both surgical options — it costs substantially more while producing fewer QALYs. SoC and Zonapride are also dominated.

The efficient frontier comprises Ablatherm alone (cheapest and most effective). If surgical options are excluded from the comparison, the pharmacological frontier runs from SoC ($417,791) to Cardivex ($1,465,197), with an ICER of $1,056,697 per QALY gained — well above any conventional WTP threshold.

### 4.3 Probabilistic Sensitivity Analysis

PSA was conducted with 1,000 Monte Carlo iterations. PSA means converge within 0.3% of deterministic values across all arms, confirming model stability.

**Table 4.2. PSA CEAC results at selected WTP thresholds**

| WTP | Cardivex | SoC | Septoplasty | Ablatherm |
|---|---|---|---|---|
| $0 | 0% | 9% | 8% | 83% |
| $50,000 | 0% | 2% | 24% | 74% |
| $100,000 | 0% | 1% | 29% | 70% |
| $200,000 | 1% | 1% | 32% | 66% |
| $500,000 | 14% | 1% | 29% | 57% |

*Zonapride is omitted from the CEAC table as it never achieves meaningful probability of cost-effectiveness. Ablatherm dominates across the full WTP range, with probability declining only modestly at very high WTP values where Cardivex begins to gain traction.*

## 5. Discussion

This analysis demonstrates that surgical intervention — particularly Ablatherm — dominates all other strategies for DMSS, offering both the lowest cost and the highest QALYs. Cardivex, despite achieving a favourable grade distribution (48% Grade I vs 22% SoC), cannot overcome its premium pricing ($64,000/year) relative to the one-time cost of Ablatherm ($50,000) or Septoplasty ($110,000).

The dominance of surgical options is driven by three factors. First, surgical arms achieve the highest Grade I proportion (72%), generating the highest QALYs despite slightly lower life years from perioperative risk. Second, surgical costs are front-loaded (one-time procedure) rather than recurring annually, producing substantial lifetime cost savings. Third, Ablatherm's lower procedural cost and lower perioperative mortality (0.9% vs 1.1%) give it a slight edge over Septoplasty.

Cardivex would need substantial price reductions to become competitive. At its current efficacy (48% Grade I), the break-even annual price versus Ablatherm would require reducing the QALY gap (Ablatherm produces 15.45 vs Cardivex 15.39) or achieving a substantially higher Grade I rate.

### 5.1 Limitations

Several limitations should be considered. The population proportion structure assumes that grade distributions are frozen after the initial assessment and do not evolve over time — in practice, disease progression or treatment response may change. The model does not include treatment discontinuation, switching, or dose adjustment. Surgical disutilities are applied for fixed durations (6 cycles for Septoplasty, 1 cycle for Ablatherm) which may not capture individual variation in recovery. Background mortality uses linear interpolation between published life table age points. All parameter values are fictional and do not represent actual clinical data.

# HuncMarkovDMSS

The `huncMarkovDMSS` package is [available on Github](https://github.com/HealthyUncertainty/huncMarkovDMSS). 

A modifiable Shiny app [can be found here](https://healthyuncertainty.shinyapps.io/huncMarkovDMSS/).

### _AI Use Disclaimer_
_The near entirety of this post was written by Claude AI. The two small sections in which I speak in the first person are written by me._

| [Introduction](https://healthyuncertainty.github.io/2026-05-16-Analogue-Models-Intro/) | [Model 1 - CAIS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-1.-CAIS/) | [Model 2 - CNRD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-2.-CNRD/) | [Model 3 - ABD](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-3.-ABD/) | [Model 4 - DMSS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-4.-DMSS/) | [Model 5 - CISS](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-5.-CISS/) | [Discussion](https://healthyuncertainty.github.io/AnalogueModels/Analogue-Models-Discussion/) |

> Written with [StackEdit](https://stackedit.io/).
