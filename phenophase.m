maxpop = 10.0;
popRange = 0.0:0.5:maxpop;

[P, F1, F2] = meshgrid(popRange);

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
comp_12 = 1.0;
comp_21 = 4.0;

ystart = [P(:).'; F1(:).'; F2(:).'];
ystart = reshape(ystart, 3*length(ystart), 1);

dy = growthODEs(0, ystart, r_p, r_f, alpha_pf, alpha_fp, q1, q2, beta1, beta2, c1, c2, d_p, d_f, h1, h2, e1, e2, length(P(:).'), dep_p, dep_f, comp_12, comp_21);

dP = reshape(dy((1:3:end),:), length(P), length(P), length(P));
dF1 = reshape(dy((2:3:end),:), length(P), length(P), length(P));
dF2 = reshape(dy((3:3:end),:), length(P), length(P), length(P));

u = dP ./ sqrt(dP .^ 2 + dF1 .^2 + dF2 .^ 2);
v = dF1 ./ sqrt(dP .^ 2 + dF1 .^2 + dF2 .^ 2);
w = dF2 ./ sqrt(dP .^ 2 + dF1 .^2 + dF2 .^ 2);

figure;
quiver3(P, F1, F2, u, v, w, 0.35);
xlabel('P');
ylabel('F1');
zlabel('F2');
hold on;

syms x y z
eq1 = ((1-dep_p).*r_p + dep_p .* (c1.*((alpha_pf(1).*y)./(h2(1)+y) + (alpha_pf(2).*z)./(h2(2)+z)))- ((dep_f(1)+dep_f(2))/2) .*(q1.*(beta1.*(y + z)./(e1+x)))-(d_p.*x));
eq2 = ((1-dep_f(1)).*r_f(1) + c2 .*(dep_f(1).*(alpha_fp(1).*x)./(h1(1)+x))-q2.*(dep_p.*((beta2(1).*x)./(e2(1)+y))) -(d_f(1).*y));
eq3 = ((1-dep_f(2)).*r_f(2) + c2 .*(dep_f(2).*(alpha_fp(2).*x)./(h1(2)+x))-q2.*(dep_p.*((beta2(2).*x)./(e2(2)+z))) -(d_f(2).*z));

fimplicit3(eq1, [0 maxpop]);
fimplicit3(eq2, [0 maxpop]);
fimplicit3(eq3, [0 maxpop]);

hold off;
