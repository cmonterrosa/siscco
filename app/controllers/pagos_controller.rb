class PagosController < ApplicationController
  def index
    @pago = Pago.new
  end

  def consultar
    @fecha = Date.civil(params[:pago][:"fecha(1i)"].to_i,params[:pago][:"fecha(2i)"].to_i,params[:pago][:"fecha(3i)"].to_i)
    @pagos = Pago.find(:all, :conditions=>["fecha = ? AND pagado = 1", @fecha])
  end

  def xml
    render :xml => Pago.find(:all, :conditions=>["pagado = 1", @fecha], :include => "credito").to_xml
  end

    def reporte
    @pagos=Pago.find(:all, :conditions=>["fecha = ? AND pagado = 1", params[:fecha]], :include => "credito").to_xml
   send_doc(@pagos,
    '/pagos/pago',
    'pagos_dia',
    'pagos_dia',
    'pdf')
  end


end
