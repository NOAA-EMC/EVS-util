import sys
import re
import os

def get_walltime(filepath):
    """
    Reads a file and searches for a PBS walltime directive.
    Returns the walltime string if found, otherwise returns None.
    """
    # Pattern looks for lines starting with #PBS, containing -l, and extracts the walltime value
    walltime_pattern = re.compile(r'^#PBS\s+-l\s+.*walltime=([0-9:]+)')
    
    try:
        with open(filepath, 'r') as f:
            for line in f:
                # Quick check to only process PBS directives
                if line.startswith('#PBS'):
                    match = walltime_pattern.search(line)
                    if match:
                        return match.group(1)
    except FileNotFoundError:
        print(f"Error: File '{filepath}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"Error reading '{filepath}': {e}")
        sys.exit(1)
        
    return None

def get_memory(filepath):
    """
    Reads a file and searches for a PBS memory directive.
    Returns the memory string if found, otherwise returns None.
    """
    # Pattern looks for lines starting with #PBS, containing -l, and extracts the memory value
    walltime_pattern = re.compile(r'^#PBS\s+-l\s+.*mem=([0-9:]+)')

    try:
        with open(filepath, 'r') as f:
            for line in f:
                # Quick check to only process PBS directives
                if line.startswith('#PBS'):
                    match = walltime_pattern.search(line)
                    if match:
                        return match.group(1)
    except FileNotFoundError:
        print(f"Error: File '{filepath}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"Error reading '{filepath}': {e}")
        sys.exit(1)

    return None

def get_select(filepath):
    """
    Reads a file and searches for a PBS select directive.
    Returns the select string if found, otherwise returns None.
    """
    # Pattern looks for lines starting with #PBS, containing -l, and extracts the select value
    walltime_pattern = re.compile(r'^#PBS\s+-l\s+.*select=([0-9:]+)')

    try:
        with open(filepath, 'r') as f:
            for line in f:
                # Quick check to only process PBS directives
                if line.startswith('#PBS'):
                    match = walltime_pattern.search(line)
                    if match:
                        return match.group(1)
    except FileNotFoundError:
        print(f"Error: File '{filepath}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"Error reading '{filepath}': {e}")
        sys.exit(1)

    return None

def get_ncpus(filepath):
    """
    Reads a file and searches for a PBS ncpus directive.
    Returns the ncpus string if found, otherwise returns None.
    """
    # Pattern looks for lines starting with #PBS, containing -l, and extracts the ncpus value
    walltime_pattern = re.compile(r'^#PBS\s+-l\s+.*ncpus=([0-9:]+)')

    try:
        with open(filepath, 'r') as f:
            for line in f:
                # Quick check to only process PBS directives
                if line.startswith('#PBS'):
                    match = walltime_pattern.search(line)
                    if match:
                        return match.group(1)
    except FileNotFoundError:
        print(f"Error: File '{filepath}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"Error reading '{filepath}': {e}")
        sys.exit(1)

    return None


def main():

    HOMEevs = f'/lfs/h2/emc/vpppg/noscrub/{os.environ["USER"]}/EVS'

    for step in ["prep", "stats", "plots"]:
        dev_drivers = os.path.join(HOMEevs, "dev", "drivers", "scripts", step)
        ecf_drivers = os.path.join(HOMEevs, "ecf", "scripts", step)
        for dirpath, dirnames, filenames in os.walk(ecf_drivers):
            for filename in filenames:
                ecf_driver_filepath = os.path.join(dirpath, filename)
                dev_driver_filepath = ecf_driver_filepath.replace(
                    ecf_drivers, dev_drivers
                ).replace(".ecf", ".sh")
                if "master" in dev_driver_filepath:
                    dev_driver_filepath = dev_driver_filepath.replace(
                        "_vhr_master", ""
                    )
                if not os.path.exists(dev_driver_filepath):
                    print(f"Cannot find match for {ecf_driver_filepath}, tried {dev_drive_filepath}")
                # Extract walltimes
                wt1 = get_walltime(ecf_driver_filepath)
                wt2 = get_walltime(dev_driver_filepath)
                if wt1 is None or wt2 is None:
                    print("Result: Cannot compare. One or both files are missing a walltime setting.")
                    sys.exit(1)
                if wt1 != wt2:
                    print("MISMATCH WALLTIME. The files have different walltime settings.")
                    print(f"{ecf_driver_filepath}: {wt1}")
                    print(f"{dev_driver_filepath}: {wt2}")
                    print("")
                # Extract memory
                m1 = get_memory(ecf_driver_filepath)
                m2 = get_memory(dev_driver_filepath)
                if m1 is None or m2 is None:
                    print("Result: Cannot compare. One or both files are missing a memory setting.")
                    sys.exit(1)
                if m1 != m2:
                    print("MISMATCH MEMORY. The files have different memory settings.")
                    print(f"{ecf_driver_filepath}: {m1}")
                    print(f"{dev_driver_filepath}: {m2}")
                    print("")
                # Extract select
                s1 = get_select(ecf_driver_filepath)
                s2 = get_select(dev_driver_filepath)
                if s1 is None or s2 is None:
                    print("Result: Cannot compare. One or both files are missing a select setting.")
                    sys.exit(1)
                if m1 != m2:
                    print("MISMATCH SELECT. The files have different select settings.")
                    print(f"{ecf_driver_filepath}: {s1}")
                    print(f"{dev_driver_filepath}: {s2}")
                    print("")
                # Extract ncpus
                n1 = get_ncpus(ecf_driver_filepath)
                n2 = get_ncpus(dev_driver_filepath)
                if n1 is None or n2 is None:
                    print("Result: Cannot compare. One or both files are missing a ncpus setting.")
                    sys.exit(1)
                if n1 != n2:
                    print("MISMATCH NCPUS. The files have different ncpus settings.")
                    print(f"{ecf_driver_filepath}: {n1}")
                    print(f"{dev_driver_filepath}: {n2}")
                    print("")



                 

if __name__ == "__main__":
    main()
