function historia = SepararHistoria(texto, num_lineas)

    addpath(fullfile('..','lib'));
    lineas = regexp(texto, char(10), 'split'); % char(10) = \n
    
    divisiones = floor(length(lineas)/num_lineas);
    if mod(length(lineas), num_lineas) ~= 0
        divisiones = divisiones + 1;
    end
    
    historia = cell(1,divisiones);
    
    for x = 1:divisiones
    
        bloque = [];
        for y = 1:num_lineas
            
            linea_actual = y + (x-1) * num_lineas;
            
            if y == 1
                bloque = lineas(linea_actual);
            elseif linea_actual > length(lineas)
                    
                bloque = [bloque char(10)];
                              
            else
                bloque = [bloque char(10) lineas(linea_actual)];
            end
            
        end
        bloque = strjoin(bloque, '');
        historia{1,x} = bloque;
        
    end
    
end