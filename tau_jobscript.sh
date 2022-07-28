#!/bin/bash -l
#SBATCH --time=24:00:00
#SBATCH --ntasks=16
#SBATCH --mem=20g
#SBATCH --tmp=20g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=lutzx119@umn.edu

BASEDIR=~
module load matlab
matlab -nodisplay -nodesktop -nosplash -r "maxNumCompThreads(1)"<$BASEDIR/m_files/mcm_comp21=0.40_comp12=0.40.m

# create a link to this sim's mat file in the mat_files directory
ln -s $BASEDIR/tau_sweep/mcm_comp21=0.40_comp12=0.40/comp_pheno_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=0.40_comp_21=0.40.mat mat_files/.

# create a link to this sim's range plot in the figures/range directory
ln -s $BASEDIR/tau_sweep/mcm_comp21=0.40_comp12=0.40/range_size_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=0.40_comp_21=0.40.fig figures/range/.
# put the png file in the png subdirectory
ln -s $BASEDIR/tau_sweep/mcm_comp21=0.40_comp12=0.40/range_size_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=0.40_comp_21=0.40.png figures/range/png/.

# create a link to this sim's N vs x plot in the figures/n_v_x directory
ln -s $BASEDIR/tau_sweep/mcm_comp21=0.40_comp12=0.40/N_v_x_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=0.40_comp_21=0.40.fig figures/n_v_x/.
# put the png file in the png subdirectory
ln -s $BASEDIR/tau_sweep/mcm_comp21=0.40_comp12=0.40/N_v_x_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=0.40_comp_21=0.40.png figures/n_v_x/png/.

# create a link to this sim's speed plot in the figures/speed directory
ln -s $BASEDIR/tau_sweep/mcm_comp21=0.40_comp12=0.40/speed_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=0.40_comp_21=0.40.fig figures/speed/.
# put the png file in the png subdirectory
ln -s $BASEDIR/tau_sweep/mcm_comp21=0.40_comp12=0.40/speed_depF1=0.9_depF2=0.1_alphaF1=0.5_alphaF2=0.5_comp_12=0.40_comp_21=0.40.png figures/speed/png/.
