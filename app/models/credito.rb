class Credito < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :periodo
  belongs_to :producto
  belongs_to :credito
  belongs_to :promotor
  belongs_to :grupo
  belongs_to :linea
  #belongs_to :banco
  belongs_to :destino
  belongs_to :grupo
  has_many :movimientos
  has_many :referencias
  has_many :pagos
  has_many :miembros
  has_many :devengos
  has_many :depositos
  has_many :excedentes

    def initialize(params = nil)
    super
      self.status = 0 unless self.status
      self.identificador = (rand(10)).to_s + Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s unless self.identificador
      self.fecha_captura = Time.now unless self.fecha_captura
    end

    #--------- Validaciones ------
    #before_save :grupo_unico?
    #before_create :grupo_unico?
    #validates_numericality_of :num_referencia, :message => "Debe de ser numero"
    #validates_uniqueness_of :num_referencia,  :message => "Ya existe un credito con ese numero de referencia"
    #validates_uniqueness_of :identificador, :message => ", Ese cliente ya esta registrado."

    def grupo_unico?
      @grupo = Grupo.find(self.grupo_id) if self.grupo_id
      sum=0

      if @grupo
         @grupo.creditos.each do |credito|
          sum+=1 if credito.status == 1
         end
         if sum > 0
          return false
         else
          return true
         end
      end
      return true
    end

    def activar
      self.status = 1
      if self.save!
        return true
      else
        return false
      end
    end

     def desactivar
      self.status = 0
      if self.save!
        return true
      else
        return false
      end
    end

     def activado?
       return true if self.status == 1
       return false if self.status != 1
     end

      def desactivado?
       return true if self.status == 0
       return false if self.status != 1
     end


  def generar_id!
    id = (rand(10)).to_s + Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
    if Credito.find_by_identificador(id)
       id = (rand(10)).to_s Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s
    end
    self.identificador = id
    self.save!
  end

  def ultimo_pago
      num_pago = Pagogrupal.maximum(:num_pago, :conditions => ["credito_id=?", self.id])
      @pago = Pagogrupal.find(:first, :conditions => ["credito_id = ? and num_pago = ?", self.id, num_pago])
      if @pago
        return @pago.fecha_limite
      else
        return "--"
      end
  end


  def tasa_moratoria
    moratorio=0.0
        if self.tipo_interes == "SALDOS INSOLUTOS (SSI)"
          if self.producto.moratorio_ssi
            moratorio=self.producto.moratorio_ssi
          else
            moratorio = ((self.producto.tasa_anualizada.to_f * 2))
          end
        else
          if self.producto.moratorio_flat
             moratorio = self.producto.moratorio_flat.to_f
          else
             moratorio = (self.producto.moratorio_flat.to_f * 2)
          end
        end
        return moratorio
  end

  def liquidado?
    if self.status==1
      return true
    else
      return false
    end
  end


  def presidente
     jerarquia = Jerarquia.find_by_jerarquia("presidente")
     return (Miembro.find(:first, :conditions => ["credito_id = ? AND jerarquia_id = ?", self.id, jerarquia.id])).cliente
  end

  def lista_pagos
    return Pagogrupal.find(:all, :conditions => ["credito_id = ?", self.id])
  end


 def inserta_pagos(arreglo_pagos, tipos_interes,tipo_credito)
    @credito = credito = self
    @tipo = (tipo_credito) ? tipo_credito : "GRUPAL"
    @producto = Producto.find(self.producto_id)
    @capital_grupal = (credito.monto.to_f / credito.grupo.clientes.size.to_f) if credito.grupo_id
    @capital = credito.monto.to_f
    @capital_semanal = @capital / @producto.num_pagos
    @cliente = Cliente.find(self.cliente_id) if self.cliente_id
    if @tipo == "GRUPAL"
        case tipos_interes
            when "SALDOS INSOLUTOS (SSI)"
              @tasa_semanal = round((((@producto.tasa_anualizada.to_f) / 360.0 ) * 7) / 100.0, 4)
              @pago_semanal = round((@capital_grupal * (@tasa_semanal/(1-(1 + @tasa_semanal)**(@producto.num_pagos*-1)))),2)
                  clientes_activos_grupo(Grupo.find(credito.grupo_id)).each do |y|
                  contador=1
                  saldo_inicial = @capital_grupal
                  arreglo_pagos.each do |x|
                      @interes_minimo = round(saldo_inicial * @tasa_semanal, 2)
                      @principal_recuperado = @pago_semanal - @interes_minimo
                      Pago.create(:num_pago => contador,
                                 :credito_id => credito.id,
                                 :fecha_limite => x,
                                 :cliente_id => y.id.to_i,
                                 :capital_minimo => @principal_recuperado,
                                 :principal_recuperado => @principal_recuperado,
                                 :interes_minimo => @interes_minimo,
                                :saldo_inicial => saldo_inicial,
                                :saldo_final => (saldo_inicial - @principal_recuperado),
                                :pagado => 0,
                                :descripcion => tipos_interes)
                      contador+=1
                      saldo_inicial -= @principal_recuperado
                end
              end

            when "SALDOS GLOBALES"
                  @capital = @credito.monto
                  saldo_inicial = @capital
                  contador=1
                  @meses = @credito.producto.num_pagos / 4
                  @pagos_semanales = @credito.producto.num_pagos
                  @pago_semanal_sin_iva = ((((@credito.producto.tasa_mensual_ssg / 100) * @meses) * @capital) + @capital) / @pagos_semanales
                  @pago_capital_semanal = (@capital / @pagos_semanales )
                  @pago_interes_semanal = @pago_semanal_sin_iva - @pago_capital_semanal
                  @iva_semanal = @pago_interes_semanal * (@credito.producto.iva / 100)
                  @pago_total_semanal = @pago_capital_semanal + @pago_interes_semanal + @iva_semanal
                  @interes_global =  @pago_interes_semanal * @pagos_semanales
                  @iva_global = @iva_semanal * @pagos_semanales
                  @credito.interes_global = @interes_global if @interes_global
                  @credito.iva_global = @iva_global if @iva_global
                  #--- Hacemos una iteracion por todos los miembros del grupo y dividimos el total del credito ---
                  @capital = (credito.monto.to_f / credito.grupo.clientes.size.to_f)
                  @capital_semanal = @capital / @producto.num_pagos

                  #### Creamos registros padres #######
                  arreglo_pagos.each do |x|
                       Pagogrupal.create(:fecha_limite => x,
                              :capital_minimo => @pago_capital_semanal,
                              :interes_minimo => @pago_interes_semanal,
                              :pagado => false,
                              :credito_id => @credito.id,
                              :saldo_inicial => saldo_inicial,
                              :saldo_final => saldo_inicial - @pago_capital_semanal,
                              :principal_recuperado => @pago_capital_semanal,
                              :num_pago => contador,
                              :iva => @iva_semanal)
                              saldo_inicial -= @capital_semanal
                    end

                    clientes_activos_grupo(Grupo.find(credito.grupo_id)).each do |y|
                    contador=1
                    saldo_inicial = @capital
                    @total_capital = @capital
                    @meses = @credito.producto.num_pagos / 4
                    @pagos_semanales = @credito.producto.num_pagos
                    #PAGO SEMANAL SIN INVA     (((tasa_mensual_ssg * meses) * monto) + monto) / pagos_semanales
                    @pago_semanal_sin_iva = ((((@credito.producto.tasa_mensual_ssg / 100) * @meses) * @capital) + @capital) / @pagos_semanales
                    @pago_capital_semanal = (@capital / @pagos_semanales )
                    @pago_interes_semanal = @pago_semanal_sin_iva - @pago_capital_semanal
                    @iva_semanal = @pago_interes_semanal * (@credito.producto.iva / 100)
                    @pago_total_semanal = @pago_capital_semanal + @pago_interes_semanal + @iva_semanal

                    ####### CREAMOS REGISTROS GENERAL ######
                    
                    arreglo_pagos.each do |x|
                      Pago.create(:num_pago => contador,
                                 :credito_id => credito.id,
                                 :fecha_limite => x,
                                 :cliente_id => y.id.to_i,
                                 :capital_minimo => @pago_capital_semanal,
                                 :iva => @iva_semanal,
                                 :principal_recuperado => @capital_semanal,
                                 :interes_minimo => @pago_interes_semanal,
                                 :saldo_inicial => saldo_inicial,
                                 :saldo_final => saldo_inicial - @capital_semanal,
                                 :pagado => 0,
                                 :descripcion => tipos_interes)
                          contador+=1
                      saldo_inicial -= @capital_semanal
                    end
                    ## UPDATE CREDITO INFO
                    @credito.save
                 end

      end


    else

     ##########################################################################
     ############### CREDITOS INDIVIDUALES ####################################
     ##########################################################################

      case tipos_interes
        when "SALDOS INSOLUTOS (SSI)"
            @pago_semanal = round((@capital * (@tasa_semanal/(1-(1 + @tasa_semanal)**(@producto.num_pagos*-1)))),2)
            contador=1
            saldo_inicial = @capital
            arreglo_pagos.each do |x|
                    @interes_minimo = round(saldo_inicial * @tasa_semanal, 2)
                    @principal_recuperado = @pago_semanal - @interes_minimo
                    Pago.create(:num_pago => contador,
                               :credito_id => credito.id,
                               :fecha_limite => x,
                               :cliente_id => @cliente.id,
                               :capital_minimo => @principal_recuperado,
                               :principal_recuperado => @principal_recuperado,
                              :interes_minimo => @interes_minimo,
                              :saldo_inicial => saldo_inicial,
                              :saldo_final => (saldo_inicial - @principal_recuperado),
                              :pagado => 0,
                              :descripcion => tipos_interes)
                    contador+=1
                    saldo_inicial -= @principal_recuperado
              end

        when "SALDOS GLOBALES"
                  @capital = @credito.monto
                  saldo_inicial = @capital
                  contador=1
                  @meses = @credito.producto.num_pagos / 4
                  @pagos_semanales = @credito.producto.num_pagos
                  @pago_semanal_sin_iva = ((((@credito.producto.tasa_mensual_ssg / 100) * @meses) * @capital) + @capital) / @pagos_semanales
                  @pago_capital_semanal = (@capital / @pagos_semanales )
                  @pago_interes_semanal = @pago_semanal_sin_iva - @pago_capital_semanal
                  @iva_semanal = @pago_interes_semanal * (@credito.producto.iva / 100)
                  @pago_total_semanal = @pago_capital_semanal + @pago_interes_semanal + @iva_semanal
                  @interes_global =  @pago_interes_semanal * @pagos_semanales
                  @iva_global = @iva_semanal * @pagos_semanales
                  @credito.interes_global = @interes_global if @interes_global
                  @credito.iva_global = @iva_global if @iva_global
                  #--- Hacemos una iteracion por todos los miembros del grupo y dividimos el total del credito ---
                  @capital = credito.monto.to_f
                  @capital_semanal = @capital / @producto.num_pagos
                  #### Creamos registros padres #######
                  arreglo_pagos.each do |x|
                        Pagogrupal.create(:fecha_limite => x,
                              :capital_minimo => @pago_capital_semanal,
                              :interes_minimo => @pago_interes_semanal,
                              :pagado => false,
                              :credito_id => @credito.id,
                              :saldo_inicial => saldo_inicial,
                              :saldo_final => saldo_inicial - @pago_capital_semanal,
                              :principal_recuperado => @pago_capital_semanal,
                              :num_pago => contador,
                              :iva => @iva_semanal)
                              saldo_inicial -= @capital_semanal
                    end

                    ####### Iteracion por cada uno de los clientes ################
                    @cliente = Cliente.find(self.cliente_id)
                    contador=1
                    saldo_inicial = @capital
                    @total_capital = @capital
                    @meses = @credito.producto.num_pagos / 4
                    @pagos_semanales = @credito.producto.num_pagos
                    #PAGO SEMANAL SIN INVA     (((tasa_mensual_ssg * meses) * monto) + monto) / pagos_semanales
                    @pago_semanal_sin_iva = ((((@credito.producto.tasa_mensual_ssg / 100) * @meses) * @capital) + @capital) / @pagos_semanales
                    @pago_capital_semanal = (@capital / @pagos_semanales )
                    @pago_interes_semanal = @pago_semanal_sin_iva - @pago_capital_semanal
                    @iva_semanal = @pago_interes_semanal * (@credito.producto.iva / 100)
                    @pago_total_semanal = @pago_capital_semanal + @pago_interes_semanal + @iva_semanal

                    ####### CREAMOS REGISTROS INDIVIDUALES ######
                    arreglo_pagos.each do |x|
                      Pago.create(:num_pago => contador,
                                 :credito_id => credito.id,
                                 :fecha_limite => x,
                                 :cliente_id => @cliente.id.to_i,
                                 :capital_minimo => @pago_capital_semanal,
                                 :iva => @iva_semanal,
                                 :principal_recuperado => @capital_semanal,
                                 :interes_minimo => @pago_interes_semanal,
                                 :saldo_inicial => saldo_inicial,
                                 :saldo_final => saldo_inicial - @capital_semanal,
                                 :pagado => 0,
                                 :descripcion => tipos_interes)
                          contador+=1
                      saldo_inicial -= @capital_semanal
                    end
                    ## UPDATE CREDITO INFO
                    @credito.save
                 
        
         end ### cierra case
    end
end





 end
