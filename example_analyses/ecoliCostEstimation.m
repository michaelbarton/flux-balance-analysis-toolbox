addpath('helpers');setup;
originalModel = readCbModel('models/Ec_iJR904_GlcMM.xml');

% Each of the amino acids to estimate the cost for
amino_acids = {'ala-L[c]', 'arg-L[c]', 'asn-L[c]', 'asp-L[c]', 'cys-L[c]', 'gln-L[c]', 'glu-L[c]', 'gly[c]', 'his-L[c]', 'ile-L[c]', 'leu-L[c]', 'lys-L[c]', 'met-L[c]', 'phe-L[c]', 'pro-L[c]', 'ser-L[c]', 'thr-L[c]', 'trp-L[c]', 'tyr-L[c]', 'val-L[c]'};

% Each of the simulated nutrient limited environments
exchanges = {'EX_glc(e)','EX_nh4(e)','EX_so4(e)'};

% A range of fluxes to fix the biomass at
fixes = [ 0.1, 0.2, 0.3 ];

% Name of the biomass reaction in yeast
biomassReaction = 'BiomassEcoli';

% Struct to store results
results = struct;

% Iterate over the range of biomass fixes
row = 0;
for f = 1:length(fixes)
  fix = fixes(f);

  % Iterate over the different environment updakes
  for e = 1:length(exchanges)
    exchange = exchanges(e);

    % Fix the biomass flux, and set the uptake flux as the objective function
    temp_model = fixGrowthOptimiseUptake(originalModel,biomassReaction,exchange,fix);

    % Iterate over each of the amino acids
    for a = 1:length(amino_acids)
      amino_acid = amino_acids(a);

      % Calculate the costs for that amino acid
      [relative,absolute] = calculateBiomassComponentSensitivity(temp_model,amino_acid,biomassReaction);

      % Store the results
      row = row + 1;
      results(row).amino_acid_names = amino_acid;
      results(row).exchange_names   = exchange;
      results(row).fix_values       = fix;
      results(row).absolute_costs   = absolute;
      results(row).relative_costs   = relative;

    end
  end
end

% Print out results
file = 'results/ecoli_amino_acid_costs.txt';
header = {'amino_acid','exchange','fix','relative','absolute'};
printLabeledData([[results.amino_acid_names]',[results.exchange_names]'],[[results.fix_values]',[results.relative_costs]',[results.absolute_costs]'],false,-1,file,header);
