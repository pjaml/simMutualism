#!/usr/bin/env bash

#SBATCH --time=24:00:00
#SBATCH --ntasks=8
#SBATCH --mem=20g
#SBATCH --tmp=20g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lutzx119@umn.edu
module load matlab
matlab -nodisplay -r "maxNumCompThreads(1)"<m_files/mcm_comp21=0.0_comp12=0.0.m


# create a link to this sim's mat file in the mat_files directory
ln -s ../tau_sweep/mcm_comp21=0.0_comp12=0.0/comp_pheno_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=0.0_comp_21=0.0.mat mat_files/.

# create a link to this sim's range plot in the figures/range directory
ln -s ../../tau_sweep/mcm_comp21=0.0_comp12=0.0/range_size_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=0.0_comp_21=0.0.fig figures/range/.

# create a link to this sim's N vs x plot in the figures/n_v_x directory
ln -s ../../tau_sweep/mcm_comp21=0.0_comp12=0.0/N_v_x_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=0.0_comp_21=0.0.fig figures/n_v_x/.

# create a link to this sim's speed plot in the figures/speed directory
ln -s ../../tau_sweep/mcm_comp21=0.0_comp12=0.0/speed_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=0.0_comp_21=0.0.fig figures/speed/.
