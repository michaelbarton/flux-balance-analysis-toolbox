function [relative,absolute,r] = calculateReactionSensitivity(model,controlRxn,numberOfPoints)
  reaction_number = findRxnIDs(model,controlRxn);
  solution = optimizeCbModel(model);
  optimal_reaction_flux = solution.x(reaction_number);

  if nargin < 3
    numberOfPoints = 7;
  end

  if optimal_reaction_flux == 0
    relative = 0;
    absolute = 0;
    r = 1;
  else
    controlFlux = linspace(optimal_reaction_flux,optimal_reaction_flux * 0.9999,numberOfPoints);
    objFlux = zeros(1,numberOfPoints);

    for i=1:length(controlFlux)
      modelControlled = changeRxnBounds(model,controlRxn,controlFlux(i),'b');
      solControlled = optimizeCbModel(modelControlled);
      objFlux(i) = solControlled.f;
    end
			
    [coefficients,confidence,residuals,intervals,stats] = regress(objFlux',[ones(numberOfPoints,1),controlFlux']);
    relative = coefficients(1);
    absolute = relative * (100 / optimal_reaction_flux);
    r = stats(1);
  end
