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
// fin habilita deshabilita tipo de persona

//-- Confirma activar/desactivar el checkbox de creditos
//function confirma()
//{
//    if ( document.forms[0].elements['credito_status'].checked == false ){
//        if ( window.confirm("¿Desea deshabilitar este Crédito?") == true ){
//            document.forms[0].elements['credito_status'].checked = false;
//        }
//        else{
//            document.forms[0].elements['credito_status'].checked = true;
//        }
//    }
//    else{
//        if ( window.confirm("¿Desea habilitar este Crédito?") == true ){
//            document.forms[0].elements['credito_status'].checked = true;
//        }
//        else{
//            document.forms[0].elements['credito_status'].checked = false;
//        }
//    }
//}
// fin de confirma checkbox
//
//function comprobar_cerrar()
//{
//    missinginfo = "";
//    var mal=false;
//    numero=document.forms[0].elements.length;
//    for(a=0;a<numero;a++) {
//        if(document.forms[0].elements[a].value=="") {
//            document.forms[0].elements[a].style.backgroundColor="#ff9999";
//            missinginfo += "\n     - "+document.forms[0].elements[a].name;
//            mal=true;
//        }
//        else {
//            document.forms[0].elements[a].style.backgroundColor="white";
//            document.forms[0].elements[a].value = document.forms[0].elements[a].value.toUpperCase();
//        }
//    }
//    if(mal) {
//        alert("Por favor, rellene los campos:"+'\n'+missinginfo);
//        return false;
//    }
//    else {
//        document.forms[0].submit();
//        return true;
//    }
//}

//-- Carga los menu -->
function mmLoadMenus() {
  if (window.menu_catalogo) return;

// Submenu de Catalogos de Cuentas
  window.menu_cuentas = new Menu("Ctas Bancarias",140,20,"Geneva, Arial, Helvetica, sans-serif",14,"#000000","#FFFFFF","#ADADAD","#6699CC","left","middle",3,0,1000,-5,7,true,true,true,0,false,true);
  menu_cuentas.addMenuItem("Concentradoras","location='/ctaconcentradoras'");
  menu_cuentas.addMenuItem("Liquidadoras","location='/ctaliquidadoras'");
  menu_cuentas.fontWeight="bold";
  menu_cuentas.hideOnMouseOut=true;
  menu_cuentas.bgColor='#555555';
  menu_cuentas.menuBorder=1;
  menu_cuentas.menuLiteBgColor='#FFFFFF';
  menu_cuentas.menuBorderBgColor='#777777';

// Menú de Catalogos
  window.menu_catalogo = new Menu("root",148,20,"Geneva, Arial, Helvetica, sans-serif",14,"#000000","#FFFFFF","#999999","#6699CC","left","middle",3,0,1000,-5,7,true,true,true,0,false,true);
  menu_catalogo.addMenuItem("Bancos","location='/bancos'");
  menu_catalogo.addMenuItem("Suc. Bancarias","location='/sucbancarias'");
  //menu_catalogo.addMenuItem("Polizas","location='/polizas'");
  menu_catalogo.addMenuItem(menu_cuentas);
  menu_catalogo.addMenuItem("Clientes","location='/clientes'");
  menu_catalogo.addMenuItem("Festivos","location='/festivos'");
  menu_catalogo.addMenuItem("Fondeos","location='/fondeos'");
//  menu_catalogo.addMenuItem("Garantías","location='/garantias'");
  menu_catalogo.addMenuItem("Cuentas&nbsp;Contables","location='/cuentas'");
  menu_catalogo.addMenuItem("Grupos","location='/grupos'");
  menu_catalogo.addMenuItem("Líneas","location='/lineas'");
//  menu_catalogo.addMenuItem("Periodos","location='/periodos'");
  menu_catalogo.addMenuItem("Productos","location='/productos'");
  menu_catalogo.addMenuItem("Promotores","location='/promotors'");
  menu_catalogo.addMenuItem("Sucursales","location='/sucursals'");
  menu_catalogo.fontWeight="bold";
  menu_catalogo.hideOnMouseOut=true;
  menu_catalogo.bgColor='#555555';
  menu_catalogo.menuBorder=1;
  menu_catalogo.menuLiteBgColor='#FFFFFF';
  menu_catalogo.menuBorderBgColor='#777777';

// Menú de Operación
  window.menu_operacion = new Menu("root",210,20,"Geneva, Arial, Helvetica, sans-serif",14,"#000000","#FFFFFF","#999999","#6699CC","left","middle",3,0,1000,-5,7,true,true,true,0,true,true);
  menu_operacion.addMenuItem("Créditos","location='/creditos/movimiento_credito'");
  menu_operacion.addMenuItem("Alta&nbsp;Crédito&nbsp;Individual","location='/creditos/new_individual'");
  menu_operacion.addMenuItem("Alta&nbsp;Crédito&nbsp;Grupal","location='/creditos/new_grupal'");
//  menu_operacion.addMenuItem("Listado&nbsp;de&nbsp;Créditos","location='#'");
  menu_operacion.addMenuItem("Pago&nbsp;Línea&nbsp;Fondeo","location='/pagoslineas/new'");
  menu_operacion.addMenuItem("Transferir&nbsp;Fondos","location='/lineas/transferir_fondos'");
  menu_operacion.addMenuItem("Exportacion&nbsp;de&nbsp;Polizas&nbsp;","location='/reportes/exportacion_polizas'");
  menu_operacion.addMenuItem("Exportacion&nbsp;de&nbsp;Cuentas","location='/reportes/exportacion_cuentas'");
  menu_operacion.addMenuItem("Cargar&nbsp;Layout","location='/upload'");
  menu_operacion.addMenuItem("Histórico&nbsp;de&nbsp;Cargas","location='/upload/historico'");
  menu_operacion.addMenuItem("Informacion&nbsp;de&nbsp;Créditos","location='/reportes/hoja_calculo'");
  menu_operacion.fontWeight="bold";
  menu_operacion.hideOnMouseOut=true;
  menu_operacion.bgColor='#555555';
  menu_operacion.menuBorder=1;
  menu_operacion.menuLiteBgColor='#FFFFFF';
  menu_operacion.menuBorderBgColor='#777777';

// Menú de Reportes
  window.menu_reporte = new Menu("root",240,20,"Geneva, Arial, Helvetica, sans-serif",14,"#000000","#FFFFFF","#999999","#6699CC","left","middle",3,0,1000,-5,7,true,true,true,0,true,true);
  menu_reporte.addMenuItem("Pagos&nbsp;del&nbsp;día","location='/pagos/index'");
  menu_reporte.addMenuItem("Vencimientos","location='/reportes/vencimientos'");
  menu_reporte.addMenuItem("Estado&nbsp;de&nbsp;Cuenta&nbsp;del&nbsp;Cliente","location='/clientes/estado_cuenta'");
  menu_reporte.addMenuItem("Estado&nbsp;de&nbsp;Cuenta&nbsp;del&nbsp;Grupo","location='/grupos/estado_cuenta'");
  menu_reporte.addMenuItem("Estado&nbsp;de&nbsp;cuenta&nbsp;línea&nbsp;fondeo","location='/lineas/estado_cuenta'");
  menu_reporte.fontWeight="bold";
  menu_reporte.hideOnMouseOut=true;
  menu_reporte.bgColor='#555555';
  menu_reporte.menuBorder=1;
  menu_reporte.menuLiteBgColor='#FFFFFF';
  menu_reporte.menuBorderBgColor='#777777';


// Menú de Administración
  window.menu_administracion = new Menu("root",150,20,"Geneva, Arial, Helvetica, sans-serif",14,"#000000","#FFFFFF","#999999","#6699CC","left","middle",3,0,1000,-5,7,true,true,true,0,false,true);
  menu_administracion.addMenuItem("Usuarios","location='/administracion/usuarios'");
  //menu_administracion.addMenuItem("Permisos","location='/administracion/permisos'");
  menu_administracion.fontWeight="bold";
  menu_administracion.hideOnMouseOut=true;
  menu_administracion.bgColor='#555555';
  menu_administracion.menuBorder=1;
  menu_administracion.menuLiteBgColor='#FFFFFF';
  menu_administracion.menuBorderBgColor='#777777';

menu_administracion.writeMenus();
} // fin menus -->