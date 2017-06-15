function [instrucciones, estimulos] = CargarBloque(carpeta)


    %% INSTRUCCIONES
    instrucciones = CargarTextosDeCarpeta(fullfile(carpeta, 'instrucciones'));

    %% ESTIMULOS
    archivos = dir(fullfile(carpeta,'estimulos','*.txt'));
    if isempty(archivos)
        estimulos = CargarAudiosDeCarpeta(fullfile(carpeta, 'estimulos'));
    else
        estimulos = CargarArchivo(fullfile(carpeta,'estimulos', archivos(1).name));
    end

end