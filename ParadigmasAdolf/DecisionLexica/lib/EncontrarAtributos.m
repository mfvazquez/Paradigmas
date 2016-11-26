function atributos = EncontrarAtributos(celda_estructuras)

    atributos = {};
    for i = 1:length(celda_estructuras)
        
        if isempty(celda_estructuras{i})
            return;
        end
        
        estructura = celda_estructuras{i};
        atributos_estructura = fieldnames(estructura);
        
        for j = 1:length(atributos_estructura)
        
%             atributo = getfield(estructura, atributos_estructura{j});
            
            repetido = false;
            for k = 1:length(atributos)
                if strcmp(atributos_estructura{j}, atributos{k})
                    repetido = true;
                end
            end
            if ~repetido
                atributos = [atributos atributos_estructura{j}];
            end
            
        
        end
        
        
    end

end