function [exit, log] = CorrerCiclo(hd, trials, texturas, teclas, log)

    for x = 1:size(trials,1)

        textos.inferior = trials{x,1};
        respuesta_correcta = trials{x,2};
        log_actual.numero = textos.inferior;

        aux = trials{x,3};
        log_actual.orden_opciones = trials{x,3};
        aux = strsplit(aux, '-');
        textos.izquierda = aux{1};
        textos.derecha = aux{2};

        categoria = trials{x,4};
        if strcmp(categoria, 'S')
            imagenes = texturas.sujetos;
        elseif strcmp(categoria, 'NS')
            imagenes = texturas.figuras;
        else
            fprintf('WARNING: Categoria %s no identificada!!!\n', categoria);
            continue
        end

        %% ESTIMULO
        DibujarEstimulo(hd, imagenes.neutral, textos, []);
        [~, OnSetTime] = Screen('Flip', hd.window);
        [exit, ~] = Esperar(1.5, teclas.salir,[], [], teclas.pausa);
        if exit 
            return
        end
        
        if ~isempty(log)
            log_actual.estimulo_onset = OnSetTime;
        end

        %% BLANK
        [~, OnSetTime] = Screen('Flip', hd.window);
        [exit, ~] = Esperar(1.5, teclas.salir,[], [], teclas.pausa);
        if exit 
            return
        end
        
        if ~isempty(log)
            log_actual.estimulo_offset = OnSetTime;
        end
        
        %% RESPUESTA
        
        DibujarRespuesta(hd, texturas.opciones, textos);
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~isempty(log)
            log_actual.opciones_onset = OnSetTime;
        end
        
        [exit, respuesta, tiempo_respuesta] = EsperarBotones(teclas.salir, {teclas.izquierda teclas.derecha});
        if exit 
            return
        end
        
        if isempty(respuesta)            
            if ~isempty(log)
                log{x} = log_actual;
            end
            continue
        elseif respuesta == 1
            respuesta_elegida = textos.izquierda;
        elseif respuesta == 2
            respuesta_elegida = textos.derecha;
        end
                
        imagen_respuesta = imagenes.ira;
        log_actual.accuracy = 0;
        if strcmp(respuesta_correcta, respuesta_elegida)
            imagen_respuesta = imagenes.alegria;
            log_actual.accuracy = 1;
        elseif strcmp(respuesta_correcta, 'C')
            imagen_respuesta = imagenes.alegria;
        end
        
        if ~isempty(log)
            log_actual.respuesta_elegida = respuesta_elegida;
            log_actual.respuesta_correcta = respuesta_correcta;
            log_actual.respuesta_tiempo = tiempo_respuesta;
            log_actual.reaction_time = tiempo_respuesta - log_actual.estimulo_onset;
        end
        
        %% BLANK
        [~, OnSetTime] = Screen('Flip', hd.window);
        [exit, ~] = Esperar(0.5, teclas.salir,[], [], teclas.pausa);
        if exit 
            return
        end
        
        if ~isempty(log)
            log_actual.opciones_offset = OnSetTime;
        end
        
        %% RESULTADO 
        DibujarEstimulo(hd, imagen_respuesta, textos, respuesta_elegida);
        [~, OnSetTime] = Screen('Flip', hd.window);
        [exit, ~] = Esperar(1, teclas.salir,[], [], teclas.pausa);
        if exit 
            return
        end
        
        if ~isempty(log)
            log_actual.feedback_onset = OnSetTime;
        end
        
        %% BLANK
        [~, OnSetTime] = Screen('Flip', hd.window);
        [exit, ~] = Esperar(1+rand, teclas.salir,[], [], teclas.pausa);
        if exit 
            return
        end
        
        if ~isempty(log)
            log_actual.feedback_offset = OnSetTime;
            log{x} = log_actual;
        end
        
    end

end