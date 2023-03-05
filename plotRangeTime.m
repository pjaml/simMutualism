function plotRangeTime(simMatFile)

    load(simMatFile);
    for i = 1:iterations+1

        rangeP(i) = length(find(n_P(i,:) >= ncrit));
        rangeF1(i) = length(find(n_F1(i,:) >= ncrit));
        rangeF2(i) = length(find(n_F2(i,:) >= ncrit));
    end

    clf
    plot(1:iterations+1, [rangeP; rangeF1; rangeF2]);
    xlabel('iterations');
    ylabel('range size');
    title(strcat(['Range size vs. time (tau21=' num2str(comp_21) ', tau12=' num2str(comp_12) ')']));
    legend('P', 'F1', 'F2');

    savefig(strcat(['comp_pheno_model/range_size_depF1=' num2str(dep_f(1)) '_depF2=' num2str(dep_f(2)) '_alphaF1=' num2str(alpha_fp(1)) '_alphaF2=' num2str(alpha_fp(2)) '_comp_12=' num2str(comp_12, fspec) '_comp_21=' num2str(comp_21, fspec) '.fig']));

end
