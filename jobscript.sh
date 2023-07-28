#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4G
#SBATCH --time=4:00:00
#SBATCH --array=0-40
#SBATCH --mail-type=ALL
#SBATCH --mail-user=venka210@umn.edu
#SBATCH --output=/home/shawa/venka210/simMutualism/reports/tausweep-%j.out

cd /home/shawa/venka210/simMutualism/ || return
module purge

module load matlab
matlab -nodisplay <tauSweep.m
