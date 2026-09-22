# An Empirical Study About the Effect of Financial Gain and Loss on User Engagement of mHealth Apps

Master's thesis research on how financial outcomes in a gain-loss incentive
system are associated with users' subsequent engagement in a mobile health
(mHealth) platform.

**Thesis:** [An Empirical Study About the Effect of Financial Gain and Loss on User Engagement of mHealth Apps](https://www.riss.kr/link?id=T17198768)  
**Author:** Haeyoon Shin  
**Institution:** Kyung Hee University  
**Degree:** M.S. in Business Administration, 2025

## Overview

Maintaining long-term user engagement is a persistent challenge for mobile
health (mHealth) applications. While prior research has examined how
financial incentives and deposit contracts affect behavior within individual
programs, less is known about how users respond after experiencing actual
financial gains or losses.

This study examines users' continuous engagement under a **gain-loss
incentive system**, in which users deposit money when joining a health
program and may subsequently experience a financial gain, a neutral outcome,
or a financial loss depending on their goal achievement.

The primary outcome is the number of days between the completion of one
program and participation in the next program.

## Research Questions

This study investigates:

1. How financial gain and loss are associated with the timing of users'
   subsequent program participation.
2. Whether the deposit amount moderates the relationship between financial
   outcomes and subsequent engagement.
3. Whether users' past program performance moderates the relationship
   between financial outcomes and subsequent engagement.

## Research Context

The study uses longitudinal behavioral data from **Challengers**, a South
Korean mHealth application that offers health-related programs under a
gain-loss incentive system.

Users deposit money when joining a program and receive different financial
outcomes based on their goal achievement:

- **Gain:** 100% goal achievement → full deposit refund + financial reward
- **Neutral:** 85% to below 100% achievement → full deposit refund
- **Loss:** below 85% achievement → partial deposit refund

The dataset spans **November 2018 to February 2023** and includes:

- **245,936 unique users**
- **71,237 health programs**
- **20M+ health-related activity submissions**
- User demographics and longitudinal program participation records

The original user-level data are not included in this repository.

## Empirical Strategy

### Two-Way Fixed Effects

The primary analysis uses a two-way fixed effects framework to examine the
relationship between financial outcomes and the number of days until a user
joins the next program.

The specifications control for:

- User fixed effects
- Program fixed effects
- Year-month fixed effects
- Deposit amount
- Average achievement rate in previous programs
- Number of activity submissions

Standard errors are clustered at the user level.

The main analysis contains approximately **1.65 million program-to-program
observations**.

### Survival Analysis

As a robustness check, I use a **Weibull Accelerated Failure Time (AFT)
model**, treating participation in the next program as the event of interest.

This approach directly models the duration between consecutive program
participations and provides an alternative specification suited to the
time-to-event nature of the dependent variable.

### Additional Analyses

The study also examines:

- Programs without deposit requirements to distinguish financial outcomes
  from goal achievement itself
- Heterogeneous relationships by deposit amount
- Heterogeneous relationships by users' past achievement
- Changes in deposit amounts between consecutive programs as an alternative
  measure of user engagement

## Key Findings

### Financial Gain and Loss

Relative to a neutral financial outcome, the two-way fixed effects estimates
show that:

- **Financial loss:** users take approximately **11.8 additional days** to
  join the next program.
- **Financial gain:** users join the next program approximately **4.6 days
  sooner**.

The results suggest an asymmetry in subsequent engagement following
financial gains and losses.

### Survival Analysis

The Weibull AFT model produces results consistent with the fixed-effects
analysis.

Relative to a neutral outcome:

- Financial loss is associated with a **52.3% longer** time until the next
  program.
- Financial gain is associated with a **40.6% shorter** time until the next
  program.

### Heterogeneous Relationships

The relationship between financial outcomes and subsequent engagement varies
with both the amount deposited and users' prior performance.

In particular, higher-performing users who experience a financial loss tend
to return more quickly than lower-performing users who experience a loss.

### Alternative Engagement Measure

Using the change in deposit amount between consecutive programs as an
alternative outcome produces consistent patterns:

- Users experiencing a financial loss subsequently reduce their deposit.
- Users experiencing a financial gain subsequently increase their deposit.

Together, these analyses show a consistent relationship between financial
outcomes and subsequent engagement across multiple empirical specifications
and engagement measures.

## Contribution

This study extends prior research on monetary incentives in mHealth in three
ways.

First, rather than focusing only on behavior within a single health program,
it examines **continuous participation across programs**.

Second, it studies a **gain-loss incentive system**, in which financial gains
and losses coexist within the same platform environment.

Third, it examines how the relationship between financial outcomes and
subsequent engagement varies with users' **deposit amounts and prior
performance**.

The findings highlight an important distinction between the motivating effect
of potential losses within a program and user behavior after an actual
financial loss has occurred.

## Data Availability

The original dataset used in this study is **not publicly available and is
not included in this repository**.

The data contain user-level behavioral and program participation information
from the platform. This repository therefore provides analysis code for
research transparency without distributing the underlying data.

As a result, the analysis code cannot be fully reproduced without access to
the original dataset.
