cl=parcluster('local')
pool = cl.parpool(16)

% use integers for the number of iterations to run
% since parfor requires it
rangeStartInt = 0
rangeInt = 40
rangeStep = 0.01
iterations = 100;
maxIterations = 1000;
<<<<<<< HEAD
[tau12Range, tau21Range] = deal(0:0.01:0.4);
outputDir = '~/tauSweep/';
=======
[tau12Range, tau21Range] = deal(rangeStartInt:rangeStartInt);

outputDir = '~/tauSweep/';

parfor i = tau12Range
>>>>>>> a355c91d24bbfa405f2459abbe5c301a155b61b4

    tau12 = i * rangeStep;

    for j = tau21Range

        tau21 = j * rangeStep;
        % more iterations for tau values that result in regional coexistence
        if tau12 > 0.13 && tau12 < 0.3 && tau21 < 0.15 || tau21 > 0.3
            maxIterations = 2000;
        else
            maxIterations = 1000;
        end

        simMutualism(outputDir, 'tau12', tau12, 'tau21', tau21, 'iterations', iterations, 'maxIterations', maxIterations);

    end
end
