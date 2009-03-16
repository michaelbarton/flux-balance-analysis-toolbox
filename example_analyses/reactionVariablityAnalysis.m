format long

addpath('helpers');setup;
model = yeastModel();

exchanges       = {'EX_nh4(e)','EX_glc(e)'};

biomassFix      = 0.3;
biomassReaction = 'biomass_SC4_bal';

reactions = singleGeneReactions(model);

% Determine the use of each reaction in each environment
results = struct;
row = 0;
for e = 1:length(exchanges)
  exchange = exchanges(e);

  uptakeModel  = fixGrowthOptimiseUptake(model,biomassReaction,exchange,biomassFix);
  solution = optimizeCbModel(uptakeModel);

  for r = 1:length(reactions)

    reaction      = reactions(r);
    reaction_name = model.rxns(reaction);

    row = row + 1;
    results(row).gene              = model.genes(find(model.rxnGeneMat(reaction,:)));
    results(row).reaction          = reaction;
    results(row).environment       = exchange;

    %Skip this reaction if not used
    if solution.x(reaction) == 0
      results(row).type = {'zero flux'};
      continue;
    end

    if solution.x(reaction)^2 == 1000^2
      results(row).type = {'at maximum'};
      continue;
    end

    % Determine variability of this reaction
    temp = changeObjective(uptakeModel,reaction_name);
    if solution.x(reaction) < 0
      % Find maximum of reaction
      minimumSolution = optimizeCbModel(temp,'max');
    else
      % Find minimum of reaction
      minimumSolution = optimizeCbModel(temp,'min');
    end

    % Skip reaction if it cannot vary in solution space
    % accounting for binary imprecision
    if round(minimumSolution.x(reaction)*10^7) == round(solution.x(reaction)*10^7)
      results(row).type = {'constrained'};
      continue;
    end

    results(row).type = {'variable'};

  end
end

% Print out reaction data
file = 'gene_reaction_type.txt';
header = {'gene','environment','type','reaction'};
printLabeledData([[results.gene]',[results.environment]',[results.type]'],[[results.reaction]'],false,-1,file,header);
