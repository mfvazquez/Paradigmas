function Log2Celda(log, archivo)

    celda = cell(length(log{1}) + length(log{2}) + 1, 10);

    for x = 1:length(log)
        for y = 1:length(log{x})
            if ~isempty(log{x}{y})
                subindice = y + (x-1) * (length(log{1})+1);
                if isfield(log{x}{y}, 'respuesta')
                   celda(subindice,:) = {log{x}{y}.estimulo{1} log{x}{y}.estimulo{2} log{x}{y}.estimulo_onset.tiempo log{x}{y}.estimulo_offset.tiempo  log{x}{y}.respuesta.tiempo  log{x}{y}.reaction_time log{x}{y}.accuracy log{x}{y}.estimulo_onset.marca log{x}{y}.estimulo_offset.marca log{x}{y}.respuesta.marca};
                else
                    celda(subindice,:) = {log{x}{y}.estimulo{1} log{x}{y}.estimulo{2} log{x}{y}.estimulo_onset.tiempo log{x}{y}.estimulo_offset.tiempo [] [] [] log{x}{y}.estimulo_onset.marca log{x}{y}.estimulo_offset.marca []};
                end
            end
        end
    end


    fid = fopen(archivo, 'w') ;
    fprintf(fid, '%s;%s;%s;%s;%s;%s;%s;%s;%s;%s\n', 'estimulo', 'codigo', 'estimulo onset tiempo', 'estimulo offset tiempo', 'respuesta tiempo', 'reaction time', 'accuracy', 'estimulo onset marca', 'estimulo offset marca', 'respuesta marca');
    for x = 1:length(celda)
        fprintf(fid, '%s;%s;%f;%f;%f;%f;%d;%d;%d;%d', celda{x,:});
        fprintf(fid, '\n');
    end
    fclose(fid);

end