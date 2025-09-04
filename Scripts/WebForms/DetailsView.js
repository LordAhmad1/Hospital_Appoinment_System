// DetailsView.js - DetailsView functionality for ASP.NET WebForms
// This file provides DetailsView control behavior and styling

if (typeof(Sys) === 'undefined') {
    var Sys = {};
}

if (typeof(Sys.WebForms) === 'undefined') {
    Sys.WebForms = {};
}

// DetailsView functionality
Sys.WebForms.DetailsView = {
    // Initialize DetailsView
    initialize: function(detailsViewElement) {
        if (detailsViewElement) {
            // Add styling to rows
            var rows = detailsViewElement.querySelectorAll('tr');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                
                // Add alternating row colors
                if (i % 2 === 0) {
                    row.classList.add('detailsview-row-even');
                } else {
                    row.classList.add('detailsview-row-odd');
                }
                
                // Style field headers
                var headerCell = row.querySelector('th');
                if (headerCell) {
                    headerCell.classList.add('detailsview-header');
                }
                
                // Style field values
                var valueCell = row.querySelector('td');
                if (valueCell) {
                    valueCell.classList.add('detailsview-value');
                }
            }
            
            // Handle edit mode
            var editButtons = detailsViewElement.querySelectorAll('.edit-button, [data-action="edit"]');
            for (var i = 0; i < editButtons.length; i++) {
                editButtons[i].addEventListener('click', function(e) {
                    Sys.WebForms.DetailsView.enterEditMode(detailsViewElement);
                    e.preventDefault();
                });
            }
            
            // Handle update/cancel buttons
            var updateButtons = detailsViewElement.querySelectorAll('.update-button, [data-action="update"]');
            for (var i = 0; i < updateButtons.length; i++) {
                updateButtons[i].addEventListener('click', function(e) {
                    Sys.WebForms.DetailsView.updateRecord(detailsViewElement);
                    e.preventDefault();
                });
            }
            
            var cancelButtons = detailsViewElement.querySelectorAll('.cancel-button, [data-action="cancel"]');
            for (var i = 0; i < cancelButtons.length; i++) {
                cancelButtons[i].addEventListener('click', function(e) {
                    Sys.WebForms.DetailsView.cancelEdit(detailsViewElement);
                    e.preventDefault();
                });
            }
        }
    },
    
    // Enter edit mode
    enterEditMode: function(detailsView) {
        detailsView.classList.add('edit-mode');
        
        // Convert read-only fields to input fields
        var valueCells = detailsView.querySelectorAll('.detailsview-value');
        for (var i = 0; i < valueCells.length; i++) {
            var cell = valueCells[i];
            var text = cell.textContent.trim();
            
            // Create input field
            var input = document.createElement('input');
            input.type = 'text';
            input.value = text;
            input.className = 'form-control';
            
            // Clear cell and add input
            cell.textContent = '';
            cell.appendChild(input);
        }
        
        // Show/hide appropriate buttons
        var editButtons = detailsView.querySelectorAll('.edit-button, [data-action="edit"]');
        var updateButtons = detailsView.querySelectorAll('.update-button, [data-action="update"]');
        var cancelButtons = detailsView.querySelectorAll('.cancel-button, [data-action="cancel"]');
        
        for (var i = 0; i < editButtons.length; i++) {
            editButtons[i].style.display = 'none';
        }
        
        for (var i = 0; i < updateButtons.length; i++) {
            updateButtons[i].style.display = 'inline-block';
        }
        
        for (var i = 0; i < cancelButtons.length; i++) {
            cancelButtons[i].style.display = 'inline-block';
        }
    },
    
    // Update record
    updateRecord: function(detailsView) {
        // Collect form data
        var formData = {};
        var inputs = detailsView.querySelectorAll('input');
        
        for (var i = 0; i < inputs.length; i++) {
            var input = inputs[i];
            var fieldName = input.getAttribute('data-field') || 'field_' + i;
            formData[fieldName] = input.value;
        }
        
        // Here you would typically send the data to the server
        console.log('Updating record with data:', formData);
        
        // Exit edit mode
        Sys.WebForms.DetailsView.exitEditMode(detailsView);
    },
    
    // Cancel edit
    cancelEdit: function(detailsView) {
        Sys.WebForms.DetailsView.exitEditMode(detailsView);
    },
    
    // Exit edit mode
    exitEditMode: function(detailsView) {
        detailsView.classList.remove('edit-mode');
        
        // Restore original text
        var valueCells = detailsView.querySelectorAll('.detailsview-value');
        for (var i = 0; i < valueCells.length; i++) {
            var cell = valueCells[i];
            var input = cell.querySelector('input');
            
            if (input) {
                cell.textContent = input.value;
            }
        }
        
        // Show/hide appropriate buttons
        var editButtons = detailsView.querySelectorAll('.edit-button, [data-action="edit"]');
        var updateButtons = detailsView.querySelectorAll('.update-button, [data-action="update"]');
        var cancelButtons = detailsView.querySelectorAll('.cancel-button, [data-action="cancel"]');
        
        for (var i = 0; i < editButtons.length; i++) {
            editButtons[i].style.display = 'inline-block';
        }
        
        for (var i = 0; i < updateButtons.length; i++) {
            updateButtons[i].style.display = 'none';
        }
        
        for (var i = 0; i < cancelButtons.length; i++) {
            cancelButtons[i].style.display = 'none';
        }
    }
};

// Auto-initialize DetailsViews on page load
document.addEventListener('DOMContentLoaded', function() {
    var detailsViews = document.querySelectorAll('.detailsview, [class*="detailsview"]');
    for (var i = 0; i < detailsViews.length; i++) {
        Sys.WebForms.DetailsView.initialize(detailsViews[i]);
    }
});
