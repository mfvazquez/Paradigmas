function [exit, log] = CorrerBloque(hd, bloque, datos, teclas, log)

    exit = false;
        
    if datos.audio
        [exit, log] = CorrerBloqueAudio(hd, bloque, datos, teclas, log);
    elseif datos.texto        
        [exit, log] = CorrerBloqueTexto(hd, bloque, datos, teclas, log);
    end

end