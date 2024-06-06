import yaml

# Function to read the ConfigMap and extract the data section
def extract_data_section(configmap_file, output_file):
    with open(configmap_file, 'r') as file:
        configmap = yaml.safe_load(file)

    # Extract the data section
    data_section = configmap.get('data', {})

    # Write the data section to the application.yaml file
    with open(output_file, 'w') as file:
        yaml.dump(data_section, file, default_flow_style=False)

# File paths
configmap_file = 'configmap.yaml'  # Input ConfigMap file
output_file = 'application.yaml'  # Output application.yaml file

# Extract and convert
extract_data_section(configmap_file, output_file)
