include LoginSystem
class UploadController < ApplicationController
    require_role "administradores", :except =>[:show_aplicados]
  def index
     
  end


    def upload
    #-- Validamos que el nombre del archivo no exista y sea con extension .txt
     case request.method
      when :post
      @nombre_archivo = params[:datafile]["file"].original_filename
      if @nombre_archivo =~ /txt|TXT$/
          post = Datafile.save_file_txt(params[:datafile])
          #---- Verificamos si guarda correctamente ----
          @post = Datafile.find(:first, :conditions => ["nombre_archivo = ?", @nombre_archivo])
          if (post) && (@post)
              #---- Validamos que el encabezado es correcto, por lo tanto empezamos a insertar los registros que hagan match con los creditos -----
             @st, @num_insertados = confronta(post)
             flash[:notice] = "Archivo #{@nombre_archivo} cargado correctamente"
             redirect_to :action => "resultados", :datafile => @post, :num_insertados=>@num_insertados
          else
              redirect_to :action => "index", :controller => "upload"
              flash[:notice] = "Archivo #{@nombre_archivo} ya existe o no contiene la estructura correcta, Verifique"
          end
          
      else
          flash[:notice] = "La extension del archivo debe de ser txt, verifique"
          render :action => "index", :controller => "upload"
      end
     end
    end
    
    
    def resultados
        @datafile = Datafile.find(params[:datafile])
        unless params[:num_insertados] =~ /\d+/
          @num_aplicados = Deposito.count(:id, :conditions => ["datafile_id = ?", @datafile.id])
        else
          @num_aplicados = params[:num_insertados].to_i
        end
        
        @archivo_na = "noaplicados_" + @datafile.nombre_archivo
        @archivo_err = "errores_" + @datafile.nombre_archivo
    end


    def download_na
      send_file(RAILS_ROOT+"/tmp/"+params[:filename] ,
      :disposition => 'inline')
    end

    def download_err_fvalor
       send_file(RAILS_ROOT+"/tmp/" + "err_fecha_valor_" +Datafile.find(params[:id]).nombre_archivo ,
      :disposition => 'inline')
    end
    
     def download_err_fvalor_extras
       send_file(RAILS_ROOT+"/tmp/" + "na_fecha_valor_extras",
      :disposition => 'inline')
    end



    def show_aplicados
      @datafile = Datafile.find(params[:datafile])
      @depositos_aplicados = Deposito.find(:all, :conditions => ["datafile_id", @datafile.id])
    end




  def upload_csv
    #-- Validamos que el nombre del archivo no exista y sea con extension .txt
     case request.method
      when :get
          @nombre_archivo = params[:datafile]["file"].original_filename
          if @nombre_archivo =~ /csv|CSV$/
              post = Datafile.save_file(params[:datafile])
              @post = Datafile.find(:first, :conditions => ["nombre_archivo = ?", @nombre_archivo])
          if (post) && (@post)
              flash[:notice] = "Archivo #{@nombre_archivo} cargado correctamente"
          else
              flash[:notice] = "Archivo #{@nombre_archivo} ya existe o no contiene la estructura correcta, Verifique"
          end
        render :action => "index", :controller => "upload"
        else
          flash[:notice] = "La extension del archivo debe de ser csv, verifique"
          render :action => "index", :controller => "upload"
        end
     end



    
  end

  def historico
    @datafiles = Datafile.find(:all, :order => "fecha_hora_carga" )
  end


  #---- Carga de depositos con fecha valor ----

  def depositos_fecha_valor
    
  end

  def upload_fecha_valor
    case request.method
      when :post
      @nombre_archivo = params[:datafile]["file"].original_filename if params[:datafile][:file].size > 0
      if @nombre_archivo =~ /csv|CSV$/
          archivo = Datafile.save_file_csv_fecha_valor(params[:datafile])
          #---- Verificamos si guarda correctamente ----
          if archivo
              #---- Validamos que el encabezado es correcto, por lo tanto empezamos a insertar los registros que hagan match con los creditos -----
             @st, @num_insertados = confronta_fecha_valor(archivo)
             flash[:notice] = "Archivo #{@nombre_archivo} cargado correctamente"
             redirect_to :action => "show_depositos_fecha_valor", :datafile => archivo, :num_insertados=>@num_insertados
          else
              redirect_to :action => "index", :controller => "upload"
              flash[:notice] = "Archivo #{@nombre_archivo} no se pudo cargar, Verifique"
          end

      else
          flash[:notice] = "La extension del archivo debe de ser csv, verifique"
          render :action => "index", :controller => "upload"
      end
     end
    end

  def show_depositos_fecha_valor
    @datafile = Datafile.find(params[:datafile])
  end

  #------- Fecha valor de extraordinarios ----

    def depositos_fecha_valor_extras
    
    end

    def show_depositos_fecha_valor_extras
      @datafile = Datafile.find(params[:datafile])
    end


    def upload_fecha_valor_extras
    case request.method
      when :post
      @nombre_archivo = params[:datafile]["file"].original_filename if params[:datafile][:file].size > 0
      if @nombre_archivo =~ /csv|CSV$/
          archivo = Datafile.save_file_csv_fecha_valor(params[:datafile])
          #---- Verificamos si guarda correctamente ----
          if archivo
              #---- Validamos que el encabezado es correcto, por lo tanto empezamos a insertar los registros que hagan match con los creditos -----
              confronta_fecha_valor_extras(archivo)
              flash[:notice] = "Archivo #{@nombre_archivo} cargado correctamente"
              redirect_to :action => "show_depositos_fecha_valor_extras", :datafile => archivo, :num_insertados=>@num_insertados
          else
              redirect_to :action => "index", :controller => "upload"
              flash[:notice] = "Archivo #{@nombre_archivo} no se pudo cargar, Verifique"
          end

      else
          flash[:notice] = "La extension del archivo debe de ser csv, verifique"
          render :action => "index", :controller => "upload"
      end
     end
    end

    def show_aplicados_extras
      @depositos = Pagoextraordinario.find(:all, :order => "fecha")
      if @depositos.nil?
        redirect_to :action => "index", :controller => "home"
      end
    end


end
