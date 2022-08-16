% Plots population vs. time for the Lotka-Volterra predator prey model

% time span
tspan = 0.0:0.1:100.0;

% initial populations
initpop = [2.0 3.0];

% predator-prey parameters
r = [0.5 -0.3]; % intrinsic growth rates
a = [0.4 0.2]; % interspecific effects

% ODE solver returns N as a single variable, a two-column matrix
[t, N] = ode45(@(t,y) lotka_pred_prey(t, y(1), y(2), r, a), tspan, initpop);

% Split the N matrix into N1 and N2
N1 = N(:,1);
N2 = N(:,2);

% generate plot
figure
plot(t, N1, t, N2)
