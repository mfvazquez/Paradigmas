function [exit, log] = CorrerCiclo(hd, trials, texturas, teclas, log, marca_prefijo)
    
    global TAMANIO_TEXTO
    
    if ~isempty(marca_prefijo)
        marca = marca_prefijo + 8;
        EnviarMarca(marca);
    end
    
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

        %% BLANK
        TextoCentrado('+', TAMANIO_TEXTO ,hd, [25 25 25]);
        Screen('Flip', hd.window);
        [exit, ~] = Esperar(1+rand, teclas.salir,[], teclas.pausa);
        
        if exit 
            return
        end
        
        %% ESTIMULO
        TextoCentrado('+', TAMANIO_TEXTO ,hd, [25 25 25]);       
        TextoCentrado(textos.inferior, TAMANIO_TEXTO ,hd);                
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~isempty(marca_prefijo)
            marca = marca_prefijo + 1;
            EnviarMarca(marca);
        end
        
        [exit, ~] = Esperar(1.5, teclas.salir,[], teclas.pausa);
        if exit 
            return
        end
        
        if ~isempty(log)
            log_actual.estimulo_onset = OnSetTime;
        end

        %% BLANK
        TextoCentrado('+', TAMANIO_TEXTO ,hd, [25 25 25]);    
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~isempty(marca_prefijo)
            marca = marca_prefijo + 2;
            EnviarMarca(marca);
        end

        [exit, ~] = Esperar(1, teclas.salir,[], teclas.pausa);
        if exit 
            return
        end
        
        if ~isempty(log)
            log_actual.estimulo_offset = OnSetTime;
        end
        
        %% RESPUESTA
        TextoCentrado('+', TAMANIO_TEXTO ,hd, [25 25 25]);
        DibujarRespuesta(hd, texturas.opciones, textos);
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~isempty(marca_prefijo)
            marca = marca_prefijo + 3;
            EnviarMarca(marca);
        end
        
        if ~isempty(log)
            log_actual.opciones_onset = OnSetTime;
        end
        
        [exit, respuesta, tiempo_respuesta] = EsperarBotones(teclas.salir, {teclas.izquierda teclas.derecha});
        if exit 
            return
        end
        
        if ~isempty(marca_prefijo)           
            marca = marca_prefijo + 3 + respuesta;            
            EnviarMarca(marca);
        end
         
        if ~isempty(log)
            log{x} = log_actual;
        end

        if respuesta == 1
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
        TextoCentrado('+', TAMANIO_TEXTO ,hd, [25 25 25]);
        [~, OnSetTime] = Screen('Flip', hd.window);
        [exit, ~] = Esperar(1, teclas.salir,[], teclas.pausa);
        if exit 
            return
        end
        
        if ~isempty(log)
            log_actual.opciones_offset = OnSetTime;
        end
        
        %% RESULTADO 
        DibujarTexturaCentrada(imagen_respuesta, hd.window);
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~isempty(marca_prefijo)           
            marca = marca_prefijo + 6;            
            EnviarMarca(marca);
        end
        
        [exit, ~] = Esperar(1, teclas.salir,[], teclas.pausa);
        if exit 
            return
        end
        
        Screen('Flip', hd.window);
        if ~isempty(marca_prefijo)           
            marca = marca_prefijo + 7;            
            EnviarMarca(marca);
        end
        
        if ~isempty(log)
            log_actual.feedback_onset = OnSetTime;
        end        
        
        if ~isempty(log)
            log_actual.feedback_offset = GetSecs;
            log{x} = log_actual;
        end
        
    end
    
    if ~isempty(marca_prefijo)           
        marca = marca_prefijo + 9;            
        EnviarMarca(marca);
    end

end