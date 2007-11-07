// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var ZINDEXTOP = 100;

Element.Methods.popup = function(element) {
    $(element).setStyle({"zIndex": ZINDEXTOP++});
    return element;
};

Element.addMethods();
