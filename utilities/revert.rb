require 'fileutils'

def reverse_rearrange_folders(base_dir)
  return unless Dir.exist?(base_dir)

  Dir.children(base_dir).each do |env_folder|
    env_path = File.join(base_dir, env_folder)
    next unless File.directory?(env_path) && !env_folder.start_with?('.')

    Dir.children(env_path).each do |service_folder|
      service_path = File.join(env_path, service_folder)
      next unless File.directory?(service_path) && !service_folder.start_with?('.')

      original_service_path = File.join(base_dir, service_folder)
      original_env_path = File.join(original_service_path, env_folder)
      
      FileUtils.mkdir_p(original_service_path)
      FileUtils.mv(service_path, original_env_path)
    end

    Dir.rmdir(env_path) if Dir.empty?(env_path)
  end
end

base_directory = ARGV[0] || '.'  # Use the first argument as the base directory or default to current directory
reverse_rearrange_folders(base_directory)
puts "Folders reversed successfully!"
