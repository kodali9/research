#!/usr/bin/env ruby
require 'fileutils'

# Set your root directory here
root_dir = 'path/to/root'  # Change this to your root folder

# Get all service directories in the root folder
services = Dir.entries(root_dir).select do |entry|
  path = File.join(root_dir, entry)
  File.directory?(path) && !['.', '..'].include?(entry)
end

services.each do |service|
  service_path = File.join(root_dir, service)
  next unless File.directory?(service_path)

  # Get all environment directories under the current service
  environments = Dir.entries(service_path).select do |entry|
    path = File.join(service_path, entry)
    File.directory?(path) && !['.', '..'].include?(entry)
  end

  environments.each do |env|
    env_path = File.join(service_path, env)
    new_env_dir = File.join(root_dir, env)
    new_service_dir = File.join(new_env_dir, service)

    # Create the new environment/service directory structure if it doesn't exist
    FileUtils.mkdir_p(new_service_dir)

    # Move the environment folder into the new service directory under the environment folder
    FileUtils.mv(env_path, new_service_dir)
  end

  # Remove the original service folder if it's empty
  if (Dir.entries(service_path) - %w[. ..]).empty?
    Dir.rmdir(service_path)
  end
end

puts "Rearrangement complete!"
