function [log, exit] = PreguntasEntendimiento(hd, texturas, teclas, log)

    textos.izquierda = 'positiva';
    textos.derecha = 'negativa';
    textos.superior = '¿Qué tipo de respuesta\n representa la siguiente imagen?';
    
    [log.sujeto_ira, exit] = PreguntaImagen(hd, texturas.sujetos.ira, texturas.opciones, textos, teclas);
    if exit
        return
    end
    [log.sujeto_alegria, exit] = PreguntaImagen(hd, texturas.sujetos.alegria, texturas.opciones, textos, teclas);
    if exit
        return
    end
    [log.no_sujeto_rojo, exit] = PreguntaImagen(hd, texturas.figuras.ira, texturas.opciones, textos, teclas);
    if exit
        return
    end
    [log.no_sujeto_verde, exit] = PreguntaImagen(hd, texturas.figuras.alegria, texturas.opciones, textos, teclas);
    if exit
        return
    end
  

end

