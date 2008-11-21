function updated_model = fixGrowthOptimiseUptake(model,biomassShort,rxnShort,biomassFix)

  if (nargin < 4)
    biomassFix = 0.05;
  end

  % Set all exchange reactions to -1000
  [selExc,selUptake] = findExcRxns(model,false,false);
  exchanges = find(selUptake);
  temp = changeRxnBounds(model, model.rxns(exchanges), -100000, 'l');

  % Fix the biomass growth rate at the specified rate
  temp = changeRxnBounds(temp,biomassShort,biomassFix,'b');

  % Set specified exhange reaction as the reaction to be optimised
  updated_model = changeObjective(temp,rxnShort);
