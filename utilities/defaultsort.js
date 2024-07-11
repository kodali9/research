<script>
    var filtersConfig = {
        base_path: 'path/to/tablefilter/',
        col_types: [
            'string', 'string'  // Adjust the column types as needed
        ],
        sort_config: {
            sort_types: ['string', 'string'], // Define the types for sorting
            initial_sort: [
                {col: 0, order: 'asc'}, // Sort column 0 in ascending order
                {col: 1, order: 'desc'} // Sort column 1 in descending order (optional)
            ]
        },
        extensions: [{
            name: 'sort'
        }]
    };

    var tf = new TableFilter('myTable', filtersConfig);
    tf.init();
</script>
