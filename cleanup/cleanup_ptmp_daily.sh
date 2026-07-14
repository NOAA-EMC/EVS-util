#!/bin/bash
#################################################
# Author: Perry Shafran
# Purpose: Cleans up the ptmp tar directory once
#          files are transferred to emcrzdm
#          Clears the restart directories and tarballs
#################################################

set -x

# Module Loads
module load prod_util

# EVS Output Info
user_para=/lfs/h2/emc/ptmp/${USER}/evs/v2.0/plots

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

# Set base directory
if [[ "$COMPONENT" == "glwu" || "$COMPONENT" == "nwps" ]]; then
    user_para=/lfs/h2/emc/ptmp/${USER}/evs_devonly/v2.0/plots
else
    user_para=/lfs/h2/emc/ptmp/${USER}/evs/v2.0/plots
fi

# Clean up tarball directory
echo "Clearing out tarball directory for one day before date selected"
rm_VDATE=$($NDATE -24 ${VDATE}00 |cut -c1-8)
COMPONENT_RUN_RM_VDATE=${COMPONENT}/${RUN}.${rm_VDATE}
rm -f -r ${user_para}/${COMPONENT_RUN_RM_VDATE}

