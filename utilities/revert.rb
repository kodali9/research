#!/usr/bin/env ruby
require 'fileutils'

# Set your root directory here
root_dir = 'path/to/root'  # Change this to your root folder

# Get environment directories
environments = Dir.entries(root_dir).select do |entry|
  path = File.join(root_dir, entry)
  File.directory?(path) && !['.', '..'].include?(entry)
end

environments.each do |env|
  env_path = File.join(root_dir, env)

  # Get service directories inside each environment
  services = Dir.entries(env_path).select do |entry|
    path = File.join(env_path, entry)
    File.directory?(path) && !['.', '..'].include?(entry)
  end

  services.each do |service|
    service_path = File.join(env_path, service)
    new_service_dir = File.join(root_dir, service)
    new_env_path = File.join(new_service_dir, env)

    # Create service directory if not exists
    FileUtils.mkdir_p(new_service_dir)

    # Move environment folder under the service
    FileUtils.mv(service_path, new_env_path)
  end

  # Remove the original empty environment folder
  Dir.rmdir(env_path) if Dir.empty?(env_path)
end

puts "Reversal complete!"
