#!/usr/bin/env ruby
require 'fileutils'

# Set your base directory here.
base_dir = "/path/to/your/services"

def revert_to_service_structure(base_dir)
  # Iterate over top-level environment folders.
  Dir.foreach(base_dir) do |env|
    # Skip hidden folders and folders named "build" or "html".
    next if env.start_with?('.') || %w[build html].include?(env)
    env_path = File.join(base_dir, env)
    next unless File.directory?(env_path)

    # For each service inside the environment folder.
    Dir.foreach(env_path) do |service|
      next if service.start_with?('.') || %w[build html].include?(service)
      service_path = File.join(env_path, service)
      next unless File.directory?(service_path)

      # Ensure the original service folder exists.
      original_service_path = File.join(base_dir, service)
      FileUtils.mkdir_p(original_service_path)

      # Move the environment folder back inside the service folder.
      new_env_path = File.join(original_service_path, env)
      FileUtils.mv(service_path, new_env_path)
    end
  end

  # Cleanup: Remove empty environment folders (ignoring "build" and "html").
  Dir.foreach(base_dir) do |env|
    next if env.start_with?('.') || %w[build html].include?(env)
    env_path = File.join(base_dir, env)
    next unless File.directory?(env_path)
    if (Dir.entries(env_path) - %w[. ..]).empty?
      Dir.rmdir(env_path)
    end
  end

  puts "Reversion complete!"
end

revert_to_service_structure(base_dir)
