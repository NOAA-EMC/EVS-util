#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=stats
COMPONENT=aigefs

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
run_job=$1
if [ $run_job == atmos ]; then
    model=$2
    verif_case=$3
    if [ $model == all ]; then
        if [ $verif_case = grid2grid -o $verif_case = grid2obs -o $verif_case = precip ]; then
            models="gefs aigefs hgefs"
        fi
    else
        models=${model}
    fi
    for run_model in ${models}; do
        qsub ${drivers_dir}/jevs_stats_aigefs_${run_model}_atmos_${verif_case}.sh
    done
fi
