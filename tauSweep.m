% [[file:mutual_ide.org::*Sweep script][Sweep script:1]]
% use integers for the number of iterations to run (rather than the actual
% values of tau12 and tau21) because it seems parfor requires it

rangeStep = 0.01;

outputDir = '/home/shawa/lutzx119/tauSweep/';

% instead of using a for loop for the tau12 values, we can use Slurm to set up
% jobs for each tau12 value. To change the range of tau12 values, modify the
% "SBATCH --array=" line in the Slurm job script.
tau12 = rangeStep * uint16(str2num(getenv("SLURM_ARRAY_TASK_ID")))

parfor j = 0:40

    tau21 = j * rangeStep;

    % more iterations for tau values that result in regional coexistence
    if (tau12 > 0.13 && tau12 < 0.25 && tau21 < 0.15) || (tau21 > 0.28 && tau12 > 0.23 && tau12 < 0.3)
        simMutualism(outputDir, 'tau12', tau12, 'tau21', tau21, 'maxIterations', maxIterations, 'diameter', 3600);
    else
        simMutualism(outputDir, 'tau12', tau12, 'tau21', tau21);
    end

end
% Sweep script:1 ends here
