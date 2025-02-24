import os
import shutil

# Define root directory
root_dir = "path/to/root"  # Change this to your root directory

# Get environment folders
environments = [d for d in os.listdir(root_dir) if os.path.isdir(os.path.join(root_dir, d))]

# Dictionary to store service structure
services = {}

for env in environments:
    env_path = os.path.join(root_dir, env)
    
    # Get services within each environment
    service_dirs = [d for d in os.listdir(env_path) if os.path.isdir(os.path.join(env_path, d))]
    
    for service in service_dirs:
        service_path = os.path.join(env_path, service)
        new_service_dir = os.path.join(root_dir, service)
        new_env_path = os.path.join(new_service_dir, env)
        
        # Create service directory if not exists
        os.makedirs(new_service_dir, exist_ok=True)
        
        # Move environment subfolder to the service directory
        shutil.move(service_path, new_env_path)

    # Remove the original empty environment folder
    if not os.listdir(env_path):
        os.rmdir(env_path)

print("Reversal complete!")
