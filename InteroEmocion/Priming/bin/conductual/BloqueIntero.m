function [log, exit] = BloqueIntero(datos, num_corrida, hd, log)
    exit = false;
    global TAMANIO_INSTRUCCIONES
    
    %% CONSTANTES

    KbName('UnifyKeyNames');
    teclas.ExitKey = KbName('ESCAPE');
    teclas.LatidosKey = KbName('Z');
    
    %% DATOS
    
%     data_dir = fullfile('data', 'intersujeto', bloque);
%     bloques_dir = fullfile(data_dir, 'bloques');
%     bloques_carpetas = ArchivosDeCarpeta(bloques_dir);
%     
%     bloques = cell(length(bloques_carpetas), 1);
%     
%     for i = 1:length(bloques)
%         carpeta = fullfile(bloques_dir, bloques_carpetas{i});
%         bloques{i} = CargarBloqueInteroMotor(carpeta);
%     end
%     
%     practica_dir = fullfile(data_dir, 'practica');
%     practica = [];
%     if exist(practica_dir, 'dir') == 7;
%         practica = CargarBloqueInteroMotor(practica_dir);
%     end
%     
%     instrucciones_principales = fullfile(data_dir, 'instrucciones.txt');
%     instrucciones = [];
%     if exist(instrucciones_principales, 'file') == 2
%         instrucciones = fileread(instrucciones_principales);
%     end
%     
    %% PREPARO LOG
%     log = cell(length(bloques),1);
    
    
    %% ARRANCA EL PARADIGMA
    
    % INSTRUCCIONES GENERALES; SI ES QUE EXISTEN
    if ~isempty(datos.instrucciones)
        TextoCentrado(datos.instrucciones, TAMANIO_INSTRUCCIONES, hd);
        Screen('Flip', hd.window);
        KbStrokeWait; 
    end
    
    % SI HAY PRACTICA ARRANCA LAS PRACTICAS
    if ~isempty(datos.practica) && num_corrida == 1
        [~, exit] = CorrerSecuenciaIntero(datos.practica, teclas, hd);
        if exit
            return
        end
    end
    
    
    % CORRE LOS BLOQUES
    for i = 1:length(datos.bloques)
        [log_bloque.secuencia, exit] = CorrerSecuenciaIntero(datos.bloques{i}, teclas, hd);
        log{i} = log_bloque;
        
        if exit
            return
        end
    end
    
    
end