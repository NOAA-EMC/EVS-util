
import argparse
import os
import glob
import subprocess

### Set up paths
online_evs_dir = "/lfs/h2/emc/vpppg/noscrub/emc.vpppg/evs/v2.0/stats"
hpss_dir = "/NCEPDEV/emc-global/5year/emc.vpppg/evs_v2.0_parallel/stats"

### Read runtime agruments
parser = argparse.ArgumentParser(
    description="Send final stat files to HPSS. Supporting component and YYYYmm"
)
parser.add_argument("component", help="The component")
parser.add_argument("YYYYmm", help="The year and month to archive")
args = parser.parse_args()

### Keep only final stat dirs
matching_YYYYmm_dirs = glob.glob(
    os.path.join(online_evs_dir, args.component, f"*{args.YYYYmm}*")
)
RUN_list = ["atmos", "headline", "ocean", "wave"]
archive_dir = []
for check_dir in matching_YYYYmm_dirs:
    check_subdir = check_dir.rpartition("/")[2]
    if not any(RUN in check_subdir for RUN in RUN_list):
        archive_dir.append(check_subdir)

### Archive to HPSS
hpss_tar_file = os.path.join(
    hpss_dir, args.component, f"{args.component}_{args.YYYYmm}.tar"
)
os.chdir(os.path.join(online_evs_dir, args.component))
hpss_cmd = ["htar", "-cvf", hpss_tar_file] + archive_dir
print(f"Running {' '.join(hpss_cmd)}")
hpss_result = subprocess.run(
    hpss_cmd, capture_output=True
)
