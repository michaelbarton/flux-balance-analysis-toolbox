### Gene Sensitivity Analysis

Calculates the sensitivity of the reactions catalysed by all the genes in the yeast model in five different simulated nutrient limitations. The aim of this is to simulate and predict what the sensitivity of growth rate is to each of the genes (see [Metabolic Control Analysis][mca] and [Shadow Prices][shadow]). The biomass is fixed at a constant rate, and the objective function set to minimise the flux through one of five defined nutrient exchanges. The nutrient limitations are glucose, nitrogen, sulphur, nitrogen, and oxygen. For each of the genes defined in the model and their corresponding reactions, the reaction sensitivity was then calculated under each condition, using the calculateReactionSensitivity.m helper script.

### Amino Acid Sensitivity Analysis

Calculates the sensitiivity of all amino acids, in four different nutrient limitations, at three different levels of biomass flux. This analysis is based on using the yeast model, and the calculateBiomassComponentSensitivity.m helper.

[mca]: http://www.ncbi.nlm.nih.gov/pubmed/1530563
[shadow]: http://www.ncbi.nlm.nih.gov/pubmed/8368835
