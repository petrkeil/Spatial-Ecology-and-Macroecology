# Spatial-Ecology-and-Macroecology 2025

*Petr Keil, Florencia Grattarola, Mel Tietje, Adam Ulicny, Elisa Padulosi, Carmen Soria, Gabriele Midolo*

## Summary

This is an introduction to geographical patterns of species distributions and biodiversity, and their connections to applied ecological and conservation problems. It focuses on biological phenomena at large geographic resolutions (ca. 1km2 or coarser) or large geographic extents (continents, Earth). It also introduces major theories and models that explain or predict these geographic patterns. Practical parts are done mostly in R, and they aim to introduce data types, and quantitative methods used in macroecology. The course blends elements of biogeography, ecology, and spatial data analysis. Among others, the course is aimed at species distribution modellers, physical geographers, conservationists, and policy makers who will benefit from a "big picture" perspective not provided by traditional ecology, nor by physical geography.

## Requirements

Elementary knowledge of R, i.e. participants should be able to turn it on, load data in, and execute basic commands. Prior knowledge of ecology, geography, or statistics is advantageous, but not necessary.

## Exam

Will be in person, it will last between 30-60 minutes, and it will be mostly about the contents of the lectures. Petr will offer dates throughout the examination period.

## Zapocet

"Zapocet" is given based on your attendance in the practical class (up to 3 absences are tolerated), and you need to either **give a 5-10 min presentation** (on 12.12.2022) or hand in a **2-3 page report**.

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

## Lectures (Mon 8:45-10:15, lecture hall Z115)

- Sep 29 - *Petr Keil*: **Species geographic distributions - where species live?** Course overview. What is macroecology and spatial ecology. Historical exposition, biogeography, old guys: Humboldt, Wallace, etc. The currencies of macroecology: Probability of occurrence, abundance, endemism, spatial aggregation, rarity. The big questions of macroecology.
- Oct 6 - *Petr Keil*: **Drivers of distributions - why are species where they are?** Environmental drivers of distributions, dispersal limits and barriers, species abiotic and biotic niche, climatic niche, optima, ecological limits, habitat requirements.
- Oct 13 - *Carmen Soria*: **Species range size - what does it mean to be rare?** Range size, area of occupancy, extent of occurrence, role of spatial scale, fractals, aggregation. Patterns of range size, Rapoport's rule, range size vs abundance, range size and abundance distributions.
- Oct 20 - *Petr Keil*: **Applied issues around range and its size - which species should we protect?** Rarity, conservation status, IUCN, endemism, threat. Range collapse, species extinctions, invasions. Spatial structure of populations, metapopulation ecology.
- Oct 27 - *Elisa Padulosi*: **Simple biodiversity - what is diversity and why does it matter?** Introduction to biodiversity, history, major concepts. Count-based measures - taxonomic, phylogenetic, functional diversity, weighted endemism. Why diversity matters, biodiversity-ecosystem functioning (BEF).
- Nov 3 - *Petr Keil*: **Biodiversity and spatial scale - where and how much should we count species.** Biodiversity scaling: Species-area relationship, endemics-area relationship, alpha vs. beta vs. gamma diversity. Species accumulation curves, rarefaction, MoB. Grain-dependent drivers of biodiversity.
- Nov 10 - *Melanie Tietje* **Evolution of biodiversity.** Global biodiversity in geological time, mass extinctions, speciation and evolution - from natural selection to emergence of new species. Types of speciation, diversification, radiation, phylogeny. The current global biodiversity, and its partition among plants, animals, bacteria, primary productents, and among realms. 
- Nov 17 - **STATE HOLIDAY - No lecture**
- Nov 24 - *Petr Keil*: **Mechanistic and simulation models** The idea of complex nature emerging from simple rules. Cellular automata - Conway's game of life, rule 30, fractals, deterministic chaos. Unified Neutral Theory of Biodiversity (UNTB) - how it sits in the context of competitive exclusion principle, niche theory, and paradox of the plankton. How UNTB works.
- Dec 1 - *Petr Keil*: **Spatial patterns of biodiversity - where are the places with many species?** Biodiversity patterns: Latitudinal and altitudinal gradients, their ubiquity and most common forms, and exceptions from the pattern. Explanations for the patterns: Rohde's hypothesis, metabolic theory, species-energy, endotherms vs ectotherms, habitat heterogeneity. Historical drivers of diversity. 
- Dec 8 - *Petr Keil*: **Species composition, species associations** Community matrices and similarity matrices as the basis of community analysis. Pairwise similarity metrics, an example (Jaccard index), distance decay of similarity (Tobler's law), partitioning similarity to fractions explained by space vs environment, ordinations and clusters, biological regionalization. Interspecific associations, co-occurrences, inferring assembly rules from co-occurrence patterns.
- Dec 15 - *Petr Keil*: **Temporal change - how does nature change in time during anthropocene?** Biodiversity change, species loss, extinction rates, invasions, homogenization, temporal turnover, temporal change of spatial turnover. Spatial scale and biodiversity change, drivers of biodiversity change, anthropocene. Conservation biogeography and applied issues.


## Practical classes  (Mon 12:15-13:45, computer room Z225)

Most practical classes use R. Mild use of either QGIS or ArcGIS can be expected.

- Sep 29 (**Flo**). Major biodiversity data sources and data types: GBIF, OBIS, Map of Life, IUCN, BIEN, eBIRD, BBS, important atlas projects. Temporal change databases: BioTime, PREDICTS. Open vs. closed data, data quality issues, download through R, licensing and data sharing.
- Oct 6 (**Adam, Elisa**). An example of large-scale biodiversity database, learning the basics and visualizing things. Gridding biodiversity data (geographic ranges, biodiversity), exploring patterns at different resolutions, making pretty maps. 
- Oct 13 (**Elisa, Adam**) - Drivers of distributions and diversity: Environmental data, historical data, human-related predictors, climate, soils, land cover. Future climate projected layers. Plotting and exploring associations and correlations.
- Oct 20 (**Mel, Gabriele**). Species Distribution Models I.
- Oct 27 (**Gabriele, Carmen**). Species Distribution Models II.
- Nov 3  (**Petr, Flo**). Biodiversity change.
- Nov 10 (**Petr, Flo**). Simulation models of biodiversity.
- Nov 17 - **State holiday - no practical class**
- Nov 24 (**all**). Mini project I: Choosing a taxon, region, question, and data source. 
- Nov 1 (**all**). Mini project II. Work on the project with us, data preparation.
- Dec 8 (**all**). Mini project III. Work on the project with us, analysis.
- Dec 15 (**all**). Mini project IV: Presentations of results.

Types of data- should we include this in the first practical.



## Literature

- Lomolino et al. (2010) Biogeography. Sinauer.
- Storch et al. (2007) Scaling Biodiversity. Cambridge University Press.
- McGill & Mittlebach (2012) Community Ecology. Oxford University Press.
- Brown J. (1995) Macroecology. University of Chicago Press.
- Smith et al. (2014) Foundations of Macroecology. University of Chicago Press.
- Ladle & Whittaker (2011) Conservation Biogeography. Wiley.
