function fermentative = createFermentativeModel(model,originalObjective)

  oxygenExchange  = 'EX_o2(e)';
  cytochromeCReaction = 'CYOOm';

  % Find smallest oxygen flux
  fermentative = changeObjective(model,oxygenExchange);
  sol = optimizeCbModel(fermentative);
  minOxygen = sol.f;

  % Kill cytochrome c and fix oxygen at smallest
  fermentative = changeRxnBounds(fermentative, cytochromeCReaction, 0, 'b');
  fermentative = changeRxnBounds(fermentative, oxygenExchange, minOxygen, 'l');

  % Reset objective
  fermentative = changeObjective(fermentative,originalObjective);
