include LoginSystem
class AdministracionController < ApplicationController
 require_role "administradores", :except =>["change_password", "update_password"]

  def index
  end
  #--- definicion de las acciones principales ----
  def usuarios
    redirect_to :action => "roles"
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


   #-------------------------------------------------------------
   # ADMINISTRACION DE USUARIOS
   #-------------------------------------------------------------

   def roles
   end

   def users_by_rol
#   @user_pages, @usuarios = paginate :users, :per_page => 10
    @usuarios = User.find(:all, :order => 'nombre')
    @rol = Role.find(params[:id])
    @usuarios = @rol.users
   end

   def agregar_usuario
     @rol = Role.find(params[:id])
     @users=[]
     $users.each do |user|
       unless user.has_role?(@rol)
         @users << user
       end
     end
   end

   def agregar_usuario_rol
     @user = User.new
     @all_roles = Role.find(params[:id])
     @rol = Role.find(params[:id])
     @users=[]
     $users.each do |user|
       unless user.has_role?(@rol)
         @users << user
       end
     end
   end

   def adduser
    @rol = Role.find(params[:rol])
    @user = User.find(params["user"]["user_id"])
    @rol.users << @user
    if @rol.save!
      redirect_to :action => "users_by_rol", :id => @rol
    end
   end

   def edit_usuario

   end

   def quitar_usuario
     @rol = Role.find(params[:rol])
     @user = User.find(params[:id])
     @rol.users.delete(@user)
     if @rol.save!
      redirect_to :action => "users_by_rol", :id => @rol
     end
   end




  def configuracion
    @configuracion = Configuracion.find(:first)
  end

  def actualizar_refnumerica
    @configuracion = Configuracion.find(params[:id])
    @configuracion.ultima_referencia = params[:configuracion][:ultima_referencia]
    if @configuracion.save
      flash[:notice] = "Configuración actualizada correctamente"
      redirect_to :action => "configuracion", :controller => "administracion"
    else
      flash[:notice] = "No se pudo actualizar la configuración, verifique"
      render :action => "configuracion", :controller => "administracion"
    end
  end


#--- Cambio de contraseña --

  def change_password
    @user = session.data["user"]
    @user.password=""
  end

  def update_password
    if params[:user][:password] == params[:user][:password_confirmation]
       @user = session.data["user"]
       if @user.change_password("solaris")
          flash[:notice] = "Contraseña cambiada correctamente"
          redirect_to :action => "index", :controller => "home"
       end
    else
      @user = session.data["user"]
      flash[:notice] = "La confirmación no coincide con el password"
      render :action => "change_password"
    end
  end
  


end
