---
output: 
  html_document: 
    toc: yes
    number_sections: yes
---
# Student project description

**Petr Keil, Florencia Grattarola & Francois Leroy**

## Time frame

- 21 November 2023 - every student leaves with an idea about the project topic (response, predictors, grain, extent)
 
- 28 November 2023 - work on the project

- 5 December 2023 - work on the project. If all goals have been achieved, 
expand the project.

- 12 December 2023 - every student gives a 10 min presentation about the results.

## Goal

### A statistical model

The goal is to give students a hands-on experience with a statistical model applied
at biogeographical context. This can be a species distribution model (SDM), model explaining biodiversity (species richness), or any other response variable.

Students must pick a different response than what we used during classes.

### A simulation model

Alternatively, students can also choose to **implement a simulation model** (e.g. a neutral
model of biodiversity). Such activity may then indeed not include a response and predictors.

## Pick a response variable 

This can be:
- point occurrences of a species (e.g. from GBIF or other database)
- range maps, presence-absence data, surveys, time series, ...
- species richness, or other forms of biodiversity
- any other variable of interest, after discussion with us (e.g. language diversity,
deforestation, spectral variables, ...)

## Pick predictors

These are **hypothesized** variables that affect the response variable. 

You should pick at least **3 different data sources** for the predictors (e.g. WorldClim, EarthEnv, Corine, ...).

You should have some **reason** for why you're picking a specific predictor.

## Pick extent and grain (resolution)

**Extent** is the overall boundary within which you will operate. E.g. Czech Republic, Europe, World

**Grain** is the pixel size, if you work with rasters. E.g. 1x1 km in WorldClim. But it can also be country grain, 10x10 km grain, ...

## Do the analysis

Link the response to predictors. You can use any technique that you like, e.g. 
linear models, generalized linear models (logistic regression), random forest,
MaxEnt, ...

### Interpret the model

What can you learn from the fitted model? Can you say something about habitat
preferences/niche? Can you interpret model coefficients?

### Use it to for spatial predictions

Use the model to map your response into areas for which you have no data.

## Present the results

Prepare a 10 min presentation describing all the steps above. 


