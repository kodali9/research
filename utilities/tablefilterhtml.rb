# Generate HTML content with a table
html_content = <<-HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TableFilter Example</title>
    <!-- Include TableFilter CSS -->
    <link rel="stylesheet" href="https://unpkg.com/tablefilter@latest/dist/tablefilter/style/tablefilter.css">
</head>
<body>
    <table id="demo-table">
        <thead>
            <tr>
                <th>Name</th>
                <th>Age</th>
                <th>Country</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>John Doe</td>
                <td>30</td>
                <td>USA</td>
            </tr>
            <tr>
                <td>Jane Smith</td>
                <td>25</td>
                <td>Canada</td>
            </tr>
            <tr>
                <td>James Brown</td>
                <td>35</td>
                <td>UK</td>
            </tr>
        </tbody>
    </table>

    <!-- Include TableFilter JS -->
    <script src="https://unpkg.com/tablefilter@latest/dist/tablefilter/tablefilter.js"></script>
    <script>
        // Initialize TableFilter
        var tf = new TableFilter('demo-table', {
            base_path: 'https://unpkg.com/tablefilter@latest/dist/tablefilter/'
        });
        tf.init();
    </script>
</body>
</html>
HTML

# Write the HTML content to a file
File.open("tablefilter_example.html", "w") do |file|
  file.write(html_content)
end
