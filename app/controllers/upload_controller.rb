class UploadController < ApplicationController

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
             if confronta(@nombre_archivo)
                flash[:notice] = "Archivo #{@nombre_archivo} cargado correctamente"
                redirect_to :action => "resultados", :datafile => @post
             end
          else
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
        @num_aplicados = Deposito.count(:id, :conditions => ["datafile_id = ?", @datafile.id])
        @archivo_na = "na_" + @datafile.nombre_archivo
        @archivo_err = "err_" + @datafile.nombre_archivo
    end


    def download_na
      send_file(RAILS_ROOT+"/tmp/"+params[:filename] ,
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


end
