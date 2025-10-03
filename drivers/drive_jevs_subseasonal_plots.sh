#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=plots
COMPONENT=subseasonal

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
types="temp sea_ice sst pres_lvls precip"
##periods="last31days last90days"
periods="last90days"
for period in ${periods}; do
    for type in ${types}; do
        qsub ${drivers_dir}/jevs_plots_subseasonal_grid2grid_${type}_${period}.sh
    done
    qsub ${drivers_dir}/jevs_plots_subseasonal_grid2obs_prepbufr_${period}.sh
done
