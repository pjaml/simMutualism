% Phase space plot for Lotka-Volterra predator-prey model
%
% The range of starting populations
popRange = 0.0:0.5:10.0;

% Creates matrices for points in the N1 vs. N2 plot
[N1, N2] = meshgrid(popRange);

% predator-prey parameters
r = [0.5 -0.3]; % intrinsic growth rates
a = [0.4 0.2]; % interspecific effects

% find rates of change for starting populations in population range
% dN is a single matrix with rows representing dN1dt followed by dN2dt
dN = lotka(0, N1, N2, r, a);

% separates dN into the two matrices needed for U,V in quiver()
dN1 = dN(1:height(N1),:);
dN2 = dN(height(N1)+1:height(dN),:);

% generate vector field
figure
quiver(N1, N2, dN1, dN2)
