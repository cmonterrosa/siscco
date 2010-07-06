require "pdf/writer"
require 'pdf/simpletable'
require 'date'
require 'iconv'


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
    @credito = Credito.find(:first, :conditions => ["id = ?", 1])
    @pagos =Pago.find(:all, :group => "num_pago",  :conditions=>["credito_id = ?", @credito.id])

    _pdf = PDF::Writer.new(:paper => "LETTER")
    _pdf.select_font "Times-Roman"
    _pdf.margins_cm(2,2,2,2)
    #--- Numeros de pagina ---
    _pdf.numeros_pagina(40, 25, 10, pos = nil, pattern = nil)
    #--- logos -----
    _pdf.move_pointer(-80)
    i0 = _pdf.image "#{RAILS_ROOT}/public/images/SOCAMA.png", :resize => 0.45, :justification=>:left

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
    _pdf.text to_iso(total_adeudado_por_persona(@credito).to_s), :font_size => 14, :justification => :center
    _pdf.move_pointer(10)
    _pdf.text to_iso(total_adeudado_por_persona(@credito).to_f.to_words), :font_size => 14, :justification => :center

    _pdf.move_pointer(15)
    @leyenda2=<<-EOS
    Mediante #{@credito.num_pagos} Pagos #{@credito.periodo.nombre}, pago por la cantidad de #{pago_minimo_informativo(@credito)} y pagandoce las amortizaciones con vencimientos consecutivos, mismas que se señalan de la siguiente manera:
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
    @cliente = Cliente.find(:first, :conditions => ["id = ?", 1])
    @credito = Credito.find(:first, :conditions => ["id = ?", 1])
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
       _pdf.add_object(heading, :all_pages)
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
    _pdf.text to_iso("<b>Plazo: </b> #{@credito.num_pagos}"), :font_size => 12, :justification => :left, :left => 10
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

        def jasper
       param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
       param["PDIRECCION"]={:tipo=>"String", :valor=>"DIRECCION DE INFORMATICA"}
       param["PDEPARTAMENTO"]={:tipo=>"String", :valor=>"DEPARTAMENTO DE BASE DE DATOS"}


       send_doc_xml(xml,
       '/records/record',
      'directorio',
      'Directorio',
       param,
      'pdf')
    end



end
