import os
from pathlib import Path

def get_directory_size(directory):
    """
    Recursively finds all .tar files in the given directory and 
    calculates their total size in bytes.
    """
    total_size_bytes = 0
    base_path = Path(directory)
    
    total_size_bytes = sum(f.stat().st_size for f in Path(directory).rglob('*') if f.is_file())
            
    return total_size_bytes

if __name__ == "__main__":
    # Assign EVS output base and date to add together
    evs_output_base = "/lfs/h1/ops/prod/com/evs/v2.0"
    sum_date = "20260718"

    grand_total_bytes = 0

    for step in ["prep", "stats", "plots"]:
        evs_step_base = Path(evs_output_base+f"/{step}")

        step_total_bytes = 0

        print("="*40)
        print(f"Calculating {step}")
        components = sorted(os.listdir(evs_step_base))
        for component in components:
            print(f"Calculating for component {component}")
            # Get all EVS step output directories
            target_directories = (evs_step_base / component
            ).glob(f"*.{sum_date}")
        
            component_total_bytes = 0
        
            for target in target_directories:
                total_bytes = get_directory_size(target)
            
                # Convert directly to Gigabytes
                size_in_gb = total_bytes / (1024 ** 3)
                print(f"{target}  -> {size_in_gb:.4f} GB ({total_bytes} bytes)")
                component_total_bytes += total_bytes
        
            component_total_gb = component_total_bytes / (1024 ** 3)
            print(f"{component} Total: {component_total_gb} GB")
            step_total_bytes += component_total_bytes
        
        step_total_gb = step_total_bytes / (1024 ** 3)
        print(f"\n {step} total: {step_total_gb}") 
        grand_total_bytes += step_total_bytes

    # Calculate and display the combined total
    grand_total_gb = grand_total_bytes / (1024 ** 3)
    print("\n" + "="*40)
    print(f"GRAND TOTAL: {grand_total_gb:.4f} GB ({grand_total_bytes} bytes)")
    print("="*40)
