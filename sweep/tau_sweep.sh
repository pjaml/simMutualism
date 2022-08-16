#!/bin/bash

BASEDIR=~/sweep

ORIGFILE=$BASEDIR/mutual_comp_model.m
JOBSCRIPT=$BASEDIR/tau_jobscript.sh

chmod 775 $JOBSCRIPT

# create a directory to store all the .m and .mat files
mkdir -p $BASEDIR/{m_files,mat_files}

# create directories to store symlinks to the various figures
mkdir -p $BASEDIR/figures/{n_v_x,range,speed}/png

# create a directory to store each simulation
mkdir -p $BASEDIR/tau_sweep

# Loop through all the tau values you want to simulate
for comp21 in $(seq 0.0 0.01 0.4);
do
    for comp12 in $(seq 0.0 0.01 0.4);
    do

	# Format the comp12 and comp21 floating point values with the same format spec as the MATLAB files
	printf -v fcomp12 '%.2f' $comp12
	printf -v fcomp21 '%.2f' $comp21

        # Check to see if the current parameter value exists as a file (i.e. it's already been run on a previous sweep)
        # If it exists, skip it
        PARAMETERFILE=$BASEDIR/tau_sweep/mcm_comp21=${fcomp21}_comp12=${fcomp12}
        if [ -f "$PARAMETERFILE" ]; then
                continue
        else
                # create a directory to hold all files for each simulation
                mkdir -p $PARAMETERFILE

                # Replace the decimal values after comp_12 and comp_21 in the original .m file with the
                # current for loop values and create a new .m file with these values in the filename
                # then update .m file to save newly generated mat, fig, and png files to directory created above
sed -r "s/(comp_12\s*=\s*)[0-9]+\.?[0-9]*/\1${fcomp12}/; s/(comp_21\s*=\s*)[0-9]+\.?[0-9]*/\1${fcomp21}/; s/comp_pheno_model/tau_sweep\/mcm_comp21=${fcomp21}_comp12=${fcomp12}/" <$ORIGFILE >$BASEDIR/m_files/mcm_comp21=${fcomp21}_comp12=${fcomp12}.m


                chmod 775 $BASEDIR/m_files/mcm_comp21=${fcomp21}_comp12=${fcomp12}.m

                # Append instructions for the new .m file to the MSI batch job script


                # This updates the job script to use the current sim's values
                sed -i -r "s/(comp[_]?12=)[0-9]+\.?[0-9]*/\1${fcomp12}/g; s/(comp[_]?21=)[0-9]+\.?[0-9]*/\1${fcomp21}/g" $JOBSCRIPT

                sbatch $JOBSCRIPT
        fi
    done
done
