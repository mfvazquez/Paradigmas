function exit = CorrerCiclo(hd, trials, texturas, teclas)

    for x = 1:size(trials,1)

        textos.inferior = trials{x,1};
        respuesta_correcta = trials{x,2};

        aux = trials{x,3};
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
        DibujarEstimulo(hd, imagenes.neutral, textos);
        Screen('Flip', hd.window);
        [exit, ~] = Esperar(1, teclas.salir,[], []);
        if exit 
            return
        end

        %% BLANK
        Screen('Flip', hd.window);
        [exit, ~] = Esperar(2, teclas.salir,[], []);
        if exit 
            return
        end
        
        %% RESPUESTA
        
        DibujarRespuesta(hd, texturas.opciones, textos);
        Screen('Flip', hd.window);
        [exit, respuesta, ~] = Esperar(1, teclas.salir, {teclas.izquierda teclas.derecha}, []);
        if exit 
            return
        end
        
        if isempty(respuesta)
            continue
        elseif respuesta == 1
            respuesta_elegida = textos.izquierda;
        elseif respuesta == 2
            respuesta_elegida = textos.derecha;
        end
                
        imagen_respuesta = imagenes.ira;
        if strcmp(respuesta_correcta, respuesta_elegida)
            imagen_respuesta = imagenes.alegria;
        end
        
        %% BLANK
        Screen('Flip', hd.window);
        [exit, ~] = Esperar(0.5, teclas.salir,[], []);
        if exit 
            return
        end
        
        %% RESULTADO 
        DibujarEstimulo(hd, imagen_respuesta, textos);
        Screen('Flip', hd.window);
        [exit, ~] = Esperar(1, teclas.salir,[], []);
        if exit 
            return
        end
        
        %% BLANK
        Screen('Flip', hd.window);
        [exit, ~] = Esperar(1+rand, teclas.salir,[], []);
        if exit 
            return
        end
        
    end

end