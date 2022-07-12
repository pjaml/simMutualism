#!/usr/bin/env bash

chmod 775 tau_jobscript.sh

ORIGFILE=mutual_comp_model.m
JOBSCRIPT=tau_jobscript.sh

# create a directory to store all the .m and .mat files
mkdir -p {m_files,mat_files}

# create directories to store symlinks to the various figures
mkdir -p figures/{n_v_x,range,speed}

# create a directory to store each simulation
mkdir -p tau_sweep

# Loop through all the tau values you want to simulate
for comp21 in $(seq 0.0 0.5 1.0);
do
    for comp12 in $(seq 0.0 0.5 1.0);
    do

        # create a directory to hold all files for each simulation
        mkdir -p tau_sweep/mcm_comp21=${comp21}_comp12=${comp12}

        # Replace the decimal values after comp_12 and comp_21 in the original .m file with the
        # current for loop values and create a new .m file with these values in the filename
        sed -r "/comp_12*/ s/=\s*([0-9]+\.?[0-9]*)/= ${comp12}/; /comp_21*/ s/=\s*([0-9]+\.?[0-9]*)/= ${comp21}/" <$ORIGFILE >m_files/mcm_comp21=${comp21}_comp12=${comp12}.m

        # Update .m file to save newly generated files to directory created above
        sed "s/comp_pheno_model/tau_sweep\/mcm_comp21=${comp21}_comp12=${comp12}/" <$ORIGFILE >m_files/mcm_comp21=${comp21}_comp12=${comp12}.m

        chmod 775 m_files/mcm_comp21=${comp21}_comp12=${comp12}.m

        # Append instructions for the new .m file to the MSI batch job script

        # This updates the job script to use the current sim's values
        sed -i -r "s/(comp[_]?12=)[0-9]+\.?[0-9]*/\1${comp12}/g; s/(comp[_]?21=)[0-9]+\.?[0-9]*/\1${comp21}/g" $JOBSCRIPT

        #  sbatch tau_jobscript.sh
    done
done
