format long

addpath('helpers');setup;
model = yeastModel();

exchanges       = {'EX_nh4(e)','EX_glc(e)','EX_so4(e)'};

biomassFix      = 0.3;
biomassReaction = 'biomass_SC4_bal';

reactions = model.rxns;

% Determine the use of each reaction in each environment
results = struct;
row = 0;
for e = 1:length(exchanges)
  exchange = exchanges(e);

  setups = struct;

  setups(1).model    = fixGrowthOptimiseUptake(model,biomassReaction,exchange,biomassFix);
  setups(1).solution = optimizeCbModel(setups(1).model);
  setups(1).name     = {'optimal'};

  % Increase nutrient uptake by 5% to create suboptimal solution
  setups(2).model    =  changeRxnBounds(setups(1).model,exchange,setups(1).solution.f * 1.05,'b');
  setups(2).solution = optimizeCbModel(setups(2).model);
  setups(2).name     = {'suboptimal'};

  for s = 1:length(setups)
    setup = setups(s);

    for r = 1:length(reactions)

    reaction      = r;

    row = row + 1;
    results(row).reaction    = reaction;
    results(row).environment = exchange;
    results(row).setup       = setup.name;
    results(row).type        = calculateReactionVariability(setup.model,reaction);

    end
  end
end

% Print out reaction data
file = 'results/all_reaction_type.txt';
header = {'environment','type','solution','reaction'};
printLabeledData([[results.environment]',[results.type]',[results.setup]'],[[results.reaction]'],false,-1,file,header);
