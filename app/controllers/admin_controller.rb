class AdminController < ApplicationController
  before_filter :login_required
  #require_role [:admin], :except => [:index]
  
  def index

  end

  def new_role
    @role = Role.new
  end

  def save_role
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = "Perfil creado correctamente"
      redirect_to :action => "show_roles"
    else
      flash[:notice] = "No se pudo guardar, verifique"
      render :action => "new_role"
    end
  end

  #--- administracion de roles y estatus por visualizar
  def roles_estatus
    @role = Role.find(1)
  end

  def filtro_role
    if params[:role_id].size > 0
      @role = Role.find(params[:role_id])
      return render(:partial => 'estatus_by_role', :layout => false) if request.xhr?
    else
      render :text => "No se pudo realizar la búsqueda, verifique"
    end
  end

  def update_role_estatus
    @role = Role.find(params[:id])
    @role.estatus = []
    @role.estatus =  Estatu.find(params[:estatu][:role_ids]) if params[:estatu][:role_ids]
    if @role.save
      flash[:notice] = "Estatus actualizado correctamente"
      redirect_to :action => "roles_estatus"
    end
  end

  #--- administración de flujo de peticiones
  def flujo
    @flujos = Flujo.all
    @estatus = Estatu.all
    @users = Role.all
  end

  def add_flujo
    if params[:flujo][:role_id] && params[:flujo][:old_status_id] && params[:flujo][:new_status_id]
       @flujo = Flujo.new(params[:flujo])
       if @flujo.save
         flash[:notice] = "Guardado correctamente"
       else
         flash[:notice] = "No se puedo guardar, verifique"
       end
       redirect_to :action => "flujo"
    else
      flash[:notice] = "No se puedo guardar, verifique"
      render :action => "flujo"
    end
  end

  def delete_flujo
    if params[:id]
      @flujo = Flujo.find(params[:id])
      if @flujo.destroy
        flash[:notice] = "Registro eliminado correctamente"
      else
         flash[:notice] = "No se pudo eliminar, verifique"
      end
      redirect_to :action => "flujo"
    end
  end


 

  #------- Administracion de Usuarios ---------
  def members_by_role
     @role = Role.find(params[:id])
     @users = []
      User.find(:all).each{|user|
        unless @role.users.include?(user)
          @users << user
        end
      }
  end

  def add_user
  @role = Role.find(params[:role])
  @role.users << User.find(params[:user][:user_id])
  if @role.save
    flash[:notice] = "Usuario agregado correctamente"
  else
    flash[:notice] = "El usuario no fue agregado, verifique"
  end
  redirect_to :action => "members_by_role", :id => @role

  end

  def new_user
    @role = Role.find(params[:id])
    @users = []
    User.find(:all).each{|user|
    unless @role.users.include?(user)
      @users << user
    end
    }
  end

  def delete_user
    @role = Role.find(params[:role])
    @user = User.find(params[:id])
     @role.users.delete(@user)
     if @role.save!
       flash[:notice] = "Elemento eliminado del perfil correctamente"
     else
       flash[:notice] = "No se pudo eliminar, verifique"
     end
      redirect_to :action => "members_by_role", :id => @role
  end

  def show_roles
    @roles = Role.find(:all)
    @token = generate_token
  end

  def show_users
    @usuarios = User.find(:all, :order => "login, paterno, materno, nombre")
    @token = generate_token
  end

# -- termina modulo de administracion de usuarios ----

#--- listado de usuarios por area ---

 def show_users_by_area
    @areas = Subdireccion.find(:all, :order => "municipio_id")
 end

 def  update_list_usuarios
     @users = User.find(:all, :conditions => ["subdireccion_id = ?", params[:id]], :order => "paterno, materno, nombre")
     @token = generate_token
     render :layout => false
 end

# def change_horario_estatus
#   if validate_token(params[:t]) && @horario= Horario.find(params[:id])
#     @mensaje = @horario.activo ? "Horario bloqueado" : "Horario desbloqueado"
#     (@horario.activo) ? @horario.update_attributes!(:activo => false) : @horario.update_attributes!(:activo => true)
#     flash[:notice] = @mensaje
#   else
#     flash[:notice] = "No se pudo bloquear horario, verifique"
#   end
#   redirect_to :action => "show_horarios_sesiones"
# end

 def change_user_estatus
   if validate_token(params[:t]) && @user = User.find(params[:id])
     @mensaje = @user.activo ? "Usuario bloqueado" : "Usuario reactivado"
     (@user.activo) ? @user.update_attributes!(:activo => false) : @user.update_attributes!(:activo => true)
     flash[:notice] = @mensaje
   else
     flash[:notice] = "No se pudo bloquear usuario, verifique"
   end
   redirect_to :action => "show_users_by_area"
 end


 def change_user_area
   if validate_token(params[:t]) && @user = User.find(params[:id])
     @mensaje = @user.activo ? "Usuario bloqueado" : "Usuario reactivado"
     (@user.activo) ? @user.update_attributes!(:activo => false) : @user.update_attributes!(:activo => true)
     flash[:notice] = @mensaje
   else
     flash[:notice] = "No se pudo bloquear usuario, verifique"
   end
   redirect_to :action => "show_users_by_area"
 end

# def show_horarios_sesiones
#   @salas = Sala.find(:all, :order=> "descripcion")
#   @horarios = Horario.find(:all, :order => "hora,minutos")
#   @token= generate_token
# end

 def edit_user
   @user = User.find(params[:id])
 end

 def save_user
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.activated_at ||= Time.now
#    @user.activo=true
    success = @user && @user.save
    if success && @user.errors.empty?
      flash[:notice] = "Tus datos se actualizaron correctamente"
      redirect_to :action => "show_users"
    else
      flash[:notice]  = "No se pudieron modificar tus datos, verifica"
      render :action => 'edit_user'
    end
 end

# def situacion_user
##   unless validate_token(params[:t]) && @user = User.find(params[:id])
#   unless @user = User.find(params[:id])
#    flash[:notice] = "No se pudo encontrar usuario"
#    redirect_to :action => "index"
#   end
# end

# def change_password
#   @user = User.find(session[:user].id)
#   if params[:user]
#    @user = User.find(session[:user].id)
#
#    if(params[:user][:password] != params[:user][:password_confirmation])
#      flash[:notice]  = "Las contraseñas no coinciden"
#      render :action => 'change_password'
#    else
#      @user.update_attributes(params[:user])
#      success = @user && @user.save
#      if success && @user.errors.empty?
#        flash[:notice] = "La contraseña ha sido actualizada"
#        redirect_to :action => "change_password"
#      else
#        flash[:notice]  = "No se pudo actualizar la contraseña"
#        render :action => 'change_password'
#      end
#    end
#
#   end
# end
 
end
