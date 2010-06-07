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
#     @user_pages, @usuarios = paginate :users, :per_page => 10
    @usuarios = User.find(:all, :order => 'nombre')
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
    
    flash[:notice] = "Permisos otorgados"
    redirect_to :action => "verifica_permisos", :id => Rol.find(params[:rol])
  end


end
