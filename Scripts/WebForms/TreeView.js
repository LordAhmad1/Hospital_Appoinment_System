// TreeView.js - TreeView functionality for ASP.NET WebForms
// This file provides TreeView control behavior and styling

if (typeof(Sys) === 'undefined') {
    var Sys = {};
}

if (typeof(Sys.WebForms) === 'undefined') {
    Sys.WebForms = {};
}

// TreeView functionality
Sys.WebForms.TreeView = {
    // Initialize TreeView
    initialize: function(treeViewElement) {
        if (treeViewElement) {
            // Add click handlers to expand/collapse nodes
            var nodes = treeViewElement.querySelectorAll('.tree-node, [class*="tree-node"]');
            for (var i = 0; i < nodes.length; i++) {
                var node = nodes[i];
                
                // Add expand/collapse functionality
                var expandButton = node.querySelector('.expand-button, .toggle-button');
                if (expandButton) {
                    expandButton.addEventListener('click', function(e) {
                        Sys.WebForms.TreeView.toggleNode(this.parentNode);
                        e.preventDefault();
                        e.stopPropagation();
                    });
                }
                
                // Add node selection
                node.addEventListener('click', function(e) {
                    // Don't trigger if clicking on expand button
                    if (e.target.classList.contains('expand-button') || e.target.classList.contains('toggle-button')) {
                        return;
                    }
                    
                    Sys.WebForms.TreeView.selectNode(this);
                });
                
                // Add hover effects
                node.addEventListener('mouseenter', function() {
                    this.classList.add('tree-node-hover');
                });
                
                node.addEventListener('mouseleave', function() {
                    this.classList.remove('tree-node-hover');
                });
            }
            
            // Initialize first level nodes as expanded
            var rootNodes = treeViewElement.querySelectorAll('> .tree-node, > [class*="tree-node"]');
            for (var i = 0; i < rootNodes.length; i++) {
                Sys.WebForms.TreeView.expandNode(rootNodes[i]);
            }
        }
    },
    
    // Toggle node expansion
    toggleNode: function(node) {
        if (node.classList.contains('expanded')) {
            Sys.WebForms.TreeView.collapseNode(node);
        } else {
            Sys.WebForms.TreeView.expandNode(node);
        }
    },
    
    // Expand node
    expandNode: function(node) {
        node.classList.add('expanded');
        node.classList.remove('collapsed');
        
        // Show child nodes
        var childNodes = node.querySelectorAll('> .tree-children > .tree-node, > .tree-children > [class*="tree-node"]');
        for (var i = 0; i < childNodes.length; i++) {
            childNodes[i].style.display = 'block';
        }
        
        // Update expand button
        var expandButton = node.querySelector('.expand-button, .toggle-button');
        if (expandButton) {
            expandButton.textContent = '▼';
            expandButton.title = 'Collapse';
        }
    },
    
    // Collapse node
    collapseNode: function(node) {
        node.classList.remove('expanded');
        node.classList.add('collapsed');
        
        // Hide child nodes
        var childNodes = node.querySelectorAll('> .tree-children > .tree-node, > .tree-children > [class*="tree-node"]');
        for (var i = 0; i < childNodes.length; i++) {
            childNodes[i].style.display = 'none';
        }
        
        // Update expand button
        var expandButton = node.querySelector('.expand-button, .toggle-button');
        if (expandButton) {
            expandButton.textContent = '▶';
            expandButton.title = 'Expand';
        }
    },
    
    // Select node
    selectNode: function(node) {
        // Remove selection from other nodes
        var treeView = node.closest('.treeview, [class*="treeview"]');
        var allNodes = treeView.querySelectorAll('.tree-node, [class*="tree-node"]');
        for (var i = 0; i < allNodes.length; i++) {
            allNodes[i].classList.remove('selected');
        }
        
        // Add selection to current node
        node.classList.add('selected');
        
        // Trigger selection event
        var event = new CustomEvent('nodeSelected', {
            detail: {
                node: node,
                nodeText: node.textContent.trim()
            }
        });
        treeView.dispatchEvent(event);
    },
    
    // Get selected node
    getSelectedNode: function(treeViewElement) {
        return treeViewElement.querySelector('.tree-node.selected, [class*="tree-node"].selected');
    },
    
    // Expand all nodes
    expandAll: function(treeViewElement) {
        var nodes = treeViewElement.querySelectorAll('.tree-node, [class*="tree-node"]');
        for (var i = 0; i < nodes.length; i++) {
            Sys.WebForms.TreeView.expandNode(nodes[i]);
        }
    },
    
    // Collapse all nodes
    collapseAll: function(treeViewElement) {
        var nodes = treeViewElement.querySelectorAll('.tree-node, [class*="tree-node"]');
        for (var i = 0; i < nodes.length; i++) {
            Sys.WebForms.TreeView.collapseNode(nodes[i]);
        }
    }
};

// Auto-initialize TreeViews on page load
document.addEventListener('DOMContentLoaded', function() {
    var treeViews = document.querySelectorAll('.treeview, [class*="treeview"]');
    for (var i = 0; i < treeViews.length; i++) {
        Sys.WebForms.TreeView.initialize(treeViews[i]);
    }
});
