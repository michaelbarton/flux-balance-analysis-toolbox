function [relative,absolute] = calculateReactionSensitivity(model,controlRxn)
  reaction_number = findRxnIDs(model,controlRxn);
  solution = optimizeCbModel(model);

  reactionFlux  = solution.x(reaction_number);
  objectiveFlux = solution.f;

  if reactionFlux == 0
    relative = 0;
    absolute = 0;
  else

    peturbedReactionFlux = reactionFlux * 0.999;
    peturbedModel = changeRxnBounds(model,controlRxn,peturbedReactionFlux,'b');
    peturbedSolution = optimizeCbModel(peturbedModel);
    peturbedObjectiveFlux = peturbedSolution.f;

    dObj = objectiveFlux - peturbedObjectiveFlux;
    dReaction = reactionFlux - peturbedReactionFlux;

    relative = dObj / dReaction;
    absolute = relative * (100 / reactionFlux);
  end
