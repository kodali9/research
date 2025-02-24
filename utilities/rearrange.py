require 'fileutils'

def rearrange_folders(base_dir)
  return unless Dir.exist?(base_dir)

  Dir.children(base_dir).each do |service_folder|
    service_path = File.join(base_dir, service_folder)
    next unless File.directory?(service_path) && !service_folder.start_with?('.')

    Dir.children(service_path).each do |env_folder|
      env_path = File.join(service_path, env_folder)
      next unless File.directory?(env_path) && !env_folder.start_with?('.')

      new_env_dir = File.join(base_dir, env_folder)
      new_service_path = File.join(new_env_dir, service_folder)
      
      FileUtils.mkdir_p(new_env_dir)
      FileUtils.mv(env_path, new_service_path)
    end

    Dir.rmdir(service_path) if Dir.empty?(service_path)
  end
end

base_directory = ARGV[0] || '.'  # Use the first argument as the base directory or default to current directory
rearrange_folders(base_directory)
puts "Folders rearranged successfully!"
