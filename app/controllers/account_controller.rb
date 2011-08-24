###############################################################################
# Controlador: Account                                                        #
# Función: Métodos para la administración de acceso al sistema                #
#                                                                             #
###############################################################################

class AccountController < ApplicationController
  model   :user
#  if $usuario.empty?
    layout 'inicio', :except=>[:signup, :signup_perfil]
#  else
#    layout 'contenido', :except=>[:login]
#  end
#  before_filter :login_required, :except =>[ :login, :signup]
    before_filter :permiso_requerido, :except =>[ :login, :logout]

  def login

    if session['user']
      redirect_to :controller => "home"
    end

    case request.method
      when :post
        if session['user'] = User.authenticate(params['user_login'], params['user_password'])
          flash['notice']  = "Login correcto"
          $usuario = session['user'] #agregado
          session['usuario']= params['user_login']
          redirect_to(:controller => 'home', :action => 'index')
        else
          @login    = params['user_login']
          @message  = "Login incorrecto"
          $usuario= params['user_login'] 
          flash['notice'] ="Login incorrecto" 
          render :action => signup
        end
   end
  end

  def signup
        @roles = Role.find(:all)
        @user = User.new
        @all_roles=Role.find(:all, :order=>"name")
        @selected=[]
        @role_selected=[]
     case request.method
      when :post
        @user = User.new(params['user'])
        #@user.fecha_hora = Time.now
        #@user.user_id = session['user'].id
        #@user.rol = Rol.find(params['rol']['rol_id']) if params['rol']['rol_id']
        @user.roles=Role.find(params[:roles]) if params[:roles]
        if @user.save
          flash[:notice]  = "ALTA CORRECTA"
          redirect_to(:controller => 'home')
        end
      when :get
        @user = User.new
        render :layout=>"contenido"
    end
      # 
  end
#--- el mismo metodo para dar de alta, solo que este recibe el rol de parametro ----
  def signup_perfil
     case request.method
      when :get
        @user = User.new(params['user'])
        @user.rol = Rol.find(params[:rol])
        if @user.save!
          flash[:notice]  = "ALTA CORRECTA PARA EL USUARIO: #{@user.nombre} con el perfil de #{@user.rol.nombre}"
          redirect_to(:controller => 'home')
        end
      when :post
        @user = User.new
        if params['rol']
           @rol = Rol.find(params['rol'])
        else
           @rol = Rol.find(params['rol_id'])
        end
        begin
          @user.save!
          flash[:notice]  = "ALTA CORRECTA PARA EL USUARIO: #{@user.nombre} con el perfil de #{@user.rol.nombre}"
          redirect_to(:controller => 'administracion', :action => "users_by_rol", :id => @rol)
        rescue ActiveRecord::RecordInvalid => invalid
          flash[:notice] = invalid
          redirect_to :action => 'new', :controller => "#{params[:controller]}"
        end

        
       
    end
       render :layout=>"contenido"
  end


  def list
      @user_pages, @users = paginate :users, :per_page => 10
  end

    
  def edit
      @user = User.find(params[:id])
      @user.password = ""
      @roles = Rol.find(:all)
  end

  def update
      @user = User.find(params[:id])
      @user.fecha_hora = Time.now
      @user.user_id = session['user'].id
      if @user.update_attributes(params[:user])
         flash[:notice] = 'Usuario actualizado correctamente'
         redirect_to :action => 'administracion', :controller => "usuarios"
      else
         render :action => 'edit'
      end
  end

  def delete
    @admin=User.find_by_login("administrador")
    if (params['usuario']['id']).to_i==@admin.id
          flash[:notice]="No se puede eliminar al usuario administrador"
    else
       if params['usuario']['id']
            user = User.find(params['usuario']['id'])
            user.destroy
            flash[:notice]="El usuario fue eliminado"
       end
    end
    redirect_back_or_default :action => "usuarios"
  end

  def logout
    @user=User.find(:first, :conditions=>["login = ?", session['user']['login']]) if session['user']
    session['user'] = nil
    @user.save unless @user.nil?
    $usuario=""
    flash[:notice]='ESTAS FUERA DEL SISTEMA'
    redirect_to(:controller => 'account', :action => 'login')
  end

  def welcome
  end

  def usuarios
    if $usuario=="administrador"
         #es administrador
     else
          redirect_to :controller=>'home', :action=>'index'
     end
  end

  def baja

  end

  def menu
    
  end

  def index
    redirect_to :action=>'signup'
  end

end
