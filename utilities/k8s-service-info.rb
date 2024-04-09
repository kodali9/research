require 'yaml'
require 'erb'

# Define the path to your GitLab project directory
project_directory = '/path/to/your/gitlab/project'

# Define the environments
environments = ['dev', 'uat', 'prod']

# Define a data structure to hold service information
services = []

# Iterate through each environment folder
environments.each do |env|
  env_directory = File.join(project_directory, env)
  next unless File.directory?(env_directory)

  # Iterate through each service folder
  Dir.glob(File.join(env_directory, '*/')).each do |service_folder|
    service_name = File.basename(service_folder)
    kustomization_path = File.join(service_folder, 'kustomization.yaml')
    deployment_path = File.join(service_folder, 'deployment.yaml')

    next unless File.file?(kustomization_path)

    # Parse kustomization.yaml
    kustomization_data = YAML.load_file(kustomization_path)
    value1 = kustomization_data['commonAnnotations']&.fetch('value1', 'N/A')

    # Parse deployment.yaml if it exists
    if File.file?(deployment_path)
      deployment_data = YAML.load_file(deployment_path)
      memory_limit = deployment_data.dig('spec', 'template', 'spec', 'containers', 0, 'resources', 'limits', 'memory') || 'N/A'
      cpu_limit = deployment_data.dig('spec', 'template', 'spec', 'containers', 0, 'resources', 'limits', 'cpu') || 'N/A'

      # Calculate memory_limit_number
      memory_limit_number = case memory_limit
                            when /(\d+)Gi/
                              $1.to_i
                            when /(\d+)Mi/
                              $1.to_i / 1024
                            else
                              'N/A'
                            end

      # Calculate cpu_limit_number
      cpu_limit_number = case cpu_limit
                         when /(\d+)m/
                           $1.to_i / 1000
                         else
                           cpu_limit.to_f # assuming numeric values are in cores
                         end
    else
      memory_limit = 'N/A'
      memory_limit_number = 'N/A'
      cpu_limit = 'N/A'
      cpu_limit_number = 'N/A'
    end

    # Add service information to the data structure
    services << {
      name: service_name,
      value1: value1,
      memory_limit: memory_limit,
      memory_limit_number: memory_limit_number,
      cpu_limit: cpu_limit,
      cpu_limit_number: cpu_limit_number
    }
  end
end

# Generate HTML using ERB template
template = ERB.new(File.read('template.html.erb'))
html_output = template.result(binding)

# Write HTML to a file
File.open('output.html', 'w') { |file| file.write(html_output) }
