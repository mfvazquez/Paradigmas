function [log, exit] = CorrerSecuencia(bloque, hd, teclas, log, n_bloque)

    global TAMANIO_ESTIMULOS
    global TIEMPO_ESTIMULO
    global TIEMPO_VACIO
    global TIEMPO_ESPERA
    global MARCAS
    
    botones = {teclas.Negativo teclas.Afirmativo};
    
    for x = 1:length(bloque);
    
        estimulo_actual =  bloque(x,:);
        log_actual.estimulo = estimulo_actual;
        log_actual.botones = botones;
        
        %% ESTIMULO
        TextoCentrado(bloque{x,1}, TAMANIO_ESTIMULOS, hd);
        [~, log_actual.estimulo_tiempo] = Screen('Flip', hd.window);
        if ~isempty(log)
            marca = MARCAS(estimulo_actual) + 100*(n_bloque-1) + 20
            EnviarMarca(marca);
        end
%         GuardarPantalla(hd);
        [exit, respuesta, tiempo_respuesta] = Esperar(TIEMPO_ESTIMULO, teclas.ExitKey, botones);
        if exit
            return
        end
        if ~isempty(log)
            marca = MARCAS(estimulo_actual) + 100*(n_bloque-1) + 30
            EnviarMarca(marca);
        end
        

        %% VACIO
        if isempty(respuesta)
            [~, log_actual.vacio] = Screen('Flip', hd.window);
            [exit, respuesta, tiempo_respuesta] = Esperar(TIEMPO_VACIO, teclas.ExitKey, botones);
            if exit
                return
            end
        end
        
        %% GUARDO DATOS DE RESPUESTA
        if ~isempty(respuesta)
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
            if ~isempty(log)
                marca = MARCAS(estimulo_actual) + 100*(n_bloque-1) + (log_actual.accuracy + 4) * 10 
                EnviarMarca(marca);
            end
            
            log_actual.respuesta = respuesta;
            log_actual.respuesta_boton = botones{respuesta};
            log_actual.respuesta_tiempo = tiempo_respuesta;
            log_actual.reaction_time = log_actual.respuesta_tiempo  - log_actual.estimulo_tiempo;
        end
        
        %% ESPERA
        Screen('Flip', hd.window)
        [exit, ~] = Esperar(TiempoDeEspera(TIEMPO_ESPERA), teclas.ExitKey, []);
         
        if ~isempty(log)
           log{x} = log_actual;
        end
    end
    
    if ~isempty(log)
        marca = n_bloque + 10 
        EnviarMarca(marca);
    end

end