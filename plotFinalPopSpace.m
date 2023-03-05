function plotFinalPopSpace(simMatFile)

    load(simMatFile);

    clf
    hold on
    plot(n_P(end,:));
    plot(n_F1(end,:));
    plot(n_F2(end,:));
    legend('P', 'F1', 'F2');
    title(strcat(['N vs. x (tau21=' num2str(comp_21) ', tau12=' num2str(comp_12) ')']));
    hold off

    savefig(strcat(['comp_pheno_model/N_v_x_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12, fspec) '_comp_21=' num2str(comp_21, fspec) '.fig']));

    % Save a PNG file
    % saveas(gcf, strcat(['comp_pheno_model/comp_pheno_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12, fspec) '_comp_21=' num2str(comp_21, fspec) '.png']));
end
