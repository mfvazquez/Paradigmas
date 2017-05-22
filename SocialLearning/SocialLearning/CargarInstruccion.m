function instruccion = CargarInstruccion(archivo)
    
    texto = fileread(archivo);
    [instruccion.opciones, instruccion.texto] = AnalizarTexto(texto);

end