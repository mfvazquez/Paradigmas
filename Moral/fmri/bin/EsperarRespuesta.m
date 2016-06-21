function [elegido, continuar] = EsperarRespuesta(elegido, pportobj, pportaddr)

    RIGHT = 16;
    LEFT = 8;
    ACCEPT = 24;
        
    continuar = true;
    leer_puerto = true;
    while leer_puerto

        input_data=io32(pportobj,pportaddr);
        input_data=bitand(input_data, 24); % filtro bits 4, 1 y 0
        
        if input_data == RIGHT && elegido < 9
            elegido = elegido + 1;
            leer_puerto = false;
        elseif input_data == LEFT && elegido > 1
            elegido = elegido - 1;
            leer_puerto = false;
        elseif input_data == ACCEPT
            leer_puerto = false;
            continuar = false;
        end
        
    end

end