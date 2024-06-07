import os
import yaml
import argparse

def merge_dict(d, keys, value):
    """ Helper function to merge keys into a dictionary. """
    for key in keys[:-1]:
        d = d.setdefault(key, {})
    d[keys[-1]] = value

def extract_data_section(configmap_file, output_file):
    with open(configmap_file, 'r') as file:
        configmap = yaml.safe_load(file)

    # Extract the data section
    data_section = configmap.get('data', {})
    hierarchical_data = {}

    # Convert the flat data section to a hierarchical structure
    for key, value in data_section.items():
        keys = key.split('.')  # Assuming keys are separated by dots for hierarchy
        merge_dict(hierarchical_data, keys, value)

    # Write the hierarchical data section to the application.yaml file
    with open(output_file, 'w') as file:
        yaml.dump(hierarchical_data, file, default_flow_style=False)

def main():
    parser = argparse.ArgumentParser(description='Convert ConfigMap data to hierarchical application.yaml')
    parser.add_argument('folder', type=str, help='The folder containing the configmap.yaml file')
    args = parser.parse_args()

    configmap_file = os.path.join(args.folder, 'configmap.yaml')
    output_file = os.path.join(args.folder, 'application.yaml')

    extract_data_section(configmap_file, output_file)

if __name__ == '__main__':
    main()
