#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=prep
COMPONENT=global_ens

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
run_job=$1
if [ $run_job == atmos ]; then
    qsub ${drivers_dir}/jevs_prep_global_ens_atmos.sh
    qsub ${drivers_dir}/jevs_prep_global_ens_naefs_atmos.sh
elif [ $run_job == atmos_headline ]; then
    qsub ${drivers_dir}/jevs_prep_global_ens_headline.sh
elif [ $run_job == wave ]; then
    qsub ${drivers_dir}/jevs_prep_global_ens_wave.sh
fi
