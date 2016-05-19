function GuardarLog(log, nombre, version, bloques)

log_folder = fullfile('..', 'log');
if (~exist(log_folder,'dir')) 
    mkdir(log_folder);
end
    
continuar = true;
contador = 0;
while continuar
    contador = contador + 1;
    nombre_archivo = [nombre '_' date '_' version '_v' int2str(contador)];
    
    log_file = fullfile(log_folder, [nombre_archivo '.mat']);
    if (~exist(log_file ,'file'))
        continuar = false;
    end

end

save(log_file, 'log');


for i = 1:bloques
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('inicio'), ['Bloque ' int2str(i)], 'A1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), num2cell(log{1,i}.begin), ['Bloque ' int2str(i)], 'A2');
    
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Tiempo de Respuesta'), ['Bloque ' int2str(i)], 'B1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), log{1,i}.resp_time, ['Bloque ' int2str(i)], 'B2');
    
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Tiempo de Respuesta Relativo'), ['Bloque ' int2str(i)], 'C1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), log{1,i}.resp_rel_time, ['Bloque ' int2str(i)], 'C2');
    
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Accuracy'), ['Bloque ' int2str(i)], 'D1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), log{1,i}.accuracy, ['Bloque ' int2str(i)], 'D2');
    
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('fin'), ['Bloque ' int2str(i)], 'E1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), num2cell(log{1,i}.end), ['Bloque ' int2str(i)], 'E2');
    
end


end