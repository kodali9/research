import os
import shutil

def revert_folders(base_dir):
    temp_dir = os.path.join(base_dir, "temp")
    os.makedirs(temp_dir, exist_ok=True)
    
    for env in os.listdir(base_dir):
        env_path = os.path.join(base_dir, env)
        
        if not os.path.isdir(env_path) or env.startswith("."):
            continue
        
        for service in os.listdir(env_path):
            service_path = os.path.join(env_path, service)
            
            if not os.path.isdir(service_path) or service.startswith("."):
                continue
            
            new_service_dir = os.path.join(temp_dir, service)
            new_env_path = os.path.join(new_service_dir, env)
            
            os.makedirs(new_service_dir, exist_ok=True)
            shutil.move(service_path, new_env_path)
    
    for env in os.listdir(base_dir):
        env_path = os.path.join(base_dir, env)
        if os.path.isdir(env_path) and not env.startswith("."):
            shutil.rmtree(env_path)
    
    for service in os.listdir(temp_dir):
        shutil.move(os.path.join(temp_dir, service), base_dir)
    
    os.rmdir(temp_dir)

if __name__ == "__main__":
    base_directory = "path/to/your/folder"  # Change this to your actual folder path
    revert_folders(base_directory)
