// WebForms.js - Core ASP.NET WebForms functionality
// This file provides basic WebForms support for ASP.NET applications

if (typeof(Sys) === 'undefined') {
    var Sys = {};
}

if (typeof(Sys.WebForms) === 'undefined') {
    Sys.WebForms = {};
}

// Define PageRequestManager as a constructor function
Sys.WebForms.PageRequestManager = function() {
    this._isPartialRendering = false;
    this._asyncPostBackElement = null;
    this._beginRequestHandlers = [];
    this._endRequestHandlers = [];
};

// Static instance and getInstance method
Sys.WebForms.PageRequestManager._instance = null;
Sys.WebForms.PageRequestManager.getInstance = function() {
    if (!Sys.WebForms.PageRequestManager._instance) {
        Sys.WebForms.PageRequestManager._instance = new Sys.WebForms.PageRequestManager();
    }
    return Sys.WebForms.PageRequestManager._instance;
};

// Add methods to the prototype
Sys.WebForms.PageRequestManager.prototype = {
    get_isPartialRendering: function() {
        return this._isPartialRendering;
    },
    
    get_asyncPostBackElement: function() {
        return this._asyncPostBackElement;
    },
    
    set_isPartialRendering: function(value) {
        this._isPartialRendering = value;
    },
    
    set_asyncPostBackElement: function(element) {
        this._asyncPostBackElement = element;
    },
    
    _initialize: function() {
        // Initialize method to prevent errors
        console.log('PageRequestManager initialized');
    },
    
    add_beginRequest: function(handler) {
        // Add begin request handler
        if (typeof handler === 'function') {
            this._beginRequestHandlers.push(handler);
        }
    },
    
    remove_beginRequest: function(handler) {
        // Remove begin request handler
        var index = this._beginRequestHandlers.indexOf(handler);
        if (index > -1) {
            this._beginRequestHandlers.splice(index, 1);
        }
    },
    
    add_endRequest: function(handler) {
        // Add end request handler
        if (typeof handler === 'function') {
            this._endRequestHandlers.push(handler);
        }
    },
    
    remove_endRequest: function(handler) {
        // Remove end request handler
        var index = this._endRequestHandlers.indexOf(handler);
        if (index > -1) {
            this._endRequestHandlers.splice(index, 1);
        }
    },
    
    _raiseBeginRequest: function(sender, args) {
        // Raise begin request event
        for (var i = 0; i < this._beginRequestHandlers.length; i++) {
            try {
                this._beginRequestHandlers[i](sender, args);
            } catch (e) {
                console.log('Begin request handler error:', e);
            }
        }
    },
    
    _raiseEndRequest: function(sender, args) {
        // Raise end request event
        for (var i = 0; i < this._endRequestHandlers.length; i++) {
            try {
                this._endRequestHandlers[i](sender, args);
            } catch (e) {
                console.log('End request handler error:', e);
            }
        }
    }
};

// Initialize WebForms support
if (typeof(window) !== 'undefined') {
    window.Sys = Sys;
}
