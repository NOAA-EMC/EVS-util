#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=stats
COMPONENT=cam

now=$(date -u +%Y%m%d%H)
vhr=${vhr:-$(echo $now | cut -c 9-10)}

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
stats_job=$1

if [[ "$stats_job" == *"rrfsmem"* ]]; then
    for mem in {1..5}; do
        qsub -v vhr=$vhr,mem=$mem ${drivers_dir}/jevs_${STEP}_${COMPONENT}_${stats_job}.sh
    done
else
    qsub -v vhr=$vhr ${drivers_dir}/jevs_${STEP}_${COMPONENT}_${stats_job}.sh
fi
