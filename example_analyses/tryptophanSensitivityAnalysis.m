format long

addpath('helpers');setup;
model = readCbModel('models/Sc_iND750_GlcMM.xml');

% Each of the amino acids to estimate the cost for
amino_acids = { 'trp-L[c]' };


% Vectors to store results
amino_acid_names = [];
exchange_names = [];
change_values = [];
response_values = [];


% Each of the simulated nutrient limited environments
exchanges = {'EX_nh4(e)' , 'EX_glc(e)'};
fix = [ 0.3 ];
biomassRxn = findRxnIDs(model,'biomass_SC4_bal');

change = [0.9998:0.0001:1.0002];

for e = 1:length(exchanges)
  exchange = exchanges(e);

  model = fixGrowthOptimiseUptake(model,'biomass_SC4_bal',exchange,fix);

  % Iterate over each of the amino acids
  for a = 1:length(amino_acids)
    amino_acid = amino_acids(a);

    % Find the row number for the given biomass component
    componentS = find(ismember(model.mets,amino_acid));
  
    for j=1:length(change)

      % Create temporary model to modify for each loop iteration
      temp_model = model;

      % Update the temporary model by modifying the coefficient of the 
      % component in the biomass reaction by the the given change
      temp_model.S(componentS,biomassRxn) = model.S(componentS,biomassRxn) * (change(j));

      % Find the optimum of the model, based on the model objective function 
      solution = optimizeCbModel(temp_model, 'max',false,false);

      % Store the results
      response_values = [response_values solution.f];
      change_values   = [change_values change(j)];
      amino_acid_names = [amino_acid_names amino_acid];
      exchange_names = [exchange_names exchange];
    end

  end

end

% Print out results
file = 'response_values.txt';
header = {'amino_acid','exchange','change','response'};
printLabeledData([amino_acid_names',exchange_names'],[change_values',response_values'],false,false,file,header);
