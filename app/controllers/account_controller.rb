###############################################################################
# Controlador: Account                                                        #
# Función: Métodos para la administración de acceso al sistema                #
#                                                                             #
###############################################################################


class AccountController < ApplicationController
  model   :user
  layout  'logged'
  #before_filter :login_required, :except =>[ :login, :signup]
    before_filter :permiso_requerido, :except =>[ :login, :signup]

  def login
    case request.method
      when :post
        if session['user'] = User.authenticate(params['user_login'], params['user_password'])
          flash['notice']  = "Login correcto"
          $usuario=params['user_login'] #agregado
          session['usuario']= params['user_login']
          redirect_to(:controller => 'home', :action => 'index')
        else
          @login    = params['user_login']
          @message  = "Login incorrecto"
          $usuario= params['user_login'] 
          flash['notice'] ="Login incorrecto" 
          render :action =>signup  
      end
    end
  end

  def signup
    @roles = Rol.find(:all)
     case request.method
      when :post
        @user = User.new(params['user'])
        @user.rol = Rol.find(params['rol']['rol_id']) if params['rol']['rol_id']
        if @user.save
          flash[:notice]  = "ALTA CORRECTA"
          redirect_to(:controller => 'home')
        end
      when :get
        @user = User.new
    end
  end
#--- el mismo metodo para dar de alta, solo que este recibe el rol de parametro ----
    def signup_perfil
     
     case request.method
      when :post
        @user = User.new(params['user'])
        @user.rol = Rol.find(params[:rol])
        if @user.save!
          flash[:notice]  = "ALTA CORRECTA PARA EL USUARIO: #{@user.nombre} con el perfil de #{@user.rol.nombre}"
          redirect_to(:controller => 'home')
        end
      when :get
        @user = User.new
        @rol = Rol.find(params['rol_id'])
    end
  end


    def list
          @user_pages, @users = paginate :users, :per_page => 10
    end

    
    def edit
       @user = User.find(params[:id])
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
    @user=User.find(:first, :conditions=>["login = ?", session['user']['login']])
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
