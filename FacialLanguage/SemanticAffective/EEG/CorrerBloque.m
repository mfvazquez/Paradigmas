function [exit, log] = CorrerBloque(bloque, practica, version, log)

    global hd
    global ExitKey
    global TEXT_SIZE_STIM
    global TIEMPOS
    global OPCION_DIST
    global MARCAS
    global pportobj pportaddr
    
    n = 1;
    for i = randperm(length(bloque))


        if ~practica
            log{n}.secuencia = bloque{i};
        end
        %% FIXATION
        TextoCentrado('+', TEXT_SIZE_STIM);
        Screen('Flip', hd.window);
        WaitSecs(TIEMPOS.FIJACION);
        
        %% PRIME
        TextoCentrado(bloque{i}{4}, TEXT_SIZE_STIM);
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~practica
            log{n}.prime = OnSetTime;
            io32(pportobj,pportaddr, MARCAS.PRIME);
            WaitSecs(MARCAS.DURACION);
            io32(pportobj,pportaddr,0);
        end
        WaitSecs(TIEMPOS.PRIME);
        
        
        %% MASK
        Screen('Flip', hd.window);
        WaitSecs(0.5);
%         WaitSecs(AleatorioEntre(TIEMPOS.MASK(1),TIEMPOS.MASK(2)));
        
        %% TARGET
        TextoCentrado(bloque{i}{5}, TEXT_SIZE_STIM);
        DibujarOpciones(version,OPCION_DIST);
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~practica
            log{n}.target = OnSetTime;
            io32(pportobj,pportaddr, MARCAS.TARGET);
            WaitSecs(MARCAS.DURACION);
            io32(pportobj,pportaddr,0);
        end
        [exit, respuesta] = Esperar(TIEMPOS.TARGET, ExitKey, {version.IZQ version.DER});
        if exit
            return
        end
        if ~practica

            log{n}.respuesta = respuesta.tiempo;
            
            if isempty(respuesta.valor)
                log{n}.accuracy = 0;
            elseif strcmp(respuesta.valor, bloque{i}{end})
                log{n}.accuracy = 1;
                io32(pportobj,pportaddr, MARCAS.CORRECTO);
                WaitSecs(MARCAS.DURACION);
                io32(pportobj,pportaddr,0);
            else
                log{n}.accuracy = -1;  
                io32(pportobj,pportaddr, MARCAS.ERROR);
                WaitSecs(MARCAS.DURACION);
                io32(pportobj,pportaddr,0);
            end
        end
        
        %% ESPERA
        Screen('Flip', hd.window);
        WaitSecs(TIEMPOS.ESPERA);
        
        n = n+1;

    end
        
end