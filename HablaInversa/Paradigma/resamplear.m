addpath('lib');

secuencia = {'R1' 'R2' 'R3' 'R4'};

freq_deseada = 44100;

for x = 1:length(secuencia)
        
    
    data_dir = fullfile('data',secuencia{x}, 'estimulos');
    archivos = ArchivosDeCarpeta(data_dir);
        
    for y = 1:length(archivos)
        
        archivo_audio = fullfile(data_dir, archivos{y});
        
        [canal, freq] = wavread(archivo_audio);
        
        canal = resample(canal, freq_deseada/freq, 1);
        
        wavwrite(canal, freq_deseada, archivo_audio);
        
        
    end

end

