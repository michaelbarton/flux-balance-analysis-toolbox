function [relative,absolute] = calculateBiomassComponentSensitivity(model,component,biomass)

  % Find the number for the biomass reaction
  biomassRxn = findRxnIDs(model,biomass);

  % Find the row number for the given biomass component
  componentS = find(ismember(model.mets,component));

  % The range of changes for the amino acid stoichiometry
  % plus/minus 0.0002% change
  change = [0.9998:0.0001:1.0002];

  % Vector for resulting changes in objective function
  response = change;

  for j=1:length(change)

    % Create temporary model to modify for each loop iteration
    temp_model = model;

    % Update the temporary model by modifying the coefficient of the 
    % component in the biomass reaction by the the given change
    temp_model.S(componentS,biomassRxn) = model.S(componentS,biomassRxn) * (change(j));

    % Find the optimum of the model, based on the model objective function 
    solution = optimizeCbModel(temp_model, 'max',false,false);

    % Find the current flux for the model objective reaction
    response(j) = solution.f;

  end

  % Relative cost is the slope between the two variables
  relative = calculateRelativeCost(change,response);

  % Absolute cost is the relative cost multiplied 
  % by the stoichiometry of the component in biomass
  absolute = calculateAbsoluteCost(relative,model.S(componentS,biomassRxn));

function relative_cost = calculateRelativeCost(change,growth)
  regression = polyfit(change,growth,1);

  % Multiply by -1 because the more negative the slope the greater the cost
  relative_cost = regression(1) * -1;

function absolute_cost = calculateAbsoluteCost(rel_cost,metabolite_requirement)
  % Multiply by -1 again because components used in the biomass
  % have a negative sign
  absolute_cost = rel_cost * (100 / metabolite_requirement) * -1;
