# ---- Personalizacion de la clase ----
class ActiveRecord::RecordInvalid
  def initialize(record)
      @record = record
      super("Verifique lo siguiente: #{@record.errors.full_messages.join(", ")}")
  end
end

class ApplicationController < ActionController::Base
  require 'date'
  # --- Plantilla por defecto ------
  layout 'contenido'
  # ---  Incluimos la libreria para el acceso ---
  include LoginSystem
  model :user
  #--- Incluimos la clase para generar los reportes ----
  helper :send_doc
  include SendDocHelper


  before_filter :configure_charsets

  #----------Variables para combos globales -----------
  $estados = Estado.find(:all, :order => "estado")
  $ejidos = Ejido.find(:all, :order => "ejido")
  $colonias = Colonia.find(:all, :order => "colonia")
  $municipios = Municipio.find(:all, :order => "municipio")
  $clientes = Cliente.find(:all, :order => "paterno, materno, nombre")
  $bancos = Banco.find(:all)
  $ejidos = Ejido.find(:all)
  $lineas = Linea.find(:all)
  $promotores = Promotor.find(:all, :order => "nombre")
  $destinos = Destino.find(:all)
  $grupos = Grupo.find(:all, :order => "nombre")
  $fondeos = Fondeo.find(:all, :order => "fuente")
  $periodos = Periodo.find(:all, :order => "dias")

  #--- combo de semanas, maximo 52 ----
  @semanas = []
  (1..52).each do |x| @semanas << x end
  $semanas = @semanas


    #----------- Cambio de idioma de las fechas --------------------
  Date::MONTHNAMES = [nil] + %w(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)
  Date::DAYNAMES = %w(Domingo Lunes Martes Miercoles Jueves Viernes Sábado)
  Date::ABBR_MONTHNAMES = [nil] + %w(ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic)
  Date::ABBR_DAYNAMES = %w(Dom Lun Mar Mie Jue Vie Sab)


  ##############################################################################
  # Métodos globales (pueden ser llamados desde cualquier controlador ---------#
  ##############################################################################
  #-- Configuracion de la codificacion --
  def configure_charsets
   headers["Content-Type"] = "text/html; charset=UTF-8"
  end

  #---- Validaciones para realizar operaciones con la BD ------
   #--- Verificamos que el usuario tenga acceso a eliminar registro -----
      def inserta_credito(credito)
        begin
          credito.save!
          return true
        rescue ActiveRecord::RecordInvalid => invalid
          return false
        end
      end




  def inserta_registro(registro, mensaje)
    begin
      registro.save!
        flash[:notice]=mensaje
        redirect_to :action => 'list', :controller => "#{params[:controller]}"
    rescue ActiveRecord::RecordInvalid => invalid
      flash[:notice] = invalid
      redirect_to :action => 'new', :controller => "#{params[:controller]}"
    end
  end

  def actualiza_registro(registro, parametros)
    begin
      registro.update_attributes(parametros)
      flash[:notice] = 'Registro actualizado satisfactoriamente'
      redirect_to :controller => params[:controller], :action => 'show', :id => registro
    rescue
      flash[:notice] = 'No se pudo actualizar verifique los datos'
      redirect_to :action => 'edit', :controller => params[:controller], :id=> registro
    end
  end


#  def eliminar_registro(registro)
#    #------Verifica que se pueda eliminar el registro -----
#   begin
#    registro.destroy
#      flash[:notice]="Registro eliminado"
#      redirect_to :action => 'list', :controller => "#{params[:controller]}"
#    rescue
#      flash[:notice]="No se pudo eliminar, puede que el registro tenga tablas asociadas"
#      redirect_to :action => 'list', :controller => "#{params[:controller]}"
#    end
#  end


  def eliminar_registro(registro, rol)
    #------Verifica que se pueda eliminar el registro -----
   if Systable.find(:first, :conditions=>["rol_id = ? and eliminar=1 and controller=?", rol, params[:controller]])
      begin
        registro.destroy
        flash[:notice]="Registro eliminado"
        redirect_to :action => 'list', :controller => params[:controller]
      rescue
        flash[:notice]="No se pudo eliminar, puede que el registro tenga tablas asociadas"
        redirect_to :action => 'list', :controller => params[:controller]
      end
    else
     flash[:notice]="No tiene privilegios para eliminar el registro"
     redirect_to :action => 'list', :controller => params[:controller]
   end
 end




  def rango_anios
    @arreglo=[]
    (4).times{|x| @arreglo << Time.now.year - x}
    return @arreglo.sort
  end

  def has_permission?(usuario)
    #--- primero verificamos que exista el usuario -----
    if User.exists?(:conditions => ["username = ?", usuario])
       return true
    else
       return false
    end
  end

  

      ###############################################
       #            Funciones del crédito            #
       ###############################################

  def abonos(credito)
    @pagos = Pago.find(:all,
                       :conditions=>["credito_id = ? AND pagado= 1", credito.id])
    sum=0
    @pagos.each do |pago|
      sum +=  pago.capital
    end
    return sum
  end

  def cargos(credito)
      @pagos = Pago.find(:all,
                       :conditions=>["credito_id = ? AND pagado= 1", credito.id])
    sum=0
    @pagos.each do |pago|
      sum +=  pago.interes
    end
    return sum

  end

  def total(credito)
    @total =  (credito.monto * (credito.tasa_interes / 100.0)) + credito.monto
    return @total - abonos(credito)
 end






  def pago_minimo(credito)
          #--- Verificamos si el credito ha sido cubierto ----
       @interes_moratorio = Configuracion.find(:first, :select=>"interes_moratorio").interes_moratorio.to_f / 100.0
       @proximo_pago= proximo_pago(credito)
       if Time.now.to_date <= @proximo_pago.fecha_limite
         return @proximo_pago.capital_minimo.to_f + @proximo_pago.interes_minimo.to_f
       else
         return ((@proximo_pago.capital_minimo.to_f + @proximo_pago.interes_minimo.to_f)*(@interes_moratorio)) + @proximo_pago.capital_minimo.to_f + @proximo_pago.interes_minimo.to_f
       end
  end






  def capital_minimo(credito)
      return credito.monto / @credito.num_pagos.to_f
  end

  def interes_minimo(credito)
          @monto = credito.monto
          @interes = credito.tasa_interes / 100.0
          return(@monto * @interes) / @credito.num_pagos
  end

  def proximo_pago(credito)
          @proximo = Pago.find(:first, :conditions=>["credito_id = ? AND
                                                   pagado=0", credito.id],
                                                   :order=>"fecha_limite")
          return @proximo
  end

  def ultimo_pago(anio, mes, dia, num_pagos, periodo)
        @dias = num_pagos.to_i * periodo.dias.to_i
           @f_ini = Date.new(y=anio.to_i,m=mes.to_i,d=dia.to_i)
           # --- Creamos un arreglo donde pondremos los pagos ---
           @pagos = []
           @fecha_preliminar = @f_ini
           (num_pagos.to_i).times{
           @fecha_preliminar = @fecha_preliminar + periodo.dias.to_i
           #---- Validamos si es inhabil o dia festivo -----
           if Festivo.find(:first, :conditions=>["fecha = ?", @fecha_preliminar.to_s]) || @fecha_preliminar.wday == 0
              if Festivo.find(:first, :conditions=>["fecha = ?", @fecha_preliminar.to_s]) && @fecha_preliminar.wday == 6
                 @fecha_preliminar += 2 #--- Es festivo y es sabado --
                 @pagos << @fecha_preliminar
              else
                 @fecha_preliminar += 1
                 @pagos << @fecha_preliminar
              end
           else
              @pagos << @fecha_preliminar
           end
           }
           return @pagos.last
  end

  def calcula_pagos(anio, mes, dia, num_pagos, periodo)
        @dias = num_pagos.to_i * periodo.dias.to_i
           @f_ini = Date.new(y=anio.to_i,m=mes.to_i,d=dia.to_i)
           # --- Creamos un arreglo donde pondremos los pagos ---
           @pagos = []
           @fecha_preliminar = @f_ini
           (num_pagos.to_i).times{
           @fecha_preliminar = @fecha_preliminar + periodo.dias.to_i
           #---- Validamos si es inhabil o dia festivo -----
           if Festivo.find(:first, :conditions=>["fecha = ?", @fecha_preliminar.to_s]) || @fecha_preliminar.wday == 0
              if Festivo.find(:first, :conditions=>["fecha = ?", @fecha_preliminar.to_s]) && @fecha_preliminar.wday == 6
                 @fecha_preliminar += 2 #--- Es festivo y es sabado --
                 @pagos << @fecha_preliminar
              else
                 @fecha_preliminar += 1
                 @pagos << @fecha_preliminar
              end
           else
              @pagos << @fecha_preliminar
           end
           }
           return @pagos
  end

  def inserta_pagos(credito, arreglo_pagos)
         if credito.pagos.size == 0
         contador=1
         #---- Esta funcion crea los registros en la tabla pagos para tener un historial ----
            arreglo_pagos.each do |x|
                   Pago.create(:num_pago => contador,
                             :credito_id => credito.id.to_i,
                             :fecha_limite => x,
                             :capital_minimo => capital_minimo(credito),
                             :interes_minimo => interes_minimo(credito),
                             :pagado => 0,
                             :descripcion => "Pago #{contador} de #{arreglo_pagos.size} capital minimo #{capital_minimo(credito)} ")
                 contador+=1
            end
         else
           return nil
         end
    end


    def tiene_permiso?(rol, controlador)
          @registro = Systable.find(:first, :conditions => ["rol_id = ? and controller = ? ", Rol.find(rol).id, controlador])
           if @registro.nil?
               false
           else
                true
           end
    end

        def tiene_permiso_accion?(rol, controlador,accion)
          @registro = Systable.find(:first, :conditions => ["rol_id = ? and controller = ? and #{accion} = 1", Rol.find(rol).id, controlador])
           if @registro.nil?
               false
           else
                true
           end
    end



        def linea_disponible(linea)
          if linea.creditos.empty?
            return linea.autorizado
          else
            return (linea.autorizado - Credito.sum(:monto, :conditions=>["linea_id = ?", linea.id])/1.0)
          end
        end


         def cargos?(pago, fecha)
           @pago= Pago.find(pago)
           @interes_moratorio = Configuracion.find(:first, :select=>"interes_moratorio").interes_moratorio.to_f / 100.0
           if @fecha <= @pago.fecha_limite
             return false
           else
             @pago.moratorio = (@pago.capital_minimo.to_f + @pago.interes_minimo.to_f)*(@interes_moratorio)
             @pago.save!
             return true
           end
         end





 # Scrub sensitive parameters from your log
   filter_parameter_logging :password
end
