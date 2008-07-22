### setLimitingExchange.m

Sets the specific reaction to have a flux of -1, sets all other fluxes to have a reaction rate of -1000. This effectively sets the specified reaction to be the limiting reaction.

### fixGrowthOptimiseUptake.m

Simulates nutrient limitation, but with a fixed biomass and instead maximises flux through the specified reaction. All the exhange reactions are set to -1000. The biomass reaction is set to the specified value, or the default of 0.05. The model objective function is then changed to the specified reaction (rxnShort). The objective function is maximised, but since exchange reactions are in the negative direction, this is equivalent to minimising the exchange flux.
