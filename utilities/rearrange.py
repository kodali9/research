import os
import shutil

# Define root directory
root_dir = "path/to/root"  # Change this to your root directory

# Scan existing structure
services = [d for d in os.listdir(root_dir) if os.path.isdir(os.path.join(root_dir, d))]

for service in services:
    service_path = os.path.join(root_dir, service)
    if not os.path.isdir(service_path):
        continue
    
    environments = [d for d in os.listdir(service_path) if os.path.isdir(os.path.join(service_path, d))]
    
    for env in environments:
        env_path = os.path.join(service_path, env)
        new_env_dir = os.path.join(root_dir, env)
        new_service_dir = os.path.join(new_env_dir, service)
        
        # Create environment and service subdirectories
        os.makedirs(new_service_dir, exist_ok=True)
        
        # Move environment subfolder to new location
        shutil.move(env_path, new_service_dir)
    
    # Remove the original empty service folder
    if not os.listdir(service_path):
        os.rmdir(service_path)

print("Rearrangement complete!")
