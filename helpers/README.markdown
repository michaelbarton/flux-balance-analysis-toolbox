### setup.example.m

An example of a file to set common parameters for using the COBRA toolbox.

### setLimitingExchange.m

Sets the specific reaction to have a lower boundary flux of -1, sets all other exchange fluxes to have a lower reaction boundary flux of -1000. This effectively sets the specified reaction to be the limiting.

### fixGrowthOptimiseUptake.m

Simulates nutrient limitation, but with a fixed biomass and instead maximises flux through the specified reaction. All exchange reactions are set have a lower boundary flux of -1000. The biomass reaction is set to the specified value, or the default of 0.05, which should should be significantly smaller than the lower boundary fluxes for the exchange reactions. The model objective function is then changed to the specified reaction (rxnShort). Optimising the model finds the maximal flux for objective reaction, but since negative flux value for exchange reactions indicates entry into the cell this, this is equivalent minimising the cellular entry flux.

### calculateReactionSensitivity.m

Estimates the sensitivity of the reaction in the provided model, given the objective function. Determines the optimal flux for the given reaction by optimising the model. The flux through the reaction is then set at 99.9% of it's optimal value, and the model optimised again. The change in objective reaction flux versus change in control reaction flux (dO/dR) is then calculated as the relative sensitivity of the reaction flux. The relative reaction sensitivity is then rescaled by the optimal control reaction flux to produce an estimate of reaction sensitivity on objective flux given an absolute changes in flux. 

### calculateBiomassComponentSensitivity.m

Estimates the sensitivity of a biomass reaction component on the model objective function. The method alters the stoichiometry of the biomass component by +/- 0.0002% in steps of 0.0001%, and at each stage estimates the resulting effect on the model objective function. A linear curve is then fitted between the percentage change in stoichiometry, and the corresponding effect on objective flux. The slope of this curve is taken as the relative sensitivity of that biomass component. An absolute sensitivity is then calculated from dividing the relative sensitivity by the original stoichiometry of the given component in biomass.
