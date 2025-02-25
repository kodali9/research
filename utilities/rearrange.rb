#!/usr/bin/env ruby
require 'fileutils'
require 'optparse'

def rearrange_by_environment(base_dir)
  # Iterate over service directories in base_dir.
  Dir.foreach(base_dir) do |service|
    # Skip hidden folders and folders named "build" or "html"
    next if service.start_with?('.') || %w[build html].include?(service)
    service_path = File.join(base_dir, service)
    next unless File.directory?(service_path)

    # Iterate over environment subdirectories inside the service folder.
    Dir.foreach(service_path) do |env|
      next if env.start_with?('.') || %w[build html].include?(env)
      env_path = File.join(service_path, env)
      next unless File.directory?(env_path)

      # Define the new destination paths.
      new_env_path = File.join(base_dir, env)
      new_service_path = File.join(new_env_path, service)

      FileUtils.mkdir_p(new_env_path)
      # Move the service's environment folder to the new structure.
      FileUtils.mv(env_path, new_service_path)
    end
  end

  # Cleanup: Remove empty service folders (ignore "build" and "html").
  Dir.foreach(base_dir) do |service|
    next if service.start_with?('.') || %w[build html].include?(service)
    service_path = File.join(base_dir, service)
    next unless File.directory?(service_path)
    # Remove directory if it's empty.
    if (Dir.entries(service_path) - %w[. ..]).empty?
      Dir.rmdir(service_path)
    end
  end

  puts "Rearrangement complete!"
end

# Process command-line arguments.
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: rearrange.rb [options] BASE_DIR"
end.parse!(ARGV)

if ARGV.empty?
  puts "Usage: rearrange.rb BASE_DIR"
  exit 1
end

base_dir = ARGV[0]
rearrange_by_environment(base_dir)
