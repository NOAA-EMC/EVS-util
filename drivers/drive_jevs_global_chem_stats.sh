#!/bin/bash
# Author: Alicia Bentley
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=stats
COMPONENT=global_chem

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
run_job=$1
run_vhr=$2
if [ $run_job == atmos ]; then
   qsub -v vhr=${run_vhr} ${drivers_dir}/jevs_${COMPONENT}_${run_job}_grid2obs_aeronet_stats.sh
   qsub -v vhr=${run_vhr} ${drivers_dir}/jevs_${COMPONENT}_${run_job}_grid2obs_airnow_stats.sh
fi
