import yaml

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

# File paths
configmap_file = 'configmap.yaml'  # Input ConfigMap file
output_file = 'application.yaml'  # Output application.yaml file

# Extract and convert
extract_data_section(configmap_file, output_file)
