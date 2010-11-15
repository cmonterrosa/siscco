module Databases
  #---- Validaciones para realizar operaciones con la BD ------
   #--- Verificamos que el usuario tenga acceso a eliminar registro -----
      def inserta_credito(credito, tipo)
        begin
          #----- Creamos el numero de referencia automaticamente --------
          @c_concentradora= Linea.find(credito.linea).ctaliquidadora
           credito.num_referencia = genera_referencia_alfa(@c_concentradora.sucbancaria.num_sucursal, @c_concentradora.num_cta)
           if tipo == "GRUPAL"
             if credito.grupo.clientes.size >= 1 #-- aqui deberiamos de validar que sean 3
                 if credito.save!
                    #--- Guardamos el log ---
                    Log.create(:operacion => "INSERTAR",
                    :clase => credito.class.to_s,
                    :objeto_id => credito.id.to_i,
                    :user_id => session['user'].id)
                    return true
                 else
                   return false
                 end
                 
             else
               return false
             end
          else
            #--- Es individual ----
            if credito.save!
               Log.create(:operacion => "INSERTAR",
                    :clase => credito.class.to_s,
                    :objeto_id => credito.id.to_i,
                    :user_id => session['user'].id)
              return true
            end
        end
      rescue ActiveRecord::RecordInvalid => invalid
          return false
        end
      end

#--- Funciones de insercion de registros ------

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


  #----- esta funcion inserta y guarda un log por cada operacion -----
    def inserta_registro_log(registro, mensaje)
    begin
      if registro.save!
        #--- Guardamos el log ---
        Log.create(:operacion => "INSERTAR",
                   :clase => registro.class.to_s,
                   :objeto_id => registro.id.to_i,
                   :user_id => session['user'].id)
      end
        flash[:notice]=mensaje
        redirect_to :action => 'list', :controller => "#{params[:controller]}"
      rescue ActiveRecord::RecordInvalid => invalid
        flash[:notice] = invalid
        redirect_to :action => 'new', :controller => "#{params[:controller]}"
      end
    end



  def inserta_cliente(cliente, negocio, mensaje)
    begin
      negocio.cliente = cliente

#      cliente.grupos << grupo
#      @log = Clientegrupo.new
#      @log.cliente= cliente
#      @log.grupo = grupo
#      @log.save!

        if cliente.save && negocio.save
          cliente.generar_id!
          flash[:notice]=mensaje + "con el identificador = #{cliente.identificador}"
          redirect_to :action => 'list', :controller => "#{params[:controller]}"
        else
           flash[:notice]= "Alguno de los campos no esta formado correctamente, verifica rfc y curp"
           render :action => 'new', :controller => "#{params[:controller]}"
        end
      
    rescue ActiveRecord::RecordInvalid => invalid
      flash[:notice] = invalid
      redirect_to :action => 'new', :controller => "#{params[:controller]}"
    end
  end

  #------ Funciones de actualizacion de registros ------


  def actualiza_registro(registro, parametros)
    begin
      #registro.fecha_hora = Time.now
      #registro.user_id = session['user'].id
      registro.update_attributes(parametros)
      flash[:notice] = 'Registro actualizado satisfactoriamente'
      redirect_to :controller => params[:controller], :action => 'show', :id => registro
    rescue
      flash[:notice] = 'No se pudo actualizar verifique los datos'
      redirect_to :action => 'edit', :controller => params[:controller], :id=> registro
    end
  end


    #----- esta funcion inserta y guarda un log por cada operacion -----
    def actualiza_registro_log(registro, parametros)
    begin
      if registro.update_attributes(parametros)
        #--- Guardamos el log ---
        Log.create(:operacion => "ACTUALIZAR",
                   :clase => registro.class.to_s,
                   :objeto_id => registro.id.to_i,
                   :user_id => session['user'].id)
      end
        flash[:notice]='Registro actualizado satisfactoriamente'
        redirect_to :controller => params[:controller], :action => 'show', :id => registro
      rescue ActiveRecord::RecordInvalid => invalid
        flash[:notice] = invalid
        redirect_to :action => 'edit', :controller => params[:controller], :id=> registro
      end
    end




 def actualiza_cliente(cliente, parametros_cliente, negocio, parametros_negocio)
    begin
#      @grupo_viejo = Clientegrupo.find(:first, :conditions => ["cliente_id = ? and activo = 1",cliente.id])
      cliente.update_attributes!(parametros_cliente)
      #---- Comparamos si el registro qie se quiere actualizar difiere en el grupo ------
      negocio.update_attributes!(parametros_negocio)
      flash[:notice] = 'Registro actualizado satisfactoriamente'
      redirect_to :controller => params[:controller], :action => 'show', :id => cliente
    rescue
      flash[:notice] = 'No se pudo actualizar verifique los datos'
      redirect_to :action => 'edit', :controller => params[:controller], :id=> cliente
    end
  end

  def actualiza_configuracion(registro, parametros)
    begin
      registro.fecha_hora = Time.now
      registro.user_id = session['user'].id
      registro.update_attributes(parametros)
      flash[:notice] = 'Configuracion actualizada satisfactoriamente'
      redirect_to :controller => "administracion", :action => 'index'
    rescue
      flash[:notice] = 'No se pudo actualizar verifique los datos'
      redirect_to :action => 'configuracion', :controller => "administracion"
    end
  end




#---------- Funciones de eliminacion de registros------

  def eliminar_registro(registro, rol)
    #------Verifica que se pueda eliminar el registro -----
   #if Systable.find(:first, :conditions=>["rol_id = ? and eliminar=1 and controller=?", rol, params[:controller]])
      begin
        registro.destroy
        flash[:notice]="Registro eliminado"
        redirect_to :action => 'list', :controller => params[:controller]
      rescue
        flash[:notice]="No se pudo eliminar, puede que el registro tenga tablas asociadas"
        redirect_to :action => 'list', :controller => params[:controller]
      end
#    else
#     flash[:notice]="No tiene privilegios para eliminar el registro"
#     redirect_to :action => 'list', :controller => params[:controller]
#   end
 end

    def elimina_registro_log(registro, rol)
    begin
      @controller = Controller.find_by_controller(params[:controller])
      #if Systable.find(:first, :conditions=>["rol_id = ? and eliminar=1 and controller_id=?", rol, @controller.id])
        #--- Cambiamos el estatus ----
        registro.st = 0
        registro.save!
        #--- Guardamos el log ---
        Log.create(:operacion => "ELIMINAR",
                   :clase => registro.class.to_s,
                   :objeto_id => registro.id.to_i,
                   :user_id => session['user'].id)
        flash[:notice]="Registro eliminado"
        redirect_to :action => 'list', :controller => params[:controller]
#      else
#        flash[:notice]="No tiene privilegios para eliminar el registro"
#        redirect_to :action => 'list', :controller => params[:controller]
#      end

     rescue ActiveRecord::RecordInvalid => invalid
        flash[:notice] = invalid
        redirect_to :action => 'edit', :controller => params[:controller], :id=> registro
     end
    end
end