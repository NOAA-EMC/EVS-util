#!/bin/bash
#################################################
# Author: Mallory Row
# Purpose: This drives mirror_evs_devonly.sh
#          submitting job to the dev_transfer queue
#################################################

set -x

HOMEevs_util=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS-util
LOGSevs_util=/lfs/h2/emc/ptmp/${USER}/evs_util_logs

mkdir -p ${LOGSevs_util}

now=$(date '+%Y%m%d%H%M%S')

# Get EVS COMPONENT
COMPONENT=${COMPONENT:-"component"}

# Parse command-line arguments (Overrides environment variables)
for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"

    case "$key" in
        component)
            COMPONENT="$value"
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

# Submit to queue
qsub -q "dev_transfer" -A "VERF-DEV" -S /bin/bash -N mirror_evs_devonly_${COMPONENT} -o ${LOGSevs_util}/log_mirror_evs_devonly_${COMPONENT}_run${now}.out -e ${LOGSevs_util}/log_mirror_evs_devonly_${COMPONENT}_run${now}.out -l walltime=06:00:00 -l select=1:ncpus=1 -l debug=true -v COMPONENT=${COMPONENT} ${HOMEevs_util}/mirror/mirror_evs_devonly.sh
