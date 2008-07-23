addpath(genpath(fullfile(matlabroot, '/3rdparty/SBMLToolbox/')))   % Insert own SMBLToolbox path
addpath(genpath(fullfile(matlabroot, '/3rdparty/COBRAToolbox/')))  % Insert own COBRAToolbox path
addpath('/fs/san/home/mognemb2/lp_solve')                          % Insert own solver path

LPsolverOK = changeCobraSolver('lp_solve', 'LP');
