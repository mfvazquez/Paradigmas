function GuardarLog(log, nombre, log_folder)

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

warning('off','xlwrite:AddSheet');
for i = 1:length(log)

    pagina = ['Bloque ' int2str(i)];

    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Inicio'), pagina, 'A1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), num2cell(log{1,i}.inicio'), pagina, 'A2');

    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Palabra'), pagina, 'B1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), log{1,i}.palabra', pagina, 'B2');

    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Cateogira'), pagina, 'C1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), log{1,i}.categoria', pagina, 'C2');

    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Fijacion'), pagina, 'D1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), log{1,i}.fijacion_time', pagina, 'D2');    

    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Estimulo'), pagina, 'E1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), log{1,i}.stim_time', pagina, 'E2');

    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Respuesta'), pagina, 'F1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), log{1,i}.resp_time', pagina, 'F2');

    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Reaccion'), pagina, 'G1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), log{1,i}.reaction_time', pagina, 'G2');

    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Accuracy'), pagina, 'H1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), log{1,i}.accuracy', pagina, 'H2');

    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), cellstr('Fin'), pagina, 'I1');
    xlwrite(fullfile(log_folder, [nombre_archivo '.xls']), log{1,i}.fin', pagina, 'I2');

end


end