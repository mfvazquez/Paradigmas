function [log, exit] = BloquePreguntas(hd, teclas)

    exit = false;
    log = [];
        
    %% TEXTOS DE PREGUNTAS

    preguntas = cell(2,1);
    
    textos_opciones.pregunta = '¿Cuánto escuchó o sintió el latido del\n corazón en una escala del 1 al 9?';
    textos_opciones.minimo = 'Nada';
    textos_opciones.medio = '';
    textos_opciones.maximo = 'Mucho';
    
    preguntas{1} = textos_opciones;
    
    textos_opciones.pregunta = '¿Cuán acertadas cree que fueron sus\n respuestas en una escala de 1 a 9?';
    
    preguntas{2} = textos_opciones;
    


%     log_bloque.preguntas = preguntas;
%     log_bloque.respuestas = cell(length(preguntas),1);
% 
%     log = cell(length(preguntas),1);
    

    for j = 1:length(preguntas)

        Screen('Flip',hd.window);
        WaitSecs(0.5);
        
        [exit, log_respuesta, saltear_bloque] = Respuesta(preguntas{j}, teclas, hd);
        if exit || saltear_bloque
            return;
        end
        log_bloque.respuesta = log_respuesta;
        log{j} = log_bloque;
        
    end

    
end