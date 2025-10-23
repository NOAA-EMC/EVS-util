#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=stats
COMPONENT=analyses

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
qsub -v vhr=$vhr ${drivers_dir}/jevs_stats_analyses_rtma_grid2obs.sh
qsub -v vhr=$vhr ${drivers_dir}/jevs_stats_analyses_rtma_precip.sh
qsub -v vhr=$vhr ${drivers_dir}/jevs_stats_analyses_urma_grid2obs.sh
qsub -v vhr=$vhr ${drivers_dir}/jevs_stats_analyses_urma_precip.sh
qsub -v vhr=$vhr ${drivers_dir}/jevs_stats_analyses_rtma_ru_grid2obs.sh
qsub -v vhr=$vhr ${drivers_dir}/jevs_stats_analyses_ccpa_precip.sh
