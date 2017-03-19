function [log, exit] = CorrerSecuencia(bloque, hd, teclas, log)

    global TAMANIO_ESTIMULOS
    global TIEMPO_ESTIMULO
    global TIEMPO_VACIO
    global TIEMPO_ESPERA
    
    botones = {teclas.Negativo teclas.Afirmativo};
    
    for x = 1:length(bloque);
    
        log_actual.estimulo = bloque(x,:);
        log_actual.botones = botones;
        
        %% ESTIMULO
        TextoCentrado(bloque{x,1}, TAMANIO_ESTIMULOS, hd);
        [~, log_actual.estimulo_tiempo] = Screen('Flip', hd.window);
        [exit, respuesta, tiempo_respuesta] = Esperar(TIEMPO_ESTIMULO, teclas.ExitKey, botones);
        if exit
            return
        end
        if ~isempty(respuesta)
            log_actual.respuesta = respuesta;
            log_actual.respuesta_boton = botones{respuesta};
            log_actual.respuesta_tiempo = tiempo_respuesta;
            
            respuesta_correcta = bloque{x,2}(1);
            if respuesta_correcta == 'n'
                log_actual.respuesta_correcta = 1;
            else
                log_actual.respuesta_correcta = 2;
            end
            
            log_actual.accuracy = 0;
            if log_actual.respuesta_correcta == respuesta
                log_actual.accuracy = 1;
            end
            
        end

        %% VACIO
        if isempty(respuesta)
            [~, log_actual.vacio] = Screen('Flip', hd.window);
            [exit, respuesta, tiempo_respuesta] = Esperar(TiempoDeEspera(TIEMPO_VACIO), teclas.ExitKey, botones);
            if exit
                return
            end
            if ~isempty(respuesta)
                log_actual.respuesta = respuesta;
                log_actual.respuesta_boton = botones{respuesta};
                log_actual.respuesta_tiempo = tiempo_respuesta;

                respuesta_correcta = bloque{x,2}(1);
                if respuesta_correcta == 'n'
                    log_actual.respuesta_correcta = 1;
                else
                    log_actual.respuesta_correcta = 2;
                end

                log_actual.accuracy = 0;
                if log_actual.respuesta_correcta == respuesta
                    log_actual.accuracy = 1;
                end
                
            end
        end
        
        %% ESPERA
        Screen('Flip', hd.window)
        [exit, ~] = Esperar(TIEMPO_ESPERA, teclas.ExitKey, []);
         
        if ~isempty(log)
           log{x} = log_actual;
        end
    end

end