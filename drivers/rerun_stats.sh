#!/bin/bash

set -x

module load prod_util

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS

PDY=${1:-$(date +\%Y\%m\%d)}
PDYm1=$(finddate.sh $PDY s-1)
PDYm2=$(finddate.sh $PDY s-2)
PDYm3=$(finddate.sh $PDY s-3)
PDYm4=$(finddate.sh $PDY s-4)
PDYm5=$(finddate.sh $PDY s-5)
PDYm6=$(finddate.sh $PDY s-6)
PDYm7=$(finddate.sh $PDY s-7)

run_aigefs="YES"
run_analyses="YES"
run_aqm="YES"
run_cam="YES"
run_global_chem="YES"
run_global_det="YES"
run_global_ens="YES"
run_glwu="YES"
run_nwps="YES"
run_rtofs="YES"
run_subseasonal="YES"
run_wafs="YES"

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

if [ $run_aigefs == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/aigefs
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_aigefs_aigefs_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_aigefs_aigefs_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_aigefs_aigefs_atmos_precip.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_aigefs_gefs_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_aigefs_gefs_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_aigefs_gefs_atmos_precip.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_aigefs_hgefs_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_aigefs_hgefs_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_aigefs_hgefs_atmos_precip.sh
fi

if [ $run_analyses == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/analyses
    vhr_loop="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22"
    for vhr $vhr_loop; do
        qsub -v VDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_stats_analyses_rtma_grid2obs.sh
        qsub -v VDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_stats_analyses_rtma_ru_grid2obs.sh
        qsub -v VDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_stats_analyses_urma_grid2obs.sh
        qsub -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_analyses_ccpa_precip.sh
        qsub -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_analyses_rtma_precip.sh
        qsub -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_analyses_urma_precip.sh
    done
    ### vhr=23 depends on all other vhrs
    submit_time=$(date -d "+1 hours" '+%Y%m%d%H')
    submit_year=$(echo $rsubmit_time|cut -c1-4)
    submit_month=$(echo $submit_time|cut -c5-6)
    submit_day=$(echo $submit_time|cut -c7-8)
    submit_hour=$(echo $submit_time|cut -c9-10)
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm1,vhr=23 ${drivers_dir}/jevs_stats_analyses_rtma_grid2obs.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm1,vhr=23 ${drivers_dir}/jevs_stats_analyses_rtma_ru_grid2obs.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm1,vhr=23 ${drivers_dir}/jevs_stats_analyses_urma_grid2obs.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm3,vhr=23 ${drivers_dir}/jevs_stats_analyses_ccpa_precip.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm3,vhr=23 ${drivers_dir}/jevs_stats_analyses_rtma_precip.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm3,vhr=23 ${drivers_dir}/jevs_stats_analyses_urma_precip.sh

fi

if [ $run_aqm == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/aqm
    vhr_loop="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22"
    for vhr $vhr_loop; do
        qsub -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_aqm_atmos_grid2grid.sh
        qsub -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_aqm_atmos_grid2obs.sh
    done
    ### vhr=23 depends on all other vhrs
    submit_time=$(date -d "+1 hours" '+%Y%m%d%H')
    submit_year=$(echo $rsubmit_time|cut -c1-4)
    submit_month=$(echo $submit_time|cut -c5-6)
    submit_day=$(echo $submit_time|cut -c7-8)
    submit_hour=$(echo $submit_time|cut -c9-10)
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm3,vhr=23 ${drivers_dir}/jevs_stats_aqm_atmos_grid2grid.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm3,vhr=23 ${drivers_dir}/jevs_stats_aqm_atmos_grid2obs.sh

fi

if [ $run_cam == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/cam
    qsub -v VDATE=$PDYm7,vhr=08 ${drivers_dir}/jevs_stats_cam_hrrr_severe.sh
    qsub -v VDATE=$PDYm7,vhr=08 ${drivers_dir}/jevs_stats_cam_rrfs_severe.sh
    qsub -v VDATE=$PDYm7,vhr=08 ${drivers_dir}/jevs_stats_cam_refs_severe.sh
    for mem in 1 2 3 4 5; do
         qsub -v VDATE=$PDYm7,vhr=08,mem=$mem ${drivers_dir}/jevs_stats_cam_rrfsmem_severe.sh
    done
    qsub -v VDATE=$PDYm2,vhr=08 ${drivers_dir}/jevs_stats_cam_refs_precip.sh
    qsub -v VDATE=$PDYm2,vhr=08 ${drivers_dir}/jevs_stats_cam_refs_snowfall.sh
    qsub -v VDATE=$PDYm1,vhr=08 ${drivers_dir}/jevs_stats_cam_refs_spcoutlook.sh
    qsub -v VDATE=$PDYm1,vhr=07 ${drivers_dir}/jevs_stats_cam_refs_grid2obs.sh
    qsub -v VDATE=$PDYm1,vhr=07 ${drivers_dir}/jevs_stats_cam_rap_grid2obs.sh
    vhr_loop="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22"
    for vhr $vhr_loop; do
        qsub -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_cam_rrfs_chem_grid2obs_aeronet_aod.sh
        qsub -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_cam_rrfs_chem_grid2obs_airnow_pm10.sh
        qsub -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_cam_rrfs_chem_grid2obs_airnow_pm25.sh
        qsub -v VDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_stats_cam_rrfs_firewxnest_grid2obs.sh
        qsub -v VDATE=$PDYm2,vhr=$vhr ${drivers_dir}/jevs_stats_cam_rap_precip.sh
        qsub -v VDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_stats_cam_hrrr_radar.sh
        qsub -v VDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_stats_cam_rrfs_radar.sh
        qsub -v VDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_stats_cam_refs_radar.sh
        for mem in 1 2 3 4 5; do
            qsub -v VDATE=$PDYm1,vhr=$vhr,mem=$mem ${drivers_dir}/jevs_stats_cam_rrfsmem_radar.sh
        done
    done
    ### vhr=23 depends on all other vhrs
    submit_time=$(date -d "+2 hours" '+%Y%m%d%H')
    submit_year=$(echo $rsubmit_time|cut -c1-4)
    submit_month=$(echo $submit_time|cut -c5-6)
    submit_day=$(echo $submit_time|cut -c7-8)
    submit_hour=$(echo $submit_time|cut -c9-10)
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm3,vhr=23 ${drivers_dir}/jevs_stats_cam_rrfs_chem_grid2obs_aeronet_aod.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm3,vhr=23 ${drivers_dir}/jevs_stats_cam_rrfs_chem_grid2obs_airnow_pm10.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm3,vhr=23 ${drivers_dir}/jevs_stats_cam_rrfs_chem_grid2obs_airnow_pm25.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm1,vhr=23 ${drivers_dir}/jevs_stats_cam_rrfs_firewxnest_grid2obs.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm2,vhr=23 ${drivers_dir}/jevs_stats_cam_rap_precip.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm1,vhr=23 ${drivers_dir}/jevs_stats_cam_hrrr_radar.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm1,vhr=23 ${drivers_dir}/jevs_stats_cam_rrfs_radar.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm1,vhr=23 ${drivers_dir}/jevs_stats_cam_refs_radar.sh
    for mem in 1 2 3 4 5; do
        qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm1,vhr=23,mem=$mem ${drivers_dir}/jevs_stats_cam_rrfsmem_radar.sh
    done
    vhr_loop="02 03 06 09 12 15 18"
    for vhr in $vhr_loop; do
        qsub -v VDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_stats_cam_hrrr_grid2obs.sh
        qsub -v VDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_stats_cam_rrfs_grid2obs.sh
        for mem in 1 2 3 4 5; do
            qsub -v VDATE=$PDYm1,vhr=$vhr,mem=$mem ${drivers_dir}/jevs_stats_cam_rrfsmem_grid2obs.sh
        done
    done
    ### vhr=21 depends on all other vhrs
    submit_time=$(date -d "+5 hours" '+%Y%m%d%H')
    submit_year=$(echo $rsubmit_time|cut -c1-4)
    submit_month=$(echo $submit_time|cut -c5-6)
    submit_day=$(echo $submit_time|cut -c7-8)
    submit_hour=$(echo $submit_time|cut -c9-10)
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm1,vhr=21 ${drivers_dir}/jevs_stats_cam_hrrr_grid2obs.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm1,vhr=21 ${drivers_dir}/jevs_stats_cam_rrfs_grid2obs.sh
    for mem in 1 2 3 4 5; do
        qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm1,vhr=21,mem=$mem ${drivers_dir}/jevs_stats_cam_rrfsmem_grid2obs.sh
    done
    vhr_loop="19 20 21"
    for vhr in $vhr_loop; do
        qsub -v VDATE=$PDYm2,vhr=$vhr ${drivers_dir}/jevs_stats_cam_hrrr_precip.sh
        qsub -v VDATE=$PDYm2,vhr=$vhr ${drivers_dir}/jevs_stats_cam_rrfs_precip.sh
        for mem in 1 2 3 4 5; do
            qsub -v VDATE=$PDYm2,vhr=$vhr,mem=$mem ${drivers_dir}/jevs_stats_cam_rrfsmem_precip.sh
        done
    done
    ### vhr=22 depends on all other vhrs
    submit_time=$(date -d "+5 hours" '+%Y%m%d%H')
    submit_year=$(echo $rsubmit_time|cut -c1-4)
    submit_month=$(echo $submit_time|cut -c5-6)
    submit_day=$(echo $submit_time|cut -c7-8)
    submit_hour=$(echo $submit_time|cut -c9-10)
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm2,vhr=22 ${drivers_dir}/jevs_stats_cam_hrrr_precip.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm2,vhr=22 ${drivers_dir}/jevs_stats_cam_rrfs_precip.sh
    for mem in 1 2 3 4 5; do
        qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm2,vhr=22,mem=$mem ${drivers_dir}/jevs_stats_cam_rrfsmem_precip.sh
    done
    vhr_loop="00 06 12"
    for vhr in $vhr_loop; do
        qsub -v VDATE=$PDYm2,vhr=$vhr ${drivers_dir}/jevs_stats_cam_hrrr_snowfall.sh
        qsub -v VDATE=$PDYm2,vhr=$vhr ${drivers_dir}/jevs_stats_cam_rrfs_snowfall.sh
        qsub -v VDATE=$PDYm2,vhr=$vhr ${drivers_dir}/jevs_stats_cam_rap_snowfall.sh
        for mem in 1 2 3 4 5; do
            qsub -v VDATE=$PDYm2,vhr=$vhr,mem=$mem ${drivers_dir}/jevs_stats_cam_rrfsmem_snowfall.sh
        done
    done
    ### vhr=18 depends on all other vhrs
    submit_time=$(date -d "+5 hours" '+%Y%m%d%H')
    submit_year=$(echo $rsubmit_time|cut -c1-4)
    submit_month=$(echo $submit_time|cut -c5-6)
    submit_day=$(echo $submit_time|cut -c7-8)
    submit_hour=$(echo $submit_time|cut -c9-10)
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm2,vhr=18 ${drivers_dir}/jevs_stats_cam_hrrr_snowfall.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm2,vhr=18 ${drivers_dir}/jevs_stats_cam_rrfs_snowfall.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm2,vhr=18 ${drivers_dir}/jevs_stats_cam_rap_snowfall.sh
    for mem in 1 2 3 4 5; do
        qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm2,vhr=18,mem=$mem ${drivers_dir}/jevs_stats_cam_rrfsmem_snowfall.sh
    done
fi

if [ $run_global_chem == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/global_chem
    vhr_loop="00 03 06 09 12 15 18"
    for vhr in $vhr_loop; do
        qsub -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_global_chem_atmos_grid2obs_aeronet.sh
        qsub -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_global_chem_atmos_grid2obs_airnow.sh
    done
    ### vhr=21 depends on all other vhrs
    submit_time=$(date -d "+1 hours" '+%Y%m%d%H')
    submit_year=$(echo $rsubmit_time|cut -c1-4)
    submit_month=$(echo $submit_time|cut -c5-6)
    submit_day=$(echo $submit_time|cut -c7-8)
    submit_hour=$(echo $submit_time|cut -c9-10)
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_global_chem_atmos_grid2obs_aeronet.sh
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v VDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_stats_global_chem_atmos_grid2obs_airnow.sh
fi

if [ $run_global_det == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/global_det
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_gfs_wave_grid2obs.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_aigfs_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_aigfs_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_cfs_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_cfs_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_cmc_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_cmc_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_cmc_regional_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_dwd_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_ecmwf_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_ecmwf_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_fnmoc_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_fnmoc_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_gfs_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_gfs_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_jma_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_jma_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_metfra_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_ukmet_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_ukmet_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_global_det_gfs_atmos_wmo_daily.sh
fi

if [ $run_global_ens == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/global_ens
    qsub -v VDATE=$PDYm1,NEXTDATE=$PDY ${drivers_dir}/jevs_stats_global_ens_gefs_wave_grid2obs.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_gefs_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_gefs_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_gefs_atmos_sst.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_gefs_atmos_sea_ice.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_gefs_atmos_snowfall.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_gefs_atmos_cnv.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_gefs_atmos_precip.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_cmce_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_cmce_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_cmce_atmos_precip.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_cmce_atmos_snowfall.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_ecme_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_ecme_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_ecme_atmos_precip.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_ecme_atmos_snowfall.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_naefs_atmos_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_naefs_atmos_grid2obs.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_naefs_atmos_precip.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_gfs_headline_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_gefs_headline_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_global_ens_naefs_headline_grid2grid.sh
fi

if [ $run_glwu == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/glwu
    qsub -v VDATE=$PDYm1,NEXTDATE=$PDY ${drivers_dir}/jevs_stats_glwu_wave_grid2obs.sh
fi

if [ $run_nwps == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/nwps
    qsub -v VDATE=$PDYm1,NEXTDATE=$PDY ${drivers_dir}/jevs_stats_nwps_wave_grid2obs.sh
fi

if [ $run_rtofs == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/rtofs
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_rtofs_argo_grid2obs.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_rtofs_aviso_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_rtofs_ghrsst_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_rtofs_ndbc_grid2obs.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_rtofs_osisaf_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_rtofs_smap_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_rtofs_smos_grid2grid.sh
fi

if [ $run_subseasonal == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/subseasonal
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_subseasonal_cfs_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_subseasonal_cfs_grid2obs.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_subseasonal_gefs_grid2grid.sh
    qsub -v VDATE=$PDYm2 ${drivers_dir}/jevs_stats_subseasonal_gefs_grid2obs.sh
fi

if [ $run_wafs == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/stats/wafs
    qsub -v VDATE=$PDYm1 ${drivers_dir}/jevs_stats_wafs_atmos.sh 
fi
