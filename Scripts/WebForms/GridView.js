// GridView.js - GridView functionality for ASP.NET WebForms
// This file provides GridView control behavior and styling

if (typeof(Sys) === 'undefined') {
    var Sys = {};
}

if (typeof(Sys.WebForms) === 'undefined') {
    Sys.WebForms = {};
}

// GridView functionality
Sys.WebForms.GridView = {
    // Initialize GridView
    initialize: function(gridViewElement) {
        if (gridViewElement) {
            // Add hover effects to rows
            var rows = gridViewElement.querySelectorAll('tr');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                
                // Skip header row
                if (row.cells.length > 0 && row.cells[0].tagName === 'TH') {
                    continue;
                }
                
                // Add hover effect
                row.addEventListener('mouseenter', function() {
                    this.classList.add('gridview-row-hover');
                });
                
                row.addEventListener('mouseleave', function() {
                    this.classList.remove('gridview-row-hover');
                });
                
                // Add click effect
                row.addEventListener('click', function() {
                    // Remove selection from other rows
                    var allRows = gridViewElement.querySelectorAll('tr');
                    for (var j = 0; j < allRows.length; j++) {
                        allRows[j].classList.remove('gridview-row-selected');
                    }
                    
                    // Add selection to current row
                    this.classList.add('gridview-row-selected');
                });
            }
            
            // Handle sorting
            var headers = gridViewElement.querySelectorAll('th');
            for (var i = 0; i < headers.length; i++) {
                var header = headers[i];
                if (header.getAttribute('data-sortable') !== 'false') {
                    header.style.cursor = 'pointer';
                    header.addEventListener('click', function() {
                        Sys.WebForms.GridView.sortColumn(gridViewElement, this);
                    });
                }
            }
        }
    },
    
    // Sort column
    sortColumn: function(gridView, header) {
        var columnIndex = Array.prototype.indexOf.call(header.parentNode.children, header);
        var tbody = gridView.querySelector('tbody');
        var rows = Array.prototype.slice.call(tbody.querySelectorAll('tr'));
        
        // Get sort direction
        var isAscending = header.classList.contains('sort-desc');
        
        // Sort rows
        rows.sort(function(a, b) {
            var aValue = a.cells[columnIndex].textContent.trim();
            var bValue = b.cells[columnIndex].textContent.trim();
            
            // Try to sort as numbers first
            var aNum = parseFloat(aValue);
            var bNum = parseFloat(bValue);
            
            if (!isNaN(aNum) && !isNaN(bNum)) {
                return isAscending ? aNum - bNum : bNum - aNum;
            }
            
            // Sort as strings
            if (isAscending) {
                return aValue.localeCompare(bValue);
            } else {
                return bValue.localeCompare(aValue);
            }
        });
        
        // Update sort indicators
        var headers = gridView.querySelectorAll('th');
        for (var i = 0; i < headers.length; i++) {
            headers[i].classList.remove('sort-asc', 'sort-desc');
        }
        
        header.classList.add(isAscending ? 'sort-asc' : 'sort-desc');
        
        // Reorder rows
        for (var i = 0; i < rows.length; i++) {
            tbody.appendChild(rows[i]);
        }
    }
};

// Auto-initialize GridViews on page load
document.addEventListener('DOMContentLoaded', function() {
    var gridViews = document.querySelectorAll('.gridview, [class*="gridview"], table[class*="grid"]');
    for (var i = 0; i < gridViews.length; i++) {
        Sys.WebForms.GridView.initialize(gridViews[i]);
    }
});
