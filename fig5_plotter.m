clear all
cd 'basicSweep_fig5'
%cd 'symkernel_basicSweep_fig5'
matfiles = dir('*.mat');
var_p = 0.001:0.001:0.099;
tau12_local = [0.020,0.200,0.370];
tau21_local = [0.020,0.150,0.290];
rho_array = zeros(length(tau12_local), length(var_p));
rho_rc_array = zeros(length(tau12_local), length(var_p));
%rel_fit_arr_s_non = zeros(1,length(costs_s_non)); 
%%
for ii = 1:length(tau12_local)
    for jj = 1:length(var_p)
        %load(strcat(['results_tau12_' num2str(tau12_local(ii), '%.3f') '_tau21_' num2str(tau21_local(ii),'%.3f') '_sigma_sq_P_' num2str(var_p(jj), '%.3f') '.mat']))
        load(strcat(['results_tau12_' num2str(tau12_local(ii), '%.3f') '_tau21_' num2str(tau21_local(ii),'%.3f') '_sigma_sq_P_' num2str(var_p(jj), '%.3f') '_useDeltaDispKernels.mat']))
        rho_array(ii,jj) = rho;
%         rho_rc_array(ii,jj) = rho_rc;
%         if rho_f_lc > 0
%             rho_f1_lc_array(ii,jj) = rho_f_lc;
%         elseif rho_f_lc < 0
%             rho_f2_lc_array(ii,jj) = rho_f_lc;
%         else
%             rho_f2_lc_array(ii,jj) = 0;
%             rho_f1_lc_array(ii,jj) = 0;
%         end                               
    end
end
%save symkernel_fig5.mat
save fig5.mat
%%
load fig5.mat
figure()
plot(var_p, rho_array(1,:),'o', 'MarkerFaceColor', 'b')
hold on
plot(var_p, rho_array(2,:),'o', 'MarkerFaceColor','r')
plot(var_p, rho_array(3,:), 'o', 'MarkerFaceColor', '[0.8500 0.3250 0.0980]')
yline (0,'--', 'Local Coexistence')
yline (-1,'--', 'F_2 Wins')
yline (1,'--', 'F_1 Wins','LabelVerticalAlignment','bottom')
%yline([max(rho_rc_array) min(rho_rc_array)],'--',{'RC Upper bound','RC Lower bound'})
%yline (max(rho_f1_lc_array),'--', 'LC+F_1 dominant Upper bound')
%yline (min(rho_f2_lc_array),'--', 'LC+F_2 dominanr Lower bound')
%legend('Rel. fit of E_{non} with S_{mot}','Fit E_{non} = E_{mot}','Rel. fit of E_{non} with S_{non}','location', 'best')
xlabel('\sigma_P^2')
ylabel('\rho')
title ('Range overlap vs mutualist dispersal ability')
legend('Weak competition','Medium Competition','Strong Competition','Location','northwest')
%figname1 = 'symkernel_Fig5_dots.jpeg';
figname1 = 'asymFig5_dots.jpeg';
print (figname1,'-djpeg','-r600');  
