function celda_log = Log2Cell(log)
    
    atributos = EncontrarAtributos(log);
    celda_log = cell(length(log)+1, length(atributos));
    
    celda_log(1,:) = atributos;
    
    for i = 1:length(log)
        
        trial = log{i};
        
        if isempty(trial)
            break;
        end
        
        for j = 1:length(atributos)
            
            if isfield(trial, atributos{j})
                celda_log{i+1,j} = getfield(trial, atributos{j});
            end
            
        end
        
    end
    
end