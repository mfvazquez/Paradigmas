function [log, exit] = BloqueIntero(bloque, hd)
    exit = false;
    global TAMANIO_INSTRUCCIONES
    
    %% CONSTANTES

    KbName('UnifyKeyNames');
    teclas.ExitKey = KbName('ESCAPE');
    teclas.LeftKey = KbName('LeftArrow');
    teclas.RighteKey = KbName('RightArrow');
    teclas.EnterKey = KbName('DownArrow');
    teclas.LatidosKey = KbName('Z');
    
    preguntas = cell(2,1);
    
    textos_opciones.pregunta = '¿Cuánto escuchó o sintió el latido del\n corazón en una escala del 1 al 9?';
    textos_opciones.minimo = 'Nada';
    textos_opciones.medio = '';
    textos_opciones.maximo = 'Mucho';
    
    preguntas{1} = textos_opciones;
    
    textos_opciones.pregunta = '¿Cuán acertadas cree qeu fueron sus\n respuestas en una escala de 1 a 9?';
    
    preguntas{2} = textos_opciones;
    
    %% DATOS
    
    data_dir = fullfile('data', 'intersujeto', bloque);
    bloques_dir = fullfile(data_dir, 'bloques');
    bloques_carpetas = ArchivosDeCarpeta(bloques_dir);
    
    bloques = cell(length(bloques_carpetas), 1);
    
    for i = 1:length(bloques)
        carpeta = fullfile(bloques_dir, bloques_carpetas{i});
        bloques{i} = CargarBloqueInteroMotor(carpeta);
    end
    
    practica_dir = fullfile(data_dir, 'practica');
    practica = [];
    if exist(practica_dir, 'dir') == 7;
        practica = CargarBloqueInteroMotor(practica_dir);
    end
    
    instrucciones_principales = fullfile(data_dir, 'instrucciones.txt');
    instrucciones = [];
    if exist(instrucciones_principales, 'file') == 2
        instrucciones = fileread(instrucciones_principales);
    end
    
    %% PREPARO LOG
    log = cell(length(bloques),1);
    
    
    %% ARRANCA EL PARADIGMA
    
    % INSTRUCCIONES GENERALES; SI ES QUE EXISTEN
    if ~isempty(instrucciones)
        TextoCentrado(instrucciones, TAMANIO_INSTRUCCIONES, hd);
        Screen('Flip', hd.window);
        KbStrokeWait; 
    end
    
    % SI HAY PRACTICA ARRANCA LAS PRACTICAS
    if ~isempty(practica)
        [~, exit] = CorrerSecuenciaIntero(practica, teclas, hd);
        if exit
            return
        end
    end
    
    
    % CORRE LOS BLOQUES
    for i = 1:length(bloques)
        [log_bloque.secuencia, exit] = CorrerSecuenciaIntero(bloques{i}, teclas, hd);
        
        log_bloque.preguntas = preguntas;
        log_bloque.respuestas = cell(length(preguntas),1);
        if exit
            return
        end
        
        for j = 1:length(preguntas)
            [exit, log_respuesta] = Respuesta(preguntas{j}, teclas, hd);
            if exit
                return
            end
            log_bloque.respuestas{j} = log_respuesta;
        end
        
        log{i} = log_bloque;
        if exit
            return
        end
    end
    
    
end