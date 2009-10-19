function [relative,absolute] = calculateBiomassComponentSensitivity(model,component,biomass)

  % Find the number for the biomass reaction
  biomassRxn = findRxnIDs(model,biomass);

  % Find the row number for the given biomass component
  componentS = find(ismember(model.mets,component));

  change      = [0.9998:0.0001:1.0002];
  relChange   = model.S(componentS,biomassRxn) * change;
  relResponse = estimateResponse(model,componentS,biomassRxn,relChange);
  regression  = polyfit(log(change),log(relResponse * -1),1);
  relative    = regression(1);

  change      = [-0.00002:0.00001:0.00002];
  absChange   = model.S(componentS,biomassRxn) + change;
  absResponse = estimateResponse(model,componentS,biomassRxn,absChange);
  regression  = polyfit(absChange,absResponse,1);
  absolute    = regression(1);



function responses = estimateResponse(model,componentS,biomassRxn,changes)
  responses = changes;
  for i=1:length(changes)

    % Temporary model for each loop iteration
    temp_model = model;

    % Update the temporary model by changing the coefficient of the 
    % component in the biomass reaction to the changed value
    temp_model.S(componentS,biomassRxn) = changes(i);

    % Find the optimum of the model, based on the model objective function 
    solution = optimizeCbModel(temp_model,'max',false,false);
    responses(i) = solution.f;

  end
