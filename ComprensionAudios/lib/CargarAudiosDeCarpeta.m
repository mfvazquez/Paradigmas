function audios = CargarAudiosDeCarpeta(carpeta)

    archivos = ArchivosDeCarpeta(carpeta);
    audios = cell(1,length(archivos));
    for x = 1:length(archivos)
        [audio.canal, audio.freq] = wavread(fullfile(carpeta, archivos{x}));
        audios{x} = audio;
    end

end