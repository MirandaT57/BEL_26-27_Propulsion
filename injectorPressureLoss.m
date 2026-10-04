%% injectorPressureLoss

function result = injectorPressureLoss(mdot, rho, Cd, Ainj)
% injectorPressureLoss
% Calculates pressure loss across an injector
%  INPUTS:
%   mdot - mass flow rate [kg/s]
%   rho  - fluid density [kg/m^3]
%   Cd   - discharge coefficient [-]
%   A    - injector flow area [m^2]
%
%  OUTPUTS:
%   result.dP - injector pressure drop [Pa]

arguments
    mdot (1,1) double {mustBeNonnegative, mustBeFinite}
    rho (1,1) double {mustBePositive, mustBeFinite}
    Cd (1,1) double {mustBePositive, mustBeFinite}
    Ainj (1,1) double {mustBePositive, mustBeFinite}
end

% injector pressure loss 
dP = 0.5 * (mdot / (Cd * Ainj))^2 / rho;

% Output 
result.dP = dP;
end