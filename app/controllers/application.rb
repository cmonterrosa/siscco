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
     




  def inserta_registro(registro, mensaje)
    begin
      registro.save!
        flash[:notice]=mensaje
        redirect_to :action => 'list', :controller => "#{params[:controller]}"
    rescue ActiveRecord::RecordInvalid => invalid
      #invalid.gsub!(/Validation/, 'Validacion')
      #invalid.gsub!(/failed/, 'Incorrecta')
      flash[:notice] = invalid

      #rescue Exception => e
      #flash[:notice]="No se pudo insertar, Verifique los campos"
      #flash[:notice]= e.message
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


    def eliminar_registro(registro, rol, controller)
    #------Verifica que se pueda eliminar el registro -----
   if Systable.find(:first, :conditions=>["rol_id = ? and delete=1 and controller=?", rol, controller])
      begin
        registro.destroy
        flash[:notice]="Registro eliminado"
        redirect_to :action => 'list', :controller => "#{params[:controller]}"
      rescue
        flash[:notice]="No se pudo eliminar, puede que el registro tenga tablas asociadas"
        redirect_to :action => 'list', :controller => "#{params[:controller]}"
      end
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

       #---- Funciones del crédito -----
  def cargos(credito)
    @arreglo = []
    @movimientos = credito.movimientos
    if @movimientos.empty?
      #el cliente no ha realizado ningun pago
        return false
    else

    @movimientos.each { | movimiento|
              if movimiento.tipo=="C"
                     @arreglo << movimiento
              end
     }
     return @arreglo
     end
  end

  def abonos(credito)
    @arreglo = []
    @movimientos = credito.movimientos
    if @movimientos.empty?
      #el cliente no ha realizado ningun pago
        return false
    else

    @movimientos.each { | movimiento|
              if movimiento.tipo =="A"
                     @arreglo << movimiento
              end
     }
     return @arreglo
     end
  end


  def liquido(credito)
    @abonos = 0
    @cargos = 0
    @movimientos = credito.movimientos
    if @movimientos.empty?
      #el cliente no ha realizado ningun pago
        return ( credito.monto * credito.tasa_interes / 100 ) + credito.monto

    else

    @movimientos.each { | movimiento|
      if movimiento.tipo=="C"
          @cargos = movimiento.capital += @cargos
      end

      if movimiento.tipo=="A"
          @abonos = movimiento.capital += @abonos
      end

     }
      return (credito.monto * (credito.tasa_interes / 100 ) + credito.monto ) + @cargos - @abonos
    end
  end

  def pago_minimo(credito)
          #--- Verificamos si el credito ha sido cubierto ----
          @monto = credito.monto
          @interes = credito.tasa_interes / 100.0
          return((@monto * @interes) + @monto) / @credito.num_pagos
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
          return @proximo.fecha_limite
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

 # Scrub sensitive parameters from your log
   filter_parameter_logging :password
end
