function dydt = odephenotypes(t,y,r1,r2,alpha12,alpha21,q1,q2,beta1,beta2,c1,c2,d1,d2,h1,h2,e1,e2,nodes,dep_p,dep_f, comp_12, comp_21)
y = reshape(y,3,nodes);
dydt  = zeros(size(y));

% rename variables so equations are easier to read
P = y(1,:);
F1 = y(2,:);
F2 = y(3,:);

dydt(1,:) = P.*((1-dep_p)*r1 + dep_p * (c1*((alpha12(1).*F1)./(h2(1)+F1) + (alpha12(2).*F2)./(h2(2)+F2)))- ((dep_f(1)+dep_f(2))/2) *(q1*(beta1.*(F1 + F2)./(e1+P)))-(d1.*P));

dydt(2,:) = F1.*((1-dep_f(1))*r2(1) + c2 *(dep_f(1)*(alpha21(1).*P)./(h1(1)+P))-q2*(dep_p*((beta2(1).*P)./(e2(1)+F1))) -(comp_12.*F2) -(d2(1).*F1));

% Testing no negative effect of dependence on intrinsic growth rate
%dydt(2,:) = F1.*(r2(1) + c2 *(dep_f(1)*(alpha21(1).*P)./(h1(1)+P))-q2*(dep_p*((beta2(1).*P)./(e2(1)+F1))) -(comp_12.*F2) -(d2(1).*F1));

dydt(3,:) = F2.*((1-dep_f(2))*r2(2) + c2 *(dep_f(2)*(alpha21(2).*P)./(h1(2)+P))-q2*(dep_p*((beta2(2).*P)./(e2(2)+F2))) - (comp_21.*F1) -(d2(2).*F2));

% Testing no negative effect of dependence on intrinsic growth rate
%dydt(3,:) = F2.*(r2(2) + c2 *(dep_f(2)*(alpha21(2).*P)./(h1(2)+P))-q2*(dep_p*((beta2(2).*P)./(e2(2)+F2))) - (comp_21.*F1) -(d2(2).*F2));

dydt = reshape(dydt,3*nodes,1);
end
