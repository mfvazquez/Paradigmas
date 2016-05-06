function GuardarLog(log, nombre, version)

log_folder = fullfile('..', 'log');
if (~exist(log_folder,'dir')) 
    mkdir(log_folder);
end
    
continuar = true;
contador = 0;
while continuar
    contador = contador + 1;
    nombre_archivo = [nombre '_' version '_v' int2str(contador) '_' date];
    
    log_file = fullfile(log_folder, [nombre_archivo '.mat']);
    if (~exist(log_file ,'file'))
        continuar = false;
    end

end

save(log_file, 'log');


loadPOI;
for i = 1:length(log)
    xlwrite(['log\' nombre_archivo '.xls'], 'inicio', ['Bloque ' int2str(i)], 'A1');
    xlwrite(['log\' nombre_archivo '.xls'], log{1,i}.begin, ['Bloque ' int2str(i)], 'A2');
    
    xlwrite(['log\' nombre_archivo '.xls'], 'Tiempo de Respuesta', ['Bloque ' int2str(i)], 'B1');
    xlwrite(['log\' nombre_archivo '.xls'], log{1,i}.resp_time, ['Bloque ' int2str(i)], 'B2');
    
    xlwrite(['log\' nombre_archivo '.xls'], 'Tiempo de Respuesta Relativo', ['Bloque ' int2str(i)], 'C1');
    xlwrite(['log\' nombre_archivo '.xls'], log{1,i}.resp_rel_time, ['Bloque ' int2str(i)], 'C2');
    
    xlwrite(['log\' nombre_archivo '.xls'], 'Accuracy', ['Bloque ' int2str(i)], 'D1');
    xlwrite(['log\' nombre_archivo '.xls'], log{1,i}.accuracy, ['Bloque ' int2str(i)], 'D2');
    
    xlwrite(['log\' nombre_archivo '.xls'], 'fin', ['Bloque ' int2str(i)], 'E1');
    xlwrite(['log\' nombre_archivo '.xls'], log{1,i}.end, ['Bloque ' int2str(i)], 'E2');
    
end


end