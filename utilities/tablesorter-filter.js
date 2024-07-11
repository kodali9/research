$(document).ready(function() {
    // Initialize tablesorter
    $("#myTable").tablesorter({
        theme: 'default',
        widgets: ['zebra', 'filter'],
        widgetOptions: {
            filter_cssFilter: '', // class name for the filter input element
            filter_placeholder: { search : 'Search...' }, // placeholder text
            filter_saveFilters : true // save filters to local storage
        }
    });
});
