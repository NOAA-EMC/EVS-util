#!/bin/bash
#################################################
# Author: Mallory Row
# Purpose: This drives cleanup_ptmp_daily.sh submitting
#          job to the dev queue
#################################################

set -x

HOMEevs_util=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS-util
LOGSevs_util=/lfs/h2/emc/ptmp/${USER}/evs_util_logs

mkdir -p ${LOGSevs_util}

now=$(date '+%Y%m%d%H%M%S')

# Get EVS COMPONENT
COMPONENT=${COMPONENT:-"component"}
RUN=${RUN:-"run"}
VDATE=${VDATE:-"vdate"}

# Parse command-line arguments (Overrides environment variables)
for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"

    case "$key" in
        component)
            COMPONENT="$value"
            ;;
        run)
            RUN="$value"
            ;;
        vdate)
            VDATE="$value"
            ;;
        *)
            echo "Warning: Unknown argument '$key'"
            exit 1
            ;;
    esac
done

# Make sure we got all our passed agrument
if [ ${COMPONENT} = "component" ]; then
    echo "ERROR: Did not pass COMPONENT"
    exit 1
fi
if [ ${RUN} = "run" ]; then
    echo "ERROR: Did not pass RUN"
    exit 1
fi
if [ ${VDATE} = "vdate" ]; then
    echo "ERROR: Did not pass VDATE"
    exit 1
fi

# Submit to queue
qsub -q "dev" -A "VERF-DEV" -S /bin/bash -N cleanup_ptmp_daily_${COMPONENT}_${RUN}_v${VDATE} -o ${LOGSevs_util}/log_cleanup_ptmp_daily_${COMPONENT}_${RUN}_v${VDATE}_run${now}.out -e ${LOGSevs_util}/log_cleanup_ptmp_daily_${COMPONENT}_${RUN}_v${VDATE}_run${now}.out -l walltime=06:00:00 -l select=1:ncpus=1 -l debug=true -v COMPONENT=${COMPONENT},RUN=${RUN},VDATE=${VDATE} ${HOMEevs_util}/cleanup/cleanup_ptmp_daily.sh
