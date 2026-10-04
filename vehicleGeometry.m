%% vehicleGeometry.m
function geom = vehicleGeometry()

inch = .0254; %inch to meter 

% Tube internal diameters 
geom.oxLeft.D = .430 * inch;
geom.oxRight.D = .430 * inch;
geom.fuel.D = .305 * inch;

%Unknown until CAD is available
geom.oxLeft.L = NaN;
geom.oxRight.L = NaN;
geom.fuel.L = NaN;

end

