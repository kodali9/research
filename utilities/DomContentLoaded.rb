require 'sculpt'

data = [
  { name: 'John Doe', age: 25, country: 'USA' },
  { name: 'Jane Smith', age: 30, country: 'Canada' },
  # Add more data as needed
]

html_content = Sculpt.new do
  html do
    head do
      meta charset: 'UTF-8'
      meta name: 'viewport', content: 'width=device-width, initial-scale=1.0'
      title 'Filterable Table'
      link rel: 'stylesheet', type: 'text/css', href: 'https://unpkg.com/tablefilter@latest/dist/tablefilter/style/tablefilter.css'
      script src: 'https://unpkg.com/tablefilter@latest/dist/tablefilter/tablefilter.js'
    end
    body do
      table id: 'demo-table' do
        thead do
          tr do
            th 'Name'
            th 'Age'
            th 'Country'
          end
        end
        tbody do
          data.each do |row|
            tr do
              td row[:name]
              td row[:age]
              td row[:country]
            end
          end
        end
      end
      script do
        raw <<-JS
        window.addEventListener('DOMContentLoaded', (event) => {
          var tf = new TableFilter('demo-table', {
            base_path: 'https://unpkg.com/tablefilter@latest/dist/tablefilter/'
          });
          tf.init();
        });
        JS
      end
    end
  end
end

File.write('table.html', html_content.to_html)
