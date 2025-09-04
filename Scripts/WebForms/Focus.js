// Focus.js - Focus management for ASP.NET WebForms
// This file provides focus handling and accessibility features

if (typeof(Sys) === 'undefined') {
    var Sys = {};
}

if (typeof(Sys.WebForms) === 'undefined') {
    Sys.WebForms = {};
}

// Focus management
Sys.WebForms.Focus = {
    // Set focus to an element
    setFocus: function(elementId) {
        var element = document.getElementById(elementId);
        if (element) {
            element.focus();
            return true;
        }
        return false;
    },
    
    // Set focus to first input element
    setFocusToFirstInput: function() {
        var inputs = document.querySelectorAll('input[type="text"], input[type="email"], input[type="password"], textarea, select');
        if (inputs.length > 0) {
            inputs[0].focus();
            return true;
        }
        return false;
    },
    
    // Set focus to next input element
    setFocusToNext: function(currentElement) {
        var inputs = document.querySelectorAll('input[type="text"], input[type="email"], input[type="password"], textarea, select');
        var currentIndex = -1;
        
        // Find current element index
        for (var i = 0; i < inputs.length; i++) {
            if (inputs[i] === currentElement) {
                currentIndex = i;
                break;
            }
        }
        
        // Set focus to next element
        if (currentIndex >= 0 && currentIndex < inputs.length - 1) {
            inputs[currentIndex + 1].focus();
            return true;
        }
        
        return false;
    },
    
    // Set focus to previous input element
    setFocusToPrevious: function(currentElement) {
        var inputs = document.querySelectorAll('input[type="text"], input[type="email"], input[type="password"], textarea, select');
        var currentIndex = -1;
        
        // Find current element index
        for (var i = 0; i < inputs.length; i++) {
            if (inputs[i] === currentElement) {
                currentIndex = i;
                break;
            }
        }
        
        // Set focus to previous element
        if (currentIndex > 0) {
            inputs[currentIndex - 1].focus();
            return true;
        }
        
        return false;
    }
};

// Auto-focus first input on page load
document.addEventListener('DOMContentLoaded', function() {
    // Set focus to first input if no element has focus
    if (document.activeElement === document.body) {
        Sys.WebForms.Focus.setFocusToFirstInput();
    }
});

// Handle Enter key navigation
document.addEventListener('keydown', function(e) {
    if (e.key === 'Enter' && e.target.tagName === 'INPUT') {
        // Move to next input on Enter
        Sys.WebForms.Focus.setFocusToNext(e.target);
    }
});
