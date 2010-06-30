Module Creditos
 
     def rango_anios55
        @arreglo=[]
        (4).times{|x| @arreglo << Time.now.year - x}
        return @arreglo.sort
     end

