#---------- Librerias que se cargan para poder utilizar las funciones globales------------
require "pdf/writer"
require 'pdf/simpletable'
require 'date'
require 'iconv'


class InformacionController < ApplicationController
  before_filter :login_required
#  before_filter :permiso_requerido

  def index
  end

  def pdf
    pdf_report(Credito.find(params[:id]))
  end


  def busca_credito
  @user = User.find(:first, :conditions => ["login = ?", session['usuario']])
  unless @user.grupo.descripcion == "administradores"
    redirect_to :action =>"historia_cliente"
  end
end

  def busca_credito_cliente
  @user = User.find(:first, :conditions => ["login = ?", session['usuario']])
  @cliente = @user.clientes[0]
  @creditos = @cliente.creditos
  end


  def historia_cliente
    @user = User.find(:first, :conditions => ["login = ?", session['usuario']])
  @cliente = @user.clientes[0] if @user
  @creditos = @cliente.creditos if @cliente

  end



    def historia #--- este metodos trae todos los creditos del cliente
    if params["credito"]["id"]=~/\d+/
      @credito_unico = Credito.find(params["credito"]["id"].to_i)
    end

    if params["credito"]["rfc"]=~/([a-z]|[A-Z])+/
      @cliente = Cliente.find(:first, :conditions => ["rfc = ? ", params["credito"]["rfc"]]) if params["credito"]["rfc"]
      @creditos = @cliente.creditos
    end
end

  #----- Este metodo es el que va a traer el historico de los creditos ---
  def consulta
   @credito = Credito.find(params[:id]) unless params[:id].nil?
   @movimientos= @credito.movimientos
  end



  def to_iso(texto)
  c = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
  iso = c.iconv(texto)
  return iso
end


#--------------- Método que genera un reporte de la plantilla del personal cam/escuelas regulares ------
# --- recibe como parámetro el id de la escuela ---------
def pdf_report(credito)

          pdf=PDF::Writer.new(:paper => "LETTER", :orientation => :vertical)
          pdf.select_font("Helvetica")
          #-------------- Formato de Fecha  -------------------
          @fecha=Time.now

          pdf.image "#{RAILS_ROOT}/public/images/financiera.jpg", :resize => 0.55, :justification => :right
          pdf.move_pointer(10)
          pdf.text("<b>Cliente:</b> #{credito.cliente.nombre_completo}")
          pdf.text("<b>Numero de credito</b>: #{credito.id}")
          pdf.text("<b>RFC:</b> #{credito.cliente.rfc}")
          pdf.text("<b>Fecha de inicio: #{credito.fecha_inicio} </b> ")
          pdf.text("<b>Fecha de inicio: #{credito.fecha_fin} </b> ")
          pdf.text("<b>Monto inicial: #{credito.monto} </b> ")
          pdf.text("<b>Tasa de interes: #{credito.tasa_interes} </b> ")

          meses= %w{enero febrero marzo abril mayo junio julio agosto septiembre octubre noviembre diciembre}
          #------ Fecha ----------
          pdf.text("<i>#{@fecha.day} de #{meses[@fecha.month-1]} de #{@fecha.year}</i>", :left => 595, :font_size => 12)

          #----------- Números de Pagina ------------
          #pdf.numeros_pagina(40, 25, 10, pos = nil, pattern = nil)

          #-------------- Creamos la tabla ---------------------
          #--- Por cada categoria vamos a crear una tabla -----------
          @abonos, @cargos = 0,0
          data=[]
          data_c=[]

           #---------- buscamos a los docentes de esa escuela----------
          #pdf.text(to_iso("<b>FINANCIERA INDEPENDENCIA</b>"), :justification => :center, :font_size => 12)
          pdf.text(to_iso("<b>ESTADO DE CUENTA</b>"), :justification => :center, :font_size => 16)
          pdf.move_pointer(15)
          pdf.text("Detalle de Movimientos", :justification => :center, :font_size => 14)
          pdf.move_pointer(10)
          #------Abonos -----
          pdf.text("<i>Abonos</i>", :justification => :center, :font_size => 13)
             pdf.move_pointer(10)
          PDF::SimpleTable.new do |tab|
              tab.column_order.push(*%w(fecha monto))
              tab.font_size=10
              tab.heading_font_size=10
              tab.bold_headings = true
              tab.show_headings = true
              tab.width=300
              tab.show_lines =:all

              #----------------- Columnas --------------------
              tab.columns["fecha"] = PDF::SimpleTable::Column.new("fecha") { |col|  col.width=150 }
              tab.columns["monto"] = PDF::SimpleTable::Column.new('monto') { |col|   col.width=150  }
              #tab.show_lines    = :false
              #tab.orientation   = :center
              tab.position      = :center

    if abonos(credito)
    
           abonos(credito).each do |abono|
                data << {"fecha" => abono.fecha_pago,
                          "monto" =>  abono.monto
                        }
                        @abonos = abono.monto += @abonos
                end
    
    end




              data << {"fecha" => "<b>TOTAL</b>", "monto" => "<b>#{@abonos}</b>"}
              #tab.shade_color = Color::RGB::White
              tab.data.replace data
              tab.render_on(pdf)
          end

  # ------ Cargos -----------
   pdf.move_pointer(18)
     pdf.text("<i>Cargos</i>", :justification => :center, :font_size => 13)
        pdf.move_pointer(10)
          PDF::SimpleTable.new do |tab|
              tab.column_order.push(*%w(fecha monto))
              tab.font_size=10
              tab.heading_font_size=10
              tab.bold_headings = true
              tab.show_headings = true
              tab.width=300
              tab.show_lines =:all

              #----------------- Columnas --------------------
              tab.columns["fecha"] = PDF::SimpleTable::Column.new("fecha") { |col|  col.width=150 }
              tab.columns["monto"] = PDF::SimpleTable::Column.new('monto') { |col|   col.width=150  }
              #tab.show_lines    = :false
              #tab.orientation   = :center
              tab.position      = :center


    if cargos(credito)
       cargos(credito).each do |cargo|
                data_c << {"fecha" => cargo.fecha_pago,
                          "monto" =>  cargo.monto
                        }
                        @cargos = cargo.monto += @cargos
                end


    end
              
           

              data_c << {"fecha" => "<b>TOTAL</b>", "monto" => "<b>#{@cargos}</b>"}

              #tab.shade_color = Color::RGB::White
              tab.data.replace data_c
              tab.render_on(pdf)
          end


    # ----- Detalle de movimientos -----
    pdf.move_pointer(10)

  pdf.text("<b>Total final : #{liquido(credito)}</b>", :justification => :center, :font_size => 13)

   

        #--- Envio del archivo al cliente-----
        send_data pdf.render, :filename => "edo-cuenta_#{credito.id}.pdf",
                              :type => "application/pdf"
      
  end






end # final de la clase
