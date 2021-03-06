function [log, exit] = CorrerSecuenciaEmociones(bloque, n_bloque, hd, teclas, log)

    ExitKey = teclas.ExitKey;
      
    botones = teclas.emociones;
    botones_salteado = teclas.botones_salteado;
    
    TITULO = 'Seleccione la opcion correcta';
    
    negativas = { 'Ang' 'Dis' 'Fea' 'Sad' };
    
    practica = true;
    texturas = bloque.texturas{n_bloque};
    if isfield(bloque, 'archivos')
        archivos = bloque.archivos{n_bloque};
        practica = false;
    end    
    
    global TAMANIO_TEXTO
    global TAMANIO_INSTRUCCIONES
    global IEEG

    
    %% INSTRUCCIONES
    EmocionesInstrucciones(bloque.instrucciones, TAMANIO_INSTRUCCIONES, bloque.textos_botones, hd);
    DibujarCuadradoNegro();
    Screen('Flip', hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    if exit
        return;
    end
    if isfield(bloque, 'mensaje_practica')
        TextoCentrado(bloque.mensaje_practica, TAMANIO_INSTRUCCIONES, hd);
        DibujarCuadradoNegro();
        Screen('Flip', hd.window);
        exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
        if exit
            return;
        end
    end
    
    %% FIJACION
    TextoCentrado('+', TAMANIO_TEXTO, hd);
    DibujarCuadradoNegro();
    Screen('Flip', hd.window);
    
    [exit, ~, ~, saltear_bloque] = Esperar(0.5, ExitKey, {}, botones_salteado);
    if exit || saltear_bloque
        return;
    end

    %% VACIO
    DibujarCuadradoNegro();
    Screen('Flip', hd.window);
    [exit, ~, ~, saltear_bloque] = Esperar(0.5, ExitKey, {}, botones_salteado);
    if exit || saltear_bloque
        return;
    end
          
    for i = 1:length(texturas)
        
        %% IMAGEN
        DibujarTextura(texturas{i}, hd.window);  
        DibujarCuadradoNegro();
        if ~practica && IEEG
            OnSetTime = blink();
        else
            [~, OnSetTime] = Screen('Flip', hd.window);
        end
        log_trial.imagen = OnSetTime;

        [exit, respuesta, tiempo, saltear_bloque] = Esperar(0.2, ExitKey, {}, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        
        %% VACIO
        if isempty(respuesta)
            DibujarCuadradoNegro();
            [~, OnSetTime] = Screen('Flip', hd.window);
            log_trial.vacio = OnSetTime;
            [exit, respuesta, tiempo, saltear_bloque] = Esperar(0.8, ExitKey, {}, botones_salteado);
            if exit || saltear_bloque
                return;
            end
        end
        
        %% PREGUNTA
        if isempty(respuesta)
            DibujarReferencias(hd, bloque.textos_botones, TAMANIO_INSTRUCCIONES);
            if i == 1
                TextoCentrado(TITULO, TAMANIO_TEXTO, hd);
            end
            DibujarCuadradoNegro();
            [~, OnSetTime] = Screen('Flip', hd.window);

            log_trial.pregunta_tiempo = OnSetTime;
%             [exit, respuesta, tiempo, saltear_bloque] = Esperar(ExitKey, botones, botones_salteado);
            [exit, respuesta, tiempo, saltear_bloque] = Esperar(1.5, ExitKey, botones, botones_salteado);
            
            if IEEG && ~isempty(respuesta) && ~practica
                blink();
            end
            
            if exit || saltear_bloque
                return;
            end            
        end
              
        if ~practica
            
            log_trial.imagen_codigo = archivos{i};
            categoria = archivos{i}(5:7);
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
                log_trial.respuesta = bloque.textos_botones{1, respuesta};
                if strcmp(log_trial.respuesta, respuesta_correcta)
                    log_trial.accuracy = 1;
                else
                    log_trial.accuracy = 0;
                end
            end
                        

            
        end
        
        log_trial.respuesta_tiempo = tiempo;
        log_trial.reaction_time = log_trial.respuesta_tiempo - log_trial.pregunta_tiempo;
        
 
        
        %% CRUZ DE FIJACION
        TextoCentrado('+', TAMANIO_TEXTO, hd);
        DibujarCuadradoNegro();
        [~, OnSetTime] = Screen('Flip', hd.window);
        log_trial.fijacion = OnSetTime;
        [exit, ~, ~, saltear_bloque] = Esperar((rand*0.1)+0.4, ExitKey, {}, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        %% OFFSET
        DibujarCuadradoNegro();
        [~, OnSetTime] = Screen('Flip', hd.window);        
        log_trial.offset_time = OnSetTime;
        [exit, ~, ~, saltear_bloque] = Esperar(0.5, ExitKey, {}, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        if ~isempty(log)
            log{i} = log_trial;
        end

    end
    

end