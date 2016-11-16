function bloque = CargarBloqueInteroMotor(carpeta)

    bloque.audio = [];
    bloque.freq = [];
    bloque.instrucciones = [];
    
    archivo_audio = fullfile(carpeta, 'audio.wav');    
    carpeta_instrucciones = fullfile(carpeta, 'instrucciones');
    
    if exist(carpeta_instrucciones, 'dir') == 7
        bloque.instrucciones = CargarTextosDeCarpeta(carpeta_instrucciones);
    end
    
    if exist(archivo_audio, 'file') == 2
        [bloque.audio, bloque.freq] = wavread(archivo_audio);
    end

end