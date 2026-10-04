%%parallelOxPressureLoss
%% parallelOxPressureLoss

function result = parallelOxPressureLoss( ...
    mdotOx, rho, mu, L, D, roughness, ...
    K, Cv, Cd, AinjTotal, dz)
% parallelOxPressureLoss
% Calculates pressure loss through two identical parallel oxidizer branches.
%
% ASSUMPTIONS:
%   - left and right oxidizer branches are identical
%   - total oxidizer mass flow splits equally
%   - total oxidizer injector area is split equally
%   - both branches connect the same upstream and downstream pressures
%
% INPUTS:
%   mdotOx      - total oxidizer mass flow rate [kg/s]
%   rho         - oxidizer density [kg/m^3]
%   mu          - oxidizer dynamic viscosity [Pa*s]
%   L           - pipe length of ONE branch [m]
%   D           - pipe inner diameter [m]
%   roughness   - absolute roughness [m]
%   K           - fitting loss coefficient for ONE branch [-]
%   Cv          - valve Cv for ONE branch [-]
%   Cd          - oxidizer injector discharge coefficient [-]
%   AinjTotal   - total oxidizer injector flow area [m^2]
%   dz          - elevation change of ONE branch [m]
%
% OUTPUTS:
%   result.dP_total    - oxidizer feed pressure loss [Pa]
%   result.mdot_left   - left branch mass flow [kg/s]
%   result.mdot_right  - right branch mass flow [kg/s]
%   result.left        - left branch results
%   result.right       - right branch results

arguments
    mdotOx      (1,1) double {mustBeNonnegative, mustBeFinite}
    rho         (1,1) double {mustBePositive, mustBeFinite}
    mu          (1,1) double {mustBePositive, mustBeFinite}
    L           (1,1) double {mustBeNonnegative, mustBeFinite}
    D           (1,1) double {mustBePositive, mustBeFinite}
    roughness   (1,1) double {mustBeNonnegative, mustBeFinite}
    K           (1,1) double {mustBeNonnegative, mustBeFinite}
    Cv          (1,1) double {mustBePositive, mustBeFinite}
    Cd          (1,1) double {mustBePositive, mustBeFinite}
    AinjTotal   (1,1) double {mustBePositive, mustBeFinite}
    dz          (1,1) double {mustBeFinite}
end

%% Split total oxidizer flow equally

mdotBranch = mdotOx / 2;

%% Split total injector area equally

AinjBranch = AinjTotal / 2;

%% Calculate one physical branch

branch = branchPressureLoss( ...
    mdotBranch, ...
    rho, ...
    mu, ...
    L, ...
    D, ...
    roughness, ...
    K, ...
    Cv, ...
    Cd, ...
    AinjBranch, ...
    dz);

%% Parallel-system outputs

result.mdot_left = mdotBranch;
result.mdot_right = mdotBranch;

% Branches are identical under the current model
result.left = branch;
result.right = branch;

% Parallel branches have the same pressure drop.
% Do NOT add left and right pressure drops together.
result.dP_total = branch.dP_total;

end