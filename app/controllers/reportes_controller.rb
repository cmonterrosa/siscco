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
before_filter :login_required


     def nuevo_pagare
      #--- Llenamos los parametros -------
       if params[:id] && Credito.find(params[:id])
        @credito = Credito.find(:first, :conditions => ["id = ?", params[:id]])
        @credito ||= Credito.find(params[:id])
        #----- Parametros del credito -------
        param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
        param["P_TOTAL_DEUDA"]={:tipo=>"String", :valor=>"\$#{separar_miles(@credito.monto)} (#{@credito.monto.to_words})"}
        param["P_CREDITO_ID"]={:tipo=>"String", :valor=>@credito.id}
        param["P_TASA_ANUALIZADA"]={:tipo=>"String", :valor=>@credito.producto.tasa_anualizada}
        param["P_FECHA_STRING"]={:tipo=>"String", :valor=>DateTime.now.strftime("%d de %B de %Y")}
        param["P_PRESIDENTE"]={:tipo=>"String", :valor=>@credito.presidente.nombre_completo_desc}
        param["P_TOTAL_PAGOS"]={:tipo=>"String", :valor=> @credito.producto.num_pagos.to_s}
        param["P_TASA_MORATORIA_ANUAL"]={:tipo=>"String", :valor=> "141.2"}
          if File.exists?("#{RAILS_ROOT}/app/reports/pagare.jasper")
            send_doc_jdbc("pagare", "pagare",  param, output_type = 'pdf')
          else
            flash[:notice] = "No se encontro un credito válido"
            redirect_to :action => "menu"
          end
        else
         flash[:notice] = "No se pudo ejecutar el reporte"
         redirect_to :action => "menu"
        end
     end

      def lista_mensual_socias
      #--- Llenamos los parametros -------
       if params[:id] && Credito.find(params[:id])
        @credito = Credito.find(params[:id])
        #----- Parametros del credito -------
        param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
        param["P_MUNICIPIO"]={:tipo=>"String", :valor=>"#{@credito.grupo.clientegrupos[0].cliente.localidad.municipio.municipio}"}
        param["P_COLONIA"]={:tipo=>"String", :valor=>"#{@credito.grupo.clientes[0].colonia}"}
        param["P_GRUPO"]={:tipo=>"String", :valor=>"#{@credito.grupo.nombre}"}
        param["P_BANCO"]={:tipo=>"String", :valor=>"#{@credito.linea.ctaliquidadora.sucbancaria.banco.nombre}"}
        param["P_SUCURSAL"]={:tipo=>"String", :valor=>"#{@credito.linea.ctaliquidadora.sucbancaria.num_sucursal}"}
        param["P_CUENTA"]={:tipo=>"String", :valor=>"#{@credito.linea.ctaliquidadora.num_cta}"}
        param["P_REFERENCIA"]={:tipo=>"String", :valor=>"#{@credito.num_referencia}"}
        param["P_PROMOTOR"]={:tipo=>"String", :valor=>"#{@credito.promotor.nombre_completo_desc}"}
        #interes = (@credito.tipo_interes == "GLOBAL MENSUAL (FLAT)") ? @credito.producto.tasa_mensual_flat : @credito.producto.interes
        interes = (@credito.producto.tasa_mensual_ssg) ? (@credito.producto.tasa_mensual_ssg) : "5.81"
        param["P_INTERES"]={:tipo=>"String", :valor=>"#{interes}"}
        param["P_NUM_SOCIAS"]={:tipo=>"String", :valor=>"#{numero_clientes_grupo(@credito.grupo)}"}
        param["P_PLAZO_SEMANAS"]={:tipo=>"String", :valor=>"#{@credito.producto.num_pagos.to_s}"}
        param["P_FONDEO"]={:tipo=>"String", :valor=>@credito.linea.fondeo.acronimo}
        param["P_MESES"]={:tipo=>"String", :valor=>(@credito.producto.num_pagos.to_i / 4).to_s}
        param["P_PROPUESTA"]={:tipo=>"String", :valor=>(@credito.linea.gcnf).to_s}
        param["P_TASA_ANUALIZADA"]={:tipo=>"String", :valor=>@credito.producto.tasa_anualizada}
        param["P_GRUPO_ID"]={:tipo=>"String", :valor=>@credito.grupo.id}
          if File.exists?("#{RAILS_ROOT}/app/reports/lista_socias.jasper")
            send_doc_jdbc("lista_socias", "lista_socias",  param, output_type = 'pdf')
          else
            flash[:notice] = "No se encontro un credito válido"
            redirect_to :action => "menu"
          end
        else
         flash[:notice] = "No se pudo ejecutar el reporte"
         redirect_to :action => "menu"
        end
     end





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

    _pdf.text to_iso("(" + total_adeudado_por_persona(@credito).to_words.to_s + ")"), :font_size => 14, :justification => :center

    _pdf.move_pointer(15)
    @leyenda2=<<-EOS
    Mediante #{@credito.producto.num_pagos} Pagos #{@credito.producto.periodo.nombre}, pago por la cantidad de #{round(pago_minimo_informativo(@credito))} y pagandoce las amortizaciones con vencimientos consecutivos, mismas que se señalan de la siguiente manera:
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
                pagos << {"monto" => "$" + round(pago.capital_minimo.to_f + pago.interes_minimo.to_f).to_s,
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

    def default
      render  :controller =>"home"
    end

    def tarjeta_pagos
    #----- filtrado de registros unicos -----
    if params[:cliente][:id].size < 1
       flash[:notice] = "Seleccione un cliente valido"
       default
      # redirect_to :action => "menu", :controller=> "reportes", :id => params[:id]
    elsif params[:id].size < 1
        flash[:notice] = "No se puedo realizar la busqueda, verifique"
        default
      #  redirect_to :action => "index", :controller=> "home"
    end

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
    #--- Validamos que tenga asignada una sucursal bancaria ---
    if @credito.linea.ctaliquidadora.sucbancaria.banco
      _pdf.text to_iso("<b>Banco:</b> #{@credito.linea.ctaliquidadora.sucbancaria.banco.nombre}"), :font_size => 12, :justification => :left, :left => 10
    else
      _pdf.text to_iso("<b>Banco:</b>  - "), :font_size => 12, :justification => :left, :left => 10
    end
    _pdf.move_pointer(5)

    #----- Validamos que tenga asignada una cuenta ----
     if @credito.linea.ctaliquidadora
       _pdf.text to_iso("<b>Cuenta:</b> #{@credito.linea.ctaliquidadora.num_cta}"), :font_size => 12, :justification => :left, :left => 10
     else
       _pdf.text to_iso("<b>Cuenta:</b> - "), :font_size => 12, :justification => :left, :left => 10
     end
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
                          "capital" => round(pago.capital_minimo.to_f),
                          "interes" => round(pago.interes_minimo.to_f),
                          "total" => round(pago.capital_minimo.to_f + pago.interes_minimo.to_f).to_s,
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

    def control_pagos_socia
        if params[:id] && Credito.find(params[:id])
           @credito = Credito.find(params[:id])

         _pdf = PDF::Writer.new(:paper => "LETTER")
    _pdf.select_font "Times-Roman"
    _pdf.margins_cm(2,2,2,2)


    #--- Numeros de pagina ---
    _pdf.numeros_pagina(40, 25, 10, pos = nil, pattern = nil)


     #---- Datos generales -----
        _pdf.move_pointer(7)
        _pdf.text to_iso("<b>MUNICIPIO: #{municipio_grupo(@credito.grupo)}</b>"), :font_size => 10, :justification => :left
        _pdf.move_pointer(12)
        _pdf.text to_iso("<b>COLONIA: #{localidad_grupo(@credito.grupo)}</b>"), :font_size => 10, :justification => :left
        _pdf.move_pointer(12)
        _pdf.text to_iso("<b>GRUPO: #{@credito.grupo.nombre}</b>"), :font_size => 10, :justification => :left
        _pdf.move_pointer(12)

         #------ Detalle de pagos ----
        PDF::SimpleTable.new do |tab|
              tab.column_order.push(*%w(np nombre pago_1_parcial interes total firma))
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
                          "capital" => round(pago.capital_minimo.to_f),
                          "interes" => round(pago.interes_minimo.to_f),
                          "total" => round(pago.capital_minimo.to_f + pago.interes_minimo.to_f).to_s,
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


         send_data _pdf.render, :filename => "entrega_fondos_#{@credito.grupo.nombre.upcase}.pdf",
                               :type => "application/pdf"



        else
          flash[:notice] = "No se encontraron registros"
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

#        #------ Encabezado --------
#        _pdf.open_object do |heading|
#        _pdf.save_state
#        _pdf.stroke_color! Color::Black
#        _pdf.stroke_style! PDF::Writer::StrokeStyle::DEFAULT
#        #---- Imagen de la empresa ----
#        s= 8
#        t = to_iso(NOMBRE_EMPRESA)
#        w = _pdf.text_width(t, s) / 2.0
#        x = _pdf.margin_x_middle
#        y = _pdf.absolute_top_margin
#        _pdf.add_text(x - w, y, t, s)
#        #--- direccion de la empresa ---
#        t2 = to_iso(DIRECCION_EMPRESA + ", " + CIUDAD_EMPRESA)
#        w = _pdf.text_width(t2, s) / 2.0
#        x = _pdf.margin_x_middle - 12
#        y = _pdf.absolute_top_margin - 12
#        _pdf.add_text(x - w, y, t2, s)
#
#        x = _pdf.absolute_left_margin
#        w = _pdf.absolute_right_margin
#        y -= (_pdf.font_height(s) * 1.01)
#        _pdf.line(x, y, w, y).stroke
#        _pdf.restore_state
#        _pdf.close_object
#        _pdf.add_object(heading, :all_pages)
#        end

          #--- logos -----
        _pdf.move_pointer(-90)
        i0 = _pdf.image "#{RAILS_ROOT}/public/images/cresolido_logo.jpg", :resize => 0.95, :justification=>:center


         #---- TITULO -----
        _pdf.move_pointer(40)
        _pdf.text to_iso("<b>CARTA COMPROMISO DE PAGO</b>"), :font_size => 12, :justification => :right
        _pdf.move_pointer(45)


        #--- Cuerpo del texto ----
        leyenda=<<-EOS
          POR ESTE MEDIO NOS COMPROMETEMOS SOLIDARIAMENTE A PAGAR PUNTUALMENTE EL MICROFINANCIAMIENTO RECIBIDO DEL FOMMUR A TRAVEZ DE CRECIMIENTO SOLIDARIO PARA EL DESARROLLO ORGANIZADO S.A DE C.V. EN ABONOS SEMANALES DE <b>$#{separar_miles(@pago_minimo)} , (#{@pago_minimo.to_words.upcase}) </b> ASI MISMO NOS COMPROMETEMOS A AHORRAR EL IMPORTE MINIMO DE <b>$30.00 (TREINTA PESOS 00/100 M.N)</b> SEÑALADO EN NUESTRO REGLAMENTO INTERNO
        EOS
        leyenda2 = leyenda.split($/).join(" ").squeeze(" ")
        _pdf.text to_iso(leyenda2), :justification => :full, :font_size => 12, :left => 10, :right => 12


        #---- Lugar y Fecha ----
        _pdf.move_pointer(25)
        _pdf.text to_iso("TUXTLA GUTIERREZ, CHIAPAS A #{fecha_sistema.upcase}"), :font_size => 11, :justification => :right


        _pdf.move_pointer(30)
        _pdf.text to_iso("<b>GRUPO SOLIDARIO:</b> #{@credito.grupo.nombre.upcase}"), :font_size => 12, :justification => :center
        _pdf.move_pointer(4)
        _pdf.text to_iso("<b>REFERENCIA:</b> #{@credito.num_referencia}"), :font_size => 12, :justification => :center

        #--- Presidente ---
        _pdf.move_pointer(60)
        _pdf.text to_iso("<b>PRESIDENTE</b>"), :font_size => 11, :justification => :center
        _pdf.move_pointer(15)
        _pdf.text to_iso(@miembros["PRESIDENTE"]), :font_size => 12, :justification => :center

        #--- Secretario ---
        _pdf.move_pointer(50)
        _pdf.text to_iso("<b>                  SECRETARIO                                                                     TESORERO </b>"), :font_size => 11, :justification => :left, :left => 20
        _pdf.move_pointer(15)
        _pdf.text to_iso(@miembros["SECRETARIO"]), :font_size => 12, :justification => :left, :left => 20

        # ---- Tesorero ----
        _pdf.move_pointer(-14)
        _pdf.text to_iso(@miembros["TESORERO"]), :font_size => 12, :justification => :right, :right => 50


        #---- Pie de Pagina izquierda ---
        #--- Promotor nombre ---
         _pdf.move_pointer(40)
         _pdf.text to_iso("<b>PROMOTOR</b>: #{Promotor.find(@credito.promotor_id).nombre_completo_desc}"), :font_size => 8, :justificacion => :left

         #--- Plazo semanas ---
         _pdf.move_pointer(4)
         _pdf.text to_iso("<b>PLAZO SEMANAS</b>: #{@credito.producto.num_pagos.to_s}"), :font_size => 8, :justificacion => :left

         #--- Num socias ---
         _pdf.move_pointer(4)
         _pdf.text to_iso("<b>NÚMERO DE SOCIAS</b>: #{clientes_activos_grupo(@credito.grupo).size.to_s}"), :font_size => 8, :justificacion => :left
        
        
         #---- Fondeo ---
         _pdf.move_pointer(-38)
         _pdf.text to_iso("<b>FONDEO</b>: #{@credito.linea.fondeo.acronimo}"), :font_size => 8, :left => 220, :justificacion => :center

         #--- Meses ---
         _pdf.move_pointer(4)
         _pdf.text to_iso("<b>MESES</b>: #{(@credito.producto.num_pagos.to_i / 4).to_s}"), :font_size => 8, :left => 220, :justificacion => :center

         #--- Propuesta ---
         _pdf.move_pointer(4)
         _pdf.text to_iso("<b>PROPUESTA</b>: #{@credito.linea.gcnf}"), :left => 220, :font_size => 8, :justificacion => :center

         #--- Tasa anualizada --
        _pdf.move_pointer(4)
         _pdf.text to_iso("<b>TASA ANUALIZADA</b>: #{@credito.producto.tasa_anualizada} %"), :left => 220, :font_size => 8, :justificacion => :center




        send_data _pdf.render, :filename => "carta_compromiso_#{@credito.grupo.nombre.upcase}.pdf",
                               :type => "application/pdf"

   else
        flash[:notice] = "Imposible encontrar registros, verifique"
        redirect_to :action => "menu"
   end

 end
 
    #---- Recibo Entrega de Fondos ----
    def recibo_entrega_fondos
    if params[:id] && Credito.find(params[:id])
        @credito = Credito.find(:first, :conditions => ["id = ?", params[:id]])
        @miembros = {}
        @credito.miembros.each do |miembro|
          @miembros["#{miembro.jerarquia.jerarquia.upcase}"] = "#{miembro.cliente.nombre_completo.upcase}"
        end
        @pago_minimo = pago_minimo_informativo(@credito)
        _pdf = PDF::Writer.new(:paper => "LETTER")
        _pdf.select_font "Times-Roman"
        _pdf.margins_cm(2,2,2,2)

        #--- Numeros de pagina ---
        _pdf.numeros_pagina(40, 25, 10, pos = nil, pattern = nil)

        #--- logos -----
        _pdf.move_pointer(-90)
        i0 = _pdf.image "#{RAILS_ROOT}/public/images/cresolido_logo.jpg", :resize => 0.95, :justification=>:center


         #---- TITULO -----
        _pdf.move_pointer(15)
        _pdf.text to_iso("<b>RECIBO DE ENTREGA DE FONDOS</b>"), :font_size => 14, :justification => :center
        _pdf.move_pointer(10)

        #---- ASUNTO -----
        _pdf.move_pointer(15)
        _pdf.text to_iso("<b>RECIBO NUMERO: ________</b>"), :font_size => 10, :justification => :right

        #---- BUENO POR -----
        _pdf.move_pointer(15)
        _pdf.text to_iso("<b>BUENO POR: $#{separar_miles(@credito.monto)} </b>"), :font_size => 12, :justification => :right

         #--- Cuerpo del texto ----
        _pdf.move_pointer(20)

        leyenda=<<-EOS
RECIBI LA CANTIDAD DE $#{separar_miles(@credito.monto)}, (#{(@credito.monto.to_words).upcase}) QUE CORRESPONDE AL PRESTAMO DEL GRUPO SOLIDARIO #{@credito.grupo.nombre}, DE LA COMUNIDAD DE #{localidad_grupo(@credito.grupo).strip}, DEL MUNICIPIO DE #{municipio_grupo(@credito.grupo).strip}, DEL ESTADO DE CHIAPAS, PARA OPERAR EL CICLO _______________ DE ACUERDO A SU SOLICITUD DE PRESTAMO AUTORIZADO POR EL FOMMUR
EOS
        #---- Imprimos la leyenda 2 ---
        leyenda2 = leyenda.split($/).join(" ").squeeze(" ")
        _pdf.text to_iso(leyenda2), :justification => :full, :font_size => 12, :left => 10, :right => 12
        _pdf.move_pointer(10)

        #---- Lugar y Fecha ----
        _pdf.text to_iso("TUXTLA GUTIERREZ, CHIAPAS A #{fecha_sistema.upcase}"), :font_size => 11, :justification => :right

        #--- Recibimos de conformidad ---
        _pdf.move_pointer(35)
        _pdf.text to_iso("<b>RECIBIMOS DE CONFORMIDAD</b>"), :font_size => 10, :justification => :center


        #--- Grupo solidario ---
        _pdf.move_pointer(15)
        _pdf.text to_iso("<b>GRUPO SOLIDARIO:</b> #{@credito.grupo.nombre}"), :font_size => 10, :justificacion => :left
        _pdf.move_pointer(5)
        _pdf.text to_iso("<b>REFERENCIA:</b> #{@credito.num_referencia}"), :font_size => 10, :justificacion => :left

        #--- Presidente ---
        _pdf.move_pointer(55)
        _pdf.text to_iso("<b>PRESIDENTE</b>"), :font_size => 11, :justification => :center
        _pdf.move_pointer(15)
        _pdf.text to_iso(@miembros["PRESIDENTE"]), :font_size => 12, :justification => :center

        #--- Secretario ---
        _pdf.move_pointer(40)
        _pdf.text to_iso("<b>                SECRETARIO                                                                        TESORERO </b>"), :font_size => 11, :justification => :left, :left => 20
        _pdf.move_pointer(15)
        _pdf.text to_iso(@miembros["SECRETARIO"]), :font_size => 12, :justification => :left, :left => 20

         # ---- Tesorero ----
         _pdf.move_pointer(-14)
         _pdf.text to_iso(@miembros["TESORERO"]), :font_size => 12, :justification => :right, :right => 55

         #--- Promotor nombre ---
         _pdf.move_pointer(30)
         _pdf.text to_iso("<b>PROMOTOR</b>: #{Promotor.find(@credito.promotor_id).nombre_completo_desc}"), :font_size => 8, :justificacion => :center

         #--- Plazo semanas ---
         _pdf.move_pointer(5)
         _pdf.text to_iso("<b>PLAZO SEMANAS</b>: #{@credito.producto.num_pagos.to_s}"), :font_size => 8, :justificacion => :center

         #--- Num socias ---
         _pdf.move_pointer(5)
         _pdf.text to_iso("<b>NÚMERO DE SOCIAS</b>: #{clientes_activos_grupo(@credito.grupo).size.to_s}"), :font_size => 8, :justificacion => :center
        
         send_data _pdf.render, :filename => "entrega_fondos_#{@credito.grupo.nombre.upcase}.pdf",
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

    #-------EXPORTACION DE INFORMACION ----
    #----- Exportacion de los creditos ------
    def hoja_calculo
    @creditos = Credito.find(:all, :select => "c.num_referencia, c.monto, c.fecha_inicio, g.nombre as nombre_grupo, g.id as grupo_id, CONCAT(p.nombre,' ',p.paterno, ' ', p.materno) as nombre_promotor", :conditions => ["c.grupo_id=g.id and c.promotor_id = p.id"], :joins => "c, grupos g, promotors p")
      csv_string = FasterCSV.generate do |csv|
         csv << ["referencia", "municipio", "localidad", "nombre_grupo", "num_socias", "credito_otorgado", "nombre_promotor"]
         @creditos.each do |c|
         localidad, municipio = localidad_grupo(c.grupo), municipio_grupo(c.grupo)
             municipio = c.grupo.clientegrupos[0].cliente.localidad.municipio.municipio
             num_socias = numero_clientes_grupo(c.grupo)
             csv << [c.num_referencia, municipio, localidad, c.nombre_grupo, num_socias, c.monto, c.nombre_promotor]
         end
     end
    send_data csv_string, :type => "application/excel",
           :filename=>"exportacion_creditos.csv",
           :disposition => 'attachment'
  end
  
  def plantilla_clientes
    f_inicio = params[:fechac]["fecha_inicio_c(1i)"]+"-"+params[:fechac]["fecha_inicio_c(2i)"]+"-"+params[:fechac]["fecha_inicio_c(3i)"]
     f_fin = params[:fechac]["fecha_fin_c(1i)"]+"-"+params[:fechac]["fecha_fin_c(2i)"]+"-"+params[:fechac]["fecha_fin_c(3i)"]

    clientes = Cliente.find(:all,
                            :select => "cl.id, cl.identificador, cl.curp, cl.clave_ife, cl.paterno, cl.materno, cl.nombre, cl.fecha_nac, cl.sexo,
                                        cl.telefono, cl.direccion, cl.num_exterior, cl.num_interior, cl.colonia, cl.codigo_postal, cl.rol_hogar_id, esc.escolaridad, cl.civil_id, ac.actividad, ac.clave_inegi,
                                        cl.escolaridad_id, ne.ing_semanal, ne.num_empleados, ne.ubicacion_negocio_id, cl.localidad_id, mu.municipio, es.estado, fo.acronimo",
                            :joins => "cl, escolaridads esc, civils ci, localidads loc, municipios mu, estados es, negocios ne, actividads ac, clientes_grupos cg, grupos gr, creditos cr, lineas li, fondeos fo",
                            :conditions => ["cl.escolaridad_id = esc.id and cl.civil_id = ci.id and ne.actividad_id = ac.id and ne.cliente_id = cl.id and
                                            cl.localidad_id = loc.id and loc.municipio_id = mu.id and mu.estado_id = es.id and
                                            cl.id = cg.cliente_id and cg.grupo_id = gr.id and cr.grupo_id = gr.id and cr.linea_id = li.id and
                                            li.fondeo_id = fo.id and fo.acronimo = 'FOMMUR' and cr.fecha_inicio >= ? and cr.fecha_inicio <= ?", f_inicio, f_fin])

      csv_string = FasterCSV.generate do |csv|
                   csv << ["ORG_ID", "ACRED_ID", "CURP", "IFE", "PRIM_AP","SEGUNDO_AP", "NOMBRE", "FECHA_NAC", "SEXO",
                           "TEL", "CVE_EDO_CIVIL", "EDO_RES", "MUNICIPIO", "LOCALIDAD", "CALLE", "NUMERO_EXTERIOR", "NUMERO_INTERIOR", "COLONIA",
                           "CP", "METODOLOGIA", "NOM_GRUPO", "ESTUDIOS", "ACTIVIDAD", "FECHA_INICIO_ACT_PRODUCTIVA", "UBICACION_NEGOCIO", "PERSONAS_TRABAJANDO", "INGRESO_SEMANAL",
                           "ROL_EN_HOGAR", "SUCURSAL"]

        clientes.each do |c|
            cg = Clientegrupo.find(:first, :select=>"cliente_id, grupo_id", :conditions => ["cliente_id = ? and activo = 1", c.id ])
            if cg == nil || !cg.grupo
              grupo = ""
              modalidad = "INDIVIDUAL"
            else
              grupo = cg.grupo.nombre
              modalidad = "GRUPAL"
            end                                       
            credito = Credito.find(:first, 
                                   :select => "cr.id, cr.fecha_inicio",
                                   :joins => "cr, grupos gr, clientes_grupos cg",
                                   :conditions => ["cr.grupo_id = gr.id and gr.id = cg.grupo_id and cg.cliente_id = ?", c.id])
            if credito.nil?
              fecha_inicio = ""
            else
              fecha_inicio = credito.fecha_inicio
            end

            rol = RolHogar.find(:first, :select => "id, rol", :conditions => ["id = ?", c.rol_hogar_id])
            if rol.nil?
              rol_hogar = ""
            else
              rol_hogar = rol.rol
            end
            
#            negocio =  Negocio.find(:fisrt, :select => "id, negocio, ubicacion_negocio_id", :conditions => ["cliente_id = ?", c.id])
            ubicacion = UbicacionNegocio.find(:first, :select => "id, ubicacion", :conditions => ["id = ?", c.ubicacion_negocio_id])
            if ubicacion.nil?
              ubicacion_negocio = ""
            else
              ubicacion_negocio = ubicacion.ubicacion
            end

            csv << ["105", c.identificador, c.curp, c.clave_ife, c.paterno, c.materno, c.nombre, c.fecha_nac, c.sexo,
              c.telefono, c.civil.civil, c.estado, c.municipio, c.localidad.localidad, c.direccion, c.num_exterior, c.num_interior, c.colonia,
              c.codigo_postal, modalidad, grupo, c.escolaridad.escolaridad, c.clave_inegi, fecha_inicio, ubicacion_negocio, c.num_empleados,
                    c.ing_semanal, rol_hogar, SUCURSAL]
        end

      end

      send_data csv_string, :type => "application/excel",
                            :filename=>"plantilla_clientes.csv",
                            :disposition => 'attachment'
    end

   def plantilla_creditos
     f_inicio = params[:fechacr]["fecha_inicio_cr(1i)"]+"-"+params[:fechacr]["fecha_inicio_cr(2i)"]+"-"+params[:fechacr]["fecha_inicio_cr(3i)"]
     f_fin = params[:fechacr]["fecha_fin_cr(1i)"]+"-"+params[:fechacr]["fecha_fin_cr(2i)"]+"-"+params[:fechacr]["fecha_fin_cr(3i)"]
     creditos = Credito.find(:all, 
                             :select => "cr.id, cr.identificador, cr.grupo_id, cr.destino_id, cr.monto, cr.fecha_inicio, cr.fecha_fin, cr.producto_id, cr.tipo_interes,
                                         fo.acronimo",
                             :joins => "cr, lineas li, fondeos fo, grupos gr",
                             :conditions => ["cr.grupo_id = gr.id and cr.linea_id = li.id and li.fondeo_id = fo.id and fo.acronimo = 'FOMMUR' and cr.fecha_inicio >= ? and cr.fecha_inicio <= ?", f_inicio, f_fin])
     csv_string = FasterCSV.generate do |csv|
       csv << ["ORG_ID", "ACRED_ID", "CREDITO_ID", "DESCRIPCION", "MONTO_CREDITO", "FECHA_ENTREGA", "FECHA_VENCIMIENTO", "TASA_MENSUAL", "TIPO_TASA", "FRECUENCIA_PAGOS",
               "BLOQUE", "CICLO"]

       creditos.each do |cd|

         if cd.producto.tasa_anualizada
            tasa_mensual = cd.producto.tasa_anualizada.to_f / 12
         else
            tasa_mensual = ""
         end

         clientes = Cliente.find(:all, :select => "cl.id, cl.identificador",
                                       :joins => "cl, clientes_grupos cg",
                                       :conditions => ["cl.id = cg.cliente_id and cg.grupo_id = ?", cd.grupo_id])

         monto = cd.monto / clientes_activos_grupo(cd.grupo).size
#         credito_id = cd.id.to_s + rand(999).to_s.rjust(3, "0") #  credito_id se crea al vuelo por que solo se usa para layuot FOMMUR

         clientes.each do |c|
             #  credito_id se crea al vuelo por que solo se usa para layuot FOMMUR
            csv << ["105", c.identificador, cd.identificador, cd.destino.destino, monto, cd.fecha_inicio, cd.fecha_fin, tasa_mensual, cd.tipo_interes, cd.producto.num_pagos,
                    cd.producto.producto, cd.acronimo]
         end

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
   # fecha, tipo_poliza, num_poliza, cta, naturaleza, importe, descripcion, identificador
     polizas = Poliza.find(:all)
     csv_string = FasterCSV.generate do |csv|
         csv << ["FECHA", "TIPO_POLIZA", "NUM_POLIZA", "CTA", "NATURALEZA", "IMPORTE", "DESCRIPCION", "IDENTIFICADOR"]
       polizas.each do |c|
         csv << [c.fecha, c.tipo_poliza, c.num_poliza, c.cta, c.naturaleza, c.importe, c.descripcion, c.identificador]
       end
     end
        send_data csv_string, type => "text/plain",
       :filename => "polizas.csv",
       :disposition => "attachment"
   end

   def vencimientos
     @creditos = Credito.find(:all, :conditions => "status = 0")
     
   end

   def layout_fommur

   end

   def layout_burocredito
     reporte = Buro.new
     reporte.calcular
     send_data reporte.s_total, type => "text/plain",
       :filename => "layoutburo.txt",
       :disposition => "attachment"

   end

   
   #---- Buro de crédito
   #--- calculamos
   def index_buro
     
   end


   #--- Mostramos URL ----
   def buro
     @inicio = Time.now
     @reporte = Buro.new
     @reporte.calcular
     @nombre_archivo = (rand(10)).to_s + Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
     f = File.new("#{RAILS_ROOT}/public/data/#{@nombre_archivo}.txt",  "w+")
     f.puts(@reporte.s_total)
     @fin = Time.now
     @minutos = (@fin - @inicio) / 60.0
     render :layout => false
   end

   #--- Descargamos archivo -----
   def download_buro
      @archivo = params[:file]
      send_file "#{RAILS_ROOT}/public/data/#{@archivo}.txt", :type=>"application/txt"
   end

   def reporte_general_grupos
       creditos = Credito.find(:all, :select => "c.id, c.grupo_id, c.fecha_inicio, c.fecha_fin, c.linea_id, c.producto_id, c.monto, c.num_referencia, c.tipo_interes, p.num_pagos",
         :joins => "c, grupos gr, productos p",
         :conditions => ["c.producto_id=p.id AND c.grupo_id = gr.id AND c.grupo_id is not null"])



       csv_string = FasterCSV.generate do |csv|
       csv << ["REFERENCIA", "GRUPO", "FECHA_ENTREGA", "FECHA_VENCIMIENTO", "PROPUESTA", "CICLO", "MUNICIPIO", "LOCALIDAD", "PRESIDENTA", "SECRETARIA", "TESORERA", "MONTO", "SEMANAS", "RECUPERADO", "VENCIDO", "NUM_SOCIAS"]
       creditos.each do |c|
         clientes = Credito.find_by_sql("
              select loc.localidad, mun.municipio, CONCAT(cl.paterno, ' ', cl.materno, ' ', cl.nombre) as nombre_completo, c.monto, jer.jerarquia  from creditos c
              inner join
                clientes_grupos cg on
                c.grupo_id = cg.grupo_id
              inner join
                clientes cl on
                cg.cliente_id = cl.id
              inner join
                miembros mi on
                mi.cliente_id = cl.id
              inner join
                jerarquias jer on
                mi.jerarquia_id=jer.id
              inner join
                localidads loc on
                cl.localidad_id = loc.id
              inner join
                municipios mun on
                loc.municipio_id=mun.id
              where c.id = #{c.id} and jer.jerarquia in ('secretario', 'tesorero', 'presidente')
              order by jer.id")
        v= Vencimiento.new(c)
        v.procesar
        if clientes.size > 2
         csv << [c.num_referencia, c.grupo.nombre, c.fecha_inicio, c.fecha_fin, c.linea.cuenta_cheques, c.producto.producto,  clientes[0]["municipio"], clientes[0]["localidad"],  clientes[0]["nombre_completo"], clientes[1]["nombre_completo"], clientes[2]["nombre_completo"], c.monto, c.num_pagos,v.total_recuperado,v.total_deuda, v.numero_clientes]
        end
      end
     end
        send_data csv_string, type => "text/plain",
       :filename => "reporte_general_grupos_#{Time.now.strftime("%d-%m-%Y")}.csv",
       :disposition => "attachment"
     
   end

   def nxporclts
     query="select '105', cl.identificador, cl.curp, cl.clave_ife, cl.paterno, cl.materno, cl.nombre, cl.fecha_nac,
       cl.sexo, cl.telefono, cl.civil_id, ci.civil, cl.localidad_id, loc.localidad, loc.municipio_id, mu.municipio,
       mu.estado_id, es.estado, cl.direccion, cl.num_exterior, cl.num_interior, cl.colonia,
       cl.codigo_postal
from clientes as cl
inner join civils ci on cl.civil_id = ci.id
inner join localidads loc on cl.localidad_id = loc.id
inner join municipios mu on loc.municipio_id = mu.id
inner join estados es on mu.estado_id = es.id"

        csv_string = FasterCSV.generate do |csv|
        csv << ["ORG_ID", "ACRED_ID", "CURP", "IFE", "PRIM_AP","SEGUNDO_AP", "NOMBRE", "FECHA_NAC", "SEXO",
                           "TEL", "CVE_EDO_CIVIL", "EDO_RES", "MUNICIPIO", "LOCALIDAD", "CALLE", "NUMERO_EXTERIOR", "NUMERO_INTERIOR", "COLONIA",
                           "CP"]
        clientes = Cliente.find_by_sql(query)
        clientes.each do |c|
        csv << ["105", c.identificador, c.curp, c.clave_ife, c.paterno, c.materno, c.nombre, c.fecha_nac, c.sexo,
              c.telefono, c.civil.civil, c.estado, c.municipio, c.localidad.localidad, c.direccion, c.num_exterior, c.num_interior, c.colonia,
              c.codigo_postal]
         end
       end
        send_data csv_string, type => "text/plain",
       :filename => "reporte_gclientes_#{Time.now.strftime("%d-%m-%Y")}.csv",
       :disposition => "attachment"
    end

   def export_grupos_propuestas
     csv=Hash.new
     query="select (select count(id) from clientes_grupos where grupo_id = g.id)
     as num_socias, c.num_referencia, g.nombre, l.gcnf as propuesta, c.fecha_captura from grupos g
     inner join creditos c on g.id=c.grupo_id
     inner join lineas l on c.linea_id=l.id order by g.nombre, l.gcnf"
     csv_string = FasterCSV.generate do |csv|
     csv << ["REFERENCIA", "NOMBRE_GRUPO", "CICLO_PROPUESTA", "NUM_SOCIAS", "FECHA_CAPTURA"]
     end
     #REFERENCIA, NOMBRE_GRUPO, CICLO_PROPUESTA, NUM_SOCIAS
     grupos = Grupo.find_by_sql(query)
     grupos.each do |g|
       csv << [g.num_referencia, g.nombre, g.propuesta, g.num_socias, g.fecha_captura]
     end
     send_data csv_string, type => "text/plain",
       :filename => "reporte_grupos_propuestas_#{Time.now.strftime("%d-%m-%Y")}.csv",
       :disposition => "attachment"
     
   end

   def export_all_grupos
   csv=Hash.new
  query="select g.nombre, l.gcnf as propuesta, c.num_referencia from grupos g left outer join creditos c on g.id=c.grupo_id
left outer join lineas l on c.linea_id=l.id order by g.nombre, l.gcnf"
   csv_string = FasterCSV.generate do |csv|
     csv << ["REFERENCIA", "NOMBRE_GRUPO", "CICLO_PROPUESTA"]
     end
     #REFERENCIA, NOMBRE_GRUPO, CICLO_PROPUESTA
     grupos = Grupo.find_by_sql(query)
     grupos.each do |g|
       csv << [g.num_referencia, g.nombre, g.propuesta]
     end
     send_data csv_string, type => "text/plain",
       :filename => "reporte_todos_grupos_#{Time.now.strftime("%d-%m-%Y")}.csv",
       :disposition => "attachment"
   end

end
