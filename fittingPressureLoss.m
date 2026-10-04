%%fittingPressureLoss
function result=fittingPressureLoss(K, rho,v)
% fittingPressureLoss
% Calculates pressure loss across a fitting.
%
% INPUTS:
%   K   - fitting loss coefficient [-]
%   rho - fluid density [kg/m^3]
%   v   - average fluid velocity [m/s]
%
% OUTPUTS:
%   result.dP - fitting pressure drop [Pa]
%   result.q  - dynamic pressure [Pa]

arguments
    K   (1,1) double {mustBeNonnegative, mustBeFinite}
    rho (1,1) double {mustBePositive, mustBeFinite}
    v   (1,1) double {mustBeNonnegative, mustBeFinite}
end

% Dynamic pressure
q = 0.5 * rho * v^2;

% Fitting pressure loss
dP = K * q;

% Outputs
result.dP = dP;
result.q = q;

end