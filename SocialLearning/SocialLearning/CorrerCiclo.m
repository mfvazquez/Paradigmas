function [exit, log] = CorrerCiclo(hd, trials, texturas, teclas, log, marca_ciclo)
    
    global TAMANIO_TEXTO TAMANIO_CRUZ
    marca_prefijo = 200;
    if ~isempty(marca_prefijo) && ~isempty(log)
        marca = marca_ciclo;
        EnviarMarca(marca);
    end
    
    exit = false;
    
    for x = 1:size(trials,1)

        textos.inferior = trials{x,1};
        respuesta_correcta = trials{x,2};
        log_actual.numero = textos.inferior;

        aux = trials{x,3};
        log_actual.orden_opciones = trials{x,3};
        aux = strsplit(aux, '-');
        textos.izquierda = aux{1};
        textos.derecha = aux{2};

        categoria = trials{x,4}(1);
        if categoria == 'S'
            imagenes = texturas.sujetos;
        elseif categoria == 'N'
            imagenes = texturas.figuras;
        end
        
        %% ESTIMULO
        TextoCentrado('+', TAMANIO_CRUZ ,hd, [25 25 25]);
        TextoCentrado(textos.inferior, TAMANIO_TEXTO ,hd);                
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~isempty(marca_prefijo)
            marca = marca_prefijo + 1;
            EnviarMarca(marca);
        end
        
        [exit, ~] = Esperar(1.5, teclas.salir,[], teclas.pausa);
        if ~isempty(marca_prefijo)
            marca = marca_prefijo + 9;
            EnviarMarca(marca);
        end
        if exit 
            return
        end
        
        if ~isempty(log)
            log_actual.estimulo_onset = OnSetTime;
            log_actual.estimulo_offset = GetSecs;
        end
        
        
        %% BLANK
        TextoCentrado('+', TAMANIO_CRUZ ,hd, [25 25 25]);
        Screen('Flip', hd.window);
        [exit, ~] = Esperar(1, teclas.salir,[], teclas.pausa);
        
        if exit 
            return
        end
        

        %% RESPUESTA
        TextoCentrado('+', TAMANIO_CRUZ ,hd, [25 25 25]);
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
         

        if respuesta == 1
            respuesta_elegida = textos.izquierda;
        elseif respuesta == 2
            respuesta_elegida = textos.derecha;
        end
        
        feliz = false;        
        imagen_respuesta = imagenes.ira;
        log_actual.accuracy = 0;
        if strcmp(respuesta_correcta, respuesta_elegida)
            imagen_respuesta = imagenes.alegria;
            log_actual.accuracy = 1;
            feliz = true;
        elseif strcmp(respuesta_correcta, 'C')
            imagen_respuesta = imagenes.alegria;
            feliz = true;
        end
        
        if ~isempty(log)
            log_actual.respuesta_elegida = respuesta_elegida;
            log_actual.respuesta_correcta = respuesta_correcta;
            log_actual.respuesta_tiempo = tiempo_respuesta;
            log_actual.reaction_time = tiempo_respuesta - log_actual.estimulo_onset;
        end
        
        %% BLANK
        TextoCentrado('+', TAMANIO_CRUZ ,hd, [25 25 25]);
        Screen('Flip', hd.window);
        [exit, ~] = Esperar(rand*0.5+2, teclas.salir,[], teclas.pausa);
        if exit 
            return
        end
        
        
        %% RESULTADO 
        DibujarTexturaCentrada(imagen_respuesta, hd.window);
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~isempty(marca_prefijo)           
            marca = marca_prefijo + 7;
            if feliz
                marca = marca_prefijo + 6;
            end
            EnviarMarca(marca);
        end
        
        if ~isempty(log)
            log_actual.resultado_onset = OnSetTime;
        end
        
        [exit, ~] = Esperar(1, teclas.salir,[], teclas.pausa);
        if exit
            return
        end
        
         [~, OnSetTime] = Screen('Flip', hd.window);
        if ~isempty(marca_prefijo)           
            marca = marca_prefijo + 8;            
            EnviarMarca(marca);
        end
        
        if ~isempty(log)
            log_actual.resultado_offset = OnSetTime;            
         end
        
        %% Shitter
        TextoCentrado('+', TAMANIO_CRUZ ,hd, [25 25 25]);  
        Screen('Flip', hd.window);
        if ~isempty(marca_prefijo)
            marca = marca_prefijo + 2;
            EnviarMarca(marca);
        end

        [exit, ~] = Esperar(rand+1, teclas.salir,[], teclas.pausa);
        if exit 
            return
        end            
        
        if ~isempty(log)
            log{x} = log_actual;
        end
        
    end
    
    if ~isempty(marca_prefijo) && ~isempty(log)        
        marca = marca_ciclo + 100;            
        EnviarMarca(marca);
    end

end