import os
import shutil
import argparse

def revert_to_service_structure(base_dir):
    # Iterate over the environment folders (top-level folders).
    for env in os.listdir(base_dir):
        env_path = os.path.join(base_dir, env)

        # Ignore non-directories, hidden folders, and folders named "build".
        if (not os.path.isdir(env_path) or 
            env.startswith('.') or 
            env == 'build'):
            continue

        # Move each service folder back into its original service folder.
        for service in os.listdir(env_path):
            service_path = os.path.join(env_path, service)

            # Ignore non-directories, hidden folders, and folders named "build".
            if (not os.path.isdir(service_path) or 
                service.startswith('.') or 
                service == 'build'):
                continue

            # Ensure the original service folder exists.
            original_service_path = os.path.join(base_dir, service)
            os.makedirs(original_service_path, exist_ok=True)

            # Move the environment folder back inside the service folder.
            new_env_path = os.path.join(original_service_path, env)
            shutil.move(service_path, new_env_path)

    # Cleanup: Remove empty environment folders (but do not remove "build").
    for env in os.listdir(base_dir):
        env_path = os.path.join(base_dir, env)
        if (os.path.isdir(env_path) and 
            not os.listdir(env_path) and 
            not env.startswith('.') and 
            env != 'build'):
            os.rmdir(env_path)

    print("Reversion complete!")

def main():
    parser = argparse.ArgumentParser(
        description='Revert the folder structure back to service-based organization.'
    )
    parser.add_argument('base_dir', help='The base directory containing the environment folders.')
    args = parser.parse_args()
    revert_to_service_structure(args.base_dir)

if __name__ == '__main__':
    main()
