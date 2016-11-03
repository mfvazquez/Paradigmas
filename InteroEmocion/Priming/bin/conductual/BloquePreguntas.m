function [log, exit] = BloquePreguntas(hd)

    exit = false;
    
    %% TECLAS
    
    KbName('UnifyKeyNames');
    teclas.ExitKey = KbName('ESCAPE');
    teclas.LeftKey = KbName('LeftArrow');
    teclas.RighteKey = KbName('RightArrow');
    teclas.EnterKey = KbName('DownArrow');
    
    %% TEXTOS DE PREGUNTAS

    preguntas = cell(2,1);
    
    textos_opciones.pregunta = '¿Cuánto escuchó o sintió el latido del\n corazón en una escala del 1 al 9?';
    textos_opciones.minimo = 'Nada';
    textos_opciones.medio = '';
    textos_opciones.maximo = 'Mucho';
    
    preguntas{1} = textos_opciones;
    
    textos_opciones.pregunta = '¿Cuán acertadas cree que fueron sus\n respuestas en una escala de 1 a 9?';
    
    preguntas{2} = textos_opciones;
    


    log_bloque.pregunta = preguntas;
    log_bloque.respuestas = cell(length(preguntas),1);

    log = cell(length(preguntas),1);
    

    for j = 1:length(preguntas)
        
        log_actual.pregunta = preguntas{1};
        [exit, log_respuesta] = Respuesta(preguntas{j}, teclas, hd);
        if exit
            return
        end
        log_actual.respuesta = log_respuesta;
        log{j} = log_actual;
    end

    
end