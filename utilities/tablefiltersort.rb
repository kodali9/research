require 'sculpt'

html = Sculpt.make do
  doctype :html
  html do
    head do
      meta charset: "UTF-8"
      meta name: "viewport", content: "width=device-width, initial-scale=1.0"
      title "TableFilter Example"
      link rel: "stylesheet", href: "https://unpkg.com/tablefilter@latest/dist/tablefilter/style/tablefilter.css"
    end
    body do
      table id: "demo-table" do
        thead do
          tr do
            th "Name"
            th "Age"
            th "Country"
          end
        end
        tbody do
          tr do
            td "John Doe"
            td "30"
            td "USA"
          end
          tr do
            td "Jane Smith"
            td "25"
            td "Canada"
          end
          tr do
            td "James Brown"
            td "35"
            td "UK"
          end
        end
      end

      script src: "https://unpkg.com/tablefilter@latest/dist/tablefilter/tablefilter.js"
      script do
        text <<-JS
          var tf = new TableFilter('demo-table', {
            base_path: 'https://unpkg.com/tablefilter@latest/dist/tablefilter/',
            col_types: [
              'string', // Name column
              'number', // Age column
              'string'  // Country column
            ],
            sort: true // Enable sorting
          });
          tf.init();
        JS
      end
    end
  end
end

# Write the HTML content to a file
File.open("tablefilter_example.html", "w") do |file|
  file.write(html.to_s)
end
