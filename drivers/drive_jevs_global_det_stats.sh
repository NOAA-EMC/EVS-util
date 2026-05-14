#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=stats
COMPONENT=global_det

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
run_job=$1
stats_job=$2
if [ $run_job == wave ]; then
    if [ $stats_job == grid2obs ]; then
        qsub ${drivers_dir}/jevs_stats_global_det_gfs_${run_job}_${stats_job}.sh
    fi
elif [ $run_job == atmos ]; then
    if [ $stats_job == grid2grid ]; then
        qsub ${drivers_dir}/jevs_stats_global_det_aigfs_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_cfs_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_gfs_${run_job}_${stats_job}.sh
        sleep 20m
        qsub ${drivers_dir}/jevs_stats_global_det_metfra_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_ecmwf_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_cmc_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_cmc_regional_${run_job}_${stats_job}.sh
        sleep 15m
        qsub ${drivers_dir}/jevs_stats_global_det_ukmet_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_jma_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_fnmoc_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_dwd_${run_job}_${stats_job}.sh
    elif [ $stats_job == grid2obs ]; then
        qsub ${drivers_dir}/jevs_stats_global_det_aigfs_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_cfs_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_gfs_${run_job}_${stats_job}.sh
        sleep 20m
        qsub ${drivers_dir}/jevs_stats_global_det_ecmwf_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_cmc_${run_job}_${stats_job}.sh
        sleep 15m
        qsub ${drivers_dir}/jevs_stats_global_det_ukmet_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_jma_${run_job}_${stats_job}.sh
        qsub ${drivers_dir}/jevs_stats_global_det_fnmoc_${run_job}_${stats_job}.sh
    elif [ $stats_job == wmo_daily ]; then
        qsub ${drivers_dir}/jevs_stats_global_det_gfs_${run_job}_${stats_job}.sh
    fi
fi
