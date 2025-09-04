# ASP.NET WebForms JavaScript Files

This directory contains JavaScript files that provide client-side functionality for ASP.NET WebForms controls.

## Files Overview

### Core Files
- **WebForms.js** - Core WebForms functionality and PageRequestManager
- **WebUIValidation.js** - Client-side validation for form controls
- **Focus.js** - Focus management and accessibility features

### Control-Specific Files
- **MenuStandards.js** - Menu functionality and hover effects
- **GridView.js** - GridView sorting, selection, and hover effects
- **DetailsView.js** - DetailsView edit mode and form handling
- **TreeView.js** - TreeView expand/collapse and node selection
- **WebParts.js** - WebParts drag-and-drop and control functionality

### Styling
- **WebForms.css** - CSS styles for all WebForms controls

## Features

### GridView
- ✅ Row hover effects
- ✅ Row selection
- ✅ Column sorting (click headers)
- ✅ Responsive design

### DetailsView
- ✅ Alternating row colors
- ✅ Edit mode functionality
- ✅ Form validation
- ✅ Update/Cancel operations

### TreeView
- ✅ Expand/collapse nodes
- ✅ Node selection
- ✅ Hover effects
- ✅ Keyboard navigation

### WebParts
- ✅ Drag and drop reordering
- ✅ Minimize/Maximize
- ✅ Close functionality
- ✅ Persistent layout (localStorage)

### Validation
- ✅ Required field validation
- ✅ Email validation
- ✅ Range validation
- ✅ Length validation
- ✅ Error display

### Focus Management
- ✅ Auto-focus first input
- ✅ Enter key navigation
- ✅ Accessibility support

## Usage

### Automatic Initialization
All controls are automatically initialized when the page loads. Simply add the appropriate CSS classes to your HTML elements:

```html
<!-- GridView -->
<table class="gridview">
    <thead>
        <tr>
            <th data-sortable="true">Name</th>
            <th data-sortable="true">Email</th>
        </tr>
    </thead>
    <tbody>
        <tr><td>John</td><td>john@example.com</td></tr>
    </tbody>
</table>

<!-- TreeView -->
<div class="treeview">
    <div class="tree-node">
        <span class="expand-button">▶</span>
        Root Node
        <div class="tree-children">
            <div class="tree-node">Child Node</div>
        </div>
    </div>
</div>

<!-- WebParts -->
<div class="webpartzone">
    <div class="webpart">
        <div class="webpart-header">
            <h3>My WebPart</h3>
            <div class="webpart-controls">
                <button class="minimize-button">_</button>
                <button class="close-button">×</button>
            </div>
        </div>
        <div class="webpart-content">
            Content here
        </div>
    </div>
</div>
```

### Manual Initialization
You can also manually initialize controls:

```javascript
// Initialize GridView
Sys.WebForms.GridView.initialize(document.querySelector('.my-gridview'));

// Initialize TreeView
Sys.WebForms.TreeView.initialize(document.querySelector('.my-treeview'));

// Initialize WebParts
Sys.WebForms.WebParts.initialize(document.querySelector('.my-webpartzone'));
```

### API Methods

#### GridView
```javascript
// Sort column
Sys.WebForms.GridView.sortColumn(gridViewElement, headerElement);

// Get selected row
var selectedRow = gridViewElement.querySelector('.gridview-row-selected');
```

#### TreeView
```javascript
// Expand node
Sys.WebForms.TreeView.expandNode(nodeElement);

// Collapse node
Sys.WebForms.TreeView.collapseNode(nodeElement);

// Select node
Sys.WebForms.TreeView.selectNode(nodeElement);

// Expand all nodes
Sys.WebForms.TreeView.expandAll(treeViewElement);
```

#### WebParts
```javascript
// Minimize webpart
Sys.WebForms.WebParts.minimizeWebPart(webPartElement);

// Maximize webpart
Sys.WebForms.WebParts.maximizeWebPart(webPartElement);

// Close webpart
Sys.WebForms.WebParts.closeWebPart(webPartElement);

// Add new webpart
var newWebPart = Sys.WebForms.WebParts.addWebPart(zoneElement, 'type', 'title');
```

#### Validation
```javascript
// Validate email
var isValid = Sys.WebForms.Validation.Validator.email('test@example.com');

// Display error
Sys.WebForms.Validation.displayError(element, 'Error message');

// Clear error
Sys.WebForms.Validation.clearError(element);
```

#### Focus
```javascript
// Set focus to element
Sys.WebForms.Focus.setFocus('elementId');

// Set focus to first input
Sys.WebForms.Focus.setFocusToFirstInput();

// Move to next input
Sys.WebForms.Focus.setFocusToNext(currentElement);
```

## Browser Compatibility

- ✅ Chrome 60+
- ✅ Firefox 55+
- ✅ Safari 12+
- ✅ Edge 79+
- ✅ Internet Explorer 11+

## Dependencies

- No external dependencies
- Uses vanilla JavaScript
- Compatible with Bootstrap CSS framework
- Works with ASP.NET WebForms

## Customization

You can customize the appearance by modifying `WebForms.css` or adding your own CSS rules. The JavaScript files use CSS classes for styling, making it easy to override default styles.

## Troubleshooting

### Common Issues

1. **Controls not initializing**
   - Check browser console for JavaScript errors
   - Ensure CSS classes are correctly applied
   - Verify files are loaded in correct order

2. **Styling issues**
   - Check if `WebForms.css` is loaded
   - Inspect element to see applied classes
   - Override CSS rules as needed

3. **Drag and drop not working**
   - Ensure elements have `draggable="true"` attribute
   - Check for JavaScript errors in console
   - Verify drop zones are properly configured

### Debug Mode

Enable debug mode by adding this to your page:

```javascript
// Enable debug logging
window.WebFormsDebug = true;
```

This will log initialization and interaction events to the console.

## License

These files are provided as-is for use with ASP.NET WebForms applications. Feel free to modify and extend as needed for your project.
