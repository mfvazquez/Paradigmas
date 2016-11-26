function bloque = CargarBloqueInteroMotor(carpeta, num_bloque)

    bloque.audio = [];
    bloque.freq = [];
    bloque.instrucciones = [];
    
    archivo_audio = fullfile(carpeta, 'audio.wav');
    if num_bloque > 2
        carpeta_instrucciones = fullfile(carpeta, 'instrucciones_secundarias');
    else
        carpeta_instrucciones = fullfile(carpeta, 'instrucciones');
    end
        
    if exist(carpeta_instrucciones, 'dir') == 7
        bloque.instrucciones = CargarTextosDeCarpeta(carpeta_instrucciones);
    end
    
    if exist(archivo_audio, 'file') == 2
        [bloque.audio, bloque.freq] = wavread(archivo_audio);
    end

end