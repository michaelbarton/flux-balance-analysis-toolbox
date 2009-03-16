function reactions = findVariableReactions(model,reaction_numbers)

  solution = optimizeCbModel(model);

  reactions = [];
  for r = 1:length(reaction_numbers)

    reaction      = reaction_numbers(r);

    %Skip this reaction if not used
    if solution.x(reaction) == 0
      continue;
    end

    %Skip if reaction at maximum
    if solution.x(reaction)^2 == 1000^2
      continue;
    end

    % Determine variability of this reaction
    temp = changeObjective(model,model.rxns(reaction));
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
      continue;
    end

    reactions = [reactions reaction];

  end

  reactions';
