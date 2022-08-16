% Plots population vs. time for the consumer-resource mutualism model

% time span
tspan = 0.0:0.1:100.0;

% initial populations
initpop = [2.0 3.0];

% consumer-resource mutualism parameters
r = [0.6 0.6]; % intrinsic growth rates
c = [1.0 1.0]; % positive effects on species i from species j resources
a = [0.6 0.6]; % saturation level of functional response
h = [0.3 0.3]; % half-saturation densities
q = [1.0 1.0]; % negative effects of species i from costs to provide for species j
b = [0.2 0.2]; % saturation level of resource supply
e = [0.3 0.3]; % half-saturation constant
d = [0.01 0.01]; % density-dependent self-limitation

% ODE solver returns N as a single variable, a two-column matrix
[t, N] = ode45(@(t,y) cr_mutualism(t, y(1), y(2), r, c, a, h, q, b, e, d), tspan, initpop);

% Split the N matrix into N1 and N2
N1 = N(:,1);
N2 = N(:,2);

% generate plot
figure
plot(t, N1, t, N2)
