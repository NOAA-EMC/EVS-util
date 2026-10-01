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

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

if [ $run_aigefs == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/prep/aigefs
    qsub -v INITDATE=$PDYm2 ${drivers_dir}/jevs_prep_aigefs_atmos.sh
fi

if [ $run_analyses == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/prep/analyses
    vhr_loop="00 06 12 18"
    for vhr in $vhr_loop; do
        qsub -v INITDATE=$PDYm3,vhr=$vhr ${drivers_dir}/jevs_prep_analyses_precip.sh
    done
fi

if [ $run_aqm == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/prep/aqm
    qsub -v INITDATE=$PDYm3 ${drivers_dir}/jevs_prep_aqm_atmos_grid2grid.sh
    qsub -v INITDATE=$PDYm3 ${drivers_dir}/jevs_prep_aqm_atmos_grid2obs.sh
fi

if [ $run_cam == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/prep/cam
    qsub -v INITDATE=$PDYm3,vhr=00 ${drivers_dir}/jevs_prep_cam_rrfs_chem_grid2obs.sh
    qsub -v INITDATE=$PDYm1,vhr=07 ${drivers_dir}/jevs_prep_cam_severe.sh
    vhr_loop="00 06 12 18"
    for vhr in $vhr_loop; do
        qsub -v INITDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_prep_cam_hrrr_severe.sh
        qsub -v INITDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_prep_cam_precip.sh
        qsub -v INITDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_prep_cam_hrrr_precip.sh
        qsub -v INITDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_prep_cam_rrfs_severe.sh
        qsub -v INITDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_prep_cam_rrfs_precip.sh
        for mem in 1 2 3 4 5; do
            qsub -v INITDATE=$PDYm1,vhr=$vhr,mem=$mem ${drivers_dir}/jevs_prep_cam_rrfsmem_severe.sh
            qsub -v INITDATE=$PDYm1,vhr=$vhr,mem=$mem ${drivers_dir}/jevs_prep_cam_rrfsmem_precip.sh
        done
        ### depends on hrrr_severe, rrfs_severe, rrfsmem_severe
        submit_time=$(date -d "+1 hours" '+%Y%m%d%H')
        submit_year=$(echo $rsubmit_time|cut -c1-4)
        submit_month=$(echo $submit_time|cut -c5-6)
        submit_day=$(echo $submit_time|cut -c7-8)
        submit_hour=$(echo $submit_time|cut -c9-10)
        qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v INITDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_prep_cam_refs_severe.sh
    done
    vhr_loop="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23"
    for vhr in $vhr_loop; do
        qsub -v INITDATE=$PDYm1,vhr=$vhr ${drivers_dir}/jevs_prep_cam_radar.sh
    done
fi

if [ $run_global_chem == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/prep/global_chem
    qsub -v INITDATE=$PDYm3 ${drivers_dir}/jevs_prep_global_chem_atmos_grid2obs.sh
fi

if [ $run_global_det == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/prep/global_det
    qsub -v INITDATE=$PDYm1 ${drivers_dir}/jevs_prep_global_det_atmos.sh
    qsub -v INITDATE=$PDYm1 ${drivers_dir}/jevs_prep_global_det_wave.sh
fi

if [ $run_global_ens == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/prep/global_ens
    qsub -v INITDATE=$PDYm1,NEXTDATE=$PDY ${drivers_dir}/jevs_prep_global_ens_wave.sh
    qsub -v INITDATE=$PDYm2 ${drivers_dir}/jevs_prep_global_ens_atmos.sh
    qsub -v INITDATE=$PDYm2 ${drivers_dir}/jevs_prep_global_ens_naefs_atmos.sh
    ### jevs_prep_global_ens_headline depends on jevs_prep_global_ens_atmos and jevs_prep_global_ens_naefs_atmos being done
    submit_time=$(date -d "+6 hours" '+%Y%m%d%H')
    submit_year=$(echo $rsubmit_time|cut -c1-4)
    submit_month=$(echo $submit_time|cut -c5-6)
    submit_day=$(echo $submit_time|cut -c7-8)
    submit_hour=$(echo $submit_time|cut -c9-10)
    qsub -a ${submit_year}${submit_month}${submit_day}${submit_hour}59 -v INITDATE=$PDYm2 ${drivers_dir}/jevs_prep_global_ens_headline.sh
fi

if [ $run_glwu == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/prep/glwu
    qsub -v INITDATE=$PDYm1,NEXTDATE=$PDY ${drivers_dir}/jevs_prep_glwu_wave_grid2obs.sh
fi

if [ $run_nwps == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/prep/nwps
    qsub -v INITDATE=$PDYm1,NEXTDATE=$PDY ${drivers_dir}/jevs_prep_nwps_wave_grid2obs.sh
fi

if [ $run_rtofs == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/prep/rtofs
    qsub -v INITDATE=$PDYm2 ${drivers_dir}/jevs_prep_rtofs.sh
fi

if [ $run_subseasonal == "YES" ]; then
    drivers_dir=${HOMEevs}/dev/drivers/scripts/prep/subseasonal
    qsub -v INITDATE=$PDYm2 ${drivers_dir}/jevs_prep_subseasonal_cfs.sh
    qsub -v INITDATE=$PDYm2 ${drivers_dir}/jevs_prep_subseasonal_gefs.sh
    qsub -v INITDATE=$PDYm2 ${drivers_dir}/jevs_prep_subseasonal_obs.sh
fi
