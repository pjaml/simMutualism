% time span
tspan = 0.0:0.1:100.0;

% initial populations
initpop = [2.0; 2.0; 2.0];

r_p = 0.3;
r_f = [0.30 0.30];
alpha_pf = [0.5 0.5];
alpha_fp = [0.5 0.5];
q1 = 1.0;
q2 = 1.0;
beta1 = 0.0;
beta2 = [0.0 0.0];
c1 = 1.0;
c2 = 1.0;
d_p = 0.1;
d_f = [0.1 0.1];
h1 = [0.3 0.3];
h2 = [0.3 0.3];
e1 = 0.3;
e2 = [0.3 0.3];
dep_p = 0.0;
dep_f = [0.4 0.9];

nodes = 1;

[t,y] = ode45(@(t,y) odephenotypes(t,y,r_p,r_f,alpha_pf,alpha_fp,q1,q2,beta1,beta2,c1,c2,d_p,d_f,h1,h2,e1,e2,nodes,dep_p,dep_f, comp_12, comp_21), tspan, initpop);

P = y(:,1);
F1 = y(:,2);
F2 = y(:,3);

% generate plot
figure;
plot(t, [P, F1, F2]);
legend('P', 'F1', 'F2');
xlabel('time');
ylabel('population')
