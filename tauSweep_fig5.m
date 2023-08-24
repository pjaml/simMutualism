% [[file:mutual_ide.org::*Sweep script][Sweep script:1]]
% use integers for the number of iterations to run (rather than the actual
% values of tau12 and tau21) because it seems parfor requires it

rangeStep = 0.001;

outputDir = '/home/shawa/venka210/simMutualism/basicSweep_fig5/';

if ~isfolder(outputDir)
    mkdir(outputDir)
end

% instead of using a for loop for the tau12 values, we can use Slurm to set up
% jobs for each tau12 value. To change the range of tau12 values, modify the
% "SBATCH --array=" line in the Slurm job script.
sigma_sq_pval = rangeStep * str2num(getenv("SLURM_ARRAY_TASK_ID"));
tau12 = [0.02,0.2,0.37];
tau21 = [0.02,0.15,0.29];
parfor i = 1:length(tau21) %check if this is changed back to parfor
    %tau21 = j * rangeStep;
    simMutualism_fig5('outputDir', outputDir, 'tau12', tau12(i), 'tau21', tau21(i),'sigma_sq_P',sigma_sq_pval);
end
% Sweep script:1 ends here
