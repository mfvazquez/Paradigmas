function EsperarBoton(pportobj,pportaddr)
    esperar = true;
    while esperar
        
        input_data=io32(pportobj,pportaddr);
        input_data=bitand(input_data, 24); % filtro bits 4, 3, 1 y 0
        
        if input_data ~= 0
            esperar = false;
        end   
    end
end