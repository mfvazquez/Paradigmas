function bloque = CargarBloqueIndividual(carpeta)

    bloque.instrucciones = fileread(fullfile(carpeta,'instrucciones.txt'));
    
    [bloque.audio, bloque.freq] = wavread(fullfile(carpeta,'audio.wav'));
    
    bloque.preguntas = CargarPreguntas(fullfile(carpeta,'preguntas.txt'));

end