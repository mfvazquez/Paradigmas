function bloque = DividirTextos(bloque, largo_situacion, largo_instrucciones)

    bloque.instrucciones = AgregarFinLinea(bloque.instrucciones, largo_instrucciones);
    for i = 1:length(bloque.situaciones)
        bloque.situaciones{i}.texto = AgregarFinLinea(bloque.situaciones{i}.texto, largo_situacion);
        
    end

end