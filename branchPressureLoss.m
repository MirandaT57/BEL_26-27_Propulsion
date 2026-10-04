%% branchPressureLoss

function result = branchPressureLoss( ...
    mdot, rho, mu, L, D, roughness, ...
    K, Cv, Cd, Ainj, dz)
% branchPressureLoss
% Calculates total pressure loss through ONE feed-system branch.
%
% Total pressure change includes:
%   - straight pipe friction
%   - fitting/minor losses
%   - valve loss
%   - injector loss
%   - gravity/elevation contribution
%
% INPUTS:
%   mdot      - mass flow rate [kg/s]
%   rho       - fluid density [kg/m^3]
%   mu        - dynamic viscosity [Pa*s]
%   L         - pipe length [m]
%   D         - pipe inner diameter [m]
%   roughness - absolute pipe roughness [m]
%   K         - total fitting loss coefficient [-]
%   Cv        - valve flow coefficient [-]
%   Cd        - injector discharge coefficient [-]
%   Ainj      - injector flow area [m^2]
%   dz        - elevation change, z_out - z_in [m]
%
% OUTPUTS:
%   result.dP_pipe
%   result.dP_fitting
%   result.dP_valve
%   result.dP_injector
%   result.dP_gravity
%   result.dP_total
%
% Diagnostics:
%   result.v
%   result.Re
%   result.f
%   result.regime

arguments
    mdot      (1,1) double {mustBeNonnegative, mustBeFinite}
    rho       (1,1) double {mustBePositive, mustBeFinite}
    mu        (1,1) double {mustBePositive, mustBeFinite}
    L         (1,1) double {mustBeNonnegative, mustBeFinite}
    D         (1,1) double {mustBePositive, mustBeFinite}
    roughness (1,1) double {mustBeNonnegative, mustBeFinite}
    K         (1,1) double {mustBeNonnegative, mustBeFinite}
    Cv        (1,1) double {mustBePositive, mustBeFinite}
    Cd        (1,1) double {mustBePositive, mustBeFinite}
    Ainj      (1,1) double {mustBePositive, mustBeFinite}
    dz        (1,1) double {mustBeFinite}
end

%% Pipe loss
pipe = pipePressureLoss( ...
    mdot, rho, mu, L, D, roughness);

%% Fitting loss
fitting = fittingPressureLoss( ...
    K, rho, pipe.v);

%% Valve loss
valve = valvePressureLoss( ...
    mdot, rho, Cv);

%% Injector loss
injector = injectorPressureLoss( ...
    mdot, rho, Cd, Ainj);

%% Gravity contribution
g = 9.80665;             % [m/s^2]

% Sign convention:
% dz = z_out - z_in
% dz > 0 means flow goes upward -> additional pressure loss
% dz < 0 means flow goes downward -> gravity helps the flow
dP_gravity = rho * g * dz;

%% Total
dP_total = ...
    pipe.dP + ...
    fitting.dP + ...
    valve.dP + ...
    injector.dP + ...
    dP_gravity;

%% Outputs
result.dP_pipe = pipe.dP;
result.dP_fitting = fitting.dP;
result.dP_valve = valve.dP;
result.dP_injector = injector.dP;
result.dP_gravity = dP_gravity;
result.dP_total = dP_total;

% Pipe diagnostics
result.v = pipe.v;
result.Re = pipe.Re;
result.f = pipe.f;
result.regime = pipe.regime;

end