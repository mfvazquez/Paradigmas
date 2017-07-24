function preguntas = CargarPreguntas(archivo)
    
    fid = fopen(archivo);
  
    preguntas = {};
    actual = [];
    tline = fgets(fid);    
    while ischar(tline)
                
        if tline(1) == char(13)
            tline = fgets(fid);  
            continue
        end
        
        fin = strfind(tline,char(13))-1;
                        
        if ~isempty(strfind(tline,'¿'))
            if ~isempty(actual)
                preguntas = [preguntas actual];
            end
            
            actual.respuestas = {};
            actual.clave = {};  
            inicio = strfind(tline,'¿');
            inicio = inicio(1);
            actual.pregunta = tline(inicio:fin);            
        elseif isstrprop(tline(1),'digit')
            actual.respuestas = [actual.respuestas tline(1:fin)];
        elseif isstrprop(tline(1),'alpha')
            actual.clave = [actual.clave tline(1:fin)];
        end
        tline = fgets(fid);
        
    end
    preguntas = [preguntas actual];
    fclose(fid);

    for x = 1:length(preguntas)

        texto = [preguntas{x}.pregunta '\n\n'];        
        for y = 1:length(preguntas{x}.respuestas)        
            if y == length(preguntas{x}.respuestas)
                texto = [texto preguntas{x}.respuestas{y}];
            else
                texto = [texto preguntas{x}.respuestas{y} '\n'];        
            end
        end
        preguntas{x}.texto_completo = texto;
        
    end
    
end

