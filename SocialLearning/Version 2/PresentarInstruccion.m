function PresentarInstruccion(hd, instruccion, texturas)
   
    global TAMANIO_INSTRUCCIONES
    global TAMANIO_TEXTO
    
    % TEXTOS PARA LAS INSTRUCCIONES CON EJEMPLOS
    MENSAJE_CONTINUAR = 'Presione ESPACIO para continuar.';
    NUMERO_EJEMPLO = '382';
    TEXTOS_OPCIONES.izquierda = 'A';
    TEXTOS_OPCIONES.derecha = 'B';
    
    texto_centrado = true;

    for y = 1:length(instruccion.opciones)
        
        if strcmp(instruccion.opciones{y}, 'mensaje_continuar')
            TextoInferior(MENSAJE_CONTINUAR, TAMANIO_INSTRUCCIONES, hd);
        elseif strcmp(instruccion.opciones{y}, 'numero')
            texto_centrado = false;
            TextoCentrado(NUMERO_EJEMPLO, TAMANIO_TEXTO ,hd);
        elseif strcmp(instruccion.opciones{y}, 'respuestas')
            texto_centrado = false;
            DibujarRespuesta(hd, texturas.opciones, TEXTOS_OPCIONES);
        end

    end

    if texto_centrado
        TextoCentrado(instruccion.texto, TAMANIO_INSTRUCCIONES, hd);
    else
        TextoSuperior(instruccion.texto, TAMANIO_INSTRUCCIONES, hd);
    end
end