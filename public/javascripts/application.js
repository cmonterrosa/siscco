// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//-- Valida campo texto, campo numero -->
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
//-- fin valida campo -->
//-- Comprueba que no se envien campos vacios -->
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
//-- fin comprobar-->

//-- Carga los menu -->
function mmLoadMenus() {
  if (window.menu_catalogo) return;
  window.menu_catalogo = new Menu("root",118,20,"Geneva, Arial, Helvetica, sans-serif",14,"#000000","#FFFFFF","#999999","#6699CC","left","middle",3,0,1000,-5,7,true,true,true,0,false,true);
  menu_catalogo.addMenuItem("Bancos","location='/bancos'");
  menu_catalogo.addMenuItem("Clientes","location='/clientes'");
  menu_catalogo.addMenuItem("Festivos","location='/festivos'");
  menu_catalogo.addMenuItem("Fondeos","location='/fondeos'");
  menu_catalogo.addMenuItem("Garantías","location='/garantias'");
  menu_catalogo.addMenuItem("Giros","location='/giros'");
  menu_catalogo.addMenuItem("Grupos","location='/grupos'");
  menu_catalogo.addMenuItem("Líneas","location='/lineas'");
  menu_catalogo.addMenuItem("Periodos","location='/periodos'");
  menu_catalogo.addMenuItem("Productos","location='/productos'");
  menu_catalogo.addMenuItem("Promotores","location='/promotors'");
  menu_catalogo.addMenuItem("Sucursales","location='/sucursals'");
  menu_catalogo.fontWeight="bold";
  menu_catalogo.hideOnMouseOut=true;
  menu_catalogo.bgColor='#555555';
  menu_catalogo.menuBorder=1;
  menu_catalogo.menuLiteBgColor='#FFFFFF';
  menu_catalogo.menuBorderBgColor='#777777';

  window.menu_operacion = new Menu("root",175,20,"Geneva, Arial, Helvetica, sans-serif",14,"#000000","#FFFFFF","#999999","#6699CC","left","middle",3,0,1000,-5,7,true,true,true,0,true,true);
  menu_operacion.addMenuItem("Aplicar&nbsp;Pagos","location='/creditos/movimiento_credito'");
  menu_operacion.addMenuItem("Alta&nbsp;Credito&nbsp;Individual","location='/creditos/new_individual'");
  menu_operacion.addMenuItem("Alta&nbsp;Credito&nbsp;Grupal","location='/creditos/new_grupal'");
  menu_operacion.addMenuItem("Listado&nbsp;de&nbsp;Créditos","location='#'");
  menu_operacion.addMenuItem("Pago&nbsp;Línea&nbsp;Fondeo","location='/pagoslineas/new'");
  menu_operacion.fontWeight="bold";
  menu_operacion.hideOnMouseOut=true;
  menu_operacion.bgColor='#555555';
  menu_operacion.menuBorder=1;
  menu_operacion.menuLiteBgColor='#FFFFFF';
  menu_operacion.menuBorderBgColor='#777777';

  window.menu_reporte = new Menu("root",240,20,"Geneva, Arial, Helvetica, sans-serif",14,"#000000","#FFFFFF","#999999","#6699CC","left","middle",3,0,1000,-5,7,true,true,true,0,true,true);
  menu_reporte.addMenuItem("Estado&nbsp;de&nbsp;Cuenta&nbsp;del&nbsp;Cliente","location='/creditos/busca_credito'");
  menu_reporte.addMenuItem("Pagos&nbsp;del&nbsp;día","location='/pagos/index'");
  menu_reporte.addMenuItem("Estado&nbsp;de&nbsp;cuenta&nbsp;línea&nbsp;fondeo","location='/lineas/estado_cuenta'");
  menu_reporte.fontWeight="bold";
  menu_reporte.hideOnMouseOut=true;
  menu_reporte.bgColor='#555555';
  menu_reporte.menuBorder=1;
  menu_reporte.menuLiteBgColor='#FFFFFF';
  menu_reporte.menuBorderBgColor='#777777';

  window.menu_administracion = new Menu("root",150,20,"Geneva, Arial, Helvetica, sans-serif",14,"#000000","#FFFFFF","#999999","#6699CC","left","middle",3,0,1000,-5,7,true,true,true,0,false,true);
  menu_administracion.addMenuItem("Usuarios","location='/administracion/usuarios'");
  menu_administracion.addMenuItem("Permisos","location='/administracion/permisos'");
  menu_administracion.fontWeight="bold";
  menu_administracion.hideOnMouseOut=true;
  menu_administracion.bgColor='#555555';
  menu_administracion.menuBorder=1;
  menu_administracion.menuLiteBgColor='#FFFFFF';
  menu_administracion.menuBorderBgColor='#777777';

menu_administracion.writeMenus();
} // fin menus -->