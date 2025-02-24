import os
import shutil

# Define the base directory where the services are stored
base_dir = "/path/to/your/services"

# Temporary dictionary to store environment-to-service mapping
env_map = {}

# Scan for services
for service in os.listdir(base_dir):
    service_path = os.path.join(base_dir, service)

    # Ignore non-directories and hidden folders
    if not os.path.isdir(service_path) or service.startswith('.'):
        continue

    # Scan for environments inside the service folder
    for env in os.listdir(service_path):
        env_path = os.path.join(service_path, env)

        # Ignore non-directories and hidden folders
        if not os.path.isdir(env_path) or env.startswith('.'):
            continue

        # Ensure environment folder exists in the new structure
        new_env_path = os.path.join(base_dir, env)
        os.makedirs(new_env_path, exist_ok=True)

        # Move the service's environment folder to the new structure
        new_service_path = os.path.join(new_env_path, service)
        shutil.move(env_path, new_service_path)

# Cleanup: Remove empty service folders
for service in os.listdir(base_dir):
    service_path = os.path.join(base_dir, service)
    if os.path.isdir(service_path) and not os.listdir(service_path):
        os.rmdir(service_path)

print("Rearrangement complete!")
