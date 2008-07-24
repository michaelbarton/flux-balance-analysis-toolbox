### setLimitingExchange.m

Sets the specific reaction to have a lower boundary flux of -1, sets all other exchange fluxes to have a lower reaction boundary flux of -1000. This effectively sets the specified reaction to be the limiting.

### fixGrowthOptimiseUptake.m

Simulates nutrient limitation, but with a fixed biomass and instead maximises flux through the specified reaction. All exchange reactions are set have a lower boundary flux of -1000. The biomass reaction is set to the specified value, or the default of 0.05, which should should be significantly smaller than the lower boundary fluxes for the exchange reactions. The model objective function is then changed to the specified reaction (rxnShort). Optimising the model finds the maximal flux for objective reaction, but since negative flux value for exchange reactions indicates entry into the cell this, this is equivalent minimising the cellular entry flux.

### calculateReactionSensitivity.m

Estimates the sensitivity of the reaction in the provided model, given the objective function. Determines the optimal flux for the given reaction by optimising the model. The flux through the reaction is then set at 99.9% of it's optimal value, and the model optimised again. The change in objective reaction flux versus change in control reaction flux (dO/dR) is then calculated as the relative sensitivity of the reaction flux. The relative reaction sensitivity is then rescaled by the optimal control reaction flux to produce an estimate of reaction sensitivity on objective flux given an absolute changes in flux. 
