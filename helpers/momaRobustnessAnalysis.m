function [controlFlux, objFlux] = momaRobustnessAnalysis(wild, mutant, controlRxn, nPoints, plotResFlag, objRxn,objType)

if (nargin < 4)
    nPoints = 20;
end
if (nargin < 5)
    plotResFlag = true;
end
if (nargin > 6)
    baseModel = changeObjective(mutant,objRxn);
else
    baseModel = mutant;
end
if (nargin < 7)
    objType = 'max';
end

if (findRxnIDs(mutant,controlRxn))
    tmpModel = changeObjective(mutant,controlRxn);
    solMin = linearMOMA(wild,tmpModel,'min');
    solMax = linearMOMA(wild,tmpModel,'max');
else
    error('Control reaction does not exist!');
end
    
objFlux = [];
controlFlux = linspace(solMin.f,solMax.f,nPoints)';

h = waitbar(0,'Robustness analysis in progress ...');
for i=1:length(controlFlux)
    waitbar(i/length(controlFlux),h);
    modelControlled = changeRxnBounds(baseModel,controlRxn,controlFlux(i),'b');
    solControlled = linearMOMA(wild,modelControlled,objType);
    objFlux(i) = solControlled.f;
end
close(h);

objFlux = objFlux';

if (plotResFlag)
    plot(controlFlux,objFlux)
    xlabel(strrep(controlRxn,'_','-'));
    ylabel('Objective');
    axis tight;
end
