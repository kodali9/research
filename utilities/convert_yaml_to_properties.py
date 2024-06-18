import yaml

def flatten_dict(d, parent_key='', sep='.'):
    items = []
    for k, v in d.items():
        new_key = f"{parent_key}{sep}{k}" if parent_key else k
        if isinstance(v, dict):
            items.extend(flatten_dict(v, new_key, sep=sep).items())
        else:
            items.append((new_key, v))
    return dict(items)

def yaml_to_properties(yaml_file, properties_file):
    with open(yaml_file, 'r') as y_file:
        yaml_content = yaml.safe_load(y_file)
    
    flat_dict = flatten_dict(yaml_content)
    
    with open(properties_file, 'w') as p_file:
        for key, value in flat_dict.items():
            p_file.write(f"{key}={value}\n")

# Example usage
yaml_to_properties('application.yaml', 'application.properties')
