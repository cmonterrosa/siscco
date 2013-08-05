class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
#      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
      flash[:notice] = "Registro creado satisfactoriamente (en espera de activación)."
    else
#      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      flash[:error]  = "No se pudo crear el registro."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def new_user
    @user = User.new
  end

  # create user from admin role not need activation
  def save
    @user = User.new(params[:user])
    @user.activated_at = Time.now
    success = @user && @user.save
    if success && @user.errors.empty?
      flash[:notice] = "Usuario creado correctamente"
      redirect_to :action => "show_roles", :controller => "admin"
    else
      flash[:notice]  = "No se puedo crear usuario"
      render :action => 'new_user'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

 def adduser
    @user = User.find(params[:id])
    if(params[:user][:password].nil? or params[:user][:password].empty?)
      if(params[:user][:password_confirmation].nil? or params[:user][:password_confirmation].empty?)
        params[:user][:password]=@user.password
        params[:user][:password_confirmation]=@user.password
      end
    end

    if(params[:user][:password] != params[:user][:password_confirmation])
      flash[:notice]  = "Las contraseñas no coinciden"
      render :action => 'edit'
    else

      @user.update_attributes(params[:user])
#    @user.activated_at ||= Time.now
#    @user.activo=true
      success = @user && @user.save
      if success && @user.errors.empty?
        flash[:notice] = "Tus datos se actualizaron correctamente"
        redirect_to :controller => 'admin', :action => "show_users"
      else
        flash[:notice]  = "No se pudieron modificar tus datos, verifica"
        render :action => 'edit'
      end
    end
 end

 def change_password

 end
 
  def change_password_update
    if User.authenticate(current_user.login, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]

        success = current_user.save
        if success
          flash[:notice] = "La contraseña ha sido actualizada."
          redirect_to change_password_path
        else
          flash[:alert] = "La Contraseña es demasiada corta (mínimo 6 caracteres)"
          render :action => 'change_password'
        end

      else
        flash[:alert] = "La nueva contraseña no coincide."
        render :action => 'change_password'
      end
    else
      flash[:alert] = "La contraseña actual es incorrecta."
      render :action => 'change_password'
    end
  end

end
