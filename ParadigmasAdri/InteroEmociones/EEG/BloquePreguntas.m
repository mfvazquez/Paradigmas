function [log, exit] = BloquePreguntas(hd, teclas)

    exit = false;
        
    %% TEXTOS DE PREGUNTAS

    preguntas = cell(3,1);
    
    textos_opciones.pregunta = '¿Cuánto escuchó o sintió el latido del\n corazón en una escala del 1 al 9?';
    textos_opciones.minimo = 'Nada';
    textos_opciones.medio = '';
    textos_opciones.maximo = 'Mucho';    
    preguntas{1} = textos_opciones;
    
    textos_opciones.pregunta = '¿Cuán acertadas cree que fueron sus\n respuestas en una escala del 1 a 9?';
    preguntas{2} = textos_opciones;
    
    textos_opciones.pregunta = '¿Cuán bien cree que identificó\n las emociones en una escala del 1 al 9?';
    preguntas{3} = textos_opciones;
    
    log = cell(length(preguntas),1);

    for j = 1:length(preguntas)

        Screen('Flip',hd.window);
        WaitSecs(0.5);
        
        [exit, log_respuesta, saltear_bloque] = Respuesta(preguntas{j}, teclas, hd);
        if exit || saltear_bloque
            return;
        end
        log_bloque.pregunta = preguntas{j};
        log_bloque.respuesta = log_respuesta;
        log{j} = log_bloque;
        
    end

    
end