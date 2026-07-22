import os
from pathlib import Path

def get_tar_files_size(directory):
    """
    Recursively finds all .tar files in the given directory and 
    calculates their total size in bytes.
    """
    total_size_bytes = 0
    base_path = Path(directory)
    
    # Check if the path actually exists so the script doesn't crash
    if not base_path.exists() or not base_path.is_dir():
        print(f"  [!] Skipping: '{directory}' is not a valid directory.")
        return 0
    
    # rglob('*.tar') recursively searches all subdirectories
    for file_path in base_path.glob('*.tar'):
        if file_path.is_file():  
            total_size_bytes += file_path.stat().st_size
            
    return total_size_bytes

if __name__ == "__main__":
    # Assign EVS output base and date to add together
    evs_output_base = "/lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots"
    sum_date = "20260719"

    components = sorted(os.listdir(evs_output_base))

    grand_total_bytes = 0
    
    for component in components:
        print(f"\nCalculating for component {component}")
        # Get all EVS plots output directories
        target_directories = Path(
            evs_output_base+f"/{component}"
        ).rglob(f"*.{sum_date}")
    
        component_total_bytes = 0
    
        for target in target_directories:
            total_bytes = get_tar_files_size(target)
        
            # Convert directly to Gigabytes
            size_in_gb = total_bytes / (1024 ** 3)
            print(f"{target}  -> {size_in_gb:.4f} GB ({total_bytes} bytes)")
            component_total_bytes += total_bytes

        component_total_gb = component_total_bytes / (1024 ** 3)
        print(f"{component} Total: {component_total_gb} GB")
        grand_total_bytes += component_total_bytes
        
    # Calculate and display the combined total
    grand_total_gb = grand_total_bytes / (1024 ** 3)
    print("\n" + "="*40)
    print(f"GRAND TOTAL: {grand_total_gb:.4f} GB ({grand_total_bytes} bytes)")
    print("="*40)
