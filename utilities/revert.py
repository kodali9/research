import os
import shutil

# Define the base directory where environments are currently stored
base_dir = "/path/to/your/services"

# Temporary dictionary to store service-to-environment mapping
service_map = {}

# Scan for environment folders (top-level folders)
for env in os.listdir(base_dir):
    env_path = os.path.join(base_dir, env)

    # Ignore non-directories and hidden folders
    if not os.path.isdir(env_path) or env.startswith('.'):
        continue

    # Scan for services inside each environment folder
    for service in os.listdir(env_path):
        service_path = os.path.join(env_path, service)

        # Ignore non-directories and hidden folders
        if not os.path.isdir(service_path) or service.startswith('.'):
            continue

        # Ensure the original service folder exists
        original_service_path = os.path.join(base_dir, service)
        os.makedirs(original_service_path, exist_ok=True)

        # Move the environment folder back inside the service folder
        new_env_path = os.path.join(original_service_path, env)
        shutil.move(service_path, new_env_path)

# Cleanup: Remove empty environment folders
for env in os.listdir(base_dir):
    env_path = os.path.join(base_dir, env)
    if os.path.isdir(env_path) and not os.listdir(env_path):
        os.rmdir(env_path)

print("Reversion complete!")
