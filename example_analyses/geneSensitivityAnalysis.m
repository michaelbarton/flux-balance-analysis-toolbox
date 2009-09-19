format long

addpath('helpers');setup;
model = yeastModel();

exchanges       = {'EX_nh4(e)','EX_glc(e)','EX_so4(e)'};
reactions       = singleGeneReactions(model);

biomassFix      = 0.3;
biomassReaction = 'biomass_SC4_bal';

change = [0.97:0.01:1.00];

results = struct;
row = 0;

for e = 1:length(exchanges)
  exchange = exchanges(e);

  setups = struct;

  setups(1).model    = fixGrowthOptimiseUptake(model,biomassReaction,exchange,biomassFix);
  setups(1).solution = optimizeCbModel(setups(1).model);
  setups(1).name     = {'optimal'};

  % Increase nutrient uptake by 5% to create suboptimal solution
  setups(2).model    =  changeRxnBounds(setups(1).model,exchange,setups(1).solution.f * 1.05,'u');
  setups(2).solution = optimizeCbModel(setups(2).model);
  setups(2).name     = {'suboptimal'};

  for s = 1:length(setups)
    setup = setups(s);

    variableReactions = findVariableReactions(setup.model,reactions);

    for r = 1:length(variableReactions)
      reaction = variableReactions(r);

      uptake  = change;
      control = change;
      for c = 1:length(change)
        flux = setup.solution.x(reaction);
        temp = changeRxnBounds(setup.model, model.rxns(reaction), flux * change(c), 'b');

        [peturbed,wild] = linearMOMA(setup.model,temp,'max');
        uptake(c)  = peturbed.f;
        control(c) = flux * change(c);
      end

      regression = polyfit(control,uptake,1);
      effect = regression(1) * -1;

      row = row + 1;
      results(row).gene     = model.genes(find(model.rxnGeneMat(reaction,:)));
      results(row).exchange = exchange;
      results(row).effect   = effect;
      results(row).setup    = setup.name;
    end

  end

end

file = 'results/gene_sensitivity.txt';
header = {'gene','environment','sensitivity'};
printLabeledData([[results.gene]',[results.exchange]',[results.setup]'],[results.effect]',false,-1,file,header);
