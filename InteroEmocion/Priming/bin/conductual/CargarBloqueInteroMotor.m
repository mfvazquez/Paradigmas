function bloque = CargarBloqueInteroMotor(carpeta)

    bloque.audio = [];
    bloque.freq = [];
    bloque.instrucciones = [];
    
    archivo_instrucciones = fullfile(carpeta, 'instrucciones.txt');
    archivo_audio = fullfile(carpeta, 'audio.wav');
    
    if exist(archivo_instrucciones, 'file') == 2
        bloque.instrucciones = fileread(archivo_instrucciones);
    end
    
    if exist(archivo_audio, 'file') == 2
        [bloque.audio, bloque.freq] = wavread(archivo_audio);
    end

end