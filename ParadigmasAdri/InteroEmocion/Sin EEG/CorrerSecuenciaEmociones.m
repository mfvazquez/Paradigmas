function [log, exit] = CorrerSecuenciaEmociones(texturas, codigos, instrucciones, hd, teclas, log, marcas, mensaje_practica, texto_botones)

    ExitKey = teclas.ExitKey;
      
    botones = teclas.emociones;
    botones_salteado = teclas.botones_salteado;
    
    TITULO = 'Seleccione la opcion correcta';
    
    negativas = { 'Ang' 'Dis' 'Fea' 'Sad' };
    
    global TAMANIO_TEXTO
    global TAMANIO_INSTRUCCIONES
    global EEG

    
    %% INSTRUCCIONES
    EmocionesInstrucciones(instrucciones, TAMANIO_INSTRUCCIONES, texto_botones, hd);
    Screen('Flip', hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    if exit
        return;
    end
    if ~isempty(mensaje_practica)
        TextoCentrado(mensaje_practica, TAMANIO_INSTRUCCIONES, hd);
        Screen('Flip', hd.window);
        exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
        if exit
            return;
        end
    end
    
    %% FIJACION
    TextoCentrado('+', TAMANIO_TEXTO, hd);
    Screen('Flip', hd.window);
    if ~isempty(codigos) && EEG
        EnviarMarca(150);
    end
    
    [exit, ~, ~, saltear_bloque] = Esperar(0.2, ExitKey, {}, botones_salteado);
    if exit || saltear_bloque
        return;
    end

    %% VACIO
    Screen('Flip', hd.window);
    WaitSecs(0.5);
          
    for i = 1:length(texturas)
        
        %% IMAGEN
        DibujarTextura(texturas{i}, hd.window);  
        [~, OnSetTime] = Screen('Flip', hd.window);
        log_trial.imagen = OnSetTime;
        if ~isempty(codigos) && EEG
            EnviarMarca(marcas(codigos{i}))
        end
        [exit, respuesta, tiempo, saltear_bloque] = Esperar(0.2, ExitKey, botones, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        %% PREGUNTA
        if isempty(respuesta)
        
            TextoCentrado(TITULO, TAMANIO_TEXTO, hd);
            if i == 1
                DibujarReferencias(hd, texto_botones, TAMANIO_INSTRUCCIONES);
            end
            [~, OnSetTime] = Screen('Flip', hd.window);

            log_trial.pregunta = OnSetTime;
            [exit, respuesta, tiempo, saltear_bloque] = Esperar(1.5, ExitKey, botones, botones_salteado);
            if exit || saltear_bloque
                return;
            end
        end
              
        if ~isempty(codigos)
            
            log_trial.imagen_codigo = codigos{i};
            categoria = codigos{i}(5:7);
            respuesta_correcta = 'Positiva';
            if strcmp(categoria, 'Neu')
                respuesta_correcta = 'Neutral';
            else 
                for y = 1:length(negativas)
                   if strcmp(categoria, negativas{y});
                        respuesta_correcta = 'Negativa';
                   end
                end
            end
            
            log_trial.accuracy = 9;
            if ~isempty(respuesta)
                log_trial.respuesta = texto_botones{1, respuesta};
                if strcmp(log_trial.respuesta, respuesta_correcta)
                    log_trial.accuracy = 1;
                else
                    log_trial.accuracy = 0;
                end
            end
                        
            if EEG && ~isempty(respuesta)
                EnviarMarca(log_trial.accuracy + 100);
            end
            
        end
        
        log_trial.respuesta_tiempo = tiempo;
        log_trial.reaction_time = log_trial.respuesta_tiempo - log_trial.imagen;
        
 
        
        %% OFFSET
        [~, OnSetTime] = Screen('Flip', hd.window);
        duracion = rand*0.5+0.7;
        
        log_trial.offset_time = OnSetTime;
        log_trial.offset_duracion = duracion;
        [exit, ~, ~, saltear_bloque] = Esperar(duracion, ExitKey, {}, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        if ~isempty(log)
            log{i} = log_trial;
        end

    end
    

end