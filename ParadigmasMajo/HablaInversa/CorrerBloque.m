function [exit, log] = CorrerBloque(hd, bloque, teclas, log)

    exit = false;    
    if bloque.datos.audio
        [exit, log] = CorrerBloqueAudio(hd, bloque.estimulos, bloque.datos, teclas, log);
    elseif bloque.datos.texto
        [exit, log] = CorrerBloqueTexto(hd, bloque.estimulos, bloque.datos, teclas, log);
    end

end