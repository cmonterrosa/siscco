require "pdf/writer"
require 'pdf/simpletable'
require 'date'
require 'iconv'
require 'fastercsv'


#---- Modificamos la clase PDF_Writer
class PDF::Writer
# ----- Método
def numeros_pagina(x, y, size, pos = nil, pattern = nil)
     pos     ||= :left
     pattern ||= "<PAGENUM> de <TOTALPAGENUM>"
     starting  ||= 1
     @page_numbering ||= []
     @page_numbering << (o = {})

     page    = @pageset.size - 1
     o[page] = {
       :x        => x,
       :y        => y,
       :pos      => pos,
       :pattern  => pattern,
       :starting => starting,
       :size     => size,
       :start    => true
     }
     @page_numbering.index(o)
   end
end




class ReportesController < ApplicationController

    def pagare
    #----- filtrado de registros unicos -----
    @credito = Credito.find(:first, :conditions => ["id = ?", params[:id]])
    @pagos =Pago.find(:all, :group => "num_pago",  :conditions=>["credito_id = ?", @credito.id])
    

    _pdf = PDF::Writer.new(:paper => "LETTER")
    _pdf.select_font "Times-Roman"
    _pdf.margins_cm(2,2,2,2)
    #--- Numeros de pagina ---
    _pdf.numeros_pagina(40, 25, 10, pos = nil, pattern = nil)
    #--- logos -----
    _pdf.move_pointer(-80)
    #i0 = _pdf.image "#{RAILS_ROOT}/public/images/cresolido_marca.png", :resize => 0.45, :justification=>:left

    #---- TITULO -----
    _pdf.move_pointer(-10)
    _pdf.text to_iso("<b>PAGARÉ</b>"), :font_size => 14, :justification => :center
    _pdf.move_pointer(15)

    #--- Formamos la Leyenda 
    @leyenda=<<-EOS
    Debemos y pagaremos incondicionalmente por este Pagaré a la Orden de #{NOMBRE_EMPRESA}, con domicilio en la #{DIRECCION_EMPRESA}, de la Ciudad #{CIUDAD_EMPRESA}.
    EOS
    #---- Imprimos la leyenda ---
    leyenda = @leyenda.split($/).join(" ").squeeze(" ")
    _pdf.text to_iso(leyenda), :justification => :full, :font_size => 12, :left => 10, :right => 10
    _pdf.move_pointer(15)
    _pdf.text to_iso("La suma de"), :font_size => 14, :justification => :center
    _pdf.move_pointer(10)
    _pdf.text to_iso("$" + total_adeudado_por_persona(@credito).to_s), :font_size => 14, :justification => :center
    _pdf.move_pointer(10)

    _pdf.text to_iso("$" + total_adeudado_por_persona(@credito).to_words.to_s), :font_size => 14, :justification => :center

    _pdf.move_pointer(15)
    @leyenda2=<<-EOS
    Mediante #{@credito.producto.num_pagos} Pagos #{@credito.producto.periodo.nombre}, pago por la cantidad de #{pago_minimo_informativo(@credito)} y pagandoce las amortizaciones con vencimientos consecutivos, mismas que se señalan de la siguiente manera:
    EOS

      #---- Imprimos la leyenda 2 ---
    leyenda2 = @leyenda2.split($/).join(" ").squeeze(" ")
    _pdf.text to_iso(leyenda2), :justification => :full, :font_size => 12, :left => 10, :right => 10
    _pdf.move_pointer(15)

    #--- detalle de los pagos ----
    pagos=[]
    PDF::SimpleTable.new do |tab|
              tab.column_order.push(*%w(monto fecha))
              tab.font_size=9
              tab.heading_font_size=9
              tab.bold_headings = true
              tab.show_headings = true
              tab.width=350
              tab.show_lines =:all

              #----------------- Columnas --------------------
              tab.columns["monto"] = PDF::SimpleTable::Column.new("CANTIDAD A PAGAR") { |col|  col.width=150 }
              tab.columns["fecha"] = PDF::SimpleTable::Column.new('FECHA DE VENCIMIENTO') { |col|   col.width=200  }
              tab.show_lines    = :false
              #tab.orientation   = :center
              tab.position      = :center
              @pagos.each do |pago|
                pagos << {"monto" => (pago.capital_minimo.to_f + pago.interes_minimo.to_f).to_s,
                          "fecha" => pago.fecha_limite.strftime("%d de %B de %Y")}
                end
              tab.data.replace pagos
              tab.render_on(_pdf)
              end
     @cuerpo=<<-EOS
     Valor recibido a nuestra entera satisfacción. En caso de que las "DEUDORAS" dejen de pagar puntualmente cualquier suma que estuvieren obligadas a cumplir conforme a este pagaré, la cantidad no pagada causará intereses moratorios, en términos del artículo 362 del Código de Comercio en vigor, a partir de la fecha en que debió ser cubierto el pago omitido, hasta la fecha de su pago total, cuya tasa será del 4.5%, sobre saldos insolutos, hasta su liquidación absoluta. En relación a lo anterior, la falta de pago oportuno de cualquier exhibición, de acuerdo a las amortizaciones señaladas y sus vencimientos, producirá el vencimiento anticipado de este Título de Crédito denominado "PAGARÉ", por lo que #{NOMBRE_EMPRESA}, podrá exigir el saldo total adeudado más sus accesorios
     EOS

      _pdf.move_pointer(15)
         #---- Imprimos el cuerpo del mensaje ---
      cuerpo = @cuerpo.split($/).join(" ").squeeze(" ")
      _pdf.text to_iso(cuerpo), :justification => :full, :font_size => 12, :left => 10, :right => 10
      _pdf.move_pointer(15)

      @cuerpo2=<<-EOS
      El crédito principal, y los intereses moratorios que se llegaren a generar en su caso, estipulados en este pagaré serán pagaderos en Pesos Mexicanos.
      EOS

      cuerpo2 = @cuerpo2.split($/).join(" ").squeeze(" ")
      _pdf.text to_iso(cuerpo2), :justification => :full, :font_size => 12, :left => 10, :right => 10
      _pdf.move_pointer(15)

      @cuerpo3=<<-EOS
      En lo relativo a la interpretación, cumplimiento o requerimiento judicial de las obligaciones contraídas en este pagaré, las "DEUDORAS", se someten expresamente a la Jurisdicción de los Tribunales competentes en la Ciudad de #{CIUDAD_EMPRESA}, o a lo determinado por #{NOMBRE_EMPRESA}, renunciando por lo tanto, al fuero de cualquier otro domicilio. En caso de litigio para obtener el pago de la suma principal amparada por este pagaré e intereses devengados en su caso, las "DEUDORAS" convienen en cubrir la cantidad adicional por concepto de gastos y honorarios legales que los Tribunales Judiciales determinen razonablemente.
      EOS

      cuerpo3 = @cuerpo3.split($/).join(" ").squeeze(" ")
      _pdf.text to_iso(cuerpo3), :justification => :full, :font_size => 12, :left => 10, :right => 10
      _pdf.move_pointer(15)

      #------------ Firmas de cada uno de los integrantes del grupo -----------

      firmas=[]
      contador=1
      PDF::SimpleTable.new do |tab|
              tab.column_order.push(*%w(nombre firma asuruego))
              tab.font_size=13
              tab.heading_font_size=9
              tab.bold_headings = true
              tab.show_headings = true
              tab.width=550
              tab.show_lines =:all

              #----------------- Columnas --------------------
              tab.columns["np"] = PDF::SimpleTable::Column.new("NP") { |col|  col.width=50 }
              tab.columns["nombre"] = PDF::SimpleTable::Column.new("nombre") { |col|  col.width=200 }
              tab.columns["firma"] = PDF::SimpleTable::Column.new('firma') { |col|   col.width=150  }
              tab.columns["asuruego"] = PDF::SimpleTable::Column.new('a su ruego') { |col|   col.width=150  }
              tab.show_lines    = :false
              #tab.orientation   = :center
              tab.position      = :center
              @credito.grupo.clientes.each do |cliente|
                firmas << { "np" => contador,
                          "nombre" => cliente.nombre_completo,
                          "firma"    => "____________________",
                          "asuruego" => "____________________"
                          }
                #---- Metemos un espacio en blanco
                 firmas << { "np" => "",
                          "nombre" => "",
                          "firma"    => "",
                          "asuruego" => ""
                          }
                          contador+=1
                end
              tab.shade_color = Color::RGB::White
              tab.data.replace firmas
              tab.render_on(_pdf)
              end

      send_data _pdf.render, :filename => "pagare.pdf",
                             :type => "application/pdf"
      end


    def tarjeta_pagos
    #----- filtrado de registros unicos -----
    @cliente = Cliente.find(:first, :conditions => ["id = ?", params[:cliente][:id]])
    @credito = Credito.find(:first, :conditions => ["id = ?", params[:id]])
    @pagos =Pago.find(:all, :conditions=>["credito_id = ? and cliente_id = ?", @credito.id, @cliente.id])
    @sum_intereses = Pago.sum(:interes_minimo, :conditions=>["credito_id = ? and cliente_id = ?", @credito.id, @cliente.id])
    @sum_capital = Pago.sum(:capital_minimo, :conditions=>["credito_id = ? and cliente_id = ?", @credito.id, @cliente.id])

    _pdf = PDF::Writer.new(:paper => "LETTER")
    _pdf.select_font "Times-Roman"
    _pdf.margins_cm(2,2,2,2)
    

    #--- Numeros de pagina ---
    _pdf.numeros_pagina(40, 25, 10, pos = nil, pattern = nil)

     
    #------ Encabezado --------
     _pdf.open_object do |heading|
       _pdf.save_state
       _pdf.stroke_color! Color::Black
       _pdf.stroke_style! PDF::Writer::StrokeStyle::DEFAULT
       #---- Imagen de la empresa ----
       s= 8
       t = to_iso(NOMBRE_EMPRESA)
       w = _pdf.text_width(t, s) / 2.0
       x = _pdf.margin_x_middle
       y = _pdf.absolute_top_margin
       _pdf.add_text(x - w, y, t, s)
       #--- direccion de la empresa ---
        t2 = to_iso(DIRECCION_EMPRESA + ", " + CIUDAD_EMPRESA)
        w = _pdf.text_width(t2, s) / 2.0
        x = _pdf.margin_x_middle - 12
        y = _pdf.absolute_top_margin - 12
        _pdf.add_text(x - w, y, t2, s)

       x = _pdf.absolute_left_margin
       w = _pdf.absolute_right_margin
       y -= (_pdf.font_height(s) * 1.01)
       _pdf.line(x, y, w, y).stroke
       _pdf.restore_state
       _pdf.close_object
       _pdf.add_object(heading, :this_page)
       end

    #--- logos -----
    #_pdf.move_pointer(-80)
    #i0 = _pdf.image "#{RAILS_ROOT}/public/images/SOCAMA.png", :resize => 0.45, :justification=>:left

    #---- TITULO -----
    _pdf.move_pointer(40)
    _pdf.text to_iso("<b>TARJETA DE PAGOS</b>"), :font_size => 14, :justification => :center
    _pdf.move_pointer(15)

    #---- Datos del crédito ----
    _pdf.text to_iso("<b>Banco:</b> #{@credito.banco.nombre}"), :font_size => 12, :justification => :left, :left => 10
    _pdf.move_pointer(5)
    _pdf.text to_iso("<b>Cuenta:</b> #{@credito.banco.num_cuenta}"), :font_size => 12, :justification => :left, :left => 10
    _pdf.move_pointer(5)
    _pdf.text to_iso("<b>Contrato: </b> _________"), :font_size => 12, :justification => :left, :left => 10
    _pdf.move_pointer(5)
    _pdf.text to_iso("<b>Grupo: </b>#{@credito.grupo.nombre}"), :font_size => 12, :justification => :left, :left => 10
    _pdf.move_pointer(5)
    _pdf.text to_iso("<b>Plazo: </b> #{@credito.producto.num_pagos}"), :font_size => 12, :justification => :left, :left => 10
    _pdf.move_pointer(5)
    _pdf.text to_iso("<b>Adeudo: </b> $ #{total_adeudado_por_persona(@credito)}"), :font_size => 12, :justification => :left, :left => 10
    _pdf.move_pointer(5)
    _pdf.text to_iso("<b>interes: </b> $ #{@sum_intereses}"), :font_size => 12, :justification => :left, :left => 10
    _pdf.move_pointer(5)
    _pdf.text to_iso("<b>Nombre: </b> #{@cliente.nombre_completo}"), :font_size => 12, :justification => :left, :left => 10
    _pdf.move_pointer(20)

    
    #--- detalle de los pagos ----
    pagos=[]
    contador=1
    PDF::SimpleTable.new do |tab|
              tab.column_order.push(*%w(np fecha capital interes total firma))
              tab.font_size=10
              tab.heading_font_size=9
              tab.bold_headings = true
              tab.show_headings = true
              tab.width=460
              tab.show_lines =:all

              #----------------- Columnas --------------------
              tab.columns["np"] = PDF::SimpleTable::Column.new("PAGO") { |col|  col.width=40 }
              tab.columns["fecha"] = PDF::SimpleTable::Column.new('FECHA') { |col|   col.width=75  }
              tab.columns["capital"] = PDF::SimpleTable::Column.new('CAPITAL') { |col|   col.width=75  }
              tab.columns["interes"] = PDF::SimpleTable::Column.new('INTERES') { |col|   col.width=75  }
              tab.columns["total"] = PDF::SimpleTable::Column.new('TOTAL') { |col|   col.width=75  }
              tab.columns["firma"] = PDF::SimpleTable::Column.new('FIRMA') { |col|   col.width=120  }
              tab.show_lines    = :false
              #tab.orientation   = :center
              tab.position      = :center
              @pagos.each do |pago|
                pagos << {"np" => contador,
                          "fecha" => pago.fecha_limite.strftime("%d/%m/%Y"),
                          "capital" => pago.capital_minimo,
                          "interes" => pago.interes_minimo,
                          "total" => (pago.capital_minimo.to_f + pago.interes_minimo.to_f).to_s,
                          "firma" => "_____________________"
                          }
                # => --------        Agregamos un espacio en blanco ----
                pagos << {"np" => "",
                          "fecha" => "",
                          "capital" => "",
                          "interes" => "",
                          "total" => "",
                          "firma" => ""
                          }
             
                contador+=1
                end

                #---- Agregamos los totales -----
                pagos << {"np" => "",
                          "fecha" => "",
                          "capital" => @sum_capital,
                          "interes" => @sum_intereses,
                          "total" => (@sum_capital.to_f + @sum_intereses.to_f).to_s
                          }
               tab.shade_color = Color::RGB::White
              tab.data.replace pagos
              tab.render_on(_pdf)
              end
     

      send_data _pdf.render, :filename => "tarjeta_pagos_#{@cliente.rfc}.pdf",
                             :type => "application/pdf"




    end

    def reglamento

      
      
    end


    def xml
      render :text =>  Grupo.find(5).clientes.to_xml
    end


    def menu
      @credito = Credito.find(params[:id])
    end




    def acta
      #--- Llenamos los parametros -------
       if params[:id] && Credito.find(params[:id])
        @credito = Credito.find(params[:id])
        @xml = clientes_activos_grupo(@credito.grupo).to_xml
        #----- Parametros del credito -------
        param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
        param["EMPRESA"]={:tipo=>"String", :valor=>NOMBRE_EMPRESA}
        param["FINANCIAMIENTO"]={:tipo=>"String", :valor=>@credito.producto.producto}
        param["CIUDAD"]={:tipo=>"String", :valor=>CIUDAD_EMPRESA}
        param["FINANCIAMIENTO"]={:tipo=>"String", :valor=>DateTime.now.strftime("%d de %B de %Y")}
        param["GRUPO"]={:tipo=>"String", :valor=>@credito.grupo.nombre}
        param["ABONO"]={:tipo=>"String", :valor=>pago_minimo_informativo(@credito)}
        param["ABONOLETRA"]={:tipo=>"String", :valor=> pago_minimo_informativo(@credito).to_words}
        param["FONDEO"]={:tipo=>"String", :valor=>@credito.linea.fondeo.fuente}
        param["AHORRO"]={:tipo=>"String", :valor=>@credito.producto.ahorro}
        param["AHORROLETRA"]={:tipo=>"String", :valor=>@credito.producto.ahorro.to_words}
        #---- Jerarquias -------
        @credito.miembros.each do |miembro|
          param["#{miembro.jerarquia.jerarquia.upcase}"] = {:tipo => "String", :valor => "#{miembro.cliente.nombre_completo.upcase}"}
        end
        #param["PRESIDENTE"]={:tipo=>"String", :valor=>"CARLOS AUGUSTO MONTERROSA LOPEZ"}
        #param["TESORERO"]={:tipo=>"String", :valor=>"JUAN IGNACIO MORENO SUAREZ"}
        #param["SECRETARIO"]={:tipo=>"String", :valor=>"HILDA CACERES RUIZ"}
        send_doc_xml(@xml,
        '/clientes/cliente',
        'acta',
        'acta',
        param,
        'pdf')
       else
          flash[:notice] = "No se encontro un credito válido"
          redirect_to :action => "menu"
       end
    end


    #-- carta compromiso ----


    def carta_compromiso
    if params[:id] && Credito.find(params[:id])
        @credito = Credito.find(:first, :conditions => ["id = ?", params[:id]])
        @empresa = NOMBRE_EMPRESA
        @miembros = {}
        @credito.miembros.each do |miembro|
          @miembros["#{miembro.jerarquia.jerarquia.upcase}"] = "#{miembro.cliente.nombre_completo.upcase}"
        end
        @ahorro = @credito.producto.ahorro
        @pago_minimo = pago_minimo_informativo(@credito)
        _pdf = PDF::Writer.new(:paper => "LETTER")
        _pdf.select_font "Times-Roman"
        _pdf.margins_cm(2,2,2,2)

        #--- Numeros de pagina ---
        _pdf.numeros_pagina(40, 25, 10, pos = nil, pattern = nil)

        #------ Encabezado --------
        _pdf.open_object do |heading|
        _pdf.save_state
        _pdf.stroke_color! Color::Black
        _pdf.stroke_style! PDF::Writer::StrokeStyle::DEFAULT
        #---- Imagen de la empresa ----
        s= 8
        t = to_iso(NOMBRE_EMPRESA)
        w = _pdf.text_width(t, s) / 2.0
        x = _pdf.margin_x_middle
        y = _pdf.absolute_top_margin
        _pdf.add_text(x - w, y, t, s)
        #--- direccion de la empresa ---
        t2 = to_iso(DIRECCION_EMPRESA + ", " + CIUDAD_EMPRESA)
        w = _pdf.text_width(t2, s) / 2.0
        x = _pdf.margin_x_middle - 12
        y = _pdf.absolute_top_margin - 12
        _pdf.add_text(x - w, y, t2, s)

        x = _pdf.absolute_left_margin
        w = _pdf.absolute_right_margin
        y -= (_pdf.font_height(s) * 1.01)
        _pdf.line(x, y, w, y).stroke
        _pdf.restore_state
        _pdf.close_object
        _pdf.add_object(heading, :all_pages)
        end

        #--- logos -----
        #_pdf.move_pointer(-80)
        #i0 = _pdf.image "#{RAILS_ROOT}/public/images/SOCAMA.png", :resize => 0.45, :justification=>:left

        #---- TITULO -----
        _pdf.move_pointer(60)
        _pdf.text to_iso("<b>CARTA COMPROMISO</b>"), :font_size => 14, :justification => :center
        _pdf.move_pointer(15)

        #--- Cuerpo del texto ----
        leyenda=<<-EOS
          POR ESTE MEDIO NOS COMPROMETEMOS SOLIDARIAMENTE A PAGAR PUNTUALMENTE EL MICROFINANCIAMIENTO RECIBIDO DEL FOMMUR A TRAVEZ DE #{@empresa}, EN ABONOS SEMANALES DE $#{@pago_minimo} , (#{@pago_minimo.to_words}) ASI MISMO NOS COMPROMETEMOS A AHORRAR EL IMPORTE MINIMO DE #{@ahorro} (#{@ahorro.to_words}) SEÑALADO EN NUESTRO REGLAMENTO INTERNO
        EOS
        #---- Imprimos la leyenda 2 ---
        leyenda2 = leyenda.split($/).join(" ").squeeze(" ")
        _pdf.text to_iso(leyenda2), :justification => :full, :font_size => 12, :left => 10, :right => 12
        _pdf.move_pointer(15)
        _pdf.text to_iso("<b>GRUPO SOLIDARIO:</b> #{@credito.grupo.nombre.upcase}"), :font_size => 14, :justification => :center

        #--- Presidente ---
        _pdf.move_pointer(70)
        _pdf.text to_iso("<b>PRESIDENTE</b>"), :font_size => 11, :justification => :center
        _pdf.move_pointer(15)
        _pdf.text to_iso(@miembros["PRESIDENTE"]), :font_size => 12, :justification => :center

        #--- Secretario ---
        _pdf.move_pointer(40)
        _pdf.text to_iso("<b>SECRETARIO                                                                     TESORERO </b>"), :font_size => 11, :justification => :left, :left => 20
        _pdf.move_pointer(15)
        _pdf.text to_iso(@miembros["SECRETARIO"]), :font_size => 12, :justification => :left, :left => 20

        # ---- Tesorero ----
        _pdf.move_pointer(-14)
        _pdf.text to_iso(@miembros["TESORERO"]), :font_size => 12, :justification => :right, :right => 50


        send_data _pdf.render, :filename => "carta_compromiso_#{@credito.grupo.nombre.upcase}.pdf",
                               :type => "application/pdf"

   else
        flash[:notice] = "Imposible encontrar registros, verifique"
        redirect_to :action => "menu"
   end

 end

 


    def promotors_xml
      @promotors = Promotor.find(:all, :select => "c.*",
                                 :joins => "p inner join creditos c on c.promotor_id = p.id")
                               render :xml => @promotors.to_xml
    end


  
   def plantilla_clientes
      clientes = Cliente.find(:all)
      csv_string = FasterCSV.generate do |csv|
            csv << ["ORG_ID", "ACRED_ID", "CURP", "IFE", "PRIM_AP","SEGUNDO_AP", "NOMBRE", "FECHA_NAC", "EDO_NAC", "SEXO",
                    "TEL", "FAX", "CORREO_ELEC", "NACIONALIDAD_ORIGEN", "CVE_EDO_CIVIL", "FECHA_NAC_TXT", "EDO_RES", "MUNICIPIO", "LOCALIDAD", "DIRECCION",
                    "COLONIA", "CP", "METODOLOGIA", "NOM_GRUPO", "ESTUDIOS", "ACTIVIDAD", "INGRESO_SEMANAL", "SUCURSAL"]
            clientes.each do |c|
              csv << [" ", " ", c.curp, c.clave_ife, c.paterno, c.materno, c.nombre, c.fecha_nac,  c.localidad.municipio.estado.edo_inegi, c.sexo,
                      c.telefono, c.fax, c.email, c.nacionalidad.pais_agent, c.civil.civil, " ", c.edo_residencia, c.localidad.municipio.clave_inegi, c.localidad.loc_id, c.direccion,  
                      c.colonia, c.codigo_postal, " ", " ", c.escolaridad, c.negocio.actividad.clave_inegi, c.negocio.ing_semanal, " "]
            end
          end
          send_data csv_string, :type => "text/plain",
           :filename=>"entries.csv",
           :disposition => 'attachment'
   end

   def plantilla_creditos
     creditos = Credito.find(:all)
     csv_string = FasterCSV.generate do |csv|
       csv << ["ORG_ID", "ACRED_ID", "CRÉDITO_ID", "DESCRIPCIÓN", "MONTO_CRÉDITO", "FECHA_ENTREGA", "FECHA_VENCIMIENTO", "TASA_MENSUAL", "TIPO_TASA", "FRECUENCIA_PAGOS",
               "TIPO_CREDITO", "BLOQUE", "CICLO"]
       creditos.each do |c|
         csv << [" ", " ", c.id, c.destino.destino, c.monto, c.fecha_inicio, c.fecha_fin, "tasa_mensual", "tipo_tasa", c.producto.num_pagos,
                 "Tipo_Crédito", "Bloque", "Ciclo"]
       end
     end
     send_data csv_string, type => "text/plain",
       :filename => "creditos.csv",
       :disposition => "attachment"
   end

   def exportacion_cuentas
     cuentas = Cuenta.find(:all)
     csv_string = FasterCSV.generate do |csv|
       csv << ["NUM_CUENTA", "DESCRIPCION"]
       cuentas.each do |c|
         csv << [c.sCtaNum, c.sNombre]
       end
     end
        send_data csv_string, type => "text/plain",
       :filename => "cuentas.csv",
       :disposition => "attachment"
   end


      def exportacion_polizas
        string = ""
        polizas = Poliza.find(:all)
        polizas.each do |p|
        string <<  p.iEjer.to_s.rjust(4) #1 -4
        string <<  p.iMes.to_s.rjust(2) # 5-6
        string <<  p.sTpPol.to_s.rjust(2) #7-9
        string <<  p.sTpPolNum.to_s.rjust(6) #10-15
        string <<  p.sTpPolmov.to_s.rjust(6) #10-15
     end
#
#         t.column :iEjer, :integer
#      t.column :iMes, :integer
#      t.column :sTpPol, :string, :limit => 3
#      t.column :sPolNum, :string, :limit => 6
#      t.column :sPolMov, :string, :limit => 6
#      t.column :iDia, :integer
#      t.column :iNatura, :integer
#      t.column :rImpMov, :real
#      t.column :sCvIVA, :string, :limit => 1
#      t.column :iAplica, :integer
#      t.column :sCnc, :string, :limit => 3
#      t.column :sRefere, :string,:limit => 8
#      t.column :sClvCnc, :string, :limit => 3
#      t.column :sNatMov, :string, :limit => 1
#      t.column :rImpMovRS, :real
#      t.column :sCtaNom, :string, :limit => 30
#
#
#












        send_data string, type => "text/plain",
        :filename => "cuentas.txt",
        :disposition => "attachment"
      end


end
