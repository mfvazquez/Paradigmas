function instrucciones = CargarInstruccionesDir(directorio)
    textos = CargarTextosDeCarpeta(directorio);
    instrucciones = cell(1,length(textos));
    for x = 1:length(textos)
        [instrucciones{x}.opciones, instrucciones{x}.texto] = AnalizarTexto(textos{x});
    end
end