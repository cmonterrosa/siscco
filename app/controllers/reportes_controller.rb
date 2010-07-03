require "pdf/writer"
require 'pdf/simpletable'
require 'date'
require 'iconv'

class ReportesController < ApplicationController

 

    def pagare
    #----- filtrado de registros unicos -----
    @pagos =Pago.find(:all, :group => "num_pago",  :conditions=>["credito_id = ?", 1])

    _pdf = PDF::Writer.new(:paper => "LETTER")
    _pdf.select_font "Times-Roman"
    _pdf.margins_cm(2,2,2,2)
       #--- logos -----
          #i0 = _pdf.image "#{RAILS_ROOT}/public/images/chiapas.png", :resize => 0.45, :justification=>:left
          #_pdf.move_pointer(-60)
          #i1 = _pdf.image "#{RAILS_ROOT}/public/images/hechos.png", :resize => 0.30, :justification=>:right
          #---- Titulo ----
          _pdf.move_pointer(-80)

          _pdf.text to_iso("<b>PAGARE</b>"), :font_size => 14, :justification => :center
#          _pdf.text to_iso("Coordinación General de Administración Federalizada"), :font_size => 12, :justification => :center
#          _pdf.text to_iso("Dirección de Administración de Personal"), :font_size => 12, :justification => :center
#          _pdf.text to_iso("Departamento de Servicios al Personal"), :font_size => 12, :justification => :center
#          _pdf.move_pointer(14)
#          _pdf.text to_iso("<b>Solicitud de cambio de adscripción 2010 - 2011</b>"), :font_size => 11, :justification => :center
#          _pdf.move_pointer(6)
#          _pdf.text "Folio: #{@folio}", :font_size => 11, :left => 395
#          _pdf.move_pointer(5)
#          _pdf.text "Fecha #{Time.now.strftime("%d/%m/%Y")}", :font_size => 11, :left => 395
          _pdf.move_pointer(15)

    #--- Formamos la Leyenda 
    @leyenda=<<-EOS
    Debemos y pagaremos incondicionalmente por este Pagaré a la Orden de SOCAMA CENTRO FRAYLESCA, A.C.., con domicilio en la 13a Avenida Sur Poniente Número 640, Barrio San Francisco, de la Ciudad Tuxtla Gutiérrez, Chiapas.
    EOS
    #---- Imprimos la leyenda ---
    leyenda = @leyenda.split($/).join(" ").squeeze(" ")
    _pdf.text to_iso(leyenda), :justification => :full, :font_size => 12, :left => 10, :right => 10
    _pdf.move_pointer(15)

      _pdf.text to_iso("La suma de"), :font_size => 14, :justification => :center
      _pdf.move_pointer(10)
      _pdf.text to_iso("$244,554"), :font_size => 14, :justification => :center
      _pdf.move_pointer(10)
      _pdf.text to_iso(244554.to_words), :font_size => 14, :justification => :center

    _pdf.move_pointer(15)
    @leyenda2=<<-EOS
    Mediante 24 Pagos Semanales, pago por la cantidad de $1,179.96 y pagandoce las amortizaciones con vencimientos consecutivos, mismas que se señalan de la siguiente manera:
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
                pagos << {"monto" => pago.capital_minimo + pago.interes_minimo,
                          "fecha" => pago.fecha_limite}
                end

              #tab.shade_color = Color::RGB::White
              tab.data.replace pagos
              tab.render_on(_pdf)
     end

      @cuerpo=<<-EOS
   Valor recibido a nuestra entera satisfacción. En caso de que las "DEUDORAS" dejen de pagar puntualmente cualquier suma que estuvieren obligadas a cumplir conforme a este pagaré, la cantidad no pagada causará intereses moratorios, en términos del artículo 362 del Código de Comercio en vigor, a partir de la fecha en que debió ser cubierto el pago omitido, hasta la fecha de su pago total, cuya tasa será del 4.5%, sobre saldos insolutos, hasta su liquidación absoluta. En relación a lo anterior, la falta de pago oportuno de cualquier exhibición, de acuerdo a las amortizaciones señaladas y sus vencimientos, producirá el vencimiento anticipado de este Título de Crédito denominado "PAGARÉ", por lo que SOCAMA CENTRO FRAYLESCA, A.C.., podrá exigir el saldo total adeudado más sus accesorios
El crédito principal, y los intereses moratorios que se llegaren a generar en su caso, estipulados en este pagaré serán pagaderos en Pesos Mexicanos.
En lo relativo a la interpretación, cumplimiento o requerimiento judicial de las obligaciones contraídas en este pagaré, las "DEUDORAS", se someten expresamente a la Jurisdicción de los Tribunales competentes en la Ciudad de Tuxtla Gutiérrez, Chiapas, o a lo determinado por SOCAMA CENTRO FRAYLESCA, A.C.., renunciando por lo tanto, al fuero de cualquier otro domicilio. En caso de litigio para obtener el pago de la suma principal amparada por este pagaré e intereses devengados en su caso, las "DEUDORAS" convienen en cubrir la cantidad adicional por concepto de gastos y honorarios legales que los Tribunales Judiciales determinen razonablemente.
    EOS

       _pdf.move_pointer(15)
         #---- Imprimos el cuerpo del mensaje ---
    cuerpo = @cuerpo.split($/).join(" ").squeeze(" ")
    _pdf.text to_iso(cuerpo), :justification => :full, :font_size => 12, :left => 10, :right => 10
    _pdf.move_pointer(15)
    _pdf.text to_iso("<b>Aqui van las firmas...</b>"), :font_size => 14, :justification => :center

    send_data _pdf.render, :filename => "pagare.pdf",
                           :type => "application/pdf"
    end


    def tabla_pagos

    end

    def reglamento
      
    end



end
