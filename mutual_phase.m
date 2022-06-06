% Phase space plot for consumer-resource mutualism model
%
% The range of starting populations
popRange = 0.0:5.0:170.0;

% Creates matrices for points in the N1 vs. N2 plot
[N1, N2] = meshgrid(popRange);

% consumer-resource mutualism parameters
r = [0.6 0.6]; % intrinsic growth rates
c = [1.0 1.0]; % positive effects on species i from species j resources
a = [0.6 0.6]; % saturation level of functional response
h = [0.3 0.3]; % half-saturation densities
q = [1.0 1.0]; % negative effects of species i from costs to provide for species j
b = [0.2 0.2]; % saturation level of resource supply
e = [0.3 0.3]; % half-saturation constant
d = [0.01 0.01]; % density-dependent self-limitation

% find rates of change for starting populations in population range
% dN is a single matrix with rows representing dN1dt followed by dN2dt
dN = cr_mutualism(0, N1, N2, r, c, a, h, q, b, e, d);

% separates dN into the two matrices needed for U,V in quiver()
dN1 = dN(1:height(N1),:);
dN2 = dN(height(N1)+1:height(dN),:);

% generate vector field
figure
quiver(N1, N2, dN1, dN2)
