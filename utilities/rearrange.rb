#!/usr/bin/env ruby
require 'fileutils'

# Set your base directory here.
base_dir = "/path/to/your/services"

def rearrange_by_environment(base_dir)
  # Iterate over service directories in base_dir.
  Dir.foreach(base_dir) do |service|
    # Skip hidden folders and folders named "build" or "html".
    next if service.start_with?('.') || %w[build html].include?(service)
    service_path = File.join(base_dir, service)
    next unless File.directory?(service_path)

    # Iterate over environment subdirectories inside the service folder.
    Dir.foreach(service_path) do |env|
      # Skip hidden folders and folders named "build" or "html".
      next if env.start_with?('.') || %w[build html].include?(env)
      env_path = File.join(service_path, env)
      next unless File.directory?(env_path)

      # Define the new destination paths.
      new_env_path = File.join(base_dir, env)
      new_service_path = File.join(new_env_path, service)

      FileUtils.mkdir_p(new_env_path)
      FileUtils.mv(env_path, new_service_path)
    end
  end

  # Cleanup: Remove empty service folders (ignoring "build" and "html").
  Dir.foreach(base_dir) do |service|
    next if service.start_with?('.') || %w[build html].include?(service)
    service_path = File.join(base_dir, service)
    next unless File.directory?(service_path)
    if (Dir.entries(service_path) - %w[. ..]).empty?
      Dir.rmdir(service_path)
    end
  end

  puts "Rearrangement complete!"
end

rearrange_by_environment(base_dir)
