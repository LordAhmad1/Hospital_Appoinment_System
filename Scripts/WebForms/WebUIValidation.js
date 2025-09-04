// WebUIValidation.js - Client-side validation for ASP.NET WebForms
// This file provides validation functionality for form controls

if (typeof(Sys) === 'undefined') {
    var Sys = {};
}

if (typeof(Sys.WebForms) === 'undefined') {
    Sys.WebForms = {};
}

// Validation namespace
Sys.WebForms.Validation = {};

// Basic validation functions
Sys.WebForms.Validation.Validator = {
    // Required field validation
    required: function(value) {
        return value && value.trim().length > 0;
    },
    
    // Email validation
    email: function(value) {
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(value);
    },
    
    // Range validation
    range: function(value, min, max) {
        var num = parseFloat(value);
        return !isNaN(num) && num >= min && num <= max;
    },
    
    // Length validation
    length: function(value, min, max) {
        var len = value ? value.length : 0;
        return len >= min && len <= max;
    }
};

// Validation display functions
Sys.WebForms.Validation.displayError = function(element, message) {
    if (element && message) {
        // Create error display element
        var errorDiv = document.createElement('div');
        errorDiv.className = 'validation-error';
        errorDiv.style.color = 'red';
        errorDiv.style.fontSize = '12px';
        errorDiv.style.marginTop = '5px';
        errorDiv.textContent = message;
        
        // Insert after the element
        element.parentNode.insertBefore(errorDiv, element.nextSibling);
    }
};

Sys.WebForms.Validation.clearError = function(element) {
    if (element) {
        var nextSibling = element.nextSibling;
        if (nextSibling && nextSibling.className === 'validation-error') {
            nextSibling.remove();
        }
    }
};
