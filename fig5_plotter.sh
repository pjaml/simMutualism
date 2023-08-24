#!/bin/bash -l        
#SBATCH --time=2:00:00
#SBATCH --ntasks=4
#SBATCH --mem=4g
#SBATCH --tmp=4g
#SBATCH --mail-type=ALL  
#SBATCH --mail-user=venka210@umn.edu 
module load matlab 
matlab -nodisplay <fig5_plotter.m
