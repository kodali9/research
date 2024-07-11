document.addEventListener('DOMContentLoaded', function () {
    var tf = new TableFilter('your-table-id', {
        base_path: 'path/to/tablefilter/'
    });
    tf.init();
});
