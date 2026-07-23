from datetime import datetime, timedelta
from pathlib import Path
import os
import shutil
import argparse

evs_all_dir = Path("/lfs/h2/emc/vpppg/noscrub/emc.vpppg/evs/v2.0")
evs_devonly_dir = Path("/lfs/h2/emc/vpppg/noscrub/emc.vpppg/evs_devonly/v2.0")

parser = argparse.ArgumentParser(
    description="A script that supports a --dry-run flag."
)    
parser.add_argument(
    "--dry-run", 
    action="store_true", 
    help="Perform a trial run with no changes made"
)
args = parser.parse_args()

def check_dir_for_removal(full_check_dir, removal_days):
    removal_date = datetime.today() - timedelta(days=removal_days)
    check_dir = full_check_dir.name
    if "." in check_dir and len(check_dir.split(".")):
        check_dir_date = datetime.strptime(
            check_dir.split(".")[-1], "%Y%m%d"
        )
        if check_dir_date < removal_date:
            if args_dry_run := args.dry_run:
                print(f"DRY RUN: Would remove {full_check_dir}")
            else:
                print(f"Removing {full_check_dir}")
                shutil.rmtree(full_check_dir)
    else:
        print(f"WARNING: Do not recognize formatting for {full_check_dir}")

### Clean up prep
for evs_dir in [evs_all_dir, evs_devonly_dir]:
    prep_dir = evs_dir / "prep"
    prep_components = [x.name for x in prep_dir.iterdir() if x.is_dir()]
    print(f"\n--- Cleaning up prep: {prep_dir}")
    for component in prep_components:
        if component in ["analyses", "aqm", "cam", "glwu", "nwps", "rtofs"]:
            keep_ndays_prep = 15
        elif component in ["aigefs", "global_chem", "global_det", "global_ens"]:
            keep_ndays_prep = 25
        elif component in ["subseasonal"]:
            keep_ndays_prep = 40
        else:
            print(f"WARNING: {component} not recognized, skipping cleanup")
            continue
        print(f"Keeping last {keep_ndays_prep} days prep for {component}")
        for check_prep_dir in (prep_dir / component).iterdir():
            if not check_prep_dir.is_dir():
                continue
            check_dir_for_removal(
                check_prep_dir,  keep_ndays_prep
            )

### Clean up stats
RUN_list = ["atmos", "chem", "headline", "ocean", "wave"]
for evs_dir in [evs_all_dir, evs_devonly_dir]:
    stats_dir = evs_dir / "stats"
    stats_components = [x.name for x in stats_dir.iterdir() if x.is_dir()]
    print(f"\n--- Cleaning up stats: {stats_dir}")
    for component in stats_components:
        small_stats_dirs = []
        final_stats_dirs = []
        for full_path_subdir in (stats_dir / component).iterdir():
            if not full_path_subdir.is_dir():
                continue
            if any(RUN in full_path_subdir.name for RUN in RUN_list):
                small_stats_dirs.append(full_path_subdir)
            else:
                if full_path_subdir.name != "long_term":
                    final_stats_dirs.append(full_path_subdir)
        ###### Clean up small stat
        keep_ndays_small_stats = 8
        print(f"Keeping last {keep_ndays_small_stats} days small stats for {component}")
        for check_small_stat_dir in small_stats_dirs:
            check_dir_for_removal(
                check_small_stat_dir, keep_ndays_small_stats
            )
        #### Clean up final stat files
        keep_ndays_final_stats = 100
        print(f"Keeping last {keep_ndays_final_stats} days final stats for {component}")
        for check_final_stat_dir in final_stats_dirs:
            check_dir_for_removal(
                check_final_stat_dir, keep_ndays_final_stats
            )
        
