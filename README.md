# Spatial-Ecology-and-Macroecology 2022

*Petr Keil, Florencia Grattarola & Francois Leroy*

## Summary

This is an introduction to geographical patterns of species distributions and biodiversity, and their connections to applied ecological and conservation problems. It focuses on biological phenomena at large geographic resolutions (ca. 1km2 or coarser) or large geographic extents (continents, Earth). It also introduces major theories and models that explain or predict these geographic patterns. Practical parts are done mostly in R, and they aim to introduce data types, and quantitative methods used in macroecology. The course blends elements of biogeography, ecology, and spatial data analysis. Among others, the course is aimed at species distribution modellers, physical geographers, conservationists, and policy makers who will benefit from a "big picture" perspective not provided by traditional ecology, nor by physical geography.

## Requirements

Elementary knowledge of R, i.e. participants should be able to turn it on, load data in, and execute basic commands. Prior knowledge of ecology, geography, or statistics is advantageous, but not necessary.

## Lectures (Mon 8:45-10:15, lecture hall Z115)

- 26 September - *I. Species geographic distributions - where species live?* What is macroecology and spatial ecology. Historical exposition, biogeography, old pharts: Humboldt, Wallace, etc. The currencies of macroecology: Probability of occurrence, abundance, endemism, spatial aggregation, rarity. The big questions of macroecology.
- 3 October - *II. Drivers of distributions - why are species where they are?* Environmental drivers of distributions, dispersal limits, species abiotic and biotic niche, climatic niche, optima, ecological limits, habitat requirements.
- 10 October - *III. Species range size - what does it mean to be rare?* Range size, area of occupancy, extent of occurrence, role of spatial scale, fractals, aggregation. Patterns of range size, Rapoport's rule, range size vs abundance, range size and abundance distributions.
- 17 October - *IV. Applied issues around range and its size - which species should we protect?* Rarity, conservation status, IUCN, endemism, threat.
- 24 October - *V. Simple biodiversity - what is diversity and why does it matter?* Introduction to biodiversity, history, major concepts. Count-based measures - taxonomic, phylogenetic, functional diversity, weighted endemism. Diversity in other disciplines. Why diversity matters, biodiversity-ecosystem functioning (BEF).
- 31 October - *VI. Biodiversity and spatial scale - where and how much should we count species.* Biodiversity scaling: Species-area relationship, endemics-area relationship, alpha vs. beta vs. gamma diversity. Species accumulation curves, rarefaction, MoB.
- 7 November - *VII. Complex biodiversity - it's not just the counts.* Species composition, beta diversity, co-occurrences and species associations. Diversity at higher levels: Coenoses and biomes.
- 14 November - *VIII. Spatial patterns of biodiversity - where are the places with many species?* Biodiversity patterns: Latitudinal and altitudinal gradients, distance decay of similarity.
- 21 November - *IX.  Theories and mechanisms I. - why are some places species-rich and other poor?* Theory of island biogeography, neutral theory, maximum entropy theory, historical drivers of diversity.
- 28. November - *X.  Theories and mechanisms II. - is it all about climate?* All things climate - Rohde's hypothesis, metabolic theory, species-energy, endotherms vs ectotherms, habitat heterogeneity.
- 5 December - *XI. Temporal change - how does nature change in time during anthropocene?* Range size dynamics - expansions, contractions, extirpations. Biodiversity change, species loss, extinction rates, invasions. Spatial scale and biodiversity change, drivers of biodiversity change, anthropocene.
- 12 December - *XII. Applied issues around biodiversity - which places should we protect?* What should we protect? Biodiversity, rarity, or function? Habitat loss vs species loss, SLOSS, reserve selection, effects of climate, connectivity, refugia, neorefugia.

## Practices  (Mon 12:15-13:45, computer room Z120)

- 26 September (**Flo**). Major biodiversity data sources and data types: GBIF, OBIS, Map of Life, IUCN, BIEN, eBIRD, BBS, important atlas projects. Temporal change databases: BioTime, PREDICTS. Open vs. closed data, data quality issues, download through R, licensing and data sharing.
- 3 October (**Flo**). An example of large-scale biodiversity database, learning the basics and visualizing things. Gridding biodiversity data (geographic ranges, biodiversity), exploring patterns at different resolutions, making pretty maps. 
- 10 October (**Flo**, Petr). Drivers of distributions and diversity: Environmental data, historical data, human-related predictors, climate, soils, land cover. Future climate projected layers. Plotting and exploring associations and correlations.
- 17 October (**Petr**). Species Distribution Models (SDM) in R. Principle, techniques, fitting models, predicted vs observed maps, interpretation, predicting & forecasting.
- 24 October (**Francois**, Flo). Modelling patterns of biodiversity.
- 31 October (**Francois**). Biodiversity change.
- 7 November (**Francois**?). Species composition and beta diversity.
- 14 November (**Petr**). Simulation models of biodiversity - we will play with a simple neutral model, cellular automaton, etc.
- 21 November (**all**). Mini project I: Choosing a taxon, region, question, and data source. 
- 28 November (**all**). Mini project II.
- 5 December (**all**). Mini project III.
- 12 December (**all**). Mini project IV: Presentations of results.

## Literature

- Lomolino et al. (2010) Biogeography. Sinauer.
- Storch et al. (2007) Scaling Biodiversity. Cambridge University Press.
- McGill & Mittlebach (2012) Community Ecology. Oxford University Press.
- Brown J. (1995) Macroecology. University of Chicago Press.
- Smith et al. (2014) Foundations of Macroecology. University of Chicago Press.
- Ladle & Whittaker (2011) Conservation Biogeography. Wiley.
