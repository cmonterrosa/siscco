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
              flash[:notice] = "Archivo #{@nombre_archivo} cargado correctamente"
          else
              flash[:notice] = "Archivo #{@nombre_archivo} ya existe o no contiene la estructura correcta, Verifique"
          end
          render :action => "index", :controller => "upload"
      else
          flash[:notice] = "La extension del archivo debe de ser txt, verifique"
          render :action => "index", :controller => "upload"
      end
     end
  end






  def upload_old
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
