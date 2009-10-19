function reactionType = calculateReactionVariability(model,reaction)

  reaction_name = model.rxns(reaction);
  solution = optimizeCbModel(model);

  if solution.x(reaction) == 0
    reactionType = {'zero flux'};
    return;
  end

  if solution.x(reaction)^2 == 1000^2
    reactionType = {'at maximum'};
    return;
  end

  % Determine variability of this reaction
  temp = changeObjective(model,reaction_name);
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
    reactionType = {'constrained'};
  else
    reactionType = {'variable'};
  end
