// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function CharNum(e, modo)
{
    var key = window.event ? e.keyCode : e.which;
    var keychar = String.fromCharCode(key);
    if (modo=='letra') {
        reg = /\D/;
        return reg.test(keychar);
    }
    else {
        return (key <= 13 || (key >= 48 && key <= 57) || key == 46);
    }
}

function comprobar()
{
    missinginfo = "";
    var mal=false;
    numero=document.forms[0].elements.length;
    for(a=0;a<numero;a++)
    {
        if(document.forms[0].elements[a].value=="")
        {
            document.forms[0].elements[a].style.backgroundColor="#ff9999";
            missinginfo += "\n     - "+document.forms[0].elements[a].name;
            mal=true;
        }
        else
        {
            document.forms[0].elements[a].style.backgroundColor="white";
        }
    }
    if(mal)
    {
        alert("Por favor, rellene los campos:"+'\n'+missinginfo);
        return false;
    }
    else
    {
        document.forms[0].submit();
        return true;
    }
}
