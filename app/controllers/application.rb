# ---- Personalizacion de la clase ----
class ActiveRecord::RecordInvalid


  def initialize(record)
      @record = record
      super("Verifique lo siguiente: #{@record.errors.full_messages.join(", ")}")
  end

end

class ApplicationController < ActionController::Base
  
  # --- Plantilla por defecto ------
  layout 'logged'

  # ---  Incluimos la libreria para el acceso ---
  include LoginSystem
  model :user
  before_filter :configure_charsets


  #-- Variables para combos globales ---
  $estados = Estado.find(:all, :order => "estado")
  $clientes = Cliente.find(:all, :order => "paterno, materno, nombre")

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


  def eliminar_registro(registro)
    #------Verifica que se pueda eliminar el registro -----
   begin
      registro.destroy
      flash[:notice]="Registro eliminado"
      redirect_to :action => 'list', :controller => "#{params[:controller]}"
    rescue
      flash[:notice]="No se pudo eliminar, puede que el registro tenga tablas asociadas"
      redirect_to :action => 'list', :controller => "#{params[:controller]}"
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


  def cargos(credito)
    @arreglo = []
    @movimientos = credito.movimientos
    if @movimientos.empty?
      #el cliente no ha realizado ningun pago
        return false
    else

    @movimientos.each { | movimiento|
              unless movimiento.cargo.nil?
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
              unless movimiento.abono.nil?
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
        return ( credito.importe * credito.tasa_interes / 100 ) + credito.importe

    else

    @movimientos.each { | movimiento|
      unless movimiento.cargo.nil?
          @cargos = movimiento.cargo += @cargos
      end

      unless movimiento.abono.nil?
          @abonos = movimiento.abono += @abonos
      end

    }
      return (credito.importe * (credito.tasa_interes / 100 ) + credito.importe ) + @cargos - @abonos
  end
end



  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
