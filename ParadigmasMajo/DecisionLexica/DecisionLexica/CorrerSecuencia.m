function [log, exit] = CorrerSecuencia(bloque, hd, teclas, log)

    global TAMANIO_ESTIMULOS
    global TIEMPO_ESTIMULO
    global TIEMPO_VACIO
    global TIEMPO_ESPERA
    
    botones = {teclas.Negativo teclas.Afirmativo};
    
    for x = 1:length(bloque)
    
        log_actual.estimulo = bloque(x,:);
        estimulo_actual = bloque{x,1};
        respuesta_correcta = bloque{x,2};
        log_actual.botones = botones;
        
        %% ESTIMULO
        TextoCentrado(estimulo_actual, TAMANIO_ESTIMULOS, hd);
        [~, log_actual.estimulo_onset] = Screen('Flip', hd.window);

        [exit, respuesta, tiempo_respuesta] = Esperar(TIEMPO_ESTIMULO, teclas.ExitKey, botones, teclas.Pausa);
        if exit
            return
        end
        log_actual.estimulo_offset = GetSecs;        

        %% VACIO
        if isempty(respuesta)
            [~, log_actual.vacio] = Screen('Flip', hd.window);
            [exit, respuesta, tiempo_respuesta] = Esperar(TIEMPO_VACIO, teclas.ExitKey, botones, teclas.Pausa);
            if exit
                return
            end
        end
        
        %% GUARDO DATOS DE RESPUESTA
        if ~isempty(respuesta)
            if strcmp(respuesta_correcta,'no')
                log_actual.respuesta_correcta = 1;
            else
                log_actual.respuesta_correcta = 2;
            end
            
            log_actual.accuracy = 0;
            if log_actual.respuesta_correcta == respuesta
                log_actual.accuracy = 1;
            end
            
            log_actual.respuesta_subindice = respuesta;
            log_actual.respuesta_boton = botones{respuesta};
            log_actual.respuesta_tiempo = tiempo_respuesta;
            log_actual.reaction_time = log_actual.respuesta_tiempo  - log_actual.estimulo_onset;
        end
        
        %% FEEDBACK SI ES PRACTICA
        if isempty(log) && ~isempty(respuesta)
            if log_actual.accuracy == 0
                TextoCentrado('¡INCORRECTO!', TAMANIO_ESTIMULOS, hd, hd.red);
                Screen('Flip', hd.window);
            else
                TextoCentrado('¡CORRECTO!', TAMANIO_ESTIMULOS, hd, hd.blue);
                Screen('Flip', hd.window);                
            end
            WaitSecs(1);
        end
        
        %% ESPERA
        Screen('Flip', hd.window);
        [exit, ~] = Esperar(TiempoDeEspera(TIEMPO_ESPERA), teclas.ExitKey, [], teclas.Pausa);
         
        if ~isempty(log)
           log{x} = log_actual;
        end
    end

end