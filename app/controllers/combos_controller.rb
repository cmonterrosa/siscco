class CombosController < ApplicationController

  #--- Estas funciones son para manipular el AJAX

  def get_municipios
      @municipios= Municipio.find(:all, :conditions => ["estado_id = ?",params[:lugar_estado_id] ])
      return render(:partial => 'municipios', :layout => false) if request.xhr?
  end


   def get_ejidos
      @ejidos= Ejido.find(:all, :conditions => ["municipio_id = ?",params[:lugar_municipio_id] ])
      return render(:partial => 'ejidos', :layout => false) if request.xhr?
  end

    def get_colonias
      @colonias= Colonia.find(:all, :conditions => ["ejido_id = ?",params[:lugar_ejido_id] ])
      return render(:partial => 'colonias', :layout => false) if request.xhr?
    end

end
