iterations = 100;
maxIterations = 1000;
[tau12Range, tau21Range] = deal(0:0.01:0.4);
outputDir = '~/tauSweep/';

for tau12 = tau12Range

    for tau21 = tau21Range

        % more iterations for tau values that result in regional coexistence
        if tau12 > 0.13 && tau12 < 0.3 && tau21 < 0.15 || tau21 > 0.3
            maxIterations = 2000;
        else
            maxIterations = 1000;
        end

        simMutualism(outputDir, 'tau12', tau12, 'tau21', tau21, 'iterations', iterations, 'maxIterations', maxIterations);

    end
end
