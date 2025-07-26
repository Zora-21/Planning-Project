import os
import glob
from pathlib import Path

def rename_pddl_files(directory):
    # Get all problem_*.pddl files
    pddl_files = glob.glob(os.path.join(directory, "problem_*_c.pddl"))
    
    for file_path in pddl_files:
        try:
            # Convert to Path object
            file_path = Path(file_path)
            
            # Extract creator name (between 'problem_' and '.pddl')
            creator_name = file_path.stem.split('problem_')[1]
            
            # Create new filename
            new_name = f"{creator_name}_problem.pddl"
            new_path = file_path.parent / new_name
            
            # Rename file
            file_path.rename(new_path)
            print(f"Renamed: {file_path.name} -> {new_name}")
            
        except Exception as e:
            print(f"Error renaming {file_path}: {e}")

if __name__ == "__main__":
    # Get current directory
    #current_dir = os.getcwd()
    rename_pddl_files("/Users/matteo/Documents/Project/Project/1-snowman/goal")