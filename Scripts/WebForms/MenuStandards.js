// MenuStandards.js - Menu functionality for ASP.NET WebForms
// This file provides standard menu behavior and styling

if (typeof(Sys) === 'undefined') {
    var Sys = {};
}

if (typeof(Sys.WebForms) === 'undefined') {
    Sys.WebForms = {};
}

// Menu functionality
Sys.WebForms.Menu = {
    // Initialize menu
    initialize: function(menuElement) {
        if (menuElement) {
            // Add hover effects
            var menuItems = menuElement.querySelectorAll('li');
            for (var i = 0; i < menuItems.length; i++) {
                var item = menuItems[i];
                
                // Add hover class
                item.addEventListener('mouseenter', function() {
                    this.classList.add('menu-hover');
                });
                
                item.addEventListener('mouseleave', function() {
                    this.classList.remove('menu-hover');
                });
                
                // Handle submenu toggle
                var submenu = item.querySelector('ul');
                if (submenu) {
                    item.addEventListener('click', function(e) {
                        if (submenu.style.display === 'none' || submenu.style.display === '') {
                            submenu.style.display = 'block';
                        } else {
                            submenu.style.display = 'none';
                        }
                        e.preventDefault();
                    });
                }
            }
        }
    },
    
    // Show/hide submenu
    toggleSubmenu: function(menuItem) {
        var submenu = menuItem.querySelector('ul');
        if (submenu) {
            if (submenu.style.display === 'none' || submenu.style.display === '') {
                submenu.style.display = 'block';
            } else {
                submenu.style.display = 'none';
            }
        }
    }
};

// Auto-initialize menus on page load
document.addEventListener('DOMContentLoaded', function() {
    var menus = document.querySelectorAll('.menu, .nav-menu, [class*="menu"]');
    for (var i = 0; i < menus.length; i++) {
        Sys.WebForms.Menu.initialize(menus[i]);
    }
});
