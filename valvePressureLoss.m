%%valvePressureLoss

function result = valvePressureLoss(mdot, rho, Cv)
% valvePressureLoss
% Calculates liquid pressure loss across a valve using Cv.
%
% INPUTS:
%   mdot - mass flow rate [kg/s]
%   rho  - fluid density [kg/m^3]
%   Cv   - manufacturer valve flow coefficient [-]
%
% OUTPUTS:
%   result.dP     - valve pressure drop [Pa]
%   result.Q      - volumetric flow rate [m^3/s]
%   result.Q_gpm  - volumetric flow rate [US gal/min]
%   result.SG     - specific gravity [-]

arguments
    mdot (1,1) double {mustBeNonnegative, mustBeFinite}
    rho  (1,1) double {mustBePositive, mustBeFinite}
    Cv   (1,1) double {mustBePositive, mustBeFinite}
end

% Convert mass flow to volumetric flow
Q = mdot / rho;                  % [m^3/s]

% Convert m^3/s to US gallons/minute
Q_gpm = Q * 15850.323;           % [gpm]

% Specific gravity relative to water
SG = rho / 1000;

% Cv relation gives pressure drop in psi
dP_psi = SG * (Q_gpm / Cv)^2;

% Convert psi to Pa
psiToPa = 6894.757;
dP = dP_psi * psiToPa;

% Outputs
result.dP = dP;
result.Q = Q;
result.Q_gpm = Q_gpm;
result.SG = SG;

end