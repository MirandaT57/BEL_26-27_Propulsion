 %% pipePressureLoss

function result = pipePressureLoss(mdot, rho, mu, L, D, roughness)
%pipePressureLoss
%calculates pressure loss through a straight circular tube
%INPUTS:
%   mdot      - mass flow rate [kg/s]
%   rho       - fluid density [kg/m^3]
%   mu        - dynamic viscosity [Pa*s]
%   L         - pipe length [m]
%   D         - pipe diameter [m]
%   roughness - absolute roughness [m]

% Input CHECKS
arguments
    mdot      (1,1) double {mustBeNonnegative, mustBeFinite}
    rho       (1,1) double {mustBePositive, mustBeFinite}
    mu        (1,1) double {mustBePositive, mustBeFinite}
    L         (1,1) double {mustBeNonnegative, mustBeFinite}
    D         (1,1) double {mustBePositive, mustBeFinite}
    roughness (1,1) double {mustBeNonnegative, mustBeFinite}
end

%OUTPUTS:
%   result.dP  - pressure drop [Pa]
%   result.v   - average velocity [m/s]
%   result.Re  - Reynolds number [-]
%   result.f   - Darcy friction factor [-]

A = pi * D^2 / 4 ;
v = mdot / (rho* A);
Re = rho * v * D / mu;

% Darcy friction factor
if Re == 0
    % No flow means no fricional pressure loss
    f = 0;
    regime = "no flow";
elseif Re < 2300
    f = 64 / Re;
    regime = "laminar";
elseif Re < 4000
    % Transitional flow
    % Approximate interpolation btwn laminar and turbulent values
relativeRoughness = roughness / D;
    % Haaland Approximation (error around 1.4%)
    fLaminar = 64/ Re;
    fTurbulent = 1 / (-1.8 * log10 ((relativeRoughness / 3.7)^1.11 + 6.9 / Re))^2;
 
 weight = (Re - 2300) / (4000 - 2300);

 f = (1-weight) * fLaminar + weight * fTurbulent;
 % transitional flow: 
 % friction factor is uncertain in this regime
 % linear interpolation is used as approximation
 regime = "transitional";

else 
    % Turbulent flow: Haaland approximation
    relativeRoughness = roughness / D;
    f = 1 / (-1.8 * log10((relativeRoughness / 3.7)^1.11 + 6.9 / Re))^2;
    regime = "turbulent";
end

% Darcy - Weisbach pressure Loss
dP = f * (L / D) * (rho * v^2 / 2);

% outputs
result.dP = dP;
result.v = v;
result.Re = Re;
result.f = f;
result.regime = regime;
%result.regime -  flow regime ["no flow", "laminar", "transitional", or
%"turbulent"]
end