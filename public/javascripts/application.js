// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//-- Valida campo texto, campo numero -->

//Limite de caracteres

function CharNum(e, modo)
{
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    if (modo=='letra') {
        reg = /\D/;
        return reg.test(keychar);
    }
    else {
        return (key <= 13 || (key >= 48 && key <= 57) || key == 46 || key == 45);
    }
}
//-- fin valida campo -->

//-- Comprueba que no se envien campos vacios -->
function comprobar()
{
    missinginfo = "";
    var vacio=false;
    numero=document.forms[0].elements.length;
    for(a=0;a<numero;a++) {
        if(document.forms[0].elements[a].value=="" && document.forms[0].elements[a].className=="text") {
            document.forms[0].elements[a].style.backgroundColor="#ff9999";
            missinginfo += "\n     - "+document.forms[0].elements[a].name;
            vacio=true;
        }
        else {
            document.forms[0].elements[a].style.backgroundColor="white";
            document.forms[0].elements[a].value = document.forms[0].elements[a].value.toUpperCase();
        }
    }
    if(vacio) {
        alert("Por favor, rellene los campos:"+'\n'+missinginfo);
        return false;
    }
    else {
        if(valida_curp()){
            alert("Verifica CURP");
            return false;
        }
        else {
        document.forms[0].submit();
        return true;
        }
    }
}
// fin de funcion comprobar campos vacios

// Valida CURP
function valida_curp(){
    if(document.forms[0].elements['cliente_curp'].value.length != 18){
        document.forms[0].elements['cliente_curp'].style.backgroundColor="#ff9999";
        return true;
    }
    else {
        document.forms[0].elements['cliente_curp'].style.backgroundColor="white";
        return false;
    }
}

//-- Limita caracteres escritos en textbox
function longitud(texto,maxlong) {
    var in_value, out_value;

    if (texto.value.length > maxlong) {
        in_value = texto.value;
        out_value = in_value.substring(0,maxlong);
        texto.value = out_value;
        return false;
    }
    return true;
}
// fin limita caracteres introducidos

//-- Habilita-Deshabilita textbox de tipo de persona
function habilita_des(){
    if ((document.forms[0].elements['cliente_tipo_persona'].value == "FISICA") || (document.forms[0].elements['cliente_tipo_persona'].value == "")){
        document.forms[0].elements['cliente_folio_rfc'].value = "0";
        document.forms[0].elements['cliente_folio_rfc'].disabled = true;
    }
    else{
        document.forms[0].elements['cliente_folio_rfc'].disabled = false;
        document.forms[0].elements['cliente_folio_rfc'].value = "";
    }
}


function visibleLogin(obj){
	var el = document.getElementById(obj);
	if (el.style.display != 'none'){
		el.style.display = 'none';
	}
	else {
		el.style.display = 'block';
	}
}