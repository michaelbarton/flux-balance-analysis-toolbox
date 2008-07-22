function updated_model = setLimitingExchange(model,rxn)

  % Set all exchange reactions to -1000
  [selExc,selUptake] = findExcRxns(model,false,false);
  exchanges = find(selUptake);
  temp = changeRxnBounds(model, model.rxns(exchanges), -1000, 'l');

  % Update specified reaction
  updated_model = changeRxnBounds(temp, model.rxns(rxn), -1, 'l');
