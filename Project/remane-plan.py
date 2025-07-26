import os
import glob
from pathlib import Path

def rename_plan_files(directory):
    # Get all Plan_with_coord_*.txt files
    plan_files = glob.glob(os.path.join(directory, "*_plan.txt"))
    
    for file_path in plan_files:
        try:
            # Convert to Path object
            file_path = Path(file_path)
            
            # Extract creator name (between 'Plan_with_coord_' and '.txt')
            creator_name = file_path.stem.split('_plan')[1]
            
            # Create new filename
            new_name = f"{creator_name}_plan_with_coord.txt"
            new_path = file_path.parent / new_name
            
            # Rename file
            file_path.rename(new_path)
            print(f"Renamed: {file_path.name} -> {new_name}")
            
        except Exception as e:
            print(f"Error renaming {file_path}: {e}")

if __name__ == "__main__":
    # Specify your directory path
    directory_path = "/Users/matteo/Documents/Project/Project/1-snowman/Coordinate"
    rename_plan_files(directory_path)