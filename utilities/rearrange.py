require 'fileutils'

def rearrange_folders(base_path)
  return puts "Base path does not exist." unless Dir.exist?(base_path)
  
  services = Dir.entries(base_path).select { |f| File.directory?(File.join(base_path, f)) && !f.start_with?('.') }
  
  env_structure = {}
  
  services.each do |service|
    service_path = File.join(base_path, service)
    environments = Dir.entries(service_path).select { |f| File.directory?(File.join(service_path, f)) && !f.start_with?('.') }
    
    environments.each do |env|
      env_path = File.join(base_path, env)
      Dir.mkdir(env_path) unless Dir.exist?(env_path)
      
      new_service_path = File.join(env_path, service)
      FileUtils.mv(File.join(service_path, env), new_service_path)
    end
  end
  
  puts "Rearrangement complete."
end

# Example usage
base_directory = "/path/to/your/folder"
rearrange_folders(base_directory)
