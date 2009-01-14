function [controlFlux, solutions] = momaRobustnessAnalysis(wild, mutant, controlRxn, nPoints, objType)

if (nargin < 4)
    nPoints = 20;
end
if (nargin < 5)
    objType = 'max';
end

if (findRxnIDs(mutant,controlRxn))
    tmpModel = changeObjective(mutant,controlRxn);
    solMin = linearMOMA(wild,tmpModel,'min');
    solMax = linearMOMA(wild,tmpModel,'max');
else
    error('Control reaction does not exist!');
end
    
solutions = struct;
controlFlux = linspace(solMin.f,solMax.f,nPoints)';

for i=1:length(controlFlux)
    modelControlled = changeRxnBounds(mutant,controlRxn,controlFlux(i),'b');
    solControlled = linearMOMA(wild,modelControlled,objType);
    solutions(i).objective = solControlled.f;
    solutions(i).reactions = solControlled.x;
end
