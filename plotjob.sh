#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G
#SBATCH --time=6:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lutzx119@umn.edu
#SBATCH --output=/home/shawa/lutzx119/reports/plotjob-%j.out

cd /home/shawa/lutzx119/mutualism || return
module purge

module load matlab
matlab -nodisplay -r "generatePlots('~/basicSweep/', '~/figsBasicSweep/', 'plotOutcomes', true)"
