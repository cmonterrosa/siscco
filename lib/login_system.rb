require_dependency "user"

module LoginSystem
  #---- Agregado ---------
    #def role_requirements
     #role_requirements||=[]
    #end

    def logged_in?
      !!current_user
    end

  def current_user
    session['usuario']
  end

  def usuario_actual
    User.find_by_login(session['usuario'])
  end
  
  protected
  
  # overwrite this if you want to restrict access to only a few actions
  # or if you want to check if the user has the correct rights  
  # example:
  #
  #  # only allow nonbobs
  #  def authorize?(user)
  #    user.login != "bob"
  #  end
  def authorize?(user)
     true
     #user.login == "administrador"
  end
  
  
  #--- Autenticacion por grupos -------
  def autorizado?(user, controller)
    @usuario= User.find(user)
    @rol = @usuario.rol.id.to_i
    if @rol == 5  # -- es parte del grupo administrador
       return true
    end
    @controller = Controller.find_by_controller(controller)
    @systable = Systable.find(:all, :conditions => ["rol_id = ? and controller_id = ?", @rol, controller.id])
    return ( @systable.empty? ) ? false : true
  end

  # overwrite this method if you only want to protect certain actions of the controller
  # example:
  # 
  #  # don't protect the login and the about method
  #  def protect?(action)
  #    if ['action', 'about'].include?(action)
  #       return false
  #    else
  #       return true
  #    end
  #  end
  def protect?(action)
    true
  end
   
  # login_required filter. add 
  #
  #   before_filter :login_required
  #
  # if the controller should be under any rights management. 
  # for finer access control you can overwrite
  #   
  #   def authorize?(user)
  # 
  def login_required
    
    if not protect?(action_name)
      return true  
    end

    if @session['user'] and authorize?(@session['user'])
      return true
    end

    # store current location so that we can 
    # come back after the user logged in
    store_location
  
    # call overwriteable reaction to unauthorized access
    access_denied
    return false 
  end


  #------ Permiso del grupo requerido ------------
   def permiso_requerido
    if not protect?(action_name)
      return true
    end
    if @session['user'] and autorizado?(@session['user'], controller_name)
      return true
    end
    store_location
    access_denied
    return false
  end


   #-------- Inicia adecuacion para filtrar por accion -----
   #--------------------------------------
   #--------------------------------------
   def tiene_permiso?
    if not protect?(action_name)
      return true
    end
    if @session['user'] and autorizado?(@session['user'], controller_name)
      return true
    end
    store_location
    access_denied
    return false
   end





  # overwrite if you want to have special behavior in case the user is not authorized
  # to access the current operation. 
  # the default action is to redirect to the login screen
  # example use :
  # a popup window might just close itself for instance
  def access_denied
    redirect_to :controller=>"home", :action =>"index"
  end  
  
  # store current uri in  the session.
  # we can return to this location by calling return_location
  def store_location
    @session['return-to'] = @request.request_uri
  end

  # move to the last store_location call or to the passed default one
  def redirect_back_or_default(default)
    if @session['return-to'].nil?
      redirect_to default
    else
      redirect_to_url @session['return-to']
      @session['return-to'] = nil
    end
  end

  #----- Aqui vamos a agregar las funciones para role requirement --------

      def reset_role_requirements!
          self.role_requirements.clear
      end

    # Add this to the top of your controller to require a role in order to access it.
    # Example Usage:
    #
    #    require_role "contractor"
    #    require_role "admin", :only => :destroy # don't allow contractors to destroy
    #    require_role "admin", :only => :update, :unless => "current_user.authorized_for_listing?(params[:id]) "
    #
    # Valid options
    #
    #  * :only - Only require the role for the given actions
    #  * :except - Require the role for everything but
    #  * :if - a Proc or a string to evaluate.  If it evaluates to true, the role is required.
    #  * :unless - The inverse of :if
    #
    def require_role(roles, options = {})
      options.assert_valid_keys(:if, :unless,
        :for, :only,
        :for_all_except, :except
      )

      @role_requirements=[]

      # only declare that before filter once
      unless (@before_filter_declared||=false)
        @before_filter_declared=true
        before_filter :check_roles
      end

      # convert to an array if it isn't already
      roles = [roles] unless Array===roles

      options[:only] ||= options[:for] if options[:for]
      options[:except] ||= options[:for_all_except] if options[:for_all_except]

      # convert any actions into symbols
      for key in [:only, :except]
        if options.has_key?(key)
          options[key] = [options[key]] unless Array === options[key]
          options[key] = options[key].compact.collect{|v| v.to_sym}
        end
      end

      @role_requirements||=[] #self.
      @role_requirements << {:roles => roles, :options => options } #self.
    end

    # This is the core of RoleRequirement.  Here is where it discerns if a user can access a controller or not./
    def user_authorized_for?(user, params = {}, binding = self.binding)
      return true unless Array===@role_requirements
      @role_requirements.each{| role_requirement|
        roles = role_requirement[:roles]
        options = role_requirement[:options]
        # do the options match the params?

        # check the action
        if options.has_key?(:only)
          next unless options[:only].include?( (params[:action]||"index").to_sym )
        end

        if options.has_key?(:except)
          next if options[:except].include?( (params[:action]||"index").to_sym)
        end

        if options.has_key?(:if)
          # execute the proc.  if the procedure returns false, we don't need to authenticate these roles
          next unless ( String===options[:if] ? eval(options[:if], binding) : options[:if].call(params) )
        end

        if options.has_key?(:unless)
          # execute the proc.  if the procedure returns true, we don't need to authenticate these roles
          next if ( String===options[:unless] ? eval(options[:unless], binding) : options[:unless].call(params) )
        end

        # check to see if they have one of the required roles
        passed = false
        roles.each { |role|
          passed = true if user.has_role?(role)
        } unless (! user || user==:false)

        return false unless passed
      }

      return true
    end


    def render_optional_error_file(status)
      render :text => "You don't have access here.", :status => status
    end

    def access_denied
      if logged_in?
        render_optional_error_file(401)
        return false
      else
        super
      end
    end

    def check_roles
      return access_denied unless self.class.user_authorized_for?(usuario_actual, params, binding)

      true
    end

  protected
    # receives a :controller, :action, and :params.  Finds the given controller and runs user_authorized_for? on it.
    # This can be called in your views, and is for advanced users only.  If you are using :if / :unless eval expressions,
    #   then this may or may not work (eval strings use the current binding to execute, not the binding of the target
    #   controller)
    def url_options_authenticate?(params = {})
      params = params.symbolize_keys
      if params[:controller]
        # find the controller class
        klass = eval("#{params[:controller]}_controller".classify)
      else
        klass = self.class
      end
      klass.user_authorized_for?(current_user, params, binding)
    end



end


