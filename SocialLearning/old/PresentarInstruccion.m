function PresentarInstruccion(hd, instruccion, texturas)
   
    global TAMANIO_INSTRUCCIONES
    
    % TEXTOS PARA LAS INSTRUCCIONES CON EJEMPLOS
    MENSAJE_CONTINUAR = 'Presione ESPACIO para continuar.';
    TEXTOS_OPCIONES.izquierda = 'A';
    TEXTOS_OPCIONES.derecha = 'B';
    TEXTOS_OPCIONES.inferior = '382';
    
    texto_centrado = true;

    for y = 1:length(instruccion.opciones)
        
        if strcmp(instruccion.opciones{y}, 'mensaje_continuar')
            TextoInferior(MENSAJE_CONTINUAR, TAMANIO_INSTRUCCIONES, hd);
        elseif strcmp(instruccion.opciones{y}, 'numero')
            texto_centrado = false;
            DibujarEstimulo(hd, texturas.sujetos.neutral, TEXTOS_OPCIONES, []);
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