# [[file:mutual_ide.org::*Slurm job script][Slurm job script:1]]
#!/bin/bash -l
#SBATCH --time=24:00:00
#SBATCH --ntasks=16
#SBATCH --mem=20g
#SBATCH --tmp=20g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lutzx119@umn.edu
#SBATCH --output=/home/shawa/lutzx119/reports/tausweep-%j.out

BASEDIR=~/mutualism
module load matlab
matlab -nodisplay <$BASEDIR/tauSweep.m
# Slurm job script:1 ends here
