function [log, exit] = CorrerSecuencia(bloque, hd, teclas, log, n_bloque)

    global TAMANIO_ESTIMULOS
    global TIEMPO_ESTIMULO
    global TIEMPO_VACIO
    global TIEMPO_ESPERA
    global MARCAS
    
    botones = {teclas.Negativo teclas.Afirmativo};
    
    for x = 1:length(bloque)
    
        
        log_actual.estimulo = bloque(x,:);
        estimulo_actual = bloque{x,1};
        codigo_actual = bloque{x,2};
        log_actual.botones = botones;
        
        %% ESTIMULO
        TextoCentrado(estimulo_actual, TAMANIO_ESTIMULOS, hd);
        [~, log_actual.estimulo_onset.tiempo] = Screen('Flip', hd.window);
        if ~isempty(log)
            marca = MARCAS(codigo_actual) + 100*(n_bloque-1) + 20;
            EnviarMarca(marca);
            log_actual.estimulo_onset.marca = marca;
        end
%         GuardarPantalla(hd);
        [exit, respuesta, tiempo_respuesta] = Esperar(TIEMPO_ESTIMULO, teclas.ExitKey, botones);
        if exit
            return
        end
        log_actual.estimulo_offset.tiempo = GetSecs;
        if ~isempty(log)
            marca = MARCAS(codigo_actual) + 100*(n_bloque-1) + 30;
            EnviarMarca(marca);
            log_actual.estimulo_offset.marca = marca;
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
            respuesta_correcta = codigo_actual(1);
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
                marca = MARCAS(codigo_actual) + 100*(n_bloque-1) + (log_actual.accuracy + 4) * 10;
                EnviarMarca(marca);
                log_actual.respuesta.marca = marca;
            end
            
            log_actual.respuesta_subindice = respuesta;
            log_actual.respuesta_boton = botones{respuesta};
            log_actual.respuesta.tiempo = tiempo_respuesta;
            log_actual.reaction_time = log_actual.respuesta.tiempo  - log_actual.estimulo_onset.tiempo;
        end
        
        %% ESPERA
        Screen('Flip', hd.window);
        [exit, ~] = Esperar(TiempoDeEspera(TIEMPO_ESPERA), teclas.ExitKey, []);
         
        if ~isempty(log)
           log{x} = log_actual;
        end
    end
    
    if ~isempty(log)
        marca = n_bloque + 10;
        EnviarMarca(marca);
    end

end