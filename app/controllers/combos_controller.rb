class CombosController < ApplicationController

  #--- Estas funciones son para manipular el AJAX

  def get_municipios
      @municipios= Municipio.find(:all, :conditions => ["estado_id = ?",params[:_estado_id] ])
      return render(:partial => 'municipios', :layout => false) if request.xhr?
  end


   def get_localidades
      @localidades= Localidad.find(:all, :conditions => ["municipio_id = ?",params[:_municipio_id] ])
      return render(:partial => 'localidades', :layout => false) if request.xhr?
  end

  def get_grupos
#     @filtrados = Grupo.find(:all, :select=> "distinct(g.id)",  :joins => "g, clientes_grupos cg, clientes c",
#                         :conditions => "g.id = cg.grupo_id and cg.cliente_id = c.id")
#     @grupos = Grupo.find(@filtrados)
      @grupos = Grupo.find(:all, :order => "nombre")
      return render(:partial => 'grupos', :layout => false) if request.xhr?
  end

    def get_colonias
      @colonias= Colonia.find(:all, :conditions => ["ejido_id = ?",params[:_ejido_id] ])
      return render(:partial => 'colonias', :layout => false) if request.xhr?
    end

  def get_lineas
      @lineas= Linea.find(:all, :conditions => ["fondeo_id = ?",params[:_fondeo_id] ])
      return render(:partial => 'lineas', :layout => false) if request.xhr?
  end

  def get_integrantes
      #@integrantes = Cliente.find(:all, :conditions => ["grupo_id = ?", params[:credito_grupo_id]])
      puts "Aqui esta antes de la query..."
      @integrantes = Clientegrupo.find(:all, :select => "id, cliente_id", :conditions => ["grupo_id = ? and activo = 1", params[:credito_grupo_id].to_i])
      unless @integrantes.nil?
        session['grupo'] = params[:credito_grupo_id]
      end
      return render(:partial => 'integrantes', :layout => false) if request.xhr?
  end

  def get_secretario
      @secretarios = Clientegrupo.find(:all, :select => "id, cliente_id", :conditions => ["grupo_id = ? and cliente_id != ? and activo = 1", session['grupo'].to_i, params[:miembro_presidente].to_i])

      unless @secretarios.nil?
        session['presidente'] = params[:miembro_presidente]
      end
      return render(:partial => 'secretario', :layout => false) if request.xhr?
  end

  def get_tesorero
      @tesoreros = Clientegrupo.find(:all, :select => "id, cliente_id", :conditions => ["grupo_id = ? and cliente_id != ? and cliente_id != ? and activo = 1", session['grupo'], params[:miembro_secretario], session['presidente']])
      return render(:partial => 'tesorero', :layout => false) if request.xhr?
  end

end