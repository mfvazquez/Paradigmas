function GuardarEnHoja(datos, nombre_archivo, nombre_hoja)

    atributos = fieldnames(datos);
    
    for x = 1:length(atributos)
        
        xlwrite(nombre_archivo, atributos(x), nombre_hoja, [char('A'+x-1) '1']);
        
        dato_actual = getfield(datos, atributos{x});
        
        if size(dato_actual,1) == 1
            dato_actual = dato_actual';
        end
        
        xlwrite(nombre_archivo, dato_actual , nombre_hoja, [char('A'+x-1) '2']);
        
    end

end
