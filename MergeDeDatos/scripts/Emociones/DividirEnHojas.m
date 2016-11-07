function DividirEnHojas(datos, archivo, categoria)

    atributos = fieldnames(datos);
    for x = 1:length(atributos)
       
        hoja = [categoria ' ' atributos{x}];
        dato_actual = getfield(datos, atributos{x});
        
        GuardarEnHoja(dato_actual, archivo, hoja);
        
    end
    
end