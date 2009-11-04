addpath('helpers');setup;
model = readCbModel('models/Sc_iND750_GlcMM.xml');

% Each of the amino acids to estimate the cost for
amino_acids = { 'ala-L[c]'  , 'arg-L[c]' , 'asn-L[c]' , 'asp-L[c]' , 'cys-L[c]' , 'gln-L[c]' , 'glu-L[c]' , 'gly[c]' , 'his-L[c]' , 'ile-L[c]' , 'leu-L[c]' , 'lys-L[c]' , 'met-L[c]' , 'phe-L[c]' , 'pro-L[c]' , 'ser-L[c]' , 'thr-L[c]' , 'trp-L[c]' , 'tyr-L[c]' , 'val-L[c]' };


% Vectors to store results
amino_acid_names = [];
exchange_names = [];
fix_values = [];
absolute_costs = [];
relative_costs = [];


% Each of the simulated nutrient limited environments
exchange = {'EX_glc(e)'};
fix = [ 0.3 ];
biomassRxn = findRxnIDs(model,'biomass_SC4_bal');

change = [-0.00002:0.00001:0.00002];

model = fixGrowthOptimiseUptake(model,'biomass_SC4_bal',exchange,fix);

% Iterate over each of the amino acids
for a = 1:length(amino_acids)
  amino_acid = amino_acids(a);

  % Find the row number for the given biomass component
  componentS = find(ismember(model.mets,amino_acid));
  
  stoichiometry_change = change;
  response = change;

  for j=1:length(change)

    % Create temporary model to modify for each loop iteration
    temp_model = model;

    % Update the temporary model by modifying the coefficient of the 
    % component in the biomass reaction by the the given change
    temp_model.S(componentS,biomassRxn) = model.S(componentS,biomassRxn) + (change(j));

    % Find the optimum of the model, based on the model objective function 
    solution = optimizeCbModel(temp_model, 'max',false,false);

    % Find the current flux for the model objective reaction
    response(j) = solution.f;
    stoichiometry_change(j) = temp_model.S(componentS,biomassRxn);
  end

  regression = polyfit(stoichiometry_change,response,1);

  absolute = regression(1);
  relative = absolute * (model.S(componentS,biomassRxn)) * -1;

  % Store the results
  amino_acid_names = [amino_acid_names amino_acid];
  absolute_costs = [absolute_costs absolute];
  relative_costs = [relative_costs relative];

end

% Print out results
file = 'alternate_costs.txt';
header = {'amino_acid','relative','absolute'};
printLabeledData([amino_acid_names'],[relative_costs',absolute_costs'],false,false,file,header);
