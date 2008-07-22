function sensitivity = calculateReactionSensitivity(model,controlRxn)
  reaction_number = findRxnIDs(model,controlRxn);
  solution = optimizeCbModel(model);
  optimal_reaction_flux = solution.x(reaction_number);

  if optimal_reaction_flux == 0
    controlFlux = linspace(optimal_reaction_flux,optimal_reaction_flux * 0.999,5);
    objFlux = [];

    for i=1:length(controlFlux)
      modelControlled = changeRxnBounds(model,controlRxn,controlFlux(i),'b');
      solControlled = optimizeCbModel(modelControlled);
      objFlux(i) = solControlled.f;
    end
			    
    regression = polyfit(controlFlux,objFlux,1);
    sensitivity = regression(1);
  else
    sensitivity = 0;
  end
