#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=18:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lutzx119@umn.edu
#SBATCH --output=/home/shawa/lutzx119/reports/tausweep-%j.out

cd /home/shawa/lutzx119/mutualism
module purge

module load matlab
matlab -nodisplay <tauSweep.m
