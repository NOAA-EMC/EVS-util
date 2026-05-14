#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=plots
COMPONENT=rtofs

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}

qsub ${drivers_dir}/jevs_plots_rtofs_argo_grid2obs_last60days.sh
qsub ${drivers_dir}/jevs_plots_rtofs_aviso_grid2grid_last60days.sh
qsub ${drivers_dir}/jevs_plots_rtofs_ghrsst_grid2grid_last60days.sh
qsub ${drivers_dir}/jevs_plots_rtofs_osisaf_grid2grid_last60days.sh

sleep 15m
qsub ${drivers_dir}/jevs_plots_rtofs_smap_grid2grid_last60days.sh
qsub ${drivers_dir}/jevs_plots_rtofs_smos_grid2grid_last60days.sh
qsub ${drivers_dir}/jevs_plots_rtofs_ndbc_grid2obs_last60days.sh
qsub ${drivers_dir}/jevs_plots_rtofs_headline_grid2grid_last90days.sh
