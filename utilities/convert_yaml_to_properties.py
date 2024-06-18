import os
import yaml
from pathlib import Path

def yaml_to_properties(yaml_file, properties_file):
    with open(yaml_file, 'r') as yf:
        yaml_content = yaml.safe_load(yf)
    
    properties_content = []

    def recurse_yaml(content, parent_key=''):
        for key, value in content.items():
            full_key = f"{parent_key}.{key}" if parent_key else key
            if isinstance(value, dict):
                recurse_yaml(value, full_key)
            else:
                properties_content.append(f"{full_key}={value}")

    recurse_yaml(yaml_content)

    with open(properties_file, 'w') as pf:
        pf.write('\n'.join(properties_content))

def convert_folder(folder_path):
    folder = Path(folder_path)
    yaml_files = folder.glob('**/application.yaml')

    for yaml_file in yaml_files:
        properties_file = yaml_file.with_suffix('.properties')
        yaml_to_properties(yaml_file, properties_file)
        print(f"Converted {yaml_file} to {properties_file}")

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='Convert application.yaml files to application.properties')
    parser.add_argument('folder', type=str, help='The folder containing application.yaml files')

    args = parser.parse_args()
    convert_folder(args.folder)
