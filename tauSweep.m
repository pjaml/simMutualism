iterations = 100;
maxIterations = 1000;
[tau12Range, tau21Range] = deal(0:0.01:0.4);
outputDir = './tauSweep/';

for tau12 = tau12Range

    for tau21 = tau21Range

        simMutualism('tau12', tau12, 'tau21', tau21, 'outputDir', outputDir, 'iterations', iterations, 'maxIterations', maxIterations);

    end
end
