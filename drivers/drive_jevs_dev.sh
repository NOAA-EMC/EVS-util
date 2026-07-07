#!/bin/bash

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS

# 1. Initialize variables from the Environment.
# Syntax: ${ENV_VAR:-default_value}
# If argument is passed via the environment, use it. Otherwise, use its default.
STEP="${STEP:-"step"}"
COMPONENT="${COMPONENT:-"component"}"
JOB="${JOB:-"null"}"
VHR="${VHR:-"null"}"

# 2. Parse command-line arguments (Overrides environment variables)
for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"

    case "$key" in
        step)
            STEP="$value"
            ;;
        component)
            COMPONENT="$value"
            ;;
        job)
            JOB="$value"
            ;;
        vhr)
            VHR="$value"
            ;;
        *)
            echo "Warning: Unknown argument '$key'"
            exit 1
            ;;
    esac
done

# 3. Check what we have to run
if [ ${STEP} = "step" ]; then
    echo "ERROR: Did not pass step= or set STEP in environment"
    exit 1
fi
if [ ${COMPONENT} = "component" ]; then
    echo "ERROR: Did not pass component= or set COMPONENT in environment"
    exit 1
fi

# 3. Submit job
mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
if [ "$JOB" == "null" ]; then
    if [ "$VHR" == "null" ]; then
        qsub ${drivers_dir}/jevs_${STEP}_${COMPONENT}.sh
    else
        qsub -v vhr=$VHR ${drivers_dir}/jevs_${STEP}_${COMPONENT}.sh
    fi
elif [[ "$JOB" == *"rrfsmem"* ]]; then
    for mem in {1..5}; do
        qsub -v vhr=$VHR,mem=$mem ${drivers_dir}/jevs_${STEP}_${COMPONENT}_${JOB}.sh
    done
else
    if [ "$VHR" == "null" ]; then
        qsub ${drivers_dir}/jevs_${STEP}_${COMPONENT}_${JOB}.sh
    else
        qsub -v vhr=$VHR ${drivers_dir}/jevs_${STEP}_${COMPONENT}_${JOB}.sh
    fi
fi
