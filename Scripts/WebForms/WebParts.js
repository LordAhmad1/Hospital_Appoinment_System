// WebParts.js - WebParts functionality for ASP.NET WebForms
// This file provides WebParts control behavior and styling

if (typeof(Sys) === 'undefined') {
    var Sys = {};
}

if (typeof(Sys.WebForms) === 'undefined') {
    Sys.WebForms = {};
}

// WebParts functionality
Sys.WebForms.WebParts = {
    // Initialize WebParts
    initialize: function(webPartsZone) {
        if (webPartsZone) {
            // Add drag and drop functionality
            var webParts = webPartsZone.querySelectorAll('.webpart, [class*="webpart"]');
            for (var i = 0; i < webParts.length; i++) {
                var webPart = webParts[i];
                
                // Make webparts draggable
                webPart.setAttribute('draggable', 'true');
                
                // Add drag events
                webPart.addEventListener('dragstart', function(e) {
                    e.dataTransfer.setData('text/plain', this.id);
                    this.classList.add('dragging');
                });
                
                webPart.addEventListener('dragend', function(e) {
                    this.classList.remove('dragging');
                });
                
                // Add minimize/maximize functionality
                var minimizeButton = webPart.querySelector('.minimize-button, .webpart-minimize');
                if (minimizeButton) {
                    minimizeButton.addEventListener('click', function(e) {
                        Sys.WebForms.WebParts.minimizeWebPart(webPart);
                        e.preventDefault();
                    });
                }
                
                var maximizeButton = webPart.querySelector('.maximize-button, .webpart-maximize');
                if (maximizeButton) {
                    maximizeButton.addEventListener('click', function(e) {
                        Sys.WebForms.WebParts.maximizeWebPart(webPart);
                        e.preventDefault();
                    });
                }
                
                // Add close functionality
                var closeButton = webPart.querySelector('.close-button, .webpart-close');
                if (closeButton) {
                    closeButton.addEventListener('click', function(e) {
                        Sys.WebForms.WebParts.closeWebPart(webPart);
                        e.preventDefault();
                    });
                }
            }
            
            // Add drop zone functionality
            webPartsZone.addEventListener('dragover', function(e) {
                e.preventDefault();
                this.classList.add('drag-over');
            });
            
            webPartsZone.addEventListener('dragleave', function(e) {
                this.classList.remove('drag-over');
            });
            
            webPartsZone.addEventListener('drop', function(e) {
                e.preventDefault();
                this.classList.remove('drag-over');
                
                var webPartId = e.dataTransfer.getData('text/plain');
                var webPart = document.getElementById(webPartId);
                
                if (webPart) {
                    // Move webpart to new position
                    var dropTarget = e.target.closest('.webpart, [class*="webpart"]');
                    if (dropTarget && dropTarget !== webPart) {
                        Sys.WebForms.WebParts.moveWebPart(webPart, dropTarget);
                    }
                }
            });
        }
    },
    
    // Minimize webpart
    minimizeWebPart: function(webPart) {
        var content = webPart.querySelector('.webpart-content, .content');
        var minimizeButton = webPart.querySelector('.minimize-button, .webpart-minimize');
        var maximizeButton = webPart.querySelector('.maximize-button, .webpart-maximize');
        
        if (content) {
            content.style.display = 'none';
            webPart.classList.add('minimized');
        }
        
        if (minimizeButton) minimizeButton.style.display = 'none';
        if (maximizeButton) maximizeButton.style.display = 'inline-block';
    },
    
    // Maximize webpart
    maximizeWebPart: function(webPart) {
        var content = webPart.querySelector('.webpart-content, .content');
        var minimizeButton = webPart.querySelector('.minimize-button, .webpart-minimize');
        var maximizeButton = webPart.querySelector('.maximize-button, .webpart-maximize');
        
        if (content) {
            content.style.display = 'block';
            webPart.classList.remove('minimized');
        }
        
        if (minimizeButton) minimizeButton.style.display = 'inline-block';
        if (maximizeButton) maximizeButton.style.display = 'none';
    },
    
    // Close webpart
    closeWebPart: function(webPart) {
        if (confirm('Are you sure you want to close this webpart?')) {
            webPart.style.display = 'none';
            webPart.classList.add('closed');
        }
    },
    
    // Move webpart
    moveWebPart: function(webPart, targetWebPart) {
        var parent = targetWebPart.parentNode;
        var nextSibling = targetWebPart.nextSibling;
        
        // Remove webpart from current position
        webPart.parentNode.removeChild(webPart);
        
        // Insert webpart at new position
        if (nextSibling) {
            parent.insertBefore(webPart, nextSibling);
        } else {
            parent.appendChild(webPart);
        }
        
        // Save new order to localStorage or send to server
        Sys.WebForms.WebParts.saveWebPartOrder(parent);
    },
    
    // Save webpart order
    saveWebPartOrder: function(webPartsZone) {
        var webParts = webPartsZone.querySelectorAll('.webpart, [class*="webpart"]');
        var order = [];
        
        for (var i = 0; i < webParts.length; i++) {
            order.push(webParts[i].id);
        }
        
        // Save to localStorage
        localStorage.setItem('webpart-order-' + webPartsZone.id, JSON.stringify(order));
        
        // Here you could also send the order to the server
        console.log('WebPart order saved:', order);
    },
    
    // Restore webpart order
    restoreWebPartOrder: function(webPartsZone) {
        var savedOrder = localStorage.getItem('webpart-order-' + webPartsZone.id);
        
        if (savedOrder) {
            var order = JSON.parse(savedOrder);
            var webParts = webPartsZone.querySelectorAll('.webpart, [class*="webpart"]');
            
            // Reorder webparts based on saved order
            for (var i = 0; i < order.length; i++) {
                var webPart = document.getElementById(order[i]);
                if (webPart) {
                    webPartsZone.appendChild(webPart);
                }
            }
        }
    },
    
    // Add new webpart
    addWebPart: function(webPartsZone, webPartType, title) {
        var webPart = document.createElement('div');
        webPart.className = 'webpart';
        webPart.id = 'webpart-' + Date.now();
        
        webPart.innerHTML = `
            <div class="webpart-header">
                <h3>${title || 'New WebPart'}</h3>
                <div class="webpart-controls">
                    <button class="minimize-button" title="Minimize">_</button>
                    <button class="maximize-button" title="Maximize" style="display:none;">□</button>
                    <button class="close-button" title="Close">×</button>
                </div>
            </div>
            <div class="webpart-content">
                <p>This is a new ${webPartType} webpart.</p>
            </div>
        `;
        
        webPartsZone.appendChild(webPart);
        Sys.WebForms.WebParts.initialize(webPartsZone);
        
        return webPart;
    }
};

// Auto-initialize WebParts on page load
document.addEventListener('DOMContentLoaded', function() {
    var webPartsZones = document.querySelectorAll('.webpartzone, [class*="webpartzone"]');
    for (var i = 0; i < webPartsZones.length; i++) {
        Sys.WebForms.WebParts.initialize(webPartsZones[i]);
        Sys.WebForms.WebParts.restoreWebPartOrder(webPartsZones[i]);
    }
});
