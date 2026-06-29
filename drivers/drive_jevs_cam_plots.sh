#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=plots
COMPONENT=cam

now=$(date -u +%Y%m%d%H)
vhr=${vhr:-$(echo $now | cut -c 9-10)}

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
plots_job=$1

qsub -v vhr=$vhr ${drivers_dir}/jevs_${STEP}_${COMPONENT}_${plots_job}.sh
