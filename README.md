# Spatial-Ecology-and-Macroecology 2025

*Petr Keil, Florencia Grattarola, Mel Tietje, Adam Ulicny, Elisa Padulosi, Carmen Soria, Gabriele Midolo*

## Summary

This is an introduction to geographical patterns of species distributions and biodiversity, and their connections to applied ecological and conservation problems. It focuses on biological phenomena at large geographic geographic extents (continents, Earth). It also introduces major theories and models that explain or predict these geographic patterns. Practical parts are done mostly in R, and they aim to introduce data types, and quantitative methods used in macroecology. The course blends elements of biogeography, ecology, and spatial data analysis. Among others, the course is aimed at species distribution modellers, physical geographers, conservationists, and policy makers who will benefit from a "big picture" perspective not provided by traditional ecology, nor by physical geography.

## Requirements

Elementary knowledge of R, i.e. participants should be able to turn it on, load data in, and execute basic commands. Prior knowledge of ecology, geography, or statistics is advantageous, but not necessary.

## Exam

Will be in person, it will last around 30 minutes, and it will be mostly about the contents of the lectures. Petr will offer dates throughout the examination period.

## Zapocet

"Zapocet" is given based on your attendance in the practical class (up to 3 absences are tolerated), and you need to either **give a 5-10 min presentation** (on the last practical class before Christmas) or hand in a **2-3 page report** to Petr.

Both formats need to contain:

- Introduction of the system (taxon, region, variables) that 
you analyzed
- Description of your objectives (e.g. to map the species, to estimate its 
climatic requirements, to map species richness, etc.)
- Brief description of the methods that you will use
- Results (effect sizes, variable importance, predicted maps)
- Brief discussion of what the results mean
- We may ask you for your code

If the presentation or the report need a clear improvement, we may ask you to fix
it before giving you the zapocet.

If you're doing the written report, ideally send it to Petr at least **one week before
the oral exam** to give us some time to fix issues.

## Lectures and practicals 

**Lectures:** Mon 8:45-10:15, lecture hall D220
**Practical classes:** Mon 12:15-13:45, computer room Z225. Most practical classes use R. Mild use of either QGIS or ArcGIS can be expected.

### Septebmer 28th - state holiday 

### October 5th 

- LECTURE. *Petr Keil*. **Species geographic distributions - where species live?** Course overview. What is macroecology and spatial ecology. Historical exposition, biogeography, old guys: Humboldt, Wallace, etc. The currencies of macroecology: Probability of occurrence, abundance, endemism, spatial aggregation, rarity. The big questions of macroecology.

- PRACTICAL CLASS. *Flo Grattarola*. **Major biodiversity data sources and data types**: GBIF, OBIS, Map of Life, IUCN, BIEN, eBIRD, BBS, important atlas projects. Temporal change databases: BioTime, PREDICTS. Open vs. closed data, data quality issues, download through R, licensing and data sharing.


### October 12th

- LECTURE. *Petr Keil*. **Drivers of distributions - why are species where they are?** Environmental drivers of distributions, dispersal limits and barriers, species abiotic and biotic niche, climatic niche, optima, ecological limits, habitat requirements.

- PRACTICAL CLASS. *Adam, Elisa*. An example of large-scale biodiversity database, learning the basics and visualizing things. Gridding biodiversity data (geographic ranges, biodiversity), exploring patterns at different resolutions, making pretty maps. 


### October 19th

- LECTURE. *Petr Keil*. **Species range size - what does it mean to be rare?** Range size, area of occupancy, extent of occurrence, role of spatial scale, fractals, aggregation. Patterns of range size, Rapoport's rule, range size vs abundance, range size and abundance distributions.

- PRACTICAL CLASS. *Elisa, Adam*. Drivers of distributions and diversity: Environmental data, historical data, human-related predictors, climate, soils, land cover. Future climate projected layers. Plotting and exploring associations and correlations.


### October 26th

- LECTURE. *Petr Keil*. **Applied issues around range and its size - which species should we protect?** Rarity, conservation status, IUCN, endemism, threat. Range collapse, species extinctions, invasions. Spatial structure of populations, metapopulation ecology.

- PRACTICAL CLASS. *Mel, Gabriele*. Species Distribution Models I.

### November 2nd

- LECTURE. *Elisa Padulosi*. **Simple biodiversity - what is diversity and why does it matter?** Introduction to biodiversity, history, major concepts. Count-based measures - taxonomic, phylogenetic, functional diversity, weighted endemism. Why diversity matters, biodiversity-ecosystem functioning (BEF).

- PRACTICAL CLASS.*Gabriele, Mel*. Species Distribution Models II.

### November 9th

- LECTURE. *Melanie Tietje* **Evolution of biodiversity.** Global biodiversity in geological time, mass extinctions, speciation and evolution - from natural selection to emergence of new species. Types of speciation, diversification, radiation, phylogeny. The current global biodiversity, and its partition among plants, animals, bacteria, primary producents, and among realms. 

- PRACTICAL CLASS. **TBA**

### November 16th - independent work

*Petr Keil*: **Mechanistic and simulation models** The idea of complex nature emerging from simple rules. Cellular automata - Conway's game of life, rule 30, fractals, deterministic chaos. Unified Neutral Theory of Biodiversity (UNTB) - how it sits in the context of competitive exclusion principle, niche theory, and paradox of the plankton. How UNTB works.

### November 23th

- LECTURE. *Petr Keil*. **Biodiversity and spatial scale - where and how much should we count species.** Biodiversity scaling: Species-area relationship, endemics-area relationship, alpha vs. beta vs. gamma diversity. Species accumulation curves, rarefaction, MoB. Grain-dependent drivers of biodiversity.

- PRACTICAL CLASS. **Mini project I**: Choosing a taxon, region, question, and data source. 

### November 30th 

- LECTURE. *Petr Keil*. **Spatial patterns of biodiversity - where are the places with many species?** Biodiversity patterns: Latitudinal and altitudinal gradients, their ubiquity and most common forms, and exceptions from the pattern. Explanations for the patterns: Rohde's hypothesis, metabolic theory, species-energy, endotherms vs ectotherms, habitat heterogeneity. Historical drivers of diversity. 

- PRACTICAL CLASS. **Mini project II**. Data acquisition and preparation.

### December 7th 

- LECTURE. *Petr Keil*. **Species composition, species associations** Community matrices and similarity matrices as the basis of community analysis. Pairwise similarity metrics, an example (Jaccard index), distance decay of similarity (Tobler's law), partitioning similarity to fractions explained by space vs environment, ordinations and clusters, biological regionalization. Interspecific associations, co-occurrences, inferring assembly rules from co-occurrence patterns.

- PRACTICAL CLASS. **Mini project III**. Data analysis.

### December 14th 

- LECTURE. *Petr Keil*. **Temporal change - how does nature change in time during the Anthropocene?** Biodiversity change, species loss, extinction rates, invasions, homogenization, temporal turnover, temporal change of spatial turnover. Spatial scale and biodiversity change, drivers of biodiversity change, anthropocene. Conservation biogeography and applied issues.

- PRACTICAL CLASS. **Mini project IV**. Presentation of results.

## Literature

- Lomolino et al. (2010) Biogeography. Sinauer.
- Storch et al. (2007) Scaling Biodiversity. Cambridge University Press.
- McGill & Mittlebach (2012) Community Ecology. Oxford University Press.
- Brown J. (1995) Macroecology. University of Chicago Press.
- Smith et al. (2014) Foundations of Macroecology. University of Chicago Press.
- Ladle & Whittaker (2011) Conservation Biogeography. Wiley.
