clear all

fspec = '%.2f';
tau_12_list = [0.00:0.01:0.40];
tau_21_list = [0.00:0.01:0.40];

outcomes = zeros(length(tau_12_list), length(tau_21_list));

for ii = 1:length(tau_12_list)
    for jj = 1:length(tau_21_list)

        load(strcat(['~/sweep/mat_files/comp_pheno_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=' num2str(tau_12_list(ii), fspec) '_comp_21=' num2str(tau_21_list(jj), fspec) '.mat']));

        outcomes(ii,jj) = det_outcome(nP, nF1, nF2, 0.05);

    end
end

figure(1)
heatmap(tau_12_list, fliplr(tau_21_list), rot90(outcomes));
xlabel('tau_{12}');
ylabel('tau_{21}');
