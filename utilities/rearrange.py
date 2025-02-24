import os
import shutil

def rearrange_folders(base_dir):
    temp_dir = os.path.join(base_dir, "temp")
    os.makedirs(temp_dir, exist_ok=True)
    
    for service in os.listdir(base_dir):
        service_path = os.path.join(base_dir, service)
        
        if not os.path.isdir(service_path) or service.startswith("."):
            continue
        
        for env in os.listdir(service_path):
            env_path = os.path.join(service_path, env)
            
            if not os.path.isdir(env_path) or env.startswith("."):
                continue
            
            new_env_dir = os.path.join(temp_dir, env)
            new_service_path = os.path.join(new_env_dir, service)
            
            os.makedirs(new_service_path, exist_ok=True)
            shutil.move(env_path, os.path.join(new_service_path, env))
    
    for service in os.listdir(base_dir):
        service_path = os.path.join(base_dir, service)
        if os.path.isdir(service_path) and not service.startswith("."):
            shutil.rmtree(service_path)
    
    for env in os.listdir(temp_dir):
        shutil.move(os.path.join(temp_dir, env), base_dir)
    
    os.rmdir(temp_dir)

if __name__ == "__main__":
    base_directory = "path/to/your/folder"  # Change this to your actual folder path
    rearrange_folders(base_directory)
