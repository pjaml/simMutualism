% [[file:mutual_ide.org::*Sweep script][Sweep script:1]]
% use integers for the number of iterations to run (rather than the actual
% values of tau12 and tau21) because it seems parfor requires it

rangeStep = 0.01;

outputDir = '/home/shawa/lutzx119/basicSweep/';

if ~isfolder(outputDir)
    mkdir(outputDir)
end

% instead of using a for loop for the tau12 values, we can use Slurm to set up
% jobs for each tau12 value. To change the range of tau12 values, modify the
% "SBATCH --array=" line in the Slurm job script.
tau12 = rangeStep * str2num(getenv("SLURM_ARRAY_TASK_ID"));

parfor j = 0:40

    tau21 = j * rangeStep;
    simMutualism('outputDir', outputDir, 'tau12', tau12, 'tau21', tau21);
end
% Sweep script:1 ends here
