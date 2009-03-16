function reactions = singleGeneReactions(model)

  % Find how many reactions have gene associations
  allAssociations = struct;
  row = 0;
  for r = 1:length(model.rxns)
    if length(find(model.rxnGeneMat(r,:))) > 0
      row = row + 1;
      allAssociations(row).reaction = r;
      allAssociations(row).count    = length(find(model.rxnGeneMat(r,:)));
    end
  end

  % Reduce to reactions that have a 1:1 gene association
  singleAssociations = struct;
  row = 0;
  for a = 1:length([allAssociations.reaction])

  % Single gene association for the reaction
    if allAssociations(a).count == 1

      % Single rection association for the gene
      if length(find(model.rxnGeneMat(:,find(model.rxnGeneMat(allAssociations(a).reaction,:))))) == 1
        row = row + 1;
        singleAssociations(row).reaction = allAssociations(a).reaction;
      end
    end
  end

  reactions = [singleAssociations.reaction]';
