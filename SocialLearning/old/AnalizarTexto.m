function [opciones, texto_sin_opciones] = AnalizarTexto(texto)
    subindices = 0;
    contador_opciones = 0;
    opcion_inicio = false;
    for x = 1:length(texto)
        if texto(x) == '['
            contador_opciones = contador_opciones + 1;
            subindices(contador_opciones,1) = x;
            opcion_inicio = true;
        elseif opcion_inicio && texto(x) == ']'
            subindices(contador_opciones,2) = x;
            opciones_inicio = false;            
        end
    end
    
    % Si no encontro opciones
    if subindices == 0
        opciones = [];
        texto_sin_opciones = texto;
        return
    end
    
    opciones = cell(1,size(subindices,1));
    subindices_suprimidos = [];
    for x = 1:length(opciones)
        opciones{x} = texto(subindices(x,1)+1:subindices(x,2)-1);
        subindices_suprimidos = [subindices_suprimidos subindices(x,1):subindices(x,2)];
    end
    
    subindices_texto = 1:length(texto);
    subindices_finales = setdiff(subindices_texto, subindices_suprimidos);        
    texto_sin_opciones = texto(subindices_finales);
    
end