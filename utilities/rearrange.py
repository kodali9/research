import os
import shutil
import argparse

def rearrange_by_environment(base_dir):
    # Iterate over the service directories in base_dir.
    for service in os.listdir(base_dir):
        service_path = os.path.join(base_dir, service)

        # Ignore non-directories and hidden folders.
        if not os.path.isdir(service_path) or service.startswith('.'):
            continue

        # Iterate over environment subdirectories inside the service folder.
        for env in os.listdir(service_path):
            env_path = os.path.join(service_path, env)

            # Ignore non-directories and hidden folders.
            if not os.path.isdir(env_path) or env.startswith('.'):
                continue

            # Define the new destination paths.
            new_env_path = os.path.join(base_dir, env)
            new_service_path = os.path.join(new_env_path, service)

            # Ensure the environment folder exists.
            os.makedirs(new_env_path, exist_ok=True)

            # Move the service's environment folder to the new structure.
            shutil.move(env_path, new_service_path)

    # Cleanup: Remove empty service folders.
    for service in os.listdir(base_dir):
        service_path = os.path.join(base_dir, service)
        if os.path.isdir(service_path) and not os.listdir(service_path) and not service.startswith('.'):
            os.rmdir(service_path)

    print("Rearrangement complete!")

def main():
    parser = argparse.ArgumentParser(
        description='Rearrange folders by environment (e.g., /dev, /prod) within the same base directory.'
    )
    parser.add_argument('base_dir', help='The base directory containing the service folders.')
    args = parser.parse_args()
    rearrange_by_environment(args.base_dir)

if __name__ == '__main__':
    main()
