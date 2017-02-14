addpath('strings') % Cargo la libreria string que versiones viejas de matlab no la tienen

CARPETA_DESTINO = 'new';

SEPARADOR = ': ';

%% Obtengo el subject del sujeto

% Cargo el primer .txt que encuentra en la carpeta, la funcion dir devuelve
% una lista de todos los txt.
log_file = dir('*.txt');
log_file = log_file(1).name; 

% Separo el formato del archivo
aux = strsplit(log_file, '.');
aux = aux{1};
% Obtengo el subject separando por - y me quedo con los 2 ultimos valores
aux = strsplit(aux, '-');
subject = [aux{end-1} '-' aux{end}];


%% procesado del log

fileID = fopen(log_file); % ARCHIVO ORIGINAL
fileID_dest = fopen(fullfile(CARPETA_DESTINO ,log_file), 'w'); % ARCHIVO CORREGIDO

% Leo el archivo de a 1 linea
linea = fgets(fileID);
while ischar(linea) %se detiene al llegar al fin de archivo
 
    aux = strsplit(linea, SEPARADOR); % separo cada linea por el separador elegido
    if strcmp(aux{1}, 'Subject') % si la linea arranca con un subject:
    
        linea = [aux{1} SEPARADOR subject char(10)]; % creo la linea nueva con el subject antes obtenido
    
    elseif strcmp(aux{1}, 'Experiment') % si la linea arranca con experimento
        
        experimento = aux{2};
        exp_split = strsplit(experimento, '_'); % lo separo por sus _ para ver si la ultima palabra dice verde
        if strcmp(exp_split{end}, 'verde')
            experimento = strjoin(exp_split(1:end-1), '_'); % si decia verde uno lo antes separado pero sin incluir verde
        end
        linea = [aux{1} SEPARADOR experimento char(10)];
        
    end
    
    fprintf(fileID_dest, '%s', linea);    % copio la linea en el archivo destino
    linea = fgets(fileID);  % leo la siguiente linea
end


fclose(fileID);
fclose(fileID_dest);