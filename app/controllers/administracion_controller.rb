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


end
