function plotSpeedTime(simMatFile)

    load(simMatFile);

    clf

    plot(1:iterations, speed_inst_P, 1:iterations, speed_inst_F1, 1:iterations, speed_inst_F2);
    legend('P', 'F1', 'F2');
    title(strcat(['Spread speed vs. time (tau21=' num2str(comp_21) ', tau12=' num2str(comp_12) ')']));
    xlabel('iterations');
    ylabel('speed');

    savefig(strcat(['comp_pheno_model/speed_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12, fspec) '_comp_21=' num2str(comp_21, fspec) '.fig']));

end
