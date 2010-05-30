class AdministracionController < ApplicationController
 before_filter :permiso_requerido

  def index
    
  end

  #--- definicion de las acciones principales ----
  def usuarios
  end

  def permisos
  end

  def verifica_permisos
    @rol = Rol.find(params[:id])
    @usuarios = @rol.users
    @controladores = @rol.systables
  end

  #----- Este control pagina todos los usuarios que tienen acceso al sistema y le muestra opciones
  def verifica_usuarios
     @user_pages, @usuarios = paginate :users, :per_page => 10
     @rol = Rol.find(params[:id])
     @usuarios = @rol.users
  end

  def update_permisos
    @rol = Rol.find(params[:rol])
    @systable_list=[]
    @systables = @rol.systables
    #---- Creamos un arreglo de objetos tipo systable ----
    @lista = Systable.find(params[:rols][:systable_ids])
     Systable.destroy(@systables)
    params[:rols][:systable_ids].each do |id|
      #@tmp = Systable.find(:first, :conditions => ["rol_id = ? and controller = ?", params[:rol].to_i, Systable.find(id).controller ])
     # @systable_list << @tmp unless @tmp.nil?
     @tmp = Systable.find(id)
     @tmp2 = Systable.create(:controller=>@tmp.controller, :descripcion=> @tmp.descripcion)
     @rol.systables << @tmp2
     @rol.save!
    end
    #---- Iteramos sobre la lista total de systables del rol ---

#      Systable.destroy(@systables)
#      @lista.each do |systable|
#        @tmp = Systable.find(systable)
#        @rol.systables << @tmp
#        @rol.save!
#      end
    


  

#    if @systables.include?(Systable.find(:first, :conditions => ["rol_id = ? and controller = ?", params[:rol] ]))
#
#    include?()
#    #--- Iteracion por cada elemento seleccionado ---
#    params[:rols][:systable_ids].each do |id|
#        unless tiene_permiso?(Rol.find(params[:rol]), Systable.find(id).controller)
#        Systable.create(:controller => Systable.find(id).controller,
#                        :rol_id => params[:rol],
#                        :descripcion => Systable.find(id).descripcion)
#        else
#
#        end




    #--- Verificamos los que tiene en la BD y no estan en la lista ----

    
    flash[:notice] = "Permisos otorgados"
    redirect_to :action => "verifica_permisos", :id => Rol.find(params[:rol])
  end


end
