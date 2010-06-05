// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function CharNum(e, modo)
{
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    if (modo=='letra') {
        reg = /\d/;
        return !reg.test(keychar);
    }
    else {
        reg = /\D/;
        return !reg.test(keychar);
    }
}

function NumberDec(obj, e, allowDecimal, allowNegative)
{
    var key;
    var isCtrl = false;
    var keychar;
    var reg;

    if(window.event) {
	key = e.keyCode;
	isCtrl = window.event.ctrlKey
    }
    else if(e.which) {
	key = e.which;
	isCtrl = e.ctrlKey;
    }

    if (isNaN(key)) return true;

    keychar = String.fromCharCode(key);

	// check for backspace or delete, or if Ctrl was pressed
    if (key == 8 || isCtrl) {
	return true;
    }

    reg = /\d/;
    var isFirstN = allowNegative ? keychar == '-' && obj.value.indexOf('-') == -1 : false;
    var isFirstD = allowDecimal ? keychar == '.' && obj.value.indexOf('.') == -1 : false;

    return isFirstN || isFirstD || reg.test(keychar);
}

