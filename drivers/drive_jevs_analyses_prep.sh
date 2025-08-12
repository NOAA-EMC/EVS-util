#!/bin/bash
# Author: Alicia M. Bentley
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=prep
COMPONENT=analyses

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
prep_job=$1
if [ $prep_job == precip ]; then
    qsub -v vhr=$vhr ${drivers_dir}/jevs_analyses_${prep_job}_prep.sh
fi
