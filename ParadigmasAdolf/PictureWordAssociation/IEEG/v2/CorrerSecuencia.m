function [exit, log] = CorrerSecuencia(texturas, estimulos, log)

    global hd
    global TAMANIO_TEXTO
    global ExitKey
    global AfirmativeKey
    global NegativeKey
    global IEEG
    
    botones = {AfirmativeKey NegativeKey};
          
    if isempty(estimulos)
        estimulos = texturas.keys';
    end
    
    for i = 1:length(texturas)
    
        %% FIJACION
        TextoCentrado('+', TAMANIO_TEXTO);
        if IEEG
            DibujarCuadradoNegro();
        end
        [~, OnSetTime] = Screen('Flip', hd.window);
        log_trial.fijacion = OnSetTime;
        WaitSecs(0.3);        
        
        %% IMAGEN
        DibujarTextura(texturas(estimulos{i,1}));
        if IEEG
            DibujarCuadradoNegro();
        end
        
        if isempty(log)
            [~, OnSetTime] = Screen('Flip', hd.window);
        else
            DibujarPalabra(estimulos(i,:));
            if IEEG
                OnSetTime = blink;
            else
                [~, OnSetTime] = Screen('Flip', hd.window);
            end
        end
        log_trial.imagen = OnSetTime;
        [exit, respuesta, tiempo] = Esperar(2, ExitKey, botones);
        if respuesta ~= 0 && ~isempty(log) && IEEG
            tiempo = blink;
        end
        if exit
            return;
        end
        
        
        if respuesta == 0
            %% BLANK
            if IEEG
                DibujarCuadradoNegro();
            end
            [~, OnSetTime] = Screen('Flip', hd.window);
            log_trial.blank = OnSetTime;
            [exit, respuesta, tiempo] = Esperar(0.5, ExitKey, botones);
            if respuesta ~= 0 && ~isempty(log) && IEEG
                tiempo = blink;
            end
            if exit
                return;
            end
        end
        
        if respuesta ~= 0 && ~isempty(log)
           if respuesta == 1
               log_trial.respuesta = 'Si';
           elseif respuesta == 2
               log_trial.respuesta = 'No';
           end
           
           log_trial.estimulo = estimulos{i,1};
           log_trial.codigo = estimulos{i,2};
           log_trial.respuesta_correcta = estimulos{i,3};
           
           if strcmp(log_trial.respuesta_correcta, log_trial.respuesta)
               log_trial.accuracy = 1;
           else
               log_trial.accuracy = 0;
           end
            
           log_trial.respuesta_time = tiempo;
           log_trial.reaction_time = log_trial.respuesta_time - log_trial.imagen;
           
           
        end
        
        %% OFFSET
        if IEEG
            DibujarCuadradoNegro();
        end
        [~, OnSetTime] = Screen('Flip', hd.window);
        duracion = rand*0.2+0.3;
        log_trial.offset_time = OnSetTime;
        log_trial.offset_duracion = duracion;
        [exit, ~, ~] = Esperar(duracion, ExitKey, {});
        
        if ~isempty(log)
            log{i} = log_trial;
        end
    end
    

end