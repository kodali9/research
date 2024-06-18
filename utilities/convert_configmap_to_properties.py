import os
import yaml
import argparse

def flatten_dict(d, parent_key='', sep='.'):
    """ Helper function to flatten a nested dictionary. """
    items = []
    for k, v in d.items():
        new_key = f"{parent_key}{sep}{k}" if parent_key else k
        if isinstance(v, dict):
            items.extend(flatten_dict(v, new_key, sep=sep).items())
        else:
            items.append((new_key, v))
    return dict(items)

def merge_dict(d, keys, value):
    """ Helper function to merge keys into a dictionary. """
    for key in keys[:-1]:
        d = d.setdefault(key, {})
    d[keys[-1]] = value

def extract_data_section(configmap_file, output_file):
    with open(configmap_file, 'r') as file:
        configmap = yaml.safe_load(file)

    # Check if the data section exists and is not empty
    data_section = configmap.get('data')
    if not data_section:
        print(f"Warning: The 'data' section in {configmap_file} is empty or missing.")
        return

    hierarchical_data = {}

    # Convert the flat data section to a hierarchical structure
    for key, value in data_section.items():
        keys = key.split('.')  # Assuming keys are separated by dots for hierarchy
        merge_dict(hierarchical_data, keys, value)

    # Flatten the hierarchical data to a properties format
    flat_data = flatten_dict(hierarchical_data)

    # Write the flat data section to the application.properties file
    with open(output_file, 'w') as file:
        for key, value in flat_data.items():
            file.write(f"{key}={value}\n")

def main():
    parser = argparse.ArgumentParser(description='Convert ConfigMap data to application.properties')
    parser.add_argument('folder', type=str, help='The folder containing the configmap.yaml file')
    args = parser.parse_args()

    configmap_file = os.path.join(args.folder, 'configmap.yaml')
    output_file = os.path.join(args.folder, 'application.properties')

    extract_data_section(configmap_file, output_file)

if __name__ == '__main__':
    main()
