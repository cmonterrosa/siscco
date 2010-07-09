class CombosController < ApplicationController

  #--- Estas funciones son para manipular el AJAX

  def get_municipios
      @municipios= Municipio.find(:all, :conditions => ["estado_id = ?",params[:_estado_id] ])
      return render(:partial => 'municipios', :layout => false) if request.xhr?
  end


   def get_ejidos
      @ejidos= Ejido.find(:all, :conditions => ["municipio_id = ?",params[:_municipio_id] ])
      return render(:partial => 'ejidos', :layout => false) if request.xhr?
  end

    def get_colonias
      @colonias= Colonia.find(:all, :conditions => ["ejido_id = ?",params[:_ejido_id] ])
      return render(:partial => 'colonias', :layout => false) if request.xhr?
    end

  def get_lineas
      @lineas= Linea.find(:all, :conditions => ["fondeo_id = ?",params[:_fondeo_id] ])
      return render(:partial => 'lineas', :layout => false) if request.xhr?
  end

  def get_secretario
      @secretarios = Cliente.find(:all, :conditions => ["id != ?", params[:miembro_presidente]])
      unless @secretarios.nil?
        $presidente = params[:miembro_presidente]
      end
      return render(:partial => 'secretario', :layout => false) if request.xhr?
  end

  def get_tesorero
      @tesoreros = Cliente.find(:all, :conditions => ["id != ? AND id != ?", params[:miembro_secretario], $presidente])
      return render(:partial => 'tesorero', :layout => false) if request.xhr?
  end

end