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
    @controllers = Controller.find(:all, :order => "controller")
  end

  #----- Este control pagina todos los usuarios que tienen acceso al sistema y le muestra opciones
  def verifica_usuarios
#     @user_pages, @usuarios = paginate :users, :per_page => 10
    @usuarios = User.find(:all, :order => 'nombre')
    @rol = Rol.find(params[:id])
     @usuarios = @rol.users
  end


   def update_permisos
   asigna_permisos(Rol.find(params[:rol]), params[:rols][:systable_ids], params[:rols][:insertar], params[:rols][:actualizar], params[:rols][:eliminar])
#    @controllers = Controller.find(params[:rols][:systable_ids])
#    @rol = Rol.find(params[:rol])
#    @controllers.each do |controller|
#      #---- Validamos si ya lo tiene ----
#      unless Systable.find(:first, :conditions =>["controller_id = ? and rol_id = ?", controller.id, @rol.id ])
#           Systable.create(:controller_id => controller.id, :rol_id => @rol.id)
#      end
#    end
    flash[:notice] = "Permisos otorgados"
    redirect_to :action => "verifica_permisos", :id => Rol.find(params[:rol])
  end




  def configuracion
    @configuracion = Configuracion.find(:first)
  end

  def actualizar_configuracion
    actualiza_configuracion(Configuracion.find(:first), params[:configuracion])
  end


end
