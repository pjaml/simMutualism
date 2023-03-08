% use integers for the number of iterations to run (rather than the actual
% values of tau12 and tau21) because it seems parfor requires it
tau12RangeStartInt = 0;
tau12RangeEndInt = 40;
tau21RangeStartInt = 0;
tau21RangeEndInt = 40;

rangeStep = 0.01;
iterations = 100;
maxIterations = 1000;

outputDir = '/home/shawa/lutzx119/tauSweep/';

tic
parfor i = 28:40

	for j = 0:40

		tau12 = i * rangeStep;
		tau21 = j * rangeStep;

		% more iterations for tau values that result in regional coexistence
		if (tau12 > 0.13 && tau12 < 0.25 && tau21 < 0.15) || (tau21 > 0.28 && tau12 > 0.23 && tau12 < 0.3)
			maxIterations = 2000;
		else
			maxIterations = 1000;
		end

		simMutualism(outputDir, 'tau12', tau12, 'tau21', tau21, 'iterations', iterations, 'maxIterations', maxIterations);

	end
end
parallel_time=toc
