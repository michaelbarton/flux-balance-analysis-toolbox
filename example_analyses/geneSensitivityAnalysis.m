addpath('helpers');setup;
originalModel = readCbModel('models/Sc_iND750_GlcMM.xml');

genes = [];
reaction_names =[];
relative_costs = [];
absolute_costs = [];
environments =[];

exchanges = {'EX_glc(e)','EX_nh4(e)','EX_o2(e)','EX_pi(e)','EX_so4(e)'};

biomassFix = 0.1;
biomassReaction = 'biomass_SC4_bal';

for e = 1:length(exchanges)
  exchange = exchanges(e);

  model = fixGrowthOptimiseUptake(originalModel,biomassReaction,exchange,biomassFix);

  for g = 1:length(model.genes)

    % All the reactions catalysed by the gene
    reactions = model.rxns(find(model.rxnGeneMat(:,g)));

    for r = 1:length(reactions)

      % Find the optimal flux for this reaction
      reaction = reactions(r);

      [relative,absolute] = calculateReactionSensitivity(model,reaction);

      genes = [genes model.genes(g)];
      reaction_names = [reaction_names reaction];
      environments = [environments exchange];
      
      relative_costs = [relative_costs relative];
      absolute_costs = [absolute_costs absolute];

    end
  end
end

% Print out reaction data
file = 'reaction_fluxes.txt';
header = {'gene','reaction','environment','relative','absolute'};
printLabeledData([genes',reaction_names',environments'],[relative_costs',absolute_costs'],false,false,file,header);
