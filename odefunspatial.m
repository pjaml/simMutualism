function dydt = odefunspatial(t,y,r1,r2,alpha12,alpha21,q1,q2,beta1,beta2,c1,c2,d1,d2,h1,h2,e1,e2,nodes,dep_p,dep_f)
y = reshape(y,2,nodes);
dydt  = zeros(size(y));
dydt(1,:) = y(1,:).*((1-dep_p)*r1 + dep_p*(c1*(alpha12.*y(2,:))./(h2+y(2,:)))-dep_f*(q1*(beta1.*y(2,:))./(e1+y(1,:)))-(d1.*y(1,:)));  %-(q1*(beta1.*y(2,:))./(e1+y(1,:))) -- add this back in if required
dydt(2,:) = y(2,:).*((1-dep_f)*r2 + dep_f*(c2*(alpha21.*y(1,:))./(h1+y(1,:)))-dep_p*(q2*(beta2.*y(1,:))./(e2+y(2,:)))-(d2.*y(2,:)));  %-(q2*(beta2.*y(1,:))./(e2+y(2,:))) -- add this back in if required
dydt = reshape(dydt,2*nodes,1);
end

