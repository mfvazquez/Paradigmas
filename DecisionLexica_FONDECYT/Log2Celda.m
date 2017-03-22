function Log2Celda(log, archivo)

    celda = cell(length(log{1}) + length(log{2}) + 1, 6);

    for x = 1:length(log)
        for y = 1:length(log{x})
            if ~isempty(log{x}{y})
                subindice = y + (x-1) * (length(log{1})+1);
                if isfield(log{x}{y}, 'respuesta_tiempo')
                   celda(subindice,:) = {log{x}{y}.estimulo{1} log{x}{y}.estimulo{2} log{x}{y}.estimulo_tiempo log{x}{y}.respuesta_tiempo log{x}{y}.reaction_time log{x}{y}.accuracy};
                else
                    celda(subindice,:) = {log{x}{y}.estimulo{1} log{x}{y}.estimulo{2} log{x}{y}.estimulo_tiempo [] [] []};
                end
            end
        end
    end


    fid = fopen(archivo, 'w') ;
    fprintf(fid, '%s;%s;%s;%s;%s;%s\n', 'estimulo', 'codigo', 'tiempo estimulo', 'tiempo respuesta', 'reaction time', 'accuracy');
    for x = 1:length(celda)
        fprintf(fid, '%s;%s;%f;%f;%f;%d', celda{x,:});
        fprintf(fid, '\n');
    end
    fclose(fid);

end