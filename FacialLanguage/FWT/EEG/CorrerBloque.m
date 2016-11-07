function [exit, log] = CorrerBloque(bloque, botones, log, marcas)

    global hd;
   
    exit = false;
    MARCA_INICIO = 200;
    MARCA_ACCURACY = 100;
    MARCA_FIN = 13;
    
    global pportobj pportaddr
    
    experimental = true;
    if isempty(log)
        experimental = false;
    end
    
    %% ------------------- INICIO DEL BLOQUE -----------------------
    
    if (marcas) 
        io32(pportobj,pportaddr,MARCA_INICIO);
        WaitSecs(0.05);
        io32(pportobj,pportaddr,0);
    end 

    
    log.inicio = GetSecs;
    for i = 1:length(bloque.palabra)
        %% ----------------- FIJACION -------------------------------
        
        duracion = randi([700 1000], 1)/1000;
        textoCentrado('+', 0.05);
        [~, OnSetTime] = Screen('Flip',hd.window);
         
        if experimental
            log.fijacion_time{1,i} = OnSetTime;
        end
        WaitSecs(duracion);

        %% ----------------- PALABRA ------------

        textoCentrado(bloque.palabra{i}, 0.05);
        [~, OnSetTime] = Screen('Flip',hd.window);
        if (marcas) 
            io32(pportobj,pportaddr,bloque.marca{i});
            WaitSecs(0.05);
            io32(pportobj,pportaddr,0);
        end
        if experimental
            log.stim_time{i} = OnSetTime;
        end
        WaitSecs(0.3);

        %% ----------------- RESPUESTA ----------
        
        continuar = true;
        [~, tstart] = Screen('Flip',hd.window);
        while (GetSecs - tstart < 2 && continuar)
            
            [~, ~, keyCode] = KbCheck;
            if keyCode(botones.Si)
                continuar = false;
                if experimental
                    log.resp_time{i} = GetSecs;
                    log.reaction_time{i} = log.resp_time{i} - log.stim_time{i}; 

                    if strcmp(bloque.categoria{i}, 'NO CARA')
                        accuracy = 0;
                    else
                        accuracy = 1;
                    end
                    if (marcas) 
                        io32(pportobj,pportaddr, MARCA_ACCURACY + accuracy);
                        WaitSecs(0.05);
                        io32(pportobj,pportaddr,0);
                    end
                    log.accuracy{i} = accuracy;
                end    
            elseif keyCode(botones.No)
                continuar = false;
                if experimental
                    log.resp_time{i} = GetSecs;
                    log.reaction_time{i} = log.resp_time{i} - log.stim_time{i}; 

                    if strcmp(bloque.categoria{i}, 'NO CARA')
                        accuracy = 1;
                    else
                        accuracy = 0;
                    end
                    if (marcas) 
                        io32(pportobj,pportaddr, MARCA_ACCURACY + accuracy);
                        WaitSecs(0.05);
                        io32(pportobj,pportaddr,0);
                    end
                    log.accuracy{i} = accuracy;
                end
            elseif keyCode(botones.Salir)
                continuar = false;
                exit = true;
                log.fin = GetSecs;
                return
            end
            
        end
        
        %% ------------- ESPERA ---------------------------------------
        
        duracion = randi([700 1000], 1)/1000;
        WaitSecs(duracion);
        
    end
    
    if (marcas)
        io32(pportobj,pportaddr,MARCA_FIN);
        WaitSecs(0.05);
        io32(pportobj,pportaddr,0);
    end
    log.fin = GetSecs;
        
end