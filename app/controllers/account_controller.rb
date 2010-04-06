###############################################################################
# Controlador: Account                                                        #
# Función: Métodos para la administración de acceso al sistema                #
#                                                                             #
###############################################################################


class AccountController < ApplicationController
  model   :user
  layout  'logged'
  before_filter :login_required, :except =>[ :login, :signup]

  def login
    case request.method
      when :post
        if session['user'] = User.authenticate(params['user_login'], params['user_password'])

          flash['notice']  = "Login correcto"
          $usuario=params['user_login'] #agregado
          session['usuario']= params['user_login']
          #redirect_back_or_default :action => "welcome"
          redirect_to(:controller => 'home', :action => 'index')
        else
          @login    = params['user_login']
          @message  = "Login incorrecto"
          $usuario= params['user_login'] #agregado
          flash['notice'] ="Login incorrecto" #agregado
          render :action =>signup  #agregado
      end
    end
  end

  def signup
     case request.method
      when :post
        @user = User.new(params['user'])
        @user.grupo = Grupo.find(4)

        if @user.save
          #$usuario=@user.login
          #session['user'] = User.authenticate(@user.login, params['user']['password'])
          flash['notice']  = "ALTA CORRECTA"
          #redirect_back_or_default :action => "welcome"
          redirect_to(:controller => 'home')#, :action => 'index')
        end
      when :get
        @user = User.new
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

  def ver_usuarios
    @usuarios=User.find(:all)
  end


  def menu
    
  end


  def index
    redirect_to :action=>'signup'
  end

end

