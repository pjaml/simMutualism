#!/bin/bash -l
#SBATCH --time=24:00:00
#SBATCH --ntasks=16
#SBATCH --mem=20g
#SBATCH --tmp=20g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lutzx119@umn.edu

BASEDIR=~/mutualism
module load matlab
matlab -nodisplay <$BASEDIR/tauSweep.m