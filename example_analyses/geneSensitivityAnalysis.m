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
  uptakeModel = fixGrowthOptimiseUptake(model,biomassReaction,exchange,biomassFix);

  variableReactions = findVariableReactions(uptakeModel,reactions);

  solution = optimizeCbModel(uptakeModel);

  for r = 1:length(variableReactions)
    reaction = variableReactions(r);

    uptake  = change;
    control = change;
    for c = 1:length(change)
      flux = solution.x(reaction);
      temp = changeRxnBounds(uptakeModel, model.rxns(reaction), flux * change(c), 'b');

      [peturbed,wild] = linearMOMA(uptakeModel,temp,'max');
      uptake(c)  = peturbed.f;
      control(c) = flux * change(c);
    end

    regression = polyfit(control,uptake,1);
    effect = regression(1) * -1;

    row = row + 1;
    results(row).gene     = model.genes(find(model.rxnGeneMat(reaction,:)));
    results(row).exchange = exchange;
    results(row).effect   = effect;

  end

end

file = 'results/gene_sensitivity.txt';
header = {'gene','environment','sensitivity'};
printLabeledData([[results.gene]',[results.exchange]'],[results.effect]',false,-1,file,header);
